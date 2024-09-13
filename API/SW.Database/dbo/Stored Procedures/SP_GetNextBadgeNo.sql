-- =============================================
-- Author:		Asyraf Bakar
-- Create date: 03 April 2019
-- Description:	To get next badge No for Independent Contractor
-- =============================================
CREATE PROCEDURE [dbo].[SP_GetNextBadgeNo]
	 @MarketingCompanyId int
AS
BEGIN
	SET NOCOUNT ON;

	Declare @NextBadgeNo varchar(15);
	Declare @CountryCode varchar(5) = (Select CountryCode from Mst_MarketingCompany where IsDeleted = 0 and MarketingCompanyId = @MarketingCompanyId) 
	 
	IF @CountryCode != 'SG'
		BEGIN		
			-- BEGIN This is for not SG country
			Declare @IsBadgeNoNumeric bit = (Select Case When Count(*) > 0 THEN 1 Else 0 END FROM Mst_IndependentContractor a WHERE ISNUMERIC(a.BadgeNo) = 1 AND a.BadgeNo NOT LIKE '%.%' AND a.BadgeNo NOT LIKE '%e%' AND a.BadgeNo NOT LIKE '%-%' and a.MarketingCompanyId = @MarketingCompanyId)
		
			IF @IsBadgeNoNumeric = 1
				BEGIN 
					Declare @TempBadgeNo varchar(30) = (SELECT RTRIM(b.Code) + REPLACE(STR(COALESCE(MAX(CONVERT(INT, dbo.GetNumbers(BadgeNo))),0)+1, COALESCE(LEN(MAX(dbo.GetNumbers(BadgeNo))), 5)), SPACE(1), '0') AS NextBadge
					FROM Mst_IndependentContractor a
					left join Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId
					WHERE a.MarketingCompanyId = @MarketingCompanyId
					group by b.Code);

					Declare @McCodeLength int = (Select LEN(Code) from Mst_MarketingCompany where MarketingCompanyId = @MarketingCompanyId);
					IF @TempBadgeNo like '%**%'
						BEGIN
								SET @TempBadgeNo = (Select Max(Cast(a.BadgeNo as int)) FROM Mst_IndependentContractor a
								left join Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId
								WHERE a.MarketingCompanyId = @MarketingCompanyId
								group by b.Code) 
							Select @TempBadgeNo +1 as NextBadge; 
						END
					ELSE
						BEGIN
							SELECT SUBSTRING(@TempBadgeNo, @McCodeLength +1, LEN(@TempBadgeNo)+1) AS NextBadge;
						END
					
					END
			ELSE
				BEGIN 
					Set @NextBadgeNo = (SELECT RTRIM(b.Code) + REPLACE(STR(COALESCE(MAX(CONVERT(INT, dbo.GetNumbers(BadgeNo))),0)+1, COALESCE(LEN(MAX(dbo.GetNumbers(BadgeNo))), 5)), SPACE(1), '0') AS NextBadge
					FROM Mst_IndependentContractor a
					left join Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId
					WHERE a.MarketingCompanyId = @MarketingCompanyId
					group by b.Code)
					
					IF @MarketingCompanyId = 53
						BEGIN -- this is temporary patch for 'JA' next badge no contains *
							Set @NextBadgeNo = (SELECT RTRIM(b.Code) + REPLACE(STR(COALESCE(MAX(CONVERT(INT, dbo.GetNumbers(BadgeNo))),0)+1, COALESCE(LEN(MAX(CAST(dbo.GetNumbers(BadgeNo) as int))), 5)), SPACE(1), '0') AS NextBadge
							FROM Mst_IndependentContractor a
							left join Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId
							WHERE a.MarketingCompanyId = @MarketingCompanyId
							group by b.Code)
						END 

					IF @NextBadgeNo is null
						BEGIN 
							Declare @MoCode varchar(10) = (Select Code from Mst_MarketingCompany a where a.MarketingCompanyId = @MarketingCompanyId ); 
							SET @NextBadgeNo = CONCAT(@MoCode, '00001') 
						END
					
					Select @NextBadgeNo as NextBadge;
				END		
			-- END This is for not SG country
		END 
	Else
		BEGIN
			-- This is for Sg Country 
			Declare @MoCodee varchar(10) = (Select Code from Mst_MarketingCompany a where a.MarketingCompanyId = @MarketingCompanyId ); 
			Declare @IsBadgeNoNumericc bit = (Select Case When Count(*) > 0 THEN 1 Else 0 END FROM Mst_IndependentContractor a WHERE ISNUMERIC(a.BadgeNo) = 1 AND a.BadgeNo NOT LIKE '%.%' AND a.BadgeNo NOT LIKE '%e%' AND a.BadgeNo NOT LIKE '%-%' and a.MarketingCompanyId = @MarketingCompanyId and BadgeNo like @MoCode + '%')
			
			IF @IsBadgeNoNumeric = 1
				BEGIN
					Declare @TempBadgeNoo varchar(30) = (SELECT RTRIM(b.Code) + REPLACE(STR(COALESCE(MAX(CONVERT(INT, dbo.GetNumbers(a.BadgeNo))),0)+1, COALESCE(LEN(MAX(dbo.GetNumbers(a.BadgeNo))), 5)), SPACE(1), '0') AS NextBadge
					FROM Mst_IndependentContractor a
					left join Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId
					WHERE a.MarketingCompanyId = @MarketingCompanyId and BadgeNo like @MoCode + '%'
					group by b.Code);
					Declare @McCodeLengthh int = (Select LEN(Code) from Mst_MarketingCompany where MarketingCompanyId = @MarketingCompanyId);
					
					IF @TempBadgeNo like '%**%'
						BEGIN
								SET @TempBadgeNo = (Select Max(Cast(a.BadgeNo as int)) FROM Mst_IndependentContractor a
								left join Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId
								WHERE a.MarketingCompanyId = @MarketingCompanyId and BadgeNo like @MoCode + '%'
								group by b.Code)
								Set @NextBadgeNo = (Select @TempBadgeNo +1 as NextBadge);
						END
					ELSE
						BEGIN
							Set @NextBadgeNo = (SELECT SUBSTRING(@TempBadgeNo, @McCodeLength +1, LEN(@TempBadgeNo)+1) AS NextBadge);							
						END
					
					END
			ELSE  
				BEGIN		 
					IF @MarketingCompanyId in (1373,1377)  --  Code FT IO, quick patch no enough 0 at the badgeNo
						BEGIN 
							Set @NextBadgeNo = (SELECT RTRIM(b.Code) + '0'+ REPLACE(STR(COALESCE(MAX(CONVERT(INT, dbo.GetNumbers(a.BadgeNo))),0)+1, COALESCE(LEN(MAX(dbo.GetNumbers(a.BadgeNo))), 5)), SPACE(1), '0')  AS NextBadge
							FROM Mst_IndependentContractor a
							left join Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId
							WHERE a.MarketingCompanyId = @MarketingCompanyId and BadgeNo like @MoCodee + '%'
							group by b.Code)
						END
					ELSE
						Set @NextBadgeNo =  (SELECT RTRIM(b.Code) + REPLACE(STR(COALESCE(MAX(CONVERT(INT, dbo.GetNumbers(a.BadgeNo))),0)+1, COALESCE(LEN(MAX(dbo.GetNumbers(a.BadgeNo))), 5)), SPACE(1), '0') AS NextBadge
						FROM Mst_IndependentContractor a
						left join Mst_MarketingCompany b on b.MarketingCompanyId = a.MarketingCompanyId
						WHERE a.MarketingCompanyId = @MarketingCompanyId and BadgeNo like @MoCodee + '%'
						group by b.Code)
				END

			IF @NextBadgeNo is null
				SET @NextBadgeNo = CONCAT(@MoCodee, '00001') 
			Select @NextBadgeNo as NextBadge;
		END
END