using Azure.Core;
using Azure.Identity;
using Demo.WebUI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text.Json;
using System.Threading.Tasks;

namespace Demo.WebUI.Controllers;

public class WeatherController : Controller
{
    private readonly ILogger<HomeController> _logger;
    private readonly IHttpClientFactory _clientFactory;
    private readonly IConfiguration _config;

    public WeatherController(IHttpClientFactory clientFactory, IConfiguration config, ILogger<HomeController> logger)
    {
        _logger = logger;
        _clientFactory = clientFactory;
        _config = config;
    }

    // GET: WeatherController
    public async Task<ActionResult> Index()
    {
        var webAPIScope = _config["WebAPIScope"];
        var webAPIUrl = _config["WebAPIUrl"];

        try
        {
#if !DEBUG
            _logger.LogInformation($"Getting DefaultAzureCredential...");
            var tokenCredential = new DefaultAzureCredential();
            var accessToken = tokenCredential.GetToken(new TokenRequestContext(scopes: new string[] { webAPIScope }) { });
            _logger.LogInformation($"Got AccessToken: {accessToken}");
#endif

            List<WeatherForecast> weatherForecast = null;
            var client = _clientFactory.CreateClient();

#if !DEBUG
            _logger.LogInformation($"Adding Token to the header");
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken.Token);
#endif
            _logger.LogInformation($"Calling {webAPIUrl}");
            HttpResponseMessage response = await client.GetAsync(webAPIUrl);
            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                weatherForecast = JsonSerializer.Deserialize<List<WeatherForecast>>(content);
            }
#if !DEBUG
            _logger.LogInformation($"Returning data with token");
            return View(new WeatherViewModel(this.HttpContext.User.Claims, accessToken.Token, weatherForecast));
#else
            _logger.LogInformation($"Returning data without token");
            return View(new WeatherViewModel(this.HttpContext.User.Claims, string.Empty, weatherForecast));
#endif
        }
        catch (System.Exception ex)
        {
            _logger.LogError(ex, "Error in WeatherController.Index");
            throw;
        }
    }
}
