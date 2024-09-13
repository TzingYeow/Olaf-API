using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class VwUsersPreview
{
    public string UserId { get; set; }

    public string Fullname { get; set; }

    public string Email { get; set; }

    public string Role { get; set; }

    public string Username { get; set; }

    public string UserPassword { get; set; }

    public bool IsActive { get; set; }

    public string CountryAccess { get; set; }

    public string McCode { get; set; }

    public string McName { get; set; }

    public string CountryCode { get; set; }
}
