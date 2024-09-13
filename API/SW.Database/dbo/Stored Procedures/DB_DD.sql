-- =============================================
CREATE PROCEDURE [dbo].[DB_DD]  
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		SELECT
        TABLE_NAME, COLUMN_NAME, ORDINAL_POSITION, DATA_TYPE, A.CHARACTER_MAXIMUM_LENGTH, A.NUMERIC_PRECISION, A.NUMERIC_SCALE, A.IS_NULLABLE, ISNULL(col.value,'') as 'Column_Remark', ISNULL(Tbl.value,'')  as 'Table_Remark' 
 
    FROM
        INFORMATION_SCHEMA.COLUMNS  A   
		LEFT JOIN sys.tables st ON A.TABLE_NAME = st.name
    inner join sys.columns sc on st.object_id = sc.object_id and sc.name = A.COLUMN_NAME
    left join sys.extended_properties col on st.object_id = col.major_id
                                         and sc.column_id = col.minor_id
                                         and col.name = 'MS_Description'
    left join sys.extended_properties Tbl on st.object_id = Tbl.major_id 
                                         and Tbl.name = 'Description' 
    WHERE A.TABLE_NAME not in (
	'__MigrationHistory',
	'ICDEACTIVATIONLIST','Courses_Module_Settings_Backup')
    ORDER BY A.TABLE_NAME, A.ORDINAL_POSITION 
 
END
 
