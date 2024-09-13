using SW.DataAccess;
using SW.DataAccess.Models;
namespace SW.Service
{
    public class ServiceBase
    {
        protected readonly ApplicationDbContext DbContext;
 
        public ServiceBase(ApplicationDbContext dbContext)
        {
            DbContext = dbContext;
         
        }
    }
}
