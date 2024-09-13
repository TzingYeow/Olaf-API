using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstRecruitmentCandidateArchive
{
    public int RecruitmentCandidateArchiveId { get; set; }

    public int MarketingCompanyId { get; set; }

    public string BadgeNo { get; set; }

    public string FirstName { get; set; }

    public string MiddleName { get; set; }

    public string LastName { get; set; }

    public DateTime? Dob { get; set; }

    public string Email { get; set; }

    public string Nationality { get; set; }

    public string PhoneNumber { get; set; }

    public int RecruitmentCandidateId { get; set; }

    public string Remark { get; set; }

    public string EducationLevel { get; set; }

    public string RecruitmentType { get; set; }

    public string RecruiterBadgeNoOrName { get; set; }

    public string RecruiterNote { get; set; }

    public string RecruitmentSource { get; set; }

    public string AdvertisementTitle { get; set; }

    public string AddressLine1 { get; set; }

    public string AddressLine2 { get; set; }

    public string AddressLine3 { get; set; }

    public string AddressCity { get; set; }

    public string AddressPostCode { get; set; }

    public string AddressState { get; set; }

    public string AddressCountry { get; set; }

    public string EmergencyContactPerson { get; set; }

    public string EmergencyContactRelationship { get; set; }

    public string EmergencyContactPhoneNumber { get; set; }

    public string Gender { get; set; }

    public string Ic { get; set; }

    public string BankName { get; set; }

    public string BankBranch { get; set; }

    public string BankAccountName { get; set; }

    public string BankAccountNo { get; set; }

    public string BankSwiftCode { get; set; }

    public string PassportName { get; set; }

    public string PassportNo { get; set; }

    public DateTime? PassportIssueDate { get; set; }

    public DateTime? PassportExpiredDate { get; set; }

    public string PassportIssueCountry { get; set; }

    public string Status { get; set; }

    public bool IsTemporary { get; set; }

    public string LocalFirstName { get; set; }

    public string LocalLastName { get; set; }

    public bool IsPartime { get; set; }

    public string TeamName { get; set; }

    public string Nickname { get; set; }

    public int CountryRunningNumber { get; set; }

    public string AccessCode { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public string BankCountryCode { get; set; }

    public string Batype { get; set; }
}
