-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetDigitalFormSettings2]
	-- Add the parameters for the stored procedure here
	@MarketingCompanyId int,
	@Createdby nvarchar(100) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.[dbo].[Mst_IndependentContractor]
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	IF EXISTS(SELECT TOP 1 * FROM Mst_DigitalFormSettings WHERE MarketingCompanyId = @MarketingCompanyId and FormType = 'PR')
	BEGIN
		SELECT a.* FROM Mst_DigitalFormSettings a
		WHERE a.MarketingCompanyId = @MarketingCompanyId order by a.CreatedDate desc
	END
	ELSE
	BEGIN
		INSERT INTO Mst_DigitalFormSettings (MarketingCompanyId,MiddleName,NickName,LocalFirstName,LocalLastName,
		Ic,Gender,Dob,Nationality,MaritalStatus,PhoneNumber,ResidentialAddress,Country,State,City,Postcode,HasPassport,
		HasCriminalConvictions,CriminalConvictionsDescription,ReasonForApplying,BusinessGoals,PersonalGoals,
		NameOfInstituition,HighestQualification,CourseName,YearofGraduation,LanguageWriting,LanguageSpeaking,
		CurrentCompanyName,CurrentCompanyPosition,CurrentCompanyPeriodofEmployment,CurrentCompanyLastofIncome,
		CurrentCompanyReasonofLeaving,PreviousCompany1Name,PreviousCompany1Position,PreviousCompany1PeriodofEmployment,
		PreviousCompany1LastofIncome,PreviousCompany1ReasonofLeaving,PreviousCompany2Name,PreviousCompany2Position,
		PreviousCompany2PeriodofEmployment,PreviousCompany2LastofIncome,PreviousCompany2ReasonofLeaving,Referee1Name,
		Referee1ContacNumber,Referee1CompanyName,Referee1Designation,Referee2Name,Referee2ContacNumber,Referee2CompanyName,
		Referee2Designation,FaceToFaceConfifdentDescription,BusinessOpportunityRate,LearningOpportunityRate,HighEarningRate,
		ChallengingProjectsRate,RecognitionRate,LeadershipRate,CustomerServiceRate,BankruptDescription,
		BusinessInvolvementDescription,SufferMedicalDescription,DateofAvailability,ExpectedIncome,
		CreatedBy,CreatedDate,Referee1Type,Referee2Type,DateofCommenceWork,FormType)
		VALUES (@MarketingCompanyId,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,@Createdby,GETDATE(),0,0,0,'PR')

		IF NOT EXISTS(SELECT TOP 1 * FROM Mst_DigitalFormSettings WHERE MarketingCompanyId = @MarketingCompanyId and FormType = 'OR')
		BEGIN
			INSERT INTO Mst_DigitalFormSettings (MarketingCompanyId,CreatedBy,CreatedDate,FormType)
			VALUES (@MarketingCompanyId,@Createdby,GETDATE(),'OR')
		END

		SELECT a.* FROM Mst_DigitalFormSettings a
		WHERE a.MarketingCompanyId = @MarketingCompanyId order by a.CreatedDate desc
	END
END	

