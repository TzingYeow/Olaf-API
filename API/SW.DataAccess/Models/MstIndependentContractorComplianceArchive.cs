using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstIndependentContractorComplianceArchive
{
    public int IndependentContractorComplianceId { get; set; }

    public int IndependentContractorId { get; set; }

    public int ComplianceChecklistId { get; set; }

    public bool HasComplied { get; set; }

    public bool IsDeleted { get; set; }

    public string CreatedBy { get; set; }

    public DateTime? CreatedDate { get; set; }

    public string UpdatedBy { get; set; }

    public DateTime? UpdatedDate { get; set; }

    public DateTime? ComplianceEffectiveDate { get; set; }

    public string AttachmentPath { get; set; }

    public int? ComplianceAttemptCount { get; set; }

    public string UploadedBy { get; set; }

    public DateTime? UploadedDate { get; set; }
}
