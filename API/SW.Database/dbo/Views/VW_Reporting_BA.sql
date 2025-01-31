﻿



CREATE VIEW [dbo].[VW_Reporting_BA]
AS
SELECT A.IndependentContractorId AS 'BAId', A.BadgeNo,  A.OriginalBadgeNo, A.MarketingCompanyId as 'MCId', C.Code as 'MCCode', C.Name as 'MCName', C.CountryCode as 'MCCountry', CAST(CASE WHEN C.IsActive = 1 THEN 'Active' Else 'Inactive' END as nvarchar(10)) as  'MCStatus',  A.ReportBadgeNo, B.Level, B.LevelCode, B.ParentLevel, A.Status, A.FirstName, A.MiddleName, A.LastName, A.Nickname, A.LocalFirstName, A.LocalLastName, A.Gender,A.Ic, A.Dob , A.PhoneNumber, A.MobileNumber, A.Email, A.Nationality,  A.StartDate, A.DateFirstOnField as 'FirstDayOnField', A.LastSalesSubmissionDate,A.EducationLevel,
A.MaritalStatus, A.BirthPlace, A.PermanentAddress, A.Beneficiary1, A.Beneficiary2, A.AddressLine1, A.AddressLine2, A.AddressLine3, A.AddressCity, A.AddressPostCode, A.AddressState, A.AddressCountry, A.EmergencyContactPerson, A.EmergencyContactPhoneNumber, A.EmergencyContactRelationship, A.RecruitmentType, A.RecruiterBadgeNoOrName, A.RecruiterNote, A.RecruitmentSource, A.AdvertisementTitle,
A.BankName, A.BankBranch, A.BankAccountName, A.BankAccountNo, A.BankSwiftCode, A.TaxNumber, A.ReturnMaterialRemarks, A.BondLimit, A.BondPercentage, A.RecruitmentCandidateId, A.Remark, A.IsStayBackTeam, A.IsGoBackTeam, A.EffectiveAdvancementDate, A.LastDeactivateDate, A.FirstAttemptScore, A.FirstAttemptSubDate, A.SecondAttemptScore, A.SecondAttemptSubDate, A.PaymentSchema, A.TeamName, A.IsPartime, A.WithHoldingTax, A.Nhi,A.IsTemporary, A.AgreementSignedDate, A.SalesBranch, A.CreatedDate, A.UpdatedDate 
FROM Mst_IndependentContractor A 
LEFT JOIN Mst_IndependentContractorLevel B ON A.IndependentContractorLevelId = B.IndependentContractorLevelId 
LEFT JOIN  Mst_MarketingCompany C ON A.MarketingCompanyId = C.MarketingCompanyId
WHERE A.IsDeleted = 0



GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VW_Reporting_BA';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VW_Reporting_BA';

