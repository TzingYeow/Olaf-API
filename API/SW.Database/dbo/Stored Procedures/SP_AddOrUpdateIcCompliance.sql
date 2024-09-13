

-- =============================================
-- Author:		Asyraf Bakar
-- Create date: 15 April 2019
-- Description:	To create ou update Independent Contractor compliance checklist
-- =============================================
CREATE PROCEDURE [dbo].[SP_AddOrUpdateIcCompliance]
	@IndependentContractorId int, @ComplianceChecklistId int, @HasComplied bit,@CreatedBy varchar(100),@CreatedDate datetime,@ComplianceEffectiveDate datetime,@AttachmentPath varchar(300), @ComplianceAttemptCount int, @RoleName varchar(50)
AS
BEGIN
	SET NOCOUNT ON; 

Declare @ExistingIcComplianceChecklistId int = (Select  IndependentContractorComplianceId from Mst_IndependentContractor_Compliance where [IndependentContractorId] = @IndependentContractorId and [ComplianceChecklistId] = @ComplianceChecklistId and IsDeleted = 0);

IF @ExistingIcComplianceChecklistId is null
	BEGIN 
		-- Add
		IF @RoleName = 'MO Admin'
			BEGIN
				INSERT INTO Mst_IndependentContractor_Compliance ([IndependentContractorId],[ComplianceChecklistId],[HasComplied],[IsDeleted],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],[ComplianceEffectiveDate],[AttachmentPath],[ComplianceAttemptCount])
				VALUES (@IndependentContractorId,@ComplianceChecklistId,0,0,@CreatedBy,@CreatedDate,null,null,null,@AttachmentPath,null)
			END
		ELSE
			BEGIN
				INSERT INTO Mst_IndependentContractor_Compliance ([IndependentContractorId],[ComplianceChecklistId],[HasComplied],[IsDeleted],[CreatedBy],[CreatedDate],[UpdatedBy],[UpdatedDate],[ComplianceEffectiveDate],[AttachmentPath],[ComplianceAttemptCount])
				VALUES (@IndependentContractorId,@ComplianceChecklistId,@HasComplied,0,@CreatedBy,@CreatedDate,null,null,@ComplianceEffectiveDate,@AttachmentPath,@ComplianceAttemptCount)
			END	
		SELECT @ExistingIcComplianceChecklistId = SCOPE_IDENTITY()	
	END
ELSE
	BEGIN
		--- Update
		IF @AttachmentPath is not null
			BEGIN 
				IF @RoleName = 'MO Admin'
				BEGIN
					Update Mst_IndependentContractor_Compliance
					Set AttachmentPath = @AttachmentPath, UpdatedBy = @CreatedBy, UpdatedDate = @CreatedDate
					Where IndependentContractorComplianceId = @ExistingIcComplianceChecklistId
				END
			ELSE
				BEGIN 
					Update Mst_IndependentContractor_Compliance
					Set [HasComplied] = @HasComplied, ComplianceEffectiveDate = @ComplianceEffectiveDate, AttachmentPath = @AttachmentPath, ComplianceAttemptCount = @ComplianceAttemptCount, UpdatedBy = @CreatedBy, UpdatedDate = @CreatedDate
					Where IndependentContractorComplianceId = @ExistingIcComplianceChecklistId
				END			
			END
		ELSE
			BEGIN
			--print 'Update 2';
				Update Mst_IndependentContractor_Compliance
				Set [HasComplied] = @HasComplied, ComplianceEffectiveDate = @ComplianceEffectiveDate, ComplianceAttemptCount = @ComplianceAttemptCount, UpdatedBy = @CreatedBy, UpdatedDate = @CreatedDate
				Where IndependentContractorComplianceId = @ExistingIcComplianceChecklistId
			END		
	END	 

	INSERT INTO Mst_IndependentContractor_Compliance_Archive(IndependentContractorComplianceId, IndependentContractorId, 
	ComplianceChecklistId, HasComplied, IsDeleted, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate, ComplianceEffectiveDate, 
	AttachmentPath, ComplianceAttemptCount, UploadedBy, UploadedDate)
	SELECT * FROM Mst_IndependentContractor_Compliance WHERE IndependentContractorComplianceId = @ExistingIcComplianceChecklistId

END
