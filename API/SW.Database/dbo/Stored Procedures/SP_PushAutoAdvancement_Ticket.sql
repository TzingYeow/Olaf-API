
-- EXEC SP_PushAutoAdvancement 'TH','26/06/2022' ,37285,4
--SELECT CONVERT(DATE,'26/06/2022',103)
CREATE PROCEDURE [dbo].[SP_PushAutoAdvancement_Ticket]
	@CountryCode NVARCHAR(5),
	@AdvancementDate NVARCHAR(50),
	@IndependentContractorId INT,
	@CurrentLevel INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--IN
--DECLARE @CountryCode nvarchar(5) = 'MY'
--DECLARE @AdvancementDate date = '2021-09-09'
--DECLARE @IndependentContractorId int = 585
--DECLARE @CurrentLevel INT = 4
 
	DECLARE @ReportBadgeEmail nvarchar(50)
	DECLARE @ReportBadgeName nvarchar(50)
	DECLARE @OwnerEmail nvarchar(50)
	DECLARE @OwnerName nvarchar(50)
	DECLARE @ICFullName nvarchar(50)
	DECLARE @McCode nvarchar(50)
	DECLARE @AdminEmail NVARCHAR(500)
	DECLARE @AdvancementDateDisplay DATE
	SET @AdvancementDateDisplay = CONVERT(DATE,@AdvancementDate,103)
 PRINT '1'
	SELECT
	@ReportBadgeEmail = (SELECT b.email FROM Mst_IndependentContractor b  LEFT JOIN Mst_MarketingCompany C ON B.MarketingCompanyId = C.MarketingCompanyId  WHERE b.BadgeNo = i.ReportBadgeNo and c.CountryCode = @CountryCode ),-- and b.MarketingCompanyId = i.MarketingCompanyId), 
	@ReportBadgeName = (SELECT TOP 1 B.Name FROM Mst_IndependentContractor a LEFT JOIN Mst_MarketingCompany_Staff B ON A.MarketingCompanyId = B.MarketingCompanyId where IndependentContractorId = @IndependentContractorId),-- (SELECT RTRIM(ISNULL(FirstName,'') + ' ' + ISNULL(LastName,'')) FROM Mst_IndependentContractor b  LEFT JOIN Mst_MarketingCompany C ON B.MarketingCompanyId = C.MarketingCompanyId  WHERE b.BadgeNo = i.ReportBadgeNo and c.CountryCode = @CountryCode),-- and b.MarketingCompanyId = i.MarketingCompanyId) , 
	@OwnerEmail = s.Email, @OwnerName = s.Name, 
	@ICFullName = CONCAT(TRIM(CONCAT(FirstName, ' ', MiddleName)), ' ' , LastName), @McCode = m.Name
	FROM Mst_IndependentContractor i
	INNER JOIN Mst_MarketingCompany m ON i.MarketingCompanyId = m.MarketingCompanyId
	LEFT JOIN Mst_MarketingCompany_Staff s ON i.MarketingCompanyId = s.MarketingCompanyId
	where i.IndependentContractorId = @IndependentContractorId AND CountryCode = @CountryCode
	PRINT @ReportBadgeEmail


	 PRINT '2'


	IF @ReportBadgeEmail IS NOT NULL
	BEGIN
	 
		print (@ReportBadgeEmail +  @OwnerEmail)
		DECLARE @EmailReceiver nvarchar(800)

		SET @EmailReceiver = (Select SUBSTRING((SELECT ';' + x.email  FROM Mst_EmailReceiver x  where x.IsDeleted = 0  and X.Email not in ('Not Needed')
		and x.CountryCode = @CountryCode FOR XML PATH('') ), 2 , 9999))
		SET @AdminEmail = (Select SUBSTRING((SELECT ';' + A.email FROM Mst_User A INNER JOIN Mst_IndependentContractor B ON A.MarketingCompanyId = B.MarketingCompanyId where TRIM(ISNULL(A.email,'')) <> '' and A.IsActive = 1 and A.IsDeleted = 0 and B.IndependentContractorId = @IndependentContractorId
		 FOR XML PATH('') ), 2 , 9999))

		--DECLARE @NextLevel INT = 7
		DECLARE @TextTag nvarchar(50) 
		DECLARE @EmailContent nvarchar(2000)
		DECLARE @EmailSubject nvarchar(100)

		IF @CurrentLevel = 4 -- ADVANCE TO TEAM LEADER
		BEGIN 
			SET @TextTag = 'EmailAutoAdvancementTL';
		END
		ELSE IF @CurrentLevel = 7 and @CountryCode not in ( 'MY','TW','TH','HK') -- SENIOR TEAM LEADER
		BEGIN
			SET @TextTag =  'EmailAutoAdvancementSTL'
		END
		ELSE IF @CurrentLevel = 7 and @CountryCode in ( 'MY','TW','TH','HK') -- SENIOR TEAM LEADER
		BEGIN
			SET @TextTag =  'EmailAutoAdvancementAO'
		END
		ELSE IF @CurrentLevel in (9,1)	-- OP
		BEGIN
			SET @TextTag =  'EmailAutoAdvancementOP'
		END
		ELSE IF @CurrentLevel = 8	-- ASSISTANT OWNER
		BEGIN
			SET @TextTag =  'EmailAutoAdvancementAO'
		END
		--PRINT @TextTag

		SELECT @TextTag 

		Select @EmailContent = Case @CountryCode 
		When 'KR' Then (SELECT KRDescription FROM Mst_Localization WHERE TextTag = @TextTag AND TextType = 'FullContent')
		When 'TW' Then (SELECT TWDescription FROM Mst_Localization WHERE TextTag = @TextTag AND TextType = 'FullContent')
		When 'HK' Then (SELECT HKDescription FROM Mst_Localization WHERE TextTag = @TextTag AND TextType = 'FullContent')
		When 'TH' Then (SELECT THDescription FROM Mst_Localization WHERE TextTag = @TextTag AND TextType = 'FullContent')
		Else (SELECT ENDescription FROM Mst_Localization WHERE TextTag = @TextTag AND TextType = 'FullContent')
		End 
		--PRINT @CountryCode
		--PRINT @EmailContent

		Select @EmailSubject = Case @CountryCode 
		When 'KR' Then (SELECT KRDescription FROM Mst_Localization WHERE TextTag = @TextTag AND TextType = 'Subject')
		When 'TW' Then (SELECT TWDescription FROM Mst_Localization WHERE TextTag = @TextTag AND TextType = 'Subject')
		When 'HK' Then (SELECT HKDescription FROM Mst_Localization WHERE TextTag = @TextTag AND TextType = 'Subject')
		When 'TH' Then (SELECT THDescription FROM Mst_Localization WHERE TextTag = @TextTag AND TextType = 'Subject')
		Else (SELECT ENDescription FROM Mst_Localization WHERE TextTag = @TextTag AND TextType = 'Subject')
		End 
		 
		 SELECT @EmailSubject, @EmailContent,@ReportBadgeName,@ICFullName,@AdvancementDateDisplay,@McCode
		SET @EmailContent = (SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
							REPLACE(@EmailContent, '[OWNERFULLNAME]', @ReportBadgeName),
							'[CONTRACTORFULLNAME]', @ICFullName),
							'[ADVANCEMENTDATE]', FORMAT(@AdvancementDateDisplay, 'dd-MM-yyyy')),
							'[DUEDATE]', FORMAT(DATEADD(DAY, 7, GETDATE()), 'dd-MM-yyyy')),
							'[BSUDATE]', FORMAT(DATEADD(DAY, 6, GETDATE()), 'dd-MM-yyyy')),
							'[DUEDATE2]', FORMAT(DATEADD(DAY, 5, GETDATE()), 'dd-MM-yyyy')),
							'[MC]', @McCode));
				
 
		Insert TXN_EmailQueue2 (TxnID, Description, Recipient, CC, Subject, Body, CreateDate, CreateBy)
		select CONCAT('ICAutoAdvancement-', CONVERT(NVARCHAR(20),GETDATE(),20), '-', Cast(@IndependentContractorId as nvarchar)), 
		CONCAT('AutoAdvancement-', Cast(@IndependentContractorId as nvarchar)), 
		'leonard.yong@salesworks.asia;adilla.aziz@salesworks.asia','leonard.yong@salesworks.asia', 
		CONCAT(@EmailSubject, @ICFullName), 
		@EmailContent, GETDATE(), 'Admin' 
 
		SELECT 1 AS result;
	END
	ELSE
	BEGIN
		SELECT 0 AS result;
	END
END
 
