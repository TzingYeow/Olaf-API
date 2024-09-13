
using System.Diagnostics;
using SW.DataAccess;
using Serilog;
using SW.Service;
using Microsoft.EntityFrameworkCore;
using SW.DataAccess.Models;
using System.Linq;
using System.Threading.Tasks;
using SW.DataAccess.RawQueryClass;
using Microsoft.IdentityModel.Tokens;
namespace IcPortfolioManagement.WebApplication.Services
{
    public class TPTSummaryService : ServiceBase
    {

        public TPTSummaryService(ApplicationDbContext dbContext) : base(dbContext)
        {

        }

        public async Task TPTCalculationAsync(DateOnly? weekendingDate, string createdBy)
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

                    Log.Information("Run BA Info " + matchingWeek.Wedate.ToString(), DateTime.Now);

                    var weDate = matchingWeek.Wedate;

                    var existingSummaryEntries = DbContext.TxnTptsummaries
                        .Where(e => e.WeDate == weDate);

                    var existingDetailsEntries = DbContext.TxnTptdetails1
                       .Where(e => e.WeDate == weDate);


                    DbContext.TxnTptsummaries.RemoveRange(existingSummaryEntries);
                    Log.Information("Done Delete TPT Summary", DateTime.Now);

                    DbContext.TxnTptdetails1.RemoveRange(existingDetailsEntries);
                    Log.Information("Done Delete TPT Details", DateTime.Now);



                    await DbContext.SaveChangesAsync(); // Save the deletion of existing entries

                    //GET REGIONAL SALES
                    var sqlRegionalSales = @"
        		SELECT  IndependentContractorID,MAX(WeekendingDate) WeekendingDate
		INTO #MinDateBA
		FROM  Mst_IndependentContractor_BAInfo_Weekending
		WHERE WEEKENDINGDATE < '@WEDate'
		GROUP BY  IndependentContractorID

				SELECT B.*
		INTO #BAInfo
		FROM Mst_IndependentContractor_BAInfo_Weekending b
		inner JOIN #MinDateBA A ON A.IndependentContractorId=B.IndependentContractorId AND A.WeekendingDate=B.WeekendingDate
			
		  

--GET ALL THE BA INFO		 
select A.BadgeNo,isnull(A.FirstName,'') + ' ' + isnull(A.LastName,'') BAName, CONVERT(INT,NULL) Campaign,'' Division,'' CampaignCode,'' CampaignName,'' CampaignCountryCode,A.CountryCode ,CONVERT( NVARCHAR(MAX),'') AS BadgeNoLink,
		    CASE WHEN OP1.IndependentContractorId IS NOT NULL THEN 'OP'
			ELSE C.LevelCode END  LevelCode,
			 CASE WHEN OP1.IndependentContractorId IS NOT NULL THEN 'OP1'
			WHEN   A.CountryCode  = 'KR' AND C.LevelCode='OP' AND  OP1.IndependentContractorId IS NULL THEN 'OP2'
			ELSE C.Level END  Level,
			E.Code MOCode,E.[Name] MCName,D.PointConversion,0 Amount INTO #BAInfo2 from VW_ICDetail A
left join  #BAInfo B
ON A.IndependentContractorId = B.IndependentContractorId  
 LEFT JOIN Mst_IndependentContractorLevel C
 ON CASE WHEN  B.IndependentContractorLevelId IS NULL THEN A.IndependentContractorLevelId ELSE  B.IndependentContractorLevelId END =C.IndependentContractorLevelId
 	LEFT JOIN VW_KoreaLevelOP1 OP1 ON OP1.IndependentContractorId = B.IndependentContractorId AND OP1.WeDate =  '@WEDate' AND OP1.IsActive=1
	 LEFT JOIN Mst_MarketingCompany E ON A.MarketingCompanyId = E.MarketingCompanyId
 INNER JOIN MST_TPTCountryPoint D ON A.CountryCode=D.Country AND     
			CASE WHEN OP1.IndependentContractorId IS NOT NULL THEN 'OP1'
			WHEN   A.CountryCode   = 'KR' AND C.LevelCode='OP' THEN 'OP2'
			ELSE C.LevelCode END  = D.BALevel AND '@WEDate'  BETWEEN D.StartWE AND EndWE AND D.isActive=1
			AND  E.LocationType= D.LocationType

			SELECT  distinct   case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalBadgeNo ELSE A.BadgeNo END BadgeNo,
			    CONVERT(INT,A.Campaign) Campaign,
            CAM.CampaignCode,
            CAM.CampaignName,CAM.CountryCode CampaignCountryCode,
            case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalCountryCode ELSE A.CountryCode END CountryCode
			INTO #SalesBa
			FROM TXN_RegionalSalesSummary A
         LEFT JOIN TXN_RegionalRoadtrip B ON A.CountryCode = B.RTCountryCode AND A.BadgeNo = B.RTBadgeNo AND A.StatusWeDate = B.Weekending
       	LEFT JOIN Mst_Campaign CAM ON CAM.CampaignId = a.Campaign       
        where   A.StatusWeDate = '@WEDate'
 
 UPDATE A
 SET BadgeNoLink=C.BadgeNoLink
 FROM #BAInfo2 A
 LEFT JOIN VW_BARelationship C ON    A.CountryCode  = C.CountryCode AND  A.BadgeNo   = C.BadgeNo AND   C.WEDate='@WEDate'
  
	      SELECT 
		  
            case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalBadgeNo ELSE A.BadgeNo END BadgeNo,
			IC.FirstName +' '+IC.LastName  BAName,
			DV.DivisionName Division,
            CONVERT(INT,A.Campaign) Campaign,
            CAM.CampaignCode,
            CAM.CampaignName,
			CAM.CountryCode CampaignCountryCode,
            case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalCountryCode ELSE A.CountryCode END CountryCode,
            C.BadgeNoLink,
            CASE WHEN OP1.IndependentContractorId IS NOT NULL THEN 'OP'
			ELSE L.LevelCode END  LevelCode,
			CASE WHEN OP1.IndependentContractorId IS NOT NULL THEN 'OP1'
			WHEN   case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalCountryCode ELSE A.CountryCode END = 'KR' and OP1.IndependentContractorId IS NULL AND L.LevelCode='OP' THEN 'OP2'
			ELSE L.Level END  Level,
			IC.Code  MoCode,
			IC.Name  McName,
            D.PointConversion,
			 sum(CASE WHEN A.STATUS LIKE '%Reject%' THEN (ISNULL(A.ICStroke,0))*-1
					ELSE (ISNULL(A.ICStroke,0)) END)
     --      CASE WHEN  OriCountry.CountryCode IS NULL THEN  sum(CASE WHEN A.STATUS LIKE '%Reject%' THEN (ISNULL(A.ICStroke,0)+ISNULL(A.Bonus1,0)+ISNULL(A.Bonus2,0))*-1
					--ELSE (ISNULL(A.ICStroke,0)+ISNULL(A.Bonus1,0)+ISNULL(A.Bonus2,0)) END)
					--ELSE 
					-- sum(CASE WHEN A.STATUS LIKE '%Reject%' THEN (ISNULL(A.ICStroke,0)+ISNULL(A.Bonus1,0)+ISNULL(A.Bonus2,0))*-1
					--ELSE (ISNULL(A.ICStroke,0)+ISNULL(A.Bonus1,0)+ISNULL(A.Bonus2,0)) END) / RTCountry.[ConversionRate] * OriCountry.[ConversionRate]
					--end 
					Amount
			 into #Result
        FROM  TXN_RegionalSalesSummary A
        LEFT JOIN  TXN_RegionalRoadtrip B ON A.CountryCode = B.RTCountryCode AND A.BadgeNo = B.RTBadgeNo AND A.StatusWeDate = B.Weekending
        LEFT JOIN  VW_BARelationship C ON  case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalCountryCode ELSE A.CountryCode END = C.CountryCode 
							AND  case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalBadgeNo ELSE A.BadgeNo END = C.BadgeNo AND A.StatusWeDate = C.WEDate
        LEFT JOIN  VW_IndependentContractor_BAInfo_Weekending BI ON case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalCountryCode ELSE A.CountryCode END = BI.CountryCode 
							AND  case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalBadgeNo ELSE A.BadgeNo END = BI.BadgeNo
							AND BI.WeekendingDate = A.StatusWeDate
		LEFT JOIN Mst_Campaign CAM	ON CAM.CampaignId = a.Campaign 
		LEFT JOIN MST_Division DV  ON CAM.DivisionId= DV.DivisionId
        LEFT JOIN    Mst_IndependentContractorLevel L ON BI.IndependentContractorLevelId = L.IndependentContractorLevelId
    	LEFT JOIN VW_ICDetail IC ON   case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalBadgeNo ELSE A.BadgeNo END = IC.BadgeNo AND 
									  case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalCountryCode ELSE A.CountryCode END = IC.CountryCode
		LEFT JOIN VW_KoreaLevelOP1 OP1 ON OP1.IndependentContractorId = IC.IndependentContractorId AND OP1.WeDate =  A.StatusWeDate AND OP1.IsActive=1
		LEFT JOIN Mst_MarketingCompany MC ON A.CountryCode=MC.CountryCode AND A.MOCode=MC.Code
		LEFT JOIN MST_TPTCountryPoint D ON A.CountryCode = D.Country AND   
				CASE WHEN OP1.IndependentContractorId IS NOT NULL THEN 'OP1'
			WHEN   case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalCountryCode ELSE A.CountryCode END = 'KR' AND L.LevelCode='OP' THEN 'OP2'
			ELSE L.LevelCode END = D.BALevel AND A.StatusWeDate BETWEEN D.StartWE AND D.EndWE And D.isActive=1
			AND MC.LocationType=D.LocationType
    WHERE  A.StatusWeDate ='@WEDate'
and A.Status in ('SubmissionDate','ClientrejectDate','ClientReSubmissionDate','RejectDate','ResubmissionDate','UpDownRejectDate','UpDownReSubDate') AND A.IsDeleted='N'
GROUP BY      case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalBadgeNo ELSE A.BadgeNo END,IC.FirstName +' '+IC.LastName,DV.DivisionName, Campaign,  CAM.CampaignCode,  CAM.CampaignName, CAM.CountryCode,
 case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalCountryCode ELSE A.CountryCode end,C.BadgeNoLink,
			   CASE WHEN OP1.IndependentContractorId IS NOT NULL THEN 'OP'
			ELSE L.LevelCode END ,
			CASE WHEN OP1.IndependentContractorId IS NOT NULL THEN 'OP1'
			WHEN   case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalCountryCode ELSE A.CountryCode END = 'KR' AND  OP1.IndependentContractorId IS NULL  AND L.LevelCode='OP' THEN 'OP2'
			ELSE L.Level END  ,
			IC.Code ,IC.Name,D.PointConversion

 --CONVERT RT CONVERTION , ONLY ORICOUNTRY AND ROADTRIP COUNTRY GOT DIFFERENT WILL CAL
  UPDATE #Result
  SET Amount=       CASE WHEN  A.CountryCode = A.CampaignCountryCode THEN   a.Amount
					else
					isnull(A.Amount,0) / RTCountry.[ConversionRate] * OriCountry.[ConversionRate]
					end
  FROM #Result A
  LEFT JOIN MST_RTConversionRate RTCountry ON  A.CampaignCountryCode =RTCountry.CountryCode  AND '@WEDate' BETWEEN RTCountry.StartDate AND RTCountry.EndDate 
  LEFT JOIN MST_RTConversionRate OriCountry ON a.CountryCode= OriCountry.CountryCode  AND '@WEDate' BETWEEN OriCountry.StartDate AND OriCountry.EndDate 

   SELECT A.BadgeNo,A.BAName,b.Division,B.Campaign,B.CampaignCode,B.CampaignName,CampaignCountryCode,A.CountryCode,A.BadgeNoLink,A.LevelCode,A.Level,A.MOCode,A.MCName,A.PointConversion,A.Amount 
   INTO #BAInfo3 FROM #BAInfo2 A
 LEFT JOIN  (SELECT DISTINCT A.BadgeNo,B.Division,B.Campaign,B.CampaignCode,B.CampaignName From #Result B
			 LEFT JOIN #BAInfo2 A  ON B.BadgeNoLink LIKE '%'+A.BadgeNo+'%'  
)  B
ON A.BadgeNo=B.BadgeNo  

--- DELETE EXIST MEMBER THAT IN SALES
 DELETE #BAInfo3
FROM #BAInfo3 A
INNER JOIN #SalesBa B ON A.BadgeNo = B.BadgeNo AND A.CountryCode=B.CountryCode AND A.Campaign=B.Campaign
 
 select * from #Result   
 union
 SELECT * FROM #BAInfo3   
  --drop table #BAInfo,#BAInfo2,#BAInfo3,#MinDateBA,#Result,#SalesBa
     
    
    
";
                     
 
                    sqlRegionalSales = sqlRegionalSales.Replace("@WEDate", weDate.ToString());

                    var resultRegionalSales = DbContext.Set<TPTSalesSummaryResult>().FromSqlRaw(sqlRegionalSales).ToList();

                    //GET BONUS  
                    var sql = @"
  SELECT 
               case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalBadgeNo ELSE A.BadgeNo END BadgeNo,
			IC.FirstName +' '+IC.LastName BAName,
			DV.[DivisionName] Division,
            A.Campaign,
            CAM.CampaignCode,
            CAM.CampaignName,
			CAM.CountryCode CampaignCountryCode,
            case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalCountryCode ELSE A.CountryCode END CountryCode,
            C.BadgeNoLink,
            CASE WHEN OP1.IndependentContractorId IS NOT NULL THEN 'OP'
			ELSE L.LevelCode END  LevelCode,
			 CASE WHEN OP1.IndependentContractorId IS NOT NULL THEN 'OP1'
			WHEN   case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalCountryCode ELSE A.CountryCode END = 'KR' AND  OP1.IndependentContractorId IS NULL AND L.LevelCode='OP' THEN 'OP2'
			ELSE L.Level END  Level,
            A.MOCode,
			IC.[Name] McName,
            D.PointConversion,
            sum(CASE WHEN CAM.CountryCode=case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalCountryCode ELSE A.CountryCode END  THEN  A.Amount ELSE A.Amount/ RTCountry.[ConversionRate] * OriCountry.[ConversionRate] END ) Amount
        FROM 
            TXN_SalesSummaryBonus A
        LEFT JOIN TXN_RegionalRoadtrip B ON A.CountryCode = B.RTCountryCode AND A.BadgeNo = B.RTBadgeNo AND A.StatusWE = B.Weekending
       LEFT JOIN  VW_BARelationship C ON  case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalCountryCode ELSE A.CountryCode END = C.CountryCode 
							AND  case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalBadgeNo ELSE A.BadgeNo END = C.BadgeNo AND A.StatusWE = C.WEDate
        LEFT JOIN   VW_IndependentContractor_BAInfo_Weekending BI ON case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalCountryCode ELSE A.CountryCode END = BI.CountryCode 
							AND  case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalBadgeNo ELSE A.BadgeNo END = BI.BadgeNo
							AND BI.WeekendingDate = A.StatusWE
		LEFT JOIN VW_ICDetail IC ON   case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalBadgeNo ELSE A.BadgeNo END = IC.BadgeNo AND 
									  case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalCountryCode ELSE A.CountryCode END = IC.CountryCode
		LEFT JOIN Mst_Campaign CAM	ON CAM.CampaignId = a.Campaign    
		LEFT JOIN Mst_Division dv	ON DV.DivisionId = CAM.DivisionId    
        LEFT JOIN Mst_IndependentContractorLevel L ON BI.IndependentContractorLevelId = L.IndependentContractorLevelId
		LEFT JOIN VW_KoreaLevelOP1 OP1 ON OP1.IndependentContractorId = IC.IndependentContractorId AND OP1.WeDate =  A.StatusWE AND OP1.IsActive=1
		LEFT JOIN Mst_MarketingCompany MC ON IC.MarketingCompanyId=MC.MarketingCompanyId 
        LEFT JOIN MST_TPTCountryPoint D ON A.CountryCode = D.Country AND   CASE WHEN OP1.IndependentContractorId IS NOT NULL THEN 'OP1'
			WHEN   case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalCountryCode ELSE A.CountryCode END = 'KR' AND L.LevelCode='OP' THEN 'OP2'
			ELSE L.LevelCode END = D.BALevel AND A.StatusWE BETWEEN D.StartWE AND D.EndWE AND D.isActive=1
			AND MC.LocationType=D.LocationType
			INNER JOIN MST_TPTBonus E ON A.StatusWE BETWEEN E.STARTDATE AND E.ENDDATE AND A.Division = E.DivisionId AND A.CountryCode = E.CountryCode AND E.[BonusCalculatedFlag]=1
		 LEFT JOIN MST_RTConversionRate RTCountry ON  CAM.CountryCode =RTCountry.CountryCode  AND a.StatusDate BETWEEN RTCountry.StartDate AND RTCountry.EndDate 
		LEFT JOIN MST_RTConversionRate OriCountry ON   case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalCountryCode ELSE A.CountryCode END= OriCountry.CountryCode  AND A.StatusWE BETWEEN OriCountry.StartDate AND OriCountry.EndDate 
    WHERE  A.StatusWE = '@WEDate'
AND BonusSource='SW'
GROUP BY   case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalBadgeNo ELSE A.BadgeNo END,DV.[DivisionName],IC.FirstName +' '+IC.LastName,DV.DivisionName, A.Campaign,  CAM.CampaignCode,  CAM.CampaignName,
   	CAM.CountryCode,  case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalCountryCode ELSE A.CountryCode END ,C.BadgeNoLink,
 CASE WHEN OP1.IndependentContractorId IS NOT NULL THEN 'OP'
				ELSE L.LevelCode END,
			 CASE WHEN OP1.IndependentContractorId IS NOT NULL THEN 'OP1'
			WHEN   case when B.OriginalBadgeNo IS NOT NULL THEN B.OriginalCountryCode ELSE A.CountryCode END = 'KR' AND  OP1.IndependentContractorId IS NULL AND L.LevelCode='OP' THEN 'OP2'
			ELSE L.Level END ,
	A.MOCode,IC.Name,D.PointConversion
";
                    sql = sql.Replace("@WEDate", weDate.ToString());

                    var result = DbContext.Set<TPTSalesSummaryResult>().FromSqlRaw(sql).ToList();

                    // COMBINE BOTH SALES
                    var combinedResults = resultRegionalSales.Concat(result).ToList();

                    // Perform the grouping operation based on the specified columns GROUP BY CAMPAIGN
                    var groupedResults = combinedResults
                        .GroupBy(item => new
                        {
                            item.BadgeNo,
                            item.BAName,
                            item.Division,
                            item.Campaign,
                            item.CampaignCode,
                            item.CampaignName,
                            item.CountryCode,
                            item.BadgeNoLink,
                            item.LevelCode,
                            item.Level,
                            item.MOCode,
                            item.MCName,
                            item.PointConversion
                        })
                        .Select(group => new
                        {
                            BadgeNo = group.Key.BadgeNo,
                            BAName = group.Key.BAName,
                            Division=group.Key.Division,
                            Campaign = group.Key.Campaign,
                            CampaignCode = group.Key.CampaignCode,
                            CampaignName = group.Key.CampaignName,
                            CountryCode = group.Key.CountryCode,
                            BadgeNoLink = group.Key.BadgeNoLink,
                            LevelCode = group.Key.LevelCode,
                            Level = group.Key.Level,
                            MOCode = group.Key.MOCode,
                            MCName = group.Key.MCName,
                            PointConversion = group.Key.PointConversion,

                            // You can add any aggregation logic here if needed, like sum, average, etc.
                            Amount = group.Sum(item => item.Amount),
                        })
                        .ToList();


                    //Details
                    var totalAmountDictionary = new Dictionary<(int? Campaign, string MoCode, string CountryCode, string BadgeNo), decimal?>();
                    var teamAmountDictionary = new Dictionary<(int? Campaign, string MoCode, string CountryCode, string BadgeNo), decimal?>();

                    foreach (var item in groupedResults)
                    {
                        // Group by Campaign, CountryCode, BadgeNo for total amount
                        var totalKey = (item.Campaign, item.MOCode, item.CountryCode, item.BadgeNo);
                        if (!totalAmountDictionary.ContainsKey(totalKey))
                        {
                            totalAmountDictionary[totalKey] = 0;
                        }
                        totalAmountDictionary[totalKey] += item.Amount;

                        // Initialize team amount (excluding self)
                        var teamKey = (item.Campaign, item.MOCode, item.CountryCode, item.BadgeNo);
                        if (!teamAmountDictionary.ContainsKey(teamKey))
                        {
                            teamAmountDictionary[teamKey] = 0;
                        }

                        // Find other items where BadgeNo is contained in their BadgeNoLink
                        foreach (var otherItem in groupedResults)
                        {

                            if (otherItem.BadgeNoLink?.Contains(item.BadgeNo) == true  && otherItem.Campaign == item.Campaign && otherItem.MOCode==item.MOCode && otherItem.CountryCode==item.CountryCode)
                            {
                                teamAmountDictionary[teamKey] += otherItem.Amount;
                            }


                        }
                    }

                    var txnDetailsList = groupedResults.Select(item => new TxnTptdetails
                    {

                        WeDate = weekendingDate,
                        CountryCode = item.CountryCode,
                        Division=item.Division,
                        Mccode = item.MOCode,
                        Mcname= item.MCName,
                        BadgeNo = item.BadgeNo,
                        Baname =item.BAName,
                        CurrentLevel = item.LevelCode,
                        BadgeNoLink = item.BadgeNoLink,

                        TeamProduction = (teamAmountDictionary.ContainsKey((item.Campaign, item.MOCode, item.CountryCode, item.BadgeNo))
                            ? teamAmountDictionary[(item.Campaign, item.MOCode, item.CountryCode, item.BadgeNo)]
                            : 0),
                        CampaignId = item.Campaign,  // Replace with the actual campaign value
                        NetValue = item.Amount,
                        Rate = item.PointConversion,
                        Point = (teamAmountDictionary.ContainsKey((item.Campaign, item.MOCode, item.CountryCode, item.BadgeNo))
                            ? teamAmountDictionary[(item.Campaign, item.MOCode, item.CountryCode, item.BadgeNo)]
                            : 0) / item.PointConversion * 100, // Assuming Point = PointConversion * Amount
                        Level = item.Level  // Assuming Rate = PointConversion
                    }).ToList();

                    // Add all the instances to the DbContext at once
                    DbContext.TxnTptdetails1.AddRange(txnDetailsList);

                    //Summary
                    var teamAmountDictionarySummary = new Dictionary<(string MoCode, string CountryCode, string BadgeNo), decimal?>();
                    var divisionDictionarySummary = new Dictionary<(string MoCode, string CountryCode, string BadgeNo), string>();
                    var campaignDictionarySummary = new Dictionary<(string MoCode, string CountryCode, string BadgeNo), string>();
                    foreach (var item in groupedResults)
                    {
                        // Group by Campaign, CountryCode, BadgeNo for total amount
                        var totalKey = (item.MOCode, item.CountryCode, item.BadgeNo);

                        // Initialize the campaign entry if it doesn't exist
                        if (!campaignDictionarySummary.ContainsKey(totalKey))
                        {
                            campaignDictionarySummary[totalKey] = string.Empty;
                        }



                        // Append campaign to campaign list
                        if (!string.IsNullOrEmpty(item.CampaignName) && !campaignDictionarySummary[totalKey].Contains(item.CampaignName))
                        {
                            if (!string.IsNullOrEmpty(campaignDictionarySummary[totalKey]))
                            {
                                campaignDictionarySummary[totalKey] += ", ";
                            }
                            campaignDictionarySummary[totalKey] += item.CampaignName;
                        }


                        if (!divisionDictionarySummary.ContainsKey(totalKey))
                        {
                            divisionDictionarySummary[totalKey] = string.Empty;
                        }

                        // Append division to division list
                        if (!string.IsNullOrEmpty(item.Division) && !divisionDictionarySummary[totalKey].Contains(item.Division))
                        {
                            if (!string.IsNullOrEmpty(divisionDictionarySummary[totalKey]))
                            {
                                divisionDictionarySummary[totalKey] += ", ";
                            }
                            divisionDictionarySummary[totalKey] += item.Division;
                        }

                        // Initialize team amount (excluding self)
                        var teamKey = (item.MOCode, item.CountryCode, item.BadgeNo);
                        if (!teamAmountDictionarySummary.ContainsKey(teamKey))
                        {
                            teamAmountDictionarySummary[teamKey] = 0;
                        }

                        // Find other items where BadgeNo is contained in their BadgeNoLink
                        foreach (var otherItem in groupedResults)
                        {
                            if (otherItem.BadgeNoLink?.Contains(item.BadgeNo) == true && otherItem.Campaign == item.Campaign && otherItem.MOCode == item.MOCode && otherItem.CountryCode == item.CountryCode)
                            {
                                teamAmountDictionarySummary[teamKey] += otherItem.Amount;
                            }
                        }
                    }

                     
                    var txnTPTSummary = groupedResults.Where(item => item.Level != "Owner Partner" ||  ( item.Level == "Owner Partner" && item.BadgeNoLink == item.BadgeNo))
                              .Select(item => new TxnTptsummary
                    {

                        WeDate = weekendingDate,
                        CountryCode = item.CountryCode,
                        Mccode = item.MOCode,
                       Mcname=item.MCName,
                        BadgeNo = item.BadgeNo,
                        Baname=item.BAName,
                        CurrentLevel = item.LevelCode,
                        BadgeNoLink = item.BadgeNoLink,
                        TeamProduction = teamAmountDictionarySummary.TryGetValue((item.MOCode, item.CountryCode, item.BadgeNo), out var teamAmount)
        ? teamAmount : 0,
                        Campaign = campaignDictionarySummary.TryGetValue((item.MOCode, item.CountryCode, item.BadgeNo), out var campaign)
        ? campaign
        : "",  // Default to an empty string if the key is not found
                        Division = divisionDictionarySummary.TryGetValue((item.MOCode, item.CountryCode, item.BadgeNo), out var divison)
        ? divison
        : "",  // Default to an empty string if the key is not found


                        NetValue = item.Amount,
                        Rate = item.PointConversion,
                        Ranking = null,
                        Point = teamAmountDictionarySummary.TryGetValue((item.MOCode, item.CountryCode, item.BadgeNo), out var teamAmount1)
        ? teamAmount1 / item.PointConversion * 100
        : 0,  // Assuming Point = PointConversion * Amount
                        Level = item.Level  // Assuming Rate = PointConversion
                    }).ToList();

                
                    var groupedResults2 = txnTPTSummary
                    .Where(item => item.Rate != null && item.TeamProduction!=0) // Filter out entries where Rate is null
                   .GroupBy(item => new
                   {
                       item.WeDate,
                       item.CountryCode,
                       item.Division,
                       item.Mccode,
                       item.Mcname,
                       item.BadgeNo,
                       item.Baname,
                       item.CurrentLevel,
                       item.BadgeNoLink,
                       item.TeamProduction,
                       item.Campaign,
                       item.Point,
                       item.Ranking,
                       item.Level,
                       item.Rate
     
                   })
                   .Select(group => new TxnTptsummary
                   {

                       WeDate= group.Key.WeDate,
                       CountryCode= group.Key.CountryCode,
                       Division = group.Key.Division,
                       Mccode= group.Key.Mccode,
                       Mcname= group.Key.Mcname,
                       BadgeNo= group.Key.BadgeNo,
                       Baname= group.Key.Baname,
                       CurrentLevel= group.Key.CurrentLevel,
                       BadgeNoLink= group.Key.BadgeNoLink,
                       TeamProduction= group.Key.TeamProduction,
                       Campaign= group.Key.Campaign,
                       Point= group.Key.Point,
                       Ranking= group.Key.Ranking,
                       Level= group.Key.Level,
                       Rate= group.Key.Rate,
                       // You can add any aggregation logic here if needed, like sum, average, etc.
                       NetValue = group.Sum(item => item.NetValue),
                   })
                   .ToList();


                    // Step 2: Sort by points in descending order
                    var groupedByLevel = groupedResults2
                        .GroupBy(x => x.CurrentLevel ?? "Unknown")
                        .ToDictionary(g => g.Key, g => g.OrderByDescending(x => (x.Point ?? 0)).ToList());

                    // Step 3: Assign rankings within each Level group
                    foreach (var levelGroup in groupedByLevel)
                    {
                        var rank = 1;
                        for (int i = 0; i < levelGroup.Value.Count; i++)
                        {
                            var currentItem = levelGroup.Value[i];

                            if (i > 0 && currentItem.Point == levelGroup.Value[i - 1].Point)
                            {
                                // If current point is the same as the previous one in the same level group, assign the same rank
                                currentItem.Ranking = levelGroup.Value[i - 1].Ranking;
                            }
                            else
                            {
                                // Assign the current rank and increment it
                                currentItem.Ranking = rank;
                            }

                            rank++;
                        }
                    }


                    // Step 3: Assign rankings

                    // Add all the instances to the DbContext at once
                    DbContext.TxnTptsummaries.AddRange(groupedResults2);


                    // Save the changes to the database
                    DbContext.SaveChanges();


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