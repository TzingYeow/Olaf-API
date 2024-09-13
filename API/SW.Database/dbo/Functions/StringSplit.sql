CREATE FUNCTION [dbo].[StringSplit] (@string NVARCHAR(MAX))
RETURNS @parsedString TABLE (id NVARCHAR(MAX))
AS 
BEGIN
   DECLARE @separator NCHAR(1)
   SET @separator=','
   DECLARE @position int
   SET @position = 1
   SET @string = @string + @separator
   WHILE charindex(@separator,@string,@position) <> 0
      BEGIN
         INSERT into @parsedString
         SELECT substring(@string, @position, charindex(@separator,@string,@position) - @position)
         SET @position = charindex(@separator,@string,@position) + 1
      END
     RETURN
END