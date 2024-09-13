using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstRecruitmentComparisonSummary
{
    public int RecruitmentComparisonSummaryId { get; set; }

    public int MarketingCompanyId { get; set; }

    public int OwnerIndependentContractorId { get; set; }

    public string Channel { get; set; }

    public string RecruiterNameOrBadgeNo { get; set; }

    public string CountryCode { get; set; }

    public DateTime WeekendingDate { get; set; }

    public int OrRecruitmentInterviewBookCount { get; set; }

    public int OrRecruitmentInterviewTurnedUpCount { get; set; }

    public double? OrRecruitmentInterviewTurnedUpPercentage { get; set; }

    public int PrRecruitmentInterviewBookCount { get; set; }

    public int PrRecruitmentInterviewTurnedUpCount { get; set; }

    public double? PrRecruitmentInterviewTurnedUpPercentage { get; set; }

    public int OrRecruitmentObservationBookCount { get; set; }

    public int OrRecruitmentObservationTurnedUpCount { get; set; }

    public double? OrRecruitmentObservationTurnedUpPercentage { get; set; }

    public int PrRecruitmentObservationBookCount { get; set; }

    public int PrRecruitmentObservationTurnedUpCount { get; set; }

    public double? PrRecruitmentObservationTurnedUpPercentage { get; set; }

    public int OrRecruitmentTrainingBookCount { get; set; }

    public int OrRecruitmentTrainingTurnedUpCount { get; set; }

    public double? OrRecruitmentTrainingTurnedUpPercentage { get; set; }

    public int PrRecruitmentTrainingBookCount { get; set; }

    public int PrRecruitmentTrainingTurnedUpCount { get; set; }

    public double? PrRecruitmentTrainingTurnedUpPercentage { get; set; }

    public int OrIdBadgeIsssuedCount { get; set; }

    public int PrIdBadgeIsssuedCount { get; set; }

    public int OrTotalHeadCount { get; set; }

    public int PrTotalHeadCount { get; set; }

    public int OrLeaderHeadCount { get; set; }

    public int PrLeaderHeadCount { get; set; }

    public int OrLeaderAdvancementCount { get; set; }

    public int PrLeaderAdvancementCount { get; set; }

    public int OrLeaderTerminationCount { get; set; }

    public int PrLeaderTerminationCount { get; set; }

    public int OrNonLeaderTerminationCount { get; set; }

    public int PrNonLeaderTerminationCount { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public virtual MstMarketingCompany MarketingCompany { get; set; }

    public virtual MstIndependentContractor OwnerIndependentContractor { get; set; }
}
