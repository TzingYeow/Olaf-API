using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using Serilog;
using Serilog.Configuration;
using SW.API.Extensions;
using SW.DataAccess;
using SW.DataAccess.Models;
using AutoMapper;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using IdentityServer4.AccessTokenValidation;
using Microsoft.OpenApi.Models;
using SW.API.Middlewares;

Log.Logger = new LoggerConfiguration()
    .WriteTo.Console()
   .WriteTo.File(@"C:\Logs\log.txt", rollingInterval: RollingInterval.Day)
  .CreateLogger();



try
{



    var builder = WebApplication.CreateBuilder(args);

    // Add services to the container.

    builder.Services.AddControllers();
    // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
    builder.Services.AddEndpointsApiExplorer();
    builder.Services.AddSwaggerGen(c =>
    {
        // Set the comments path for the Swagger JSON and UI.
        var clientCredentials = new OpenApiOAuthFlow()
        {
            TokenUrl = new Uri(builder.Configuration.GetValue<string>("Authorization:Url") + "/connect/token"),
        };
        var flows = new OpenApiOAuthFlows()
        {
            ClientCredentials = clientCredentials
        };
        var scheme = new OpenApiSecurityScheme
        {
            In = ParameterLocation.Header,
            Description = "JWT Authorization header using the Bearer scheme.",
            Name = "Authorization",
            BearerFormat = "Bearer {token}",
            Type = SecuritySchemeType.OAuth2,
            Flows = flows,
        };

        var requirement = new OpenApiSecurityRequirement { { new OpenApiSecurityScheme { Reference = new OpenApiReference { Type = ReferenceType.SecurityScheme, Id = "Bearer" } }, new string[] { } } };
        requirement.Add(scheme, new List<string>());
        c.AddSecurityDefinition("Bearer", scheme);
        c.AddSecurityRequirement(requirement);
    });
    // Configure the HTTP request pipeline.
    builder.Services.AddHttpContextAccessor();
    
    var environment = builder.Environment.EnvironmentName;
    Log.Information("Current environment: {Environment}", environment);

    Log.Information("Authorization:Scope", builder.Configuration.GetValue<string>("Authorization:Scope"));
    Log.Information("Authorization:Url",  builder.Configuration.GetValue<string>("Authorization:Url"));

    builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
       .AddJwtBearer(options =>
       {
           options.Audience = builder.Configuration.GetValue<string>("Authorization:Scope");
           options.Authority = builder.Configuration.GetValue<string>("Authorization:Url");
           options.RequireHttpsMetadata = false;
           options.TokenValidationParameters.ValidateAudience = false;
           options.TokenValidationParameters.ValidateIssuer = false;

       });

    // Authorization policies
    builder.Services.AddAuthorization(options =>
    {
        options.DefaultPolicy = new AuthorizationPolicyBuilder(JwtBearerDefaults.AuthenticationScheme)
          .RequireAuthenticatedUser()
          .RequireScope(builder.Configuration.GetValue<string>("Authorization:Scope"))
          .Build();
    });


    var connectionstring = builder.Configuration.GetConnectionString("Olaf_Prod");
    Log.Information("Using connection string: {ConnectionString}", connectionstring);


    builder.Services.AddDbContext<ApplicationDbContext>(options =>
    {
        options.UseSqlServer(connectionstring, x => x.UseHierarchyId());
    });

    builder.Services.AddSalesWorksServices();

    //CORS Origin
    builder.Services.AddCors(options =>
    {
        options.AddPolicy("AllowAll",
            builder =>
            {
                builder.AllowAnyOrigin()
                       .AllowAnyHeader()
                       .AllowAnyMethod();
            });
    });


    // Auto Mapper
    builder.Services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());

    // Create logger
 

    var app = builder.Build();


    if (app.Environment.IsDevelopment())
    {
        app.UseSwagger();
        app.UseSwaggerUI();
    }
    else
    {
        app.UseHsts();
    }


    app.UseMiddleware<GlobalExceptionHandlerMiddleware>();
    app.UseHttpsRedirection();
    //CORS Origin
    app.UseCors("AllowAll");
    app.UseAuthorization();

    app.MapControllers();

    app.Run();

}

catch (Exception ex)
{
    Log.Fatal(ex, "An unhandled exception occured during bootstrapping");
}
finally
{
    Log.CloseAndFlush();
}

