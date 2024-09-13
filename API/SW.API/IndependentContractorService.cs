using System;
using System.Linq;
using System.Threading.Tasks;
using IcPortfolioManagement.Business.Dac.DataContexts;
using System.Data.Entity;
using IcPortfolioManagement.Business.DataObject;
using System.Diagnostics;
using Serilog;

namespace IcPortfolioManagement.WebApplication.Services
{
    public class IndependentContractorService : IIndependentContactorService
    {
        private readonly ApplicationDbContext _context;
        public IndependentContractorService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task BAInfoProcessWeekendingDateAsync(DateTime weekendingDate, string createdBy)
        {
            var stopwatch = new Stopwatch();
            stopwatch.Start();

            Log.Information("StartRun", DateTime.Now);
            using (var transaction = _context.Database.BeginTransaction())
            {
                try
                {
                    var matchingWeek = await _context.Weekendings
                        .AsNoTracking()
                        .FirstOrDefaultAsync(w => weekendingDate >= w.FromDate && weekendingDate <= w.ToDate);

                    if (matchingWeek == null)
                    {
                        Log.Fatal("No matching week-ending date found.", DateTime.Now);
                        throw new InvalidOperationException("No matching week-ending date found.");
                    }

                    Log.Information("Run BA Info", DateTime.Now);

                    var weDate = matchingWeek.WEdate;

                    var existingEntries = _context.IndependentContractorBAInfoWeekendings
                        .Where(e => e.WeekendingDate == weDate);

                    _context.IndependentContractorBAInfoWeekendings.RemoveRange(existingEntries);

                    await _context.SaveChangesAsync(); // Save the deletion of existing entries

                    const int batchSize = 500; // Adjust batch size as needed

                    var totalContractors = await _context.IndependentContractors
                        .Where(ic => !ic.IsDeleted && (ic.LastDeactivateDate == null || DbFunctions.DiffDays(ic.LastDeactivateDate, DateTime.Now) <= 180))
                        .CountAsync();

                    for (int i = 0; i < totalContractors; i += batchSize)
                    {
                        var batch = await _context.IndependentContractors
                            .Where(ic => !ic.IsDeleted && (ic.LastDeactivateDate == null || DbFunctions.DiffDays(ic.LastDeactivateDate, DateTime.Now) <= 180))
                            .OrderBy(ic => ic.IndependentContractorId)
                            .Skip(i)
                            .Take(batchSize)
                            .Select(ic => new
                            {
                                ic.IndependentContractorId,
                                WeekendingDate = weDate,
                                ic.MarketingCompanyId,
                                ic.IndependentContractorLevelId,
                                ic.BAType,
                                ic.ReportBadgeNo,
                                ic.Status,
                                ic.IsSuspended,
                                IsDeleted = false,
                                CreatedBy = createdBy,
                                CreatedDate = DateTime.Now
                            })
                            .ToListAsync();

                        var newEntries = batch.Select(ic => new IndependentContractorBAInfoWeekending
                        {
                            IndependentContractorId = ic.IndependentContractorId,
                            WeekendingDate = weDate,
                            MarketingCompanyId = ic.MarketingCompanyId,
                            IndependentContractorLevelId = ic.IndependentContractorLevelId,
                            BAType = ic.BAType,
                            ReportBadgeNo = ic.ReportBadgeNo,
                            Status = ic.Status,
                            IsSuspended = ic.IsSuspended,
                            IsDeleted = false,
                            CreatedBy = createdBy,
                            CreatedDate = ic.CreatedDate
                        });

                        _context.IndependentContractorBAInfoWeekendings.AddRange(newEntries);
                        await _context.SaveChangesAsync(); // Save the batch insertion
                    }

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