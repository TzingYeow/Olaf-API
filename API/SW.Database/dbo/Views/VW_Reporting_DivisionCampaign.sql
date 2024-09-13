


CREATE VIEW [dbo].[VW_Reporting_DivisionCampaign]
AS
SELECT A.DivisionId, A.DivisionCode, A.DivisionName, B.CampaignId, B.CampaignCode, B.CampaignName, B.CountryCode, B.IsTestProduct, B.IsActive as 'CampaignIsActive' FROM Mst_Division A LEFT JOIN Mst_Campaign B ON A.DivisionId = B.DivisionId

