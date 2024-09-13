using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class VwReportingBa
{
    public int Baid { get; set; }

    public string BadgeNo { get; set; }

    public string OriginalBadgeNo { get; set; }

    public int Mcid { get; set; }

    public string Mccode { get; set; }

    public string Mcname { get; set; }

    public string Mccountry { get; set; }

    public string Mcstatus { get; set; }

    public string ReportBadgeNo { get; set; }

    public string Level { get; set; }

    public string LevelCode { get; set; }

    public string ParentLevel { get; set; }

    public string Status { get; set; }

    public string FirstName { get; set; }

    public string MiddleName { get; set; }

    public string LastName { get; set; }

    public string Nickname { get; set; }

    public string LocalFirstName { get; set; }

    public string LocalLastName { get; set; }

    public string Gender { get; set; }

    public string Ic { get; set; }

    public DateTime? Dob { get; set; }

    public string PhoneNumber { get; set; }

    public string MobileNumber { get; set; }

    public string Email { get; set; }

    public string Nationality { get; set; }

    public DateTime? StartDate { get; set; }

    public DateTime? FirstDayOnField { get; set; }

    public DateTime? LastSalesSubmissionDate { get; set; }

    public string EducationLevel { get; set; }

    public string MaritalStatus { get; set; }

    public string BirthPlace { get; set; }

    public string PermanentAddress { get; set; }

    public string Beneficiary1 { get; set; }

    public string Beneficiary2 { get; set; }

    public string AddressLine1 { get; set; }

    public string AddressLine2 { get; set; }

    public string AddressLine3 { get; set; }

    public string AddressCity { get; set; }

    public string AddressPostCode { get; set; }

    public string AddressState { get; set; }

    public string AddressCountry { get; set; }

    public string EmergencyContactPerson { get; set; }

    public string EmergencyContactPhoneNumber { get; set; }

    public string EmergencyContactRelationship { get; set; }

    public string RecruitmentType { get; set; }

    public string RecruiterBadgeNoOrName { get; set; }

    public string RecruiterNote { get; set; }

    public string RecruitmentSource { get; set; }

    public string AdvertisementTitle { get; set; }

    public string BankName { get; set; }

    public string BankBranch { get; set; }

    public string BankAccountName { get; set; }

    public string BankAccountNo { get; set; }

    public string BankSwiftCode { get; set; }

    public string TaxNumber { get; set; }

    public string ReturnMaterialRemarks { get; set; }

    public decimal? BondLimit { get; set; }

    public decimal? BondPercentage { get; set; }

    public int? RecruitmentCandidateId { get; set; }

    public string Remark { get; set; }

    public bool? IsStayBackTeam { get; set; }

    public bool? IsGoBackTeam { get; set; }

    public DateTime? EffectiveAdvancementDate { get; set; }

    public DateTime? LastDeactivateDate { get; set; }

    public string FirstAttemptScore { get; set; }

    public DateTime? FirstAttemptSubDate { get; set; }

    public string SecondAttemptScore { get; set; }

    public DateTime? SecondAttemptSubDate { get; set; }

    public string PaymentSchema { get; set; }

    public string TeamName { get; set; }

    public bool IsPartime { get; set; }

    public double? WithHoldingTax { get; set; }

    public double? Nhi { get; set; }

    public bool IsTemporary { get; set; }

    public DateTime? AgreementSignedDate { get; set; }

    public string SalesBranch { get; set; }

    public DateTime? CreatedDate { get; set; }

    public DateTime? UpdatedDate { get; set; }
}
