using System;
using System.Collections.Generic;

namespace SW.DataAccess.Models;

public partial class MstMcbatypeMapping
{
    public int Id { get; set; }

    public int? Mctype { get; set; }

    public int? Batype { get; set; }
}
