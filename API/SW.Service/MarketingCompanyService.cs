
using System.Diagnostics;
using SW.DataAccess;
using Serilog;
using SW.Service;
using Microsoft.EntityFrameworkCore;
using SW.DataAccess.Models;
using System.Linq;
using System.Threading.Tasks;

namespace IcPortfolioManagement.WebApplication.Services
{
    public class MarketingCompanyService : ServiceBase
    {
        private readonly IUserInfoService _userInfoService;

        public MarketingCompanyService(ApplicationDbContext dbContext, IUserInfoService userInfoService) : base(dbContext)
        {
            
        }

        public async Task<MstMarketingCompany> GetMarketingCompanyAsync(int marketingCompanyId)
        {
            var userInfo = _userInfoService.GetUserInfo();
            var query = DbContext.MstMarketingCompanies
                                .Include(mc => mc.MstMarketingCompanyBranches)
                                .Include(mc => mc.MstMarketingCompanyBranches)
                                .Include(mc => mc.MstMarketingCompanyCampaigns)
                                    .ThenInclude(mcc => mcc.Campaign)
                                .AsQueryable();

            if (userInfo.MarketingCompanyId == null)
            {
                var countryAccessList = _userInfoService.GetCountryAccessList();
                query = query.Where(mc => countryAccessList.Contains(mc.CountryCode) && mc.IsDeleted == false);
            }
            else
            {
                query = query.Where(mc => mc.MarketingCompanyId == userInfo.MarketingCompanyId && mc.IsDeleted == false);
            }

            return await query.FirstOrDefaultAsync(mc => mc.MarketingCompanyId == marketingCompanyId);
        }

    }
}