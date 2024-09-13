using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class YtCampaign
{
    public int? Id { get; set; }

    public string Identifier { get; set; }

    public string Name { get; set; }

    public int? CountryId { get; set; }
}
