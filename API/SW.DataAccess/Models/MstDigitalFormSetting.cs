using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstDigitalFormSetting
{
    public int MarketingCompanyId { get; set; }

    public bool? FirstName { get; set; }

    public bool? MiddleName { get; set; }

    public bool? LastName { get; set; }

    public bool? NickName { get; set; }

    public bool? LocalFirstName { get; set; }

    public bool? LocalLastName { get; set; }

    public bool? Ic { get; set; }

    public bool? Gender { get; set; }

    public bool? Dob { get; set; }

    public bool? Nationality { get; set; }

    public bool? MaritalStatus { get; set; }

    public bool? Email { get; set; }

    public bool? MobileNumber { get; set; }

    public bool? PhoneNumber { get; set; }

    public bool? ResidentialAddress { get; set; }

    public bool? Country { get; set; }

    public bool? State { get; set; }

    public bool? City { get; set; }

    public bool? Postcode { get; set; }

    public bool? HasPassport { get; set; }

    public bool? HasCriminalConvictions { get; set; }

    public bool? CriminalConvictionsDescription { get; set; }

    public bool? ReasonForApplying { get; set; }

    public bool? BusinessGoals { get; set; }

    public bool? PersonalGoals { get; set; }

    public bool? NameOfInstituition { get; set; }

    public bool? HighestQualification { get; set; }

    public bool? CourseName { get; set; }

    public bool? YearofGraduation { get; set; }

    public bool? LanguageWriting { get; set; }

    public bool? LanguageSpeaking { get; set; }

    public bool? CurrentCompanyName { get; set; }

    public bool? CurrentCompanyPosition { get; set; }

    public bool? CurrentCompanyPeriodofEmployment { get; set; }

    public bool? CurrentCompanyLastofIncome { get; set; }

    public bool? CurrentCompanyReasonofLeaving { get; set; }

    public bool? PreviousCompany1Name { get; set; }

    public bool? PreviousCompany1Position { get; set; }

    public bool? PreviousCompany1PeriodofEmployment { get; set; }

    public bool? PreviousCompany1LastofIncome { get; set; }

    public bool? PreviousCompany1ReasonofLeaving { get; set; }

    public bool? PreviousCompany2Name { get; set; }

    public bool? PreviousCompany2Position { get; set; }

    public bool? PreviousCompany2PeriodofEmployment { get; set; }

    public bool? PreviousCompany2LastofIncome { get; set; }

    public bool? PreviousCompany2ReasonofLeaving { get; set; }

    public bool? Referee1Name { get; set; }

    public bool? Referee1ContacNumber { get; set; }

    public bool? Referee1CompanyName { get; set; }

    public bool? Referee1Designation { get; set; }

    public bool? Referee2Name { get; set; }

    public bool? Referee2ContacNumber { get; set; }

    public bool? Referee2CompanyName { get; set; }

    public bool? Referee2Designation { get; set; }

    public bool? FaceToFaceConfifdentDescription { get; set; }

    public bool? BusinessOpportunityRate { get; set; }

    public bool? LearningOpportunityRate { get; set; }

    public bool? HighEarningRate { get; set; }

    public bool? ChallengingProjectsRate { get; set; }

    public bool? RecognitionRate { get; set; }

    public bool? LeadershipRate { get; set; }

    public bool? CustomerServiceRate { get; set; }

    public bool? BankruptDescription { get; set; }

    public bool? BusinessInvolvementDescription { get; set; }

    public bool? SufferMedicalDescription { get; set; }

    public bool? DateofAvailability { get; set; }

    public bool? ExpectedIncome { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public bool? Referee1Type { get; set; }

    public bool? Referee2Type { get; set; }

    public bool? DateofCommenceWork { get; set; }

    public string FormType { get; set; }

    public string TriggerPoint { get; set; }
}
