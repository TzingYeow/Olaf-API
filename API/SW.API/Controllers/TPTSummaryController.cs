using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;
using IcPortfolioManagement.WebApplication.Services;
using Microsoft.AspNetCore.Authorization;
using SW.API.Model.ReqModel;
namespace SW.API.Controllers
{
    //[Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class TPTSummaryController : ControllerBase
    {
        private readonly TPTSummaryService _service;

        public TPTSummaryController(TPTSummaryService service)
        {
            _service = service;
        }
  
        [HttpPost("tptprocess")]
        public async Task<IActionResult> TPTProcess([FromBody] ReqProcessWeekending request)
        {
            try
            {
                await _service.TPTCalculationAsync(request.WeekendingDate, request.CreatedBy);
                return Ok("Process completed successfully.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"An error occurred: {ex.Message}");
            }
        }

    }
}
