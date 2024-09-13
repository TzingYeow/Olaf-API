

-- =============================================
-- Author:		Asyraf Bakar
-- Create date: 20 April 2019
-- Description:	Top Update Localization data
-- =============================================
CREATE PROCEDURE [dbo].[SP_AddOrUpdateLocalization]
@TextTag nvarchar(100), @TextType nvarchar(100), @Page nvarchar(150),@Remark nvarchar(255),@ENDescription nvarchar(2000),@MYDescription nvarchar(300),@TWDescription nvarchar(300),@HKDescription nvarchar(300),@KRDescription nvarchar(300),@THDescription nvarchar(300),@PHDescription nvarchar(300),@IDDescription nvarchar(300),@CreatedBy nvarchar(50),@CreatedDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ExistingLocalizationId int = (Select LocalizationId from Mst_Localization where TextTag = @TextTag and TextType= @TextType and Page = @Page and IsDeleted = 0);

	IF @ExistingLocalizationId is null
		BEGIN
			print 'insert';
			INSERT INTO [dbo].[Mst_Localization]
			   ([TextTag],[TextType],[Page],[Remark]
			   ,[ENDescription],[MYDescription],[TWDescription],[HKDescription],[KRDescription],[THDescription],[PHDescription],[IDDescription],[IsDeleted],[CreatedBy]
			   ,[CreatedDate],[UpdatedBy],[UpdatedDate])
			VALUES
				(@TextTag,@TextType, @Page,@Remark,
				@ENDescription,@MYDescription,@TWDescription,@HKDescription,@KRDescription,@THDescription,@PHDescription,@IDDescription,0,@CreatedBy,@CreatedDate,null,null)
		END
	ELSE
		BEGIN
			update [Mst_Localization]
			SET Remark = @Remark,
				ENDescription= @ENDescription,
				MYDescription= @MYDescription,
				TWDescription= @TWDescription,
				HKDescription = @HKDescription,
				KRDescription = @KRDescription,
				THDescription = @THDescription,
				PHDescription = @PHDescription,
				IDDescription = @IDDescription,
				UpdatedBy = @CreatedBy,
				UpdatedDate = @CreatedDate 
			where LocalizationId = @ExistingLocalizationId
		END
END
