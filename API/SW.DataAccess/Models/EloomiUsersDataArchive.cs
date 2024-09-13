using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class EloomiUsersDataArchive
{
    public int Id { get; set; }

    public int UserId { get; set; }

    public string FirstName { get; set; }

    public string LastName { get; set; }

    public string EmployeeId { get; set; }

    public string Email { get; set; }

    public string Username { get; set; }

    public string ActivatedAt { get; set; }

    public string Gender { get; set; }

    public string Birthday { get; set; }

    public string DepartmentId { get; set; }

    public string UserPermission { get; set; }

    public string StartOfEmploymentAt { get; set; }

    public string EndOfEmploymentAt { get; set; }

    public string PersonalEmail { get; set; }

    public string Title { get; set; }

    public string Phone { get; set; }

    public string MobilePhone { get; set; }

    public string Language { get; set; }

    public string AccessGroup { get; set; }

    public string GenericRole { get; set; }

    public string Country { get; set; }

    public string Location { get; set; }

    public string Timezone { get; set; }

    public string Legal { get; set; }

    public string Level { get; set; }

    public string Initials { get; set; }

    public string SubCompany { get; set; }

    public string SkillLevel { get; set; }

    public string SalaryId { get; set; }

    public string TeamId { get; set; }

    public string DirectManagerIds { get; set; }

    public DateTime? DataInsertedAt { get; set; }

    public DateTime? DataArchivedAt { get; set; }
}
