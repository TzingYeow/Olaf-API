--select * From Mst_IndependentContractor where BadgeNo='UN0456'
--	SP_ProcessOlafAutoAdvancement 1
--=============================
CREATE PROCEDURE [dbo].[SP_ProcessOlafAutoAdvancement] 
	@Process as Bit
AS
BEGIN
	DECLARE @WeDate as DATE
	SET @WeDate = (SELECT TOP 1 WEdate FROM Mst_Weekending where wedate < GETDATE() order by WEdate desc)
 
	SET @WeDate =  '2024-04-28'
	DROP TABLE IF EXISTS #Result
	SELECT A.* INTO #Result FROM TXN_AutoAdvancementResult A LEFT JOIN Mst_IndependentContractor B ON A.IndependentContractorID = B.IndependentContractorId
	LEFT JOIN Mst_MarketingCompany C ON B.MarketingCompanyId = C.MarketingCompanyId WHERE ScheduleWeekending = @WeDate and A.IsDeleted = 0
	and FinalResult = 'YES'  and A.BadgeNo in ('MM0114')
 

	IF @WeDate = '2022-05-15'
	BEGIN
		INSERT INTO #Result 
		SELECT * FROM TXN_AutoAdvancementResult WHERE ScheduleWeekending = @WeDate and IndependentContractorID = 25556
		  UPDATE #Result SET FinalResult = 'YES', IndependentContractorLevelId = 8 WHERE  IndependentContractorID = 25556
	END 
	 
	SELECT A.*, C.LevelOrdinal, D.IndependentContractorLevelId as 'NewIndependentContractorLevelId', ISNULL(B.EffectiveAdvancementDate,B.StartDate) as 'LastAdvanceDate' INTO #ConfirmedAdvanceBA FROM #Result A 
	LEFT JOIN Mst_IndependentContractor B ON A.IndependentContractorID = B.IndependentContractorID
	LEFT JOIN Mst_IndependentContractorLevel C ON A.IndependentContractorLevelId = C.IndependentContractorLevelId
	LEFT JOIN Mst_IndependentContractorLevel D ON C.LevelOrdinal + 1 = D.LevelOrdinal 
	WHERE FinalResult = 'YES'  and B.MarketingCompanyId not in (1474)   
	and A.BadgeNo IN ('MM0114')
 
	
	   
	IF @Process = 1
	BEGIN

		--Insert into Movement
		INSERT INTO Mst_IndependentContractor_Movement (IndependentContractorId, Description,IndependentContractorLevelId, PromotionDemotionDate, EffectiveDate, HasExecuted, IsDeleted, CreatedBy, CreatedDate)
		SELECT IndependentContractorId, 'Advance', C.IndependentContractorLevelId as '@ICLevel' , @WeDate, CAST(DATEADD(DAY, 7, @WeDate) as date), 0, 0, 'AutoAdvancement', GETDATE()  
		FROM #ConfirmedAdvanceBA A
		LEFT JOIN Mst_IndependentContractorLevel B ON A.IndependentContractorLevelId = B.IndependentContractorLevelId
		LEFT JOIN Mst_IndependentContractorLevel C ON C.LevelOrdinal  = B.LevelOrdinal  + CASE WHEN B.IndependentContractorLevelId = 7 THEN 2 ELSE 1 END -- Level 7 Skip STL.
		-- Advancement WE28012024 removing STL for korea
		--LEFT JOIN Mst_IndependentContractorLevel C ON C.LevelOrdinal  = B.LevelOrdinal  + CASE WHEN B.IndependentContractorLevelId = 7 and A.CountryCode not in ('KR')  THEN 2 ELSE 1 END -- Level 7 Skip STL.
	END

 DECLARE @LOOP as BIT
 DECLARE @IndependentContractor as INT
 DECLARE @CountryCode as NVARCHAR(5)
 DECLARE @CurrentLevel as INT
 DECLARE @AdvancementDate as NVARCHAR(50)
 SET @LOOP = 0

 IF (SELECT COUNT(*) FROM #ConfirmedAdvanceBA) > 0 BEGIN SET @LOOP = 1 END
  

	 SELECT '#ConfirmedAdvanceBA',* FROM #ConfirmedAdvanceBA

	 IF @Process = 0
	 BEGIN
		SET @LOOP = 0
	 END
  
  --Loop to blast Email
 WHILE @LOOP = 1
 BEGIN
	SET @IndependentContractor = (SELECT TOP 1 IndependentContractorID FROM #ConfirmedAdvanceBA order by IndependentContractorID)
	
	SELECT @CountryCode = CountryCode, @CurrentLevel = IndependentContractorLevelId FROM #ConfirmedAdvanceBA WHERE IndependentContractorID = @IndependentContractor
	
	SET @AdvancementDate = CONVERT(NVARCHAR(50),@WeDate,103) 

 
	EXEC SP_PushAutoAdvancement @countryCode, @AdvancementDate, @IndependentContractor,@CurrentLevel
	DELETE FROM #ConfirmedAdvanceBA where IndependentContractorID = @IndependentContractor
	IF (SELECT COUNT(*) FROM #ConfirmedAdvanceBA) > 0 BEGIN SET @LOOP = 1 END ELSE BEGIN SET @LOOP = 0 END
 END
 
	--EXEC SP_ProcessOlafAutoAdvancement  0
	--INSERT INTO TXN_EmailQueue 
	SELECT * FROM  TXN_EmailQueue2
	--TRUNCATE TABLE TXN_EmailQueue2
	--	SP_ProcessOlafAutoAdvancement 1
END  
--AutoAdvancement-96306

----AutoAdvancement-
-- SELECT IndependentContractorLevelId, * FROM Mst_IndependentContractor where IndependentContractorId = '96306'
-- SELECT * FROM Mst_IndependentContractor_Movement where IndependentContractorId = '96306'

---- --SELECT * FROM Mst_IndependentContractorLevel
 
-- UPDATE  Mst_IndependentContractor set IndependentContractorLevelId = 7,EffectiveAdvancementDate = '2024-01-07 00:00:00.000' 
-- where IndependentContractorId = '96306'
-- UPDATE Mst_IndependentContractor_Movement set  HasExecuted = 1
-- where IndependentContractorMovementId = 406652

--UPDATE Mst_IndependentContractor set IndependentContractorLevelId = 1, EffectiveAdvancementDate = '2023-07-23'
--where IndependentContractorId = '87432'

--UPDATE Mst_IndependentContractor_Movement set HasExecuted = 1  where IndependentContractorId = '87432'
--and IndependentContractorMovementId = 300345

--SELECT * FROM TXN_AutoAdvancementResult where ScheduleWeekending ='2023-08-13'
--and FinalResult = 'YES' and IsDeleted = 0 and CountryCode = 'MY'

--SELECT * FROM TXN_AutoAdvancementResult where ScheduleWeekending ='2023-08-13'
--and FinalResult = 'YES' and IsDeleted = 0 and CountryCode = 'KR'

--SELECT * FROM Mst_IndependentContractorLevel

--SELECT * FROM Mst_EmailReceiver
--where EmailType ='EmailAutoAdvancement' and IsDeleted = 0 and CountryCode = 'MY'


--SELECT KRDescription FROM Mst_Localization WHERE TextTag = @TextTag AND TextType = 'FullContent'


--SELECT ENDescription FROM Mst_Localization WHERE TextTag = 'EmailAutoAdvancementAO' AND TextType = 'FullContent'


--SELECT * FROM Mst_Localization WHERE TextTag like 'EmailAutoAdvancement%' AND TextType = 'FullContent'

--SELECT * INTO Mst_Localization_20230822 FROM Mst_Localization

--'<span style="font-size:10pt;font-family:Helvetica"><p>안녕하세요 [OWNERFULLNAME] 지점장님, </p><p>세일즈웍스 그룹 아시아의 팀을 대신하여  [CONTRACTORFULLNAME] 님이 팀리더로 어드벤스먼트 하신 것을 축하드립니다! 공식적인 어드벤스먼트 날짜는 [ADVANCEMENTDATE] 입니다.<br><br>아래의 내용들을 [DUEDATE] 까지 [CONTRACTORFULLNAME] 의 OLAF 프로필에 반영해 주시기를 요청 드립니다. </p><p><ul><li> 팀이름</li><li> 이메일 주소</li><li> 휴대전화번호</li><li><mark>검은색</mark> 배경의 사진 – 최소크기 1mb & 고해상도 (300dpi)</li></ul>아래 링크를 통해 챗그룹에 참가하여 계속 업데이트되는 모든 프로그램과 활동내용들을 확인하세요   </p><p>TL/STL : <a href="https://chat.whatsapp.com/CPI6BdIBxRi86lBX5fDOBw">https://chat.whatsapp.com/CPI6BdIBxRi86lBX5fDOBw</a>   </p><p>지점장님과 [MC] 지점의 팀 모든 분께 다시 한번 축하 인사 전해드립니다. <br /><br />감사합니다. </p></span>'





--SELECT KRDescription FROM Mst_Localization WHERE TextTag = 'EmailAutoAdvancementAO' AND TextType = 'FullContent'

--UPDATE Mst_Localization SET ENDescription =N'<span style="font-size:10pt;font-family:Helvetica"><p>Dear [OWNERFULLNAME],</p><p>On behalf of the team at SalesWorks Group Asia, I would like to congratulate you for advancing [CONTRACTORFULLNAME] to to Owner Partner ! The official advancement date is [ADVANCEMENTDATE].<br><br>Kindly update the following information in [CONTRACTORFULLNAME]’s OLAF profile by  [DUEDATE].</p><p><ul><li>Team Name</li><li>Email address</li><li>Mobile number</li><li>Photo with<span style="font-size:10pt;font-family:Helvetica;background-color:#ff0"><mark>BLACK</mark></span>background – min size: 1mb & high resolution (300dpi)</li></ul>Please do click the link below to join the WhatsApp group to get constant updates on all programs and activities.</p><p><a href="https://chat.whatsapp.com/GwQp0GWD9H1I6w3wSOekRj">https://chat.whatsapp.com/GwQp0GWD9H1I6w3wSOekRj</a></p><p>Kindly contact your country''s SW PIC to create the following for the branch out process by [BSUDATE]:<br>1. Marketing Office''s Name<br>2. Marketing''s Office Code<br>3. Admin Access (Admin''s full name & email address)<br>4. Recruiter''s Name<br>5. Campaigns to be assigned to the new Marketing Office<br><br>Attached to this email is a form that you will need to complete. The information required will be used to incorporate your company when you advance to Ownership. Once this is completed, please send it to<a href="wengfat.chong@salesworks.asia">wengfat.chong@salesworks.asia & cc<a href="phoebe.kuan@salesworks.asia">phoebe.kuan@salesworks.asia</a>. Once again, congratulations on your advancement and enjoy the journey!</p>'
--WHERE TextTag = 'EmailAutoAdvancementOP' AND TextType = 'FullContent'




--Kindly update the following information in [CONTRACTORFULLNAME]’s OLAF profile by [DUEDATE].


 
--SELECT * FROM Mst_IndependentContractorLevel
--SELECT IndependentContractorLevelId, * FROM Mst_IndependentContractor where IndependentContractorId = '101722'
--SELECT IndependentContractorLevelId, * FROM Mst_IndependentContractor_Movement where IndependentContractorId = '101722'
--UPDATE Mst_IndependentContractor set IndependentContractorLevelId = 2 where IndependentContractorId = '101722'
--UPDATE Mst_IndependentContractor_Movement set HasExecuted = 1  where IndependentContractorId = '101722' and IndependentContractorMovementId = 307261