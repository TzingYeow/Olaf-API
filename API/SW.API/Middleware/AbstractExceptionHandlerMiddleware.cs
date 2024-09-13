#region Assembly SalesWorksCore.API, Version=2.0.1.0, Culture=neutral, PublicKeyToken=null
// C:\Users\tzingyeow.yap\.nuget\packages\salesworkscore.api\2.0.1\lib\net6.0\SalesWorksCore.API.dll
// Decompiled with ICSharpCode.Decompiler 8.1.1.7464
#endregion

using System;
using System.Net;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;

namespace SW.API.Middlewares;

public abstract class AbstractExceptionHandlerMiddleware
{
    private readonly RequestDelegate _next;

    private readonly ILogger<AbstractExceptionHandlerMiddleware> _logger;

    public AbstractExceptionHandlerMiddleware(RequestDelegate next, ILogger<AbstractExceptionHandlerMiddleware> logger)
    {
        _next = next;
        _logger = logger;
    }

    public abstract (HttpStatusCode code, string message) GetResponse(Exception exception);

    public async Task Invoke(HttpContext context)
    {
        try
        {
            await _next(context);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, ex.Message);
            HttpResponse response = context.Response;
            response.ContentType = "application/json";
            (HttpStatusCode code, string message) response2 = GetResponse(ex);
            HttpStatusCode item = response2.code;
            string item2 = response2.message;
            response.StatusCode = (int)item;
            await response.WriteAsync(item2);
        }
    }
}
#if false // Decompilation log
'426' items in cache
------------------
Resolve: 'System.Runtime, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Found single assembly: 'System.Runtime, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Load from: 'C:\Users\tzingyeow.yap\.nuget\packages\microsoft.netcore.app.ref\6.0.31\ref\net6.0\System.Runtime.dll'
------------------
Resolve: 'Microsoft.AspNetCore.Http.Abstractions, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60'
Found single assembly: 'Microsoft.AspNetCore.Http.Abstractions, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60'
Load from: 'C:\Users\tzingyeow.yap\.nuget\packages\microsoft.aspnetcore.app.ref\6.0.31\ref\net6.0\Microsoft.AspNetCore.Http.Abstractions.dll'
------------------
Resolve: 'Microsoft.Extensions.Logging.Abstractions, Version=6.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60'
Found single assembly: 'Microsoft.Extensions.Logging.Abstractions, Version=7.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60'
WARN: Version mismatch. Expected: '6.0.0.0', Got: '7.0.0.0'
Load from: 'C:\Users\tzingyeow.yap\.nuget\packages\microsoft.extensions.logging.abstractions\7.0.0\lib\net6.0\Microsoft.Extensions.Logging.Abstractions.dll'
------------------
Resolve: 'System.Net.Primitives, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Found single assembly: 'System.Net.Primitives, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Load from: 'C:\Users\tzingyeow.yap\.nuget\packages\microsoft.netcore.app.ref\6.0.31\ref\net6.0\System.Net.Primitives.dll'
------------------
Resolve: 'System.Runtime.InteropServices, Version=6.0.0.0, Culture=neutral, PublicKeyToken=null'
Found single assembly: 'System.Runtime.InteropServices, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Load from: 'C:\Users\tzingyeow.yap\.nuget\packages\microsoft.netcore.app.ref\6.0.31\ref\net6.0\System.Runtime.InteropServices.dll'
------------------
Resolve: 'System.Runtime.CompilerServices.Unsafe, Version=6.0.0.0, Culture=neutral, PublicKeyToken=null'
Found single assembly: 'System.Runtime.CompilerServices.Unsafe, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
Load from: 'C:\Users\tzingyeow.yap\.nuget\packages\microsoft.netcore.app.ref\6.0.31\ref\net6.0\System.Runtime.CompilerServices.Unsafe.dll'
#endif
