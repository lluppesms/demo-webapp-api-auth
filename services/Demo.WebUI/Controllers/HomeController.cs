using Demo.WebUI.Models;

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System.Diagnostics;
using System.Net.Http;
using System.Threading.Tasks;

namespace Demo.WebUI.Controllers
{
    [Authorize]
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IHttpClientFactory _clientFactory;
        private readonly IConfiguration _config;

        public HomeController(IHttpClientFactory clientFactory, IConfiguration config, ILogger<HomeController> logger)
        {
            _logger = logger;
            _clientFactory = clientFactory;
            _config = config;
        }

        public async Task<ActionResult> Index()
        {
            _ = await Task.FromResult(true);
            return View(new HomeViewModel(this.HttpContext.User.Claims));
        }

        [AllowAnonymous]
        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
