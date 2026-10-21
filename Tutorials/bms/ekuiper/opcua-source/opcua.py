import asyncio
import datetime

from asyncua import Client, ua
from ekuiper import Source, Context
import ekuiper.runtime.plugin as plugin


def _serialize(val):
    if isinstance(val, datetime.datetime):
        return val.isoformat()
    if isinstance(val, bytes):
        return val.hex()
    if isinstance(val, list):
        return [_serialize(v) for v in val]
    if isinstance(val, dict):
        return {k: _serialize(v) for k, v in val.items()}
    if not isinstance(val, (bool, int, float, str, type(None))):
        return str(val)
    return val


class OpcUaSource(Source):

    def configure(self, datasource: str, conf: dict):
        self.server = conf.get('server', 'opc.tcp://alarm-service:4840')
        self.ns = conf.get('sparkplugNs', 3)
        # DATASOURCE in stream SQL takes priority over nodePrefix conf key
        self.node_prefix = datasource or conf.get('nodePrefix', '')
        # optional allowlist — subscribe only to these metric names
        self.metrics = set(conf.get('metrics', []))
        self._loop = None
        self._stop_event = None

    def open(self, ctx: Context):
        self._loop = asyncio.new_event_loop()
        asyncio.set_event_loop(self._loop)
        self._stop_event = asyncio.Event()
        try:
            self._loop.run_until_complete(self._run(ctx))
        finally:
            self._loop.close()

    async def _run(self, ctx: Context):
        while not self._stop_event.is_set():
            try:
                async with Client(self.server) as client:
                    if self.node_prefix:
                        root = client.get_node(f'ns={self.ns};s={self.node_prefix}')
                        nodes = await self._get_variable_children(root)
                    else:
                        objects = client.get_objects_node()
                        nodes = await self._browse_ns_variables(objects, self.ns)

                    if self.metrics:
                        nodes = [n for n in nodes if self._node_metric(n) in self.metrics]

                    handler = _ChangeHandler(ctx, self.ns)
                    sub = await client.create_subscription(500, handler)
                    # batch to avoid BadTooManyOperations
                    batch_size = 10
                    for i in range(0, len(nodes), batch_size):
                        await sub.subscribe_data_change(nodes[i:i + batch_size])

                    await self._stop_event.wait()
                    await sub.delete()
            except Exception:
                if not self._stop_event.is_set():
                    await asyncio.sleep(5)

    @staticmethod
    def _node_metric(node) -> str:
        identifier = str(node.nodeid.Identifier)
        return identifier.split('//')[-1] if '//' in identifier else identifier

    async def _get_variable_children(self, node):
        result = []
        for child in await node.get_children():
            if (await child.read_node_class()) == ua.NodeClass.Variable:
                result.append(child)
        return result

    async def _browse_ns_variables(self, node, ns, depth=0):
        result = []
        if depth > 5:
            return result
        for child in await node.get_children():
            nid = child.nodeid
            nc = await child.read_node_class()
            if nc == ua.NodeClass.Variable and nid.NamespaceIndex == ns:
                result.append(child)
            elif nc == ua.NodeClass.Object:
                result.extend(await self._browse_ns_variables(child, ns, depth + 1))
        return result

    def close(self, ctx: Context):
        if self._loop and self._stop_event:
            self._loop.call_soon_threadsafe(self._stop_event.set)


class _ChangeHandler:

    def __init__(self, ctx: Context, ns: int):
        self.ctx = ctx
        self.ns = ns

    def datachange_notification(self, node, val, data):
        nid = node.nodeid
        if nid.NamespaceIndex != self.ns:
            return
        if not data.monitored_item.Value.StatusCode.is_good():
            return
        identifier = str(nid.Identifier)
        # identifier format: "{node}/{device}//{metric}" or "{node}//{metric}"
        metric = identifier.split('//')[-1] if '//' in identifier else identifier
        if val is not None:
            self.ctx.emit({metric: _serialize(val)}, {})

    def status_change_notification(self, status):
        pass


if __name__ == '__main__':
    plugin.start(plugin.PluginConfig(
        'opcua',
        sources={'opcua': OpcUaSource},
        sinks={},
        functions={},
    ))
