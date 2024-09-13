
-- =============================================
-- Author:		OLD Olaf Function
-- Create date: unknown
-- Description:	Used in generating next badge No
-- =============================================

CREATE Function [dbo].[GetNumbers](@Data NVARCHAR(MAX))
Returns NVARCHAR(MAX)
AS
Begin	
    Return COALESCE(Left(
             SubString(@Data, PatIndex('%[0-9.-]%', @Data), 8000), 
             PatIndex('%[^0-9.-]%', SubString(@Data, PatIndex('%[0-9.-]%', @Data), 8000) + 'X')-1),'0')
End
