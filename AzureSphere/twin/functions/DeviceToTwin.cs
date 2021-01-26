using System;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.EventGrid.Models;
using Microsoft.Azure.WebJobs.Extensions.EventGrid;
using System.Net.Http;
using Microsoft.Extensions.Logging;
using Azure.Identity;
using Azure.DigitalTwins.Core;
using Azure.DigitalTwins.Core.Serialization;
using Azure.Core.Pipeline;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace iotech.demo
{
  public static class DeviceToTwin
  {
    private static HttpClient httpClient = new HttpClient ();
    private static readonly string adtInstanceUrl = Environment.GetEnvironmentVariable ("ADT_SERVICE_URL");
      
    [FunctionName("DeviceToTwin")]
    public async static void Run ([EventGridTrigger] EventGridEvent ev, ILogger log)
    {
      if (adtInstanceUrl == null) log.LogError ("Application setting \"ADT_SERVICE_URL\" not set");
      try
      {
        // Authenticate with Digital Twins

        ManagedIdentityCredential cred = new ManagedIdentityCredential ("https://digitaltwins.azure.net");
        DigitalTwinsClient client = new DigitalTwinsClient (new Uri (adtInstanceUrl), cred, new DigitalTwinsClientOptions { Transport = new HttpClientTransport (httpClient) });
        log.LogInformation ("ADT service client connection created.");
       
        if (ev != null && ev.Data != null)
        {
          // Extract JSON body from event

          JObject deviceMessage = (JObject) JsonConvert.DeserializeObject (ev.Data.ToString ());
          byte[]data = System.Convert.FromBase64String ((string) deviceMessage ["body"]);
          JObject body = (JObject) JsonConvert.DeserializeObject (System.Text.ASCIIEncoding.ASCII.GetString (data));

          // Extract device twin id from message and digital twin id from system properties

          string deviceId = (string) deviceMessage ["systemProperties"]["iothub-connection-device-id"];
          string twinId = (string) body ["twin_id"];
          log.LogInformation ($"Routing from device_id: {deviceId}");
          log.LogInformation ($"Routing to twin_id: {twinId}");
        
          // Iterate set of readings and create change set for twin

          JObject readings = (JObject) body ["readings"];
          var uou = new UpdateOperationsUtility ();
          foreach (var reading in readings)
          {
            string type = (string) reading.Value ["type"];
            string key = (string) reading.Key;
            var value = reading.Value ["value"];
        
            log.LogInformation ($"key: {key} value: {value} type: {type}");

            switch(type.ToLower())
            {
              case "bool":
                uou.AppendReplaceOp ($"/{key}", value.Value<bool>());
                break;
              case "int8":
                uou.AppendReplaceOp ($"/{key}", value.Value<SByte>());
                break;
              case "int16":
                uou.AppendReplaceOp ($"/{key}", value.Value<Int16>());
                break;
              case "int32":
                uou.AppendReplaceOp ($"/{key}", value.Value<Int32>());
                break;
              case "uint8":
                uou.AppendReplaceOp ($"/{key}", value.Value<Byte>());
                break;
              case "uint16":
                uou.AppendReplaceOp ($"/{key}", value.Value<UInt16>());
                break;
              case "float32":
                uou.AppendReplaceOp ($"/{key}", value.Value<float>());
                break;
              case "float64":
                uou.AppendReplaceOp ($"/{key}", value.Value<double>());
                break;
              default:
                log.LogWarning($"{key} using {type} type isn't supported");
                break;
            }
          }
          // Update digital twin
          string digitalTwinPatch = uou.Serialize ();
          log.LogInformation ($"Updating twin: {twinId} with patch {digitalTwinPatch}");
          await client.UpdateDigitalTwinAsync (twinId, digitalTwinPatch);
        }
      }
      catch (Exception e)
      {
        log.LogError (e.Message);
      }
    }
  }
}
