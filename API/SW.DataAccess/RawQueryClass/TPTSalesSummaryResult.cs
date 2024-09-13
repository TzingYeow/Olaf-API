using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SW.DataAccess.RawQueryClass
{
    public class TPTSalesSummaryResult
    {
        public string BadgeNo { get; set; }

        public string BAName { get; set; }

        public string Division {get; set; }
        public int? Campaign { get; set; }
        public string CampaignCode { get; set; }
        public string CampaignName { get; set; }
        public string CampaignCountryCode { get; set; }

        public string CountryCode { get; set; }
        public string BadgeNoLink { get; set; }
        public string LevelCode { get; set; }
        public string Level { get; set; }
        public string MOCode { get; set; }
        public string MCName { get; set; }
        public decimal? PointConversion { get; set; }
        public decimal? Amount { get; set; }

    }

    public class BAListResult
    {
        public string BadgeNo { get; set; }
        public string CountryCode { get; set; }
        public string LevelCode { get; set; }
        public decimal? PointConversion { get; set; }

    }


}
