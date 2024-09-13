
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
    public class IndependentContractorService : ServiceBase
    {
         
        public  IndependentContractorService(ApplicationDbContext dbContext) : base(dbContext)
        {
            
        }

        public async Task BAInfoProcessWeekendingDateAsync(DateOnly? weekendingDate, string createdBy)
        {
            var stopwatch = new Stopwatch();
            stopwatch.Start();

            Log.Information("StartRun", DateTime.Now);
            using (var transaction = DbContext.Database.BeginTransaction())
            {
                try
                {

                    var matchingWeek = await DbContext.MstWeekendings  
                        .AsNoTracking()
                       .Where(w => weekendingDate >= w.FromDate && weekendingDate <= w.ToDate)
                      .FirstOrDefaultAsync();


                    if (matchingWeek == null)
                    {
                        Log.Fatal("No matching week-ending date found.", DateTime.Now);
                        throw new InvalidOperationException("No matching week-ending date found.");
                    }

                    Log.Information("Run BA Info "+ matchingWeek.Wedate.ToString(), DateTime.Now);

                    var weDate = matchingWeek.Wedate;

                    var existingEntries = DbContext.MstIndependentContractorBainfoWeekendings
                        .Where(e => e.WeekendingDate == weDate);

                    DbContext.MstIndependentContractorBainfoWeekendings.RemoveRange(existingEntries);
                    Log.Information("Done Delete", DateTime.Now);
                    await DbContext.SaveChangesAsync(); // Save the deletion of existing entries

                    var newEntries = await DbContext.MstIndependentContractors
             .Where(ic => !ic.IsDeleted && (ic.LastDeactivateDate == null || EF.Functions.DateDiffDay(ic.LastDeactivateDate, DateTime.Now) <= 180))
             .Select(ic => new MstIndependentContractorBainfoWeekending
             {
                 IndependentContractorId = ic.IndependentContractorId,
                 WeekendingDate = weDate,
                 MarketingCompanyId = ic.MarketingCompanyId,
                 IndependentContractorLevelId = ic.IndependentContractorLevelId,
                 Batype = ic.Batype,
                 ReportBadgeNo = ic.ReportBadgeNo,
                 Status = ic.Status,
                 IsSuspended = ic.IsSuspended,
                 IsDeleted = false,
                 CreatedBy = createdBy,
                 CreatedDate = DateTime.Now
             })
             .ToListAsync();

                    await DbContext.MstIndependentContractorBainfoWeekendings.AddRangeAsync(newEntries);

                    await DbContext.SaveChangesAsync(); // Save the batch insertion
                    
                    transaction.Commit();
                    Log.Information("Transaction committed.");
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    Log.Error(ex, "Transaction rolled back due to an error.");
                    throw;
                }
                finally
                {
                    stopwatch.Stop();
                    Log.Information("Process ended at: {Now}", DateTime.Now);
                    Log.Information("Elapsed time: {Elapsed}", stopwatch.Elapsed);
                }
            }
        }
    }
}