-- =============================================
-- Author:		Tommy Gee
-- Create date: 10/07/2017
-- Description:	Mobile user attendance punching
-- =============================================
CREATE PROCEDURE [dbo].[ss_User_MobileAttendancePunching]
	@UserId int,
	@MOCode nvarchar(50),
	@CheckStatus nvarchar(50),
	@Campaign nvarchar(50),
	@ChannelCode nvarchar(50),
	@CreatedBy nvarchar(50),
	@CreatedDate datetime,
	--@EventTerritoryCode nvarchar(50),
	@District nvarchar(50),
	@Location nvarchar(50),
	@Return int OUTPUT
AS
BEGIN
DECLARE @LastAttendanceStatus nvarchar(50),
		@Count int = 0;
	SET NOCOUNT ON;

	CREATE TABLE #temp (
		CheckStatus nvarchar(50)
	);

	INSERT INTO #temp
	SELECT TOP 1 B.CheckStatus FROM Mst_User A
	INNER JOIN Mst_Attendance B ON A.UserId = B.UserId
	LEFT JOIN VW_MST_CampaignList C ON B.Campaign COLLATE DATABASE_DEFAULT = C.Client
	WHERE A.UserId = @UserId
	GROUP BY B.CheckStatus, B.CheckInOutDate
	ORDER BY B.CheckInOutDate DESC;
	
	
	SELECT @Count = COUNT(*) FROM #temp

	IF @Count = 0
		SET @LastAttendanceStatus = 'CheckOut';
	ELSE
		SELECT @LastAttendanceStatus = CheckStatus FROM #temp;

	BEGIN TRAN;
    IF @LastAttendanceStatus <> @CheckStatus
		BEGIN
			--INSERT INTO Mst_Attendance (UserId, MOCode, CheckInOutDate, CheckStatus, Campaign, ChannelCode, CreatedBy, CreatedDate,EventTerritoryCode) VALUES 
			--(@UserId, @MOCode, GetDate(), @CheckStatus, @Campaign, @ChannelCode, @CreatedBy, @CreatedDate,@EventTerritoryCode);
			INSERT INTO Mst_Attendance (UserId, MOCode, CheckInOutDate, CheckStatus, Campaign, ChannelCode, CreatedBy, CreatedDate,[District], [Location]) VALUES 
			(@UserId, @MOCode, GetDate(), @CheckStatus, @Campaign, @ChannelCode, @CreatedBy, @CreatedDate,@District, @Location);

			SET @Return = @@ROWCOUNT;

			IF @Return > 0
				COMMIT TRAN;--
				SELECT TOP 1 B.UserId, B.MOCode, C.Division, B.Campaign, B.CheckInOutDate, B.CheckStatus, B.ChannelCode,B.[District], B.[Location]--B.EventTerritoryCode
				FROM Mst_User A
				INNER JOIN Mst_Attendance B ON A.UserId = B.UserId
				LEFT JOIN VW_MST_CampaignList C ON B.Campaign COLLATE DATABASE_DEFAULT = C.Client
				WHERE A.UserId = @UserId
				ORDER BY B.CheckInOutDate DESC
				RETURN;
		END
	ELSE
		BEGIN
			ROLLBACK TRAN;
			SET @Return = 1;
			SELECT TOP 1 B.UserId, B.MOCode, C.Division, B.Campaign, B.CheckInOutDate, B.CheckStatus, B.ChannelCode,B.[District], B.[Location]--b.EventTerritoryCode
			FROM Mst_User A
			INNER JOIN Mst_Attendance B ON A.UserId = B.UserId
			LEFT JOIN VW_MST_CampaignList C ON B.Campaign COLLATE DATABASE_DEFAULT = C.Client
			WHERE A.UserId = @UserId
			ORDER BY B.CheckInOutDate DESC
			RETURN;
		END

	ROLLBACK TRAN;
	SET @Return = 0;
	RETURN;
END

