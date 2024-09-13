                
            
                    
CREATE PROCEDURE [dbo].[FindText]                     
(                      
	@TextToFind as VARCHAR(50)            
)                    
AS                    
BEGIN                

SET @TextToFind = '%' + @TextToFind + '%' 
		 SELECT DISTINCT
		   o.name AS Object_Name,
		   o.type_desc
		FROM sys.sql_modules m
			   INNER JOIN
			   sys.objects o
				 ON m.object_id = o.object_id
		WHERE m.definition Like @TextToFind;
END 