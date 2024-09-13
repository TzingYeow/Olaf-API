using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class TxnAutoAdvancementResult
{
    public DateOnly? ScheduleWeekending { get; set; }

    public string CountryCode { get; set; }

    public DateOnly? Weekending1 { get; set; }

    public string BadgeNo { get; set; }

    public string DirectReportBadgeNo { get; set; }

    public string Balink { get; set; }

    public string Bastatus { get; set; }

    public int? IndependentContractorId { get; set; }

    public int? IndependentContractorLevelId { get; set; }

    public string Balevel { get; set; }

    public string Webalevel { get; set; }

    public DateOnly? PromotionDate1 { get; set; }

    public decimal? BapersonalSalesValue { get; set; }

    public decimal? BapersonalPoint { get; set; }

    public int? BasubPcs { get; set; }

    public string CriteriaSubPcs { get; set; }

    public string CriteriaTeamSizeLevel { get; set; }

    public string Baprovince { get; set; }

    public string CriteriaProvince { get; set; }

    public decimal? BasalesValue { get; set; }

    public decimal? CriteriaSalesValue { get; set; }

    public int? BasalesPcs { get; set; }

    public int? CriteriaSalesPcs { get; set; }

    public int? BateamSize { get; set; }

    public int? CriteriaTeamSize { get; set; }

    public decimal? BabulettinPoint { get; set; }

    public decimal? CriteriaBuletinPoint { get; set; }

    public int? BafirstGenLeader { get; set; }

    public int? CriterialFirstGenLeader { get; set; }

    public DateOnly? Weekending2 { get; set; }

    public string DirectReportBadgeNo2 { get; set; }

    public string Balevel2 { get; set; }

    public string Webalevel2 { get; set; }

    public DateOnly? PromotionDate2 { get; set; }

    public string Balink2 { get; set; }

    public string Bastatus2 { get; set; }

    public string Baprovince2 { get; set; }

    public decimal? BapersonalSalesValue2 { get; set; }

    public decimal? BapersonalPoint2 { get; set; }

    public int? BasubPcs2 { get; set; }

    public string CriteriaSubPcs2 { get; set; }

    public string CriteriaTeamSizeLevel2 { get; set; }

    public string CriteriaProvince2 { get; set; }

    public decimal? BasalesValue2 { get; set; }

    public decimal? CriteriaSalesValue2 { get; set; }

    public int? BasalesPcs2 { get; set; }

    public int? CriteriaSalesPcs2 { get; set; }

    public int? BateamSize2 { get; set; }

    public int? CriteriaTeamSize2 { get; set; }

    public decimal? BabulettinPoint2 { get; set; }

    public decimal? CriteriaBuletinPoint2 { get; set; }

    public int? BafirstGenLeader2 { get; set; }

    public int? CriterialFirstGenLeader2 { get; set; }

    public string Week1Result { get; set; }

    public string Week2Result { get; set; }

    public string FinalResult { get; set; }

    public string Remark { get; set; }

    public string ScheduleBalevel { get; set; }

    public bool? IsDeleted { get; set; }

    public DateTime? CreatedDate { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public bool? We1hitLevelRequirement { get; set; }

    public bool? We2hitLevelRequirement { get; set; }
}
