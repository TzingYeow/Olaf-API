using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SW.API.Model.ReqModel
{
    public class ReqProcessWeekending
    {
        public DateOnly? WeekendingDate { get; set; }
        public string CreatedBy { get; set; }
    }
}
