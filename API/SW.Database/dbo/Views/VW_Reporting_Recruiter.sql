



CREATE VIEW [dbo].[VW_Reporting_Recruiter]
AS 
SELECT RecruiterId, FirstName, MiddleName, LastName, LocalFirstName,LocalLastName, CASE WHEN A.IsDeleted = 0 THEN 'Active' ELSE 'Inactive' End As Status, B.MarketingCompanyId as 'MCId', B.Name, B.Code, B.CountryCode FROM Newolaf_prod..Mst_Recruiter A LEFT JOIN Newolaf_prod..MST_MarketingCompany B ON A.MarketingCompanyId = B.MarketingCompanyId
 
