using System.Security.Claims;

namespace SW.Service
{
    public class SessionService
    {
        private readonly IHttpContextAccessor _context;
        private readonly IEnumerable<string> _accesses;
        public SessionService(IHttpContextAccessor context)
        {
            _context = context;
            _accesses = context.HttpContext?.User?.FindAll("access")?.Select(c => c.Value).ToList();
        }

        public string GetUserName()
        {
            return _context.HttpContext?.User?.FindFirst("username")?.Value;
        }

        public string GetRole()
        {
            return _context.HttpContext?.User?.FindFirst(ClaimTypes.Role)?.Value;
        }

        public string[] GetMcCodes()
        {
            var mcCodes = _context.HttpContext?.User?.FindFirst("marketing_company")?.Value?.Split(',');
            return mcCodes;
        }

        public string GetIpAddress()
        {
            return _context.HttpContext?.Connection?.RemoteIpAddress?.ToString();
        }

        public IEnumerable<string> GetAccesses()
        {
            return _accesses;
        }

        public bool HasAccess(string access)
        {
            return _accesses.ToList().Exists(x => x == access);
        }
    }
}
