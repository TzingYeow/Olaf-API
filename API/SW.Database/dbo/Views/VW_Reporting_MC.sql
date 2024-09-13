



CREATE VIEW [dbo].[VW_Reporting_MC]
AS 
SELECT MarketingCompanyId as 'MCId',  Code as 'MCCode',Name as 'MCName', CountryCode as 'MCCountry', CAST(CASE WHEN IsActive = 1 THEN 'Active' Else 'Inactive' END as nvarchar(10)) as 'MCStatus' FROM Mst_MarketingCompany WHERE  IsDeleted = 0

