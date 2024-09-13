

-- =============================================
-- Author:		Asyraf Bakar
-- Create date: 12 December 2018
-- Description:	SP_UpdateOFHCRow 1,1
-- =============================================
CREATE PROCEDURE [dbo].[SP_UpdateOFHCRow]
	@onfieldHeadcountID INT,
	@independentContractorID INT,
	@DetailID INT,
	@CampaignID int,
	@ofSession NVARCHAR(50),
	@ofChannel NVARCHAR(50),
	@ofLocation NVARCHAR(50),
	@UserID NVARCHAR(50)
AS
BEGIN  
	IF @DetailID >-1
	BEGIN
		UPDATE TXN_OnfieldHeadcountDetail
		SET 
			CampaignID = @CampaignID,
			Session = @ofSession,
			Channel = @ofChannel,
			Location = @ofLocation
		WHERE DetailID = @DetailID 
	END
	ELSE
	BEGIN
		INSERT INTO TXN_OnfieldHeadcountDetail ( OnfieldHeadcountID, IndependentContractorId, CampaignID, Session, Channel,Location)
		SELECT  @onfieldHeadcountID, @independentContractorID, @CampaignID, @ofSession, @ofChannel, @ofLocation 
	 
		SET @DetailID = (SELECT SCOPE_IDENTITY())

	END 

	UPDATE TXN_OnfieldHeadcountHeader 
	SET UpdatedDate = GETDATE(), UpdatedBy = @UserID, TotalHeadcount = (SELECT COUNT(distinct IndependentContractorId) FROM TXN_OnfieldHeadcountDetail WHERE OnfieldHeadcountID = @onfieldHeadcountID and Session in ('AM','PM','FULL'))
	WHERE OnfieldHeadcountID = @onfieldHeadcountID
	
		SELECT @DetailID as 'Result'
END
