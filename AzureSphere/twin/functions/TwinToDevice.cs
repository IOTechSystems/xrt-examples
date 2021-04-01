// Default URL for triggering event grid function in the local environment.
// http://localhost:7071/runtime/webhooks/EventGrid?functionName={functionname}
using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.Devices;
using Microsoft.Azure.EventGrid.Models;
using Azure.Identity;
using System.Net.Http;
using Azure.Core.Pipeline;
using Azure.DigitalTwins.Core;
using Microsoft.Azure.WebJobs.Extensions.EventGrid;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json.Linq;
using System.Runtime.Caching;

namespace iotech.dt.demo
{
  public static class TwinToDevice
  {
    private static HttpClient httpClient = new HttpClient ();
    private static readonly string iotHubConnectionString = Environment.GetEnvironmentVariable ("IOTHUB_CONNECTION_STRING");
    private static readonly string adtInstanceUrl = Environment.GetEnvironmentVariable ("ADT_SERVICE_URL");
    private static readonly double twinCacheTimeDuration = Convert.ToDouble (Environment.GetEnvironmentVariable ("ADT_CACHE_DURATION"));
    private static MemoryCache devicesTwinIdCache = new MemoryCache ("deviceTwinId");
    private static MemoryCache twinModelsCache = new MemoryCache ("twinModels");

    [FunctionName("TwinToDevice")]
    public async static void Run([EventGridTrigger]EventGridEvent eventGridEvent, ILogger log)
    {
      try
      {
        log.LogInformation(eventGridEvent.Topic.ToString());
        log.LogInformation(eventGridEvent.Subject.ToString());
        log.LogInformation(eventGridEvent.Data.ToString());

        ManagedIdentityCredential cred = new ManagedIdentityCredential("https://digitaltwins.azure.net");
        DigitalTwinsClient client = new DigitalTwinsClient(new Uri (adtInstanceUrl), cred, new DigitalTwinsClientOptions { Transport = new HttpClientTransport (httpClient) });

        string deviceTwinId = "";
        string digitalTwinId = eventGridEvent.Subject.ToString();

        Object CachedDeviceTwinId = devicesTwinIdCache.Get (digitalTwinId);

        if (CachedDeviceTwinId != null)
        {
          log.LogInformation ("Get device twin id from cache");
          deviceTwinId = (string) CachedDeviceTwinId;
        }
        else
        {
          log.LogInformation ("Get device twin id from digtial twin service");
          JObject digitalTwin = JObject.Parse (client.GetDigitalTwin(digitalTwinId));
          deviceTwinId = digitalTwin["device_twin_id"].ToString();

          devicesTwinIdCache.Set (digitalTwinId, deviceTwinId, DateTimeOffset.Now.AddMinutes (twinCacheTimeDuration));
        }

        JObject digitalTwinData = JObject.Parse(eventGridEvent.Data.ToString());
        string digitalTwinModelId = (string) digitalTwinData["data"]["modelId"].ToString();

        JObject twinModel = null;
        Object cachedTwinModel = twinModelsCache.Get (digitalTwinId);

        if (cachedTwinModel != null)
        {
          log.LogInformation ("Get digtial twin model from cache");
          twinModel = (JObject) cachedTwinModel;
        }
        else
        {
          log.LogInformation ("Get digtial twin model from digital twin service");
          ModelData twinModelData = client.GetModel (digitalTwinModelId);

          twinModel = JObject.Parse (twinModelData.Model);

          twinModelsCache.Set (digitalTwinId, twinModel, DateTimeOffset.Now.AddMinutes (twinCacheTimeDuration));
        }

        JArray digitalTwinModelContents = (JArray) twinModel["contents"];

        JObject data = (JObject) digitalTwinData["data"];
        JArray patch = (JArray) digitalTwinData["data"]["patch"];

        JObject reformattedData = new JObject();
        reformattedData.Add("device",eventGridEvent.Subject.ToString());

        JObject values = new JObject();

        foreach (JObject item in patch)
        {
          string name = item["path"].ToString().Replace("/","");
          foreach (JObject modelItem in digitalTwinModelContents)
          {
            if (modelItem["@type"].ToString().Equals("Property") && modelItem["name"].ToString().Equals(name))
            {
              JToken writable = modelItem.SelectToken("writable");
              if(writable != null)
              {
                if(writable.ToObject<bool>() == true)
                  values.Add(new JProperty(name, item["value"]));
              }
              break;
            }
          }
        }
                
        if (values.Count > 0)
        {
          reformattedData.Add("values", values);

          log.LogInformation("Sending IOTHub device {0} payload {1}:", deviceTwinId, reformattedData.ToString());

          var methodInvocation = new CloudToDeviceMethod("publish") { ResponseTimeout = TimeSpan.FromSeconds(30) };
          methodInvocation.SetPayloadJson(reformattedData.ToString());

          ServiceClient service = ServiceClient.CreateFromConnectionString(iotHubConnectionString);

          var response = await service.InvokeDeviceMethodAsync(deviceTwinId, methodInvocation);
          log.LogInformation("Response status: {0}, payload:", response.Status, response.GetPayloadAsJson());
        }
        else
        {
          log.LogInformation("No writable values found that could sent to IOTHub");
        }
      }
      catch (Exception e)
      {
        log.LogError(e.Message);
      }
    }
  }
}
