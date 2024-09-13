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
    public class IndependentContractorController : ControllerBase
    {
        private readonly   IndependentContractorService _service;

        public IndependentContractorController(IndependentContractorService service)
        {
            _service = service;
        } 

        [HttpPost("process-weekending")]
        public async Task<IActionResult> ProcessWeekendingDate([FromBody] ReqProcessWeekending request)
        {
            try
            {
                await _service.BAInfoProcessWeekendingDateAsync(request.WeekendingDate, request.CreatedBy);
                return Ok("Process completed successfully.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"An error occurred: {ex.Message}");
            }
        }

    }
}
