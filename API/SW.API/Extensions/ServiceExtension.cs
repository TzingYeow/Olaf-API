using SW.Service;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using IcPortfolioManagement.WebApplication.Services;

namespace SW.API.Extensions
{
    public static class ServiceExtension
    {
        public static void AddSalesWorksServices(this IServiceCollection services)
        {
            services.AddScoped<IndependentContractorService>();
            services.AddScoped<TPTSummaryService>();


        }
    }
}
