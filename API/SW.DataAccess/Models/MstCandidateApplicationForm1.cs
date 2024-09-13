using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstCandidateApplicationForm1
{
    public int CandidateApplicationForm1Id { get; set; }

    public int RecruitmentCandidateId { get; set; }

    public string FirstName { get; set; }

    public string MiddleName { get; set; }

    public string LastName { get; set; }

    public string NickName { get; set; }

    public string LocalFirstName { get; set; }

    public string LocalLastName { get; set; }

    public string Ic { get; set; }

    public string Gender { get; set; }

    public DateTime? Dob { get; set; }

    public string Nationality { get; set; }

    public string MaritalStatus { get; set; }

    public string Email { get; set; }

    public string MobileNumber { get; set; }

    public string PhoneNumber { get; set; }

    public string ResidentialAddress { get; set; }

    public string Country { get; set; }

    public string State { get; set; }

    public string City { get; set; }

    public string Postcode { get; set; }

    public bool? HasPassport { get; set; }

    public bool? HasCriminalConvictions { get; set; }

    public string CriminalConvictionsDescription { get; set; }

    public string ReasonForApplying { get; set; }

    public string BusinessGoals { get; set; }

    public string PersonalGoals { get; set; }

    public string NameOfInstituition { get; set; }

    public string HighestQualification { get; set; }

    public string CourseName { get; set; }

    public int? YearofGraduation { get; set; }

    public string LanguageWriting { get; set; }

    public string LanguageSpeaking { get; set; }

    public string CurrentCompanyName { get; set; }

    public string CurrentCompanyPosition { get; set; }

    public string CurrentCompanyPeriodofEmployment { get; set; }

    public string CurrentCompanyLastofIncome { get; set; }

    public string CurrentCompanyReasonofLeaving { get; set; }

    public string PreviousCompany1Name { get; set; }

    public string PreviousCompany1Position { get; set; }

    public string PreviousCompany1PeriodofEmployment { get; set; }

    public string PreviousCompany1LastofIncome { get; set; }

    public string PreviousCompany1ReasonofLeaving { get; set; }

    public string PreviousCompany2Name { get; set; }

    public string PreviousCompany2Position { get; set; }

    public string PreviousCompany2PeriodofEmployment { get; set; }

    public string PreviousCompany2LastofIncome { get; set; }

    public string PreviousCompany2ReasonofLeaving { get; set; }

    public string Referee1Name { get; set; }

    public string Referee1ContacNumber { get; set; }

    public string Referee1CompanyName { get; set; }

    public string Referee1Designation { get; set; }

    public string Referee2Name { get; set; }

    public string Referee2ContacNumber { get; set; }

    public string Referee2CompanyName { get; set; }

    public string Referee2Designation { get; set; }

    public string FaceToFaceConfifdentDescription { get; set; }

    public int? BusinessOpportunityRate { get; set; }

    public int? LearningOpportunityRate { get; set; }

    public int? HighEarningRate { get; set; }

    public int? ChallengingProjectsRate { get; set; }

    public int? RecognitionRate { get; set; }

    public int? LeadershipRate { get; set; }

    public int? CustomerServiceRate { get; set; }

    public string BankruptDescription { get; set; }

    public string BusinessInvolvementDescription { get; set; }

    public string SufferMedicalDescription { get; set; }

    public DateTime? DateofAvailability { get; set; }

    public string ExpectedIncome { get; set; }

    public string Status { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public string Referee1Type { get; set; }

    public string Referee2Type { get; set; }

    public DateTime? DateofCommenceWork { get; set; }

    public string MobileNumberHeader { get; set; }

    public string PhoneNumberHeader { get; set; }

    public string CurrentCompanyCurrency { get; set; }

    public string CurrentCompanyIncomeType { get; set; }

    public string PreviousCompany1Currency { get; set; }

    public string PreviousCompany1IncomeType { get; set; }

    public string PreviousCompany2Currency { get; set; }

    public string Referee1ContacNumberPrefixCode { get; set; }

    public string Referee2ContacNumberPrefixCode { get; set; }

    public string ExpectedIncomeType { get; set; }

    public string ExpectedIncomeCurrency { get; set; }

    public virtual MstRecruitmentCandidate RecruitmentCandidate { get; set; }
}
