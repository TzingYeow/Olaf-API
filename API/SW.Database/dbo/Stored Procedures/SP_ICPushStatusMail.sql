-- =============================================          
-- Author:  Tan Siuk Ching          
-- Create date: 05/03/2021          
-- Description: EXEC [SP_ICPushStatusMail]      
--SELECT * FROM TXN_EmailQueue  
-- =============================================          
CREATE PROCEDURE [dbo].[SP_ICPushStatusMail]           
 -- Add the parameters for the stored procedure here  
AS          
BEGIN          
 -- SET NOCOUNT ON added to prevent extra result sets from          
 -- interfering with SELECT statements.          
 SET NOCOUNT ON;          
       
  DECLARE @Recipient as VARCHAR(800)  
  DECLARE @CCS as VARCHAR(200)  
  DECLARE @BCCS as VARCHAR(200)  
  DECLARE @Subject as NVARCHAR(200)  
  DECLARE @Body as NVARCHAR(4000)  
  DECLARE @FileAttachment as VARCHAR(200) 

  IF OBJECT_ID('tempdb..#TxnIDList') IS NOT NULL DROP TABLE #TxnIDList
  SELECT TxnID INTO #TxnIDList 
  FROM TXN_EmailQueue Where 
  SUBJECT IN('Eloomi Data Pull Summary','OLAF Suspension List Reminder: Non-Completion of M-Learning','OLAF Suspension List Reminder: No sales for 3 consecutive Weekending' ,
  'OLAF Deactivation List Reminder: No sales for 3 consecutive Weekending',
  'OLAF Suspension List Reminder : Non-Completion of M-Learning',
  'OLAF Deactivation List Reminder : Non-Completion of M-Learning',
  'Eloomi System Failed : Non-Completion of M-Learning',
  'OLAF Suspension List Reminder: No Active Campaign Assigned', 'Singapore Manual Sales Upload',
  'OLAF Deactivation List Reminder: No sales in 3 consecutive Weekending after reactivation of no sales in 3 consecutive weekending suspension') 
  OR Description like 'AutoAdvancement%'

  INSERT INTO TXN_EmailQueueArchive  
  SELECT *, GETDATE() 
  FROM TXN_EmailQueue WHERE TxnID IN (SELECT TxnID FROM #TxnIDList) 
  
  DECLARE ICAssignment_cursor CURSOR FOR               
  SELECT Recipient, ISNULL(CC,'') as 'CC',ISNULL(BCC,'') as 'BCC',  [Subject], Body, Attachment              
  FROM TXN_EmailQueue  WHERE TxnID IN (SELECT TxnID FROM #TxnIDList)       
              
   OPEN ICAssignment_cursor              
   FETCH NEXT FROM ICAssignment_cursor               
   INTO @Recipient,@CCS ,@BCCS ,@Subject,@Body, @FileAttachment  
  
   WHILE @@FETCH_STATUS = 0              
   BEGIN  
      
   EXEC msdb.dbo.sp_send_dbmail @profile_name='APPCO Asia',    
     @recipients = @Recipient,
	 @blind_copy_recipients = @BCCS,
     @subject=@Subject,    
     @body_format = 'HTML',    
     @body=@Body,
	 @file_attachments = @FileAttachment

   FETCH NEXT FROM ICAssignment_cursor               
   INTO @Recipient,@CCS ,@BCCS ,@Subject,@Body, @FileAttachment   
   END               
   CLOSE ICAssignment_cursor;              
   DEALLOCATE ICAssignment_cursor;   
  
   DELETE FROM TXN_EmailQueue WHERE TxnID IN (SELECT TxnID FROM #TxnIDList)         
        
END    
