using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System;
using System.ComponentModel.DataAnnotations;
using System.Net;

namespace SW.API.Middlewares
{
    public class GlobalExceptionHandlerMiddleware : AbstractExceptionHandlerMiddleware
    {
        public GlobalExceptionHandlerMiddleware(RequestDelegate next, ILogger<GlobalExceptionHandlerMiddleware> logger) : base(next, logger)
        {
        }

        public override (HttpStatusCode code, string message) GetResponse(Exception exception)
        {
            HttpStatusCode code;
            string message;
            switch (exception)
            {
                case ValidationException:
                    code = HttpStatusCode.BadRequest;
                    message = exception.Message;
                    break;
                default:
                    code = HttpStatusCode.InternalServerError;
                    message = "An unknown error has occured.";
                    break;
            }
            return (code, message);
        }
    }
}
