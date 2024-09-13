

-- ==========================================================================================
-- Author:		Syafiqah Ab Manah
-- Create date: 2020-11-05
-- Description:	Regional RC Analysis Report 
-- EXEC SP_RPT_WeeklyHuddleReport '2021-07-22'
-- ==========================================================================================
--EXEC SP_AutoAdvancement 
CREATE PROCEDURE [dbo].[SP_AutoAdvancement_ToCleanup]
 
AS
BEGIN
	 
DECLARE @WEDate1 as DATE
DECLARE @WEDate2 as DATE

SELECT DISTINCT TOP 2 Weekending INTO #Last2WE FROM Mst_AutoAdvancementSales ORDER BY Weekending DESC

SET @WEDate1 = (SELECT MIN(Weekending) FROM #Last2WE)
SET @WEDate2 = (SELECT MAX(Weekending) FROM #Last2WE)
 
DROP TABLE IF EXISTS #Mst_AutoAdvancementSales
SELECT * INTO #Mst_AutoAdvancementSales FROM Mst_AutoAdvancementSales A  where IsDeleted = 0 and Weekending in (@WEDate1, @WEDate2)
 
--SELECT IndependentContractorLevelId,* FROM Mst_AdvancementCriteria where countrycode = 'KR'

DROP TABLE IF EXISTS #TempResult
SELECT A.CountryCode, A.Weekending, A.BadgeNo, B.Status as 'BAStatus', B.IndependentContractorId, B.IndependentContractorLevelId, '' as 'BALevelName',  ISNULL(B.Province,'') as 'BAProvince', ISNULL(C.Province,'') as 'CriteriaProvince',
A.TeamPayable as 'BASalesValue', C.SalesValue as 'CriteriaSalesValue', A.TeamSize as 'BATeamSize', ISNULL(C.TeamSize,0) as 'CriteriaTeamSize', A.BulletinPoint as 'BABulletinPoint', ISNULL(C.SalesPoint,0.00) as 'CriterialBulletinPoint' 
,A.FirstGenLeader as 'BAFirstGenLeader' , C.FirstGenLeader as 'CriterialFirstGenLeader'  INTO #TempResult  
FROM #Mst_AutoAdvancementSales A
LEFT JOIN VW_ICDetail B ON A.BadgeNo = B.BadgeNo and A.CountryCode = B.CountryCode
LEFT JOIN Mst_IndependentContractorLevel D ON B.IndependentContractorLevelId = D.IndependentContractorLevelId
INNER JOIN Mst_AdvancementCriteria C ON A.CountryCode = C.CountryCode
and B.IndependentContractorLevelId = C.IndependentContractorLevelId and ISNULL(B.Province,'') = ISNULL(C.Province,'')
and A.Weekending >= C.StartDate and A.Weekending <= ISNULL(C.EndDate,'3000-01-01')
WHERE ISNULL(B.Status,'') = 'Active'
ORDER BY A.CountryCode, A.BadgeNo, A.Weekending
 
DROP TABLE IF EXISTS #Result
CREATE TABLE #Result 
(
	CountryCode NVARCHAR(10),
	Weekending1 DATE,
	BadgeNo NVARCHAR(50),
	BAStatus NVARCHAR(50),
	IndependentContractorID INT,
	IndependentContractorLevelId INT,
	BALevel NVARCHAR(50),
	BAProvince NVARCHAR(50),
	CriteriaProvince NVARCHAR(50),
	BASalesValue DECIMAL(18,2),
	CriteriaSalesValue  DECIMAL(18,2),
	BATeamSize INT,
	CriteriaTeamSize INT,
	BABulettinPoint  DECIMAL(18,2),
	CriteriaBuletinPoint  DECIMAL(18,2),
	BAFirstGenLeader INT,
	CriterialFirstGenLeader INT ,
	Weekending2 DATE,
	BAStatus2 NVARCHAR(50), 
	BAProvince2 NVARCHAR(50),
	CriteriaProvince2 NVARCHAR(50),
	BASalesValue2 DECIMAL(18,2),
	CriteriaSalesValue2  DECIMAL(18,2),
	BATeamSize2 INT,
	CriteriaTeamSize2 INT,
	BABulettinPoint2  DECIMAL(18,2),
	CriteriaBuletinPoint2  DECIMAL(18,2),
	BAFirstGenLeader2 INT,
	CriterialFirstGenLeader2 INT,
	Week1Result NVARCHAR(20),
	Week2Result NVARCHAR(20),
	FinalResult NVARCHAR(20)
)


INSERT INTO #Result (CountryCode, Weekending1, Weekending2 ,BadgeNo,IndependentContractorId, IndependentContractorLevelId, BALevel)
(
SELECT DISTINCT Countrycode, @WEDate1,@WEDate2, BadgeNo,IndependentContractorId,IndependentContractorLevelId,BALevelName FROM #TempResult 
) 
UPDATE A SET
A.BAStatus = B.BAStatus, 
A.IndependentContractorID = B.IndependentContractorID,
A.BAProvince = ISNULL(B.BAProvince,''),
A.CriteriaProvince = ISNULL(B.CriteriaProvince,''),
A.BASalesValue = ISNULL(B.BASalesValue,0.00),
A.CriteriaSalesValue = ISNULL(B.CriteriaSalesValue,0.00),
A.BATeamSize = ISNULL(B.BATeamSize,0),
A.CriteriaTeamSize = ISNULL(B.CriteriaTeamSize,0),
A.BABulettinPoint = ISNULL(B.BABulletinPoint,0.00),
A.CriteriaBuletinPoint = ISNULL(B.CriterialBulletinPoint,0.00),
A.BAFirstGenLeader = ISNULL(B.BAFirstGenLeader,0),
A.CriterialFirstGenLeader = ISNULL(B.CriterialFirstGenLeader,0)
FROM #Result A LEFT JOIN #TempResult B ON A.Weekending1 = B.Weekending and A.BadgeNo = B.BadgeNo

UPDATE A SET
A.BAStatus2 = B.BAStatus,  
A.BAProvince2 = B.BAProvince,
A.CriteriaProvince2 = B.CriteriaProvince,
A.BASalesValue2 = B.BASalesValue,
A.CriteriaSalesValue2 = B.CriteriaSalesValue,
A.BATeamSize2 = B.BATeamSize,
A.CriteriaTeamSize2 = B.CriteriaTeamSize,
A.BABulettinPoint2 = B.BABulletinPoint,
A.CriteriaBuletinPoint2 = B.CriterialBulletinPoint,
A.BAFirstGenLeader2 = B.BAFirstGenLeader,
A.CriterialFirstGenLeader2 = B.CriterialFirstGenLeader
FROM #Result A LEFT JOIN #TempResult B ON A.Weekending2 = B.Weekending and A.BadgeNo = B.BadgeNo

UPDATE #Result SET Week1Result = 'NO', Week2Result = 'NO', FinalResult = 'NO'

UPDATE #Result SET Week1Result = 'YES'  WHERE 
BASalesValue >= CriteriaSalesValue and 
BATeamSize >= CriteriaTeamSize and
BABulettinPoint >= CriteriaBuletinPoint and
BAFirstGenLeader >= CriterialFirstGenLeader  

UPDATE #Result SET Week2Result = 'YES'  WHERE 
BASalesValue2 >= CriteriaSalesValue2 and 
BATeamSize2 >= CriteriaTeamSize2 and
BABulettinPoint2 >= CriteriaBuletinPoint2 and
BAFirstGenLeader2 >= CriterialFirstGenLeader2 

UPDATE #Result SET FinalResult = 'YES' WHERE ISNULL(Week1Result,'NO') = 'YES' and ISNULL(Week2Result,'NO') = 'YES'

SELECT A.*, C.LevelOrdinal, D.IndependentContractorLevelId as 'NewIndependentContractorLevelId', ISNULL(B.EffectiveAdvancementDate,B.StartDate) as 'LastAdvanceDate' INTO #ConfirmedAdvanceBA FROM #Result A 
LEFT JOIN Mst_IndependentContractor B ON A.IndependentContractorID = B.IndependentContractorID
LEFT JOIN Mst_IndependentContractorLevel C ON A.IndependentContractorLevelId = C.IndependentContractorLevelId
LEFT JOIN Mst_IndependentContractorLevel D ON C.LevelOrdinal + 1 = D.LevelOrdinal

WHERE FinalResult = 'YES'
 
--INSERT INTO Mst_IndependentContractor_Movement
--SELECT IndependentContractorID, 'Advance', NewIndependentContractorLevelId, @WEDate2, DATEADD(day, 7, @WEDate2), NULL,NULL, DATEDIFF(day,LastAdvanceDate,DATEADD(day, 7, @WEDate2)), NULL,0,NULL,0,'Schedular',GETDATE(),NULL,NULL 
--FROM #ConfirmedAdvanceBA
 

 DECLARE @LOOP as BIT
 DECLARE @IndependentContractor as INT
 DECLARE @CountryCode as NVARCHAR(5)
 DECLARE @CurrentLevel as INT
 DECLARE @AdvancementDate as NVARCHAR(50)
 SET @LOOP = 0

 IF (SELECT COUNT(*) FROM #ConfirmedAdvanceBA) > 0 BEGIN SET @LOOP = 1 END

 WHILE @LOOP = 1
 BEGIN
	SET @IndependentContractor = (SELECT TOP 1 IndependentContractorID FROM #ConfirmedAdvanceBA order by IndependentContractorID)
	
	SELECT @CountryCode = CountryCode, @CurrentLevel = IndependentContractorLevelId FROM #ConfirmedAdvanceBA WHERE IndependentContractorID = @IndependentContractor
	SELECT @IndependentContractor, @CountryCode, @CurrentLevel
	SET @AdvancementDate = CONVERT(NVARCHAR(50),@WEDate2,103)
	EXEC SP_PushAutoAdvancement @countryCode, @AdvancementDate, @IndependentContractor,@CurrentLevel
	DELETE FROM #ConfirmedAdvanceBA where IndependentContractorID = @IndependentContractor
	IF (SELECT COUNT(*) FROM #ConfirmedAdvanceBA) > 0 BEGIN SET @LOOP = 1 END ELSE BEGIN SET @LOOP = 0 END
 END
 --EXEC 
 --ALTER PROCEDURE [dbo].[SP_PushAutoAdvancement]
	--@CountryCode NVARCHAR(5),
	--@AdvancementDate NVARCHAR(50),
	--@IndependentContractorId INT,
	--@CurrentLevel INT
 

END 
 --EXEC SP_AutoAdvancement 

 --SELECT GETDATE() 
 --SELECT * FROM TXN_EmailQueue5
  