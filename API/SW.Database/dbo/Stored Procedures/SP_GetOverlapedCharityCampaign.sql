

-- =============================================
-- Author:		Asyraf Bakar
-- Create date: 03 July 2019
-- Description:	To get overlapped charity campaign
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetOverlapedCharityCampaign]	
	 @IndependentContractorId int,
	 @StartDate datetime,
	 @EndDate datetime,
	 @ExcludeAssigmentId int = null
AS
BEGIN
	SET NOCOUNT ON;
	SET NOCOUNT ON;
	--Declare @IndependentContractorId int = 40147;
	--Declare @StartDate datetime = '2019-06-02';
	--Declare @EndDate datetime =  '2019-06-03';
	--Declare @ExcludeAssigmentId int = null;

	IF @EndDate is null
		BEGIN 	
			SET @EndDate = DATEADD(year, 1000, GETDATE())
		END 
	IF @ExcludeAssigmentId is null
		BEGIN
			Select * from Mst_IndependentContractor_Assignment a
			left join Mst_Campaign b on b.CampaignId = a.CampaignId
			left join Mst_Division c on c.DivisionId = b.DivisionId
			where( (@StartDate >= StartDate and @StartDate <= IIF(EndDate is null,DATEADD(year, 1000, GETDATE()),EndDate))
			OR (@EndDate > StartDate and @EndDate <= IIF(EndDate is null,DATEADD(year, 1000, GETDATE()),EndDate))
			OR (@StartDate <= StartDate and @EndDate >= IIF(EndDate is null,DATEADD(year, 1000, GETDATE()),EndDate))  )
			and a.IsDeleted = 0 and b.IsDeleted = 0 and IndependentContractorId = @IndependentContractorId
			and c.DivisionCode = 'CH'
		END
	ELSE
	BEGIN
			Select * from Mst_IndependentContractor_Assignment a
			left join Mst_Campaign b on b.CampaignId = a.CampaignId
			left join Mst_Division c on c.DivisionId = b.DivisionId
			where( (@StartDate >= StartDate and @StartDate <= IIF(EndDate is null,DATEADD(year, 1000, GETDATE()),EndDate))
			OR (@EndDate > StartDate and @EndDate <= IIF(EndDate is null,DATEADD(year, 1000, GETDATE()),EndDate))
			OR (@StartDate <= StartDate and @EndDate >= IIF(EndDate is null,DATEADD(year, 1000, GETDATE()),EndDate))  )
			and a.IsDeleted = 0 and b.IsDeleted = 0 and IndependentContractorId = @IndependentContractorId
			and c.DivisionCode = 'CH' and IndependentContractorAssigmentId != @ExcludeAssigmentId
		END	
END
