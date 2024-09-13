using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using SW.DataAccess.RawQueryClass;

namespace SW.DataAccess.Models;

public partial class ApplicationDbContext : DbContext
{
    public ApplicationDbContext()
    {
    }

    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }

    #region RawQueryClass
    public DbSet<TPTSalesSummaryResult> TPTSalesSummaryResults { get; set; }
    public DbSet<BAListResult> BAListResults { get; set; }

    #endregion
    #region Tables

    public virtual DbSet<CoursesGrouping> CoursesGroupings { get; set; }

    public virtual DbSet<CoursesModuleSetting> CoursesModuleSettings { get; set; }

    public virtual DbSet<CoursesModuleSettingsBackup> CoursesModuleSettingsBackups { get; set; }

    public virtual DbSet<CoursesUsersExclusion> CoursesUsersExclusions { get; set; }
    public virtual DbSet<TxnRegionalRoadtrip> TxnRegionalRoadtrips { get; set; }

    public virtual DbSet<CoursesUsersResult> CoursesUsersResults { get; set; }

    public virtual DbSet<EloomiCourseCategoriesArchive> EloomiCourseCategoriesArchives { get; set; }

    public virtual DbSet<EloomiCourseCategory> EloomiCourseCategories { get; set; }

    public virtual DbSet<EloomiCourseParticipantsDataArchive> EloomiCourseParticipantsDataArchives { get; set; }

    public virtual DbSet<EloomiCourseParticipantsDatum> EloomiCourseParticipantsData { get; set; }

    public virtual DbSet<EloomiCoursesDataArchive> EloomiCoursesDataArchives { get; set; }

    public virtual DbSet<EloomiCoursesDatum> EloomiCoursesData { get; set; }

    public virtual DbSet<EloomiUsersDataArchive> EloomiUsersDataArchives { get; set; }

    public virtual DbSet<EloomiUsersDatum> EloomiUsersData { get; set; }

    public virtual DbSet<HkbaleaderCount> HkbaleaderCounts { get; set; }

    public virtual DbSet<Icdeactivationlist> Icdeactivationlists { get; set; }

    public virtual DbSet<MigrationHistory> MigrationHistories { get; set; }

    public virtual DbSet<MstAdvancementCriterion> MstAdvancementCriteria { get; set; }

    public virtual DbSet<MstAutoAdvancementSale> MstAutoAdvancementSales { get; set; }

    public virtual DbSet<MstAutoAdvancementSalesJenny> MstAutoAdvancementSalesJennies { get; set; }

    public virtual DbSet<MstBank> MstBanks { get; set; }

    public virtual DbSet<MstBatype> MstBatypes { get; set; }

    public virtual DbSet<MstCampaign> MstCampaigns { get; set; }

    public virtual DbSet<MstCandidateApplicationForm1> MstCandidateApplicationForm1s { get; set; }

    public virtual DbSet<MstChannel> MstChannels { get; set; }

    public virtual DbSet<MstComplianceChecklist> MstComplianceChecklists { get; set; }

    public virtual DbSet<MstCountryCallCodeCurrency> MstCountryCallCodeCurrencies { get; set; }

    public virtual DbSet<MstCountryPoint> MstCountryPoints { get; set; }

    public virtual DbSet<MstCountryPostcode> MstCountryPostcodes { get; set; }

    public virtual DbSet<MstDigitalFormRequiredField> MstDigitalFormRequiredFields { get; set; }

    public virtual DbSet<MstDigitalFormSetting> MstDigitalFormSettings { get; set; }

    public virtual DbSet<MstDivision> MstDivisions { get; set; }

    public virtual DbSet<MstEmailReceiver> MstEmailReceivers { get; set; }

    public virtual DbSet<MstIcOverviewHeadcount> MstIcOverviewHeadcounts { get; set; }

    public virtual DbSet<MstIcOverviewNetwork> MstIcOverviewNetworks { get; set; }

    public virtual DbSet<MstIndependentContractor> MstIndependentContractors { get; set; }

    public virtual DbSet<MstIndependentContractorArchive> MstIndependentContractorArchives { get; set; }

    public virtual DbSet<MstIndependentContractorAssignment> MstIndependentContractorAssignments { get; set; }

    public virtual DbSet<MstIndependentContractorBadgeCard> MstIndependentContractorBadgeCards { get; set; }

    public virtual DbSet<MstIndependentContractorBainfoWeekending> MstIndependentContractorBainfoWeekendings { get; set; }

    public virtual DbSet<MstIndependentContractorBranchOut> MstIndependentContractorBranchOuts { get; set; }

    public virtual DbSet<MstIndependentContractorCheckIn> MstIndependentContractorCheckIns { get; set; }

    public virtual DbSet<MstIndependentContractorCompliance> MstIndependentContractorCompliances { get; set; }

    public virtual DbSet<MstIndependentContractorComplianceArchive> MstIndependentContractorComplianceArchives { get; set; }

    public virtual DbSet<MstIndependentContractorEventHistory> MstIndependentContractorEventHistories { get; set; }

    public virtual DbSet<MstIndependentContractorLevel> MstIndependentContractorLevels { get; set; }

    public virtual DbSet<MstIndependentContractorMovement> MstIndependentContractorMovements { get; set; }

    public virtual DbSet<MstIndependentContractorPayableTraining> MstIndependentContractorPayableTrainings { get; set; }

    public virtual DbSet<MstIndependentContractorReportingNoChange> MstIndependentContractorReportingNoChanges { get; set; }

    public virtual DbSet<MstIndependentContractorSaving> MstIndependentContractorSavings { get; set; }

    public virtual DbSet<MstIndependentContractorSuspension> MstIndependentContractorSuspensions { get; set; }

    public virtual DbSet<MstIndependentContractorSuspensionReason> MstIndependentContractorSuspensionReasons { get; set; }

    public virtual DbSet<MstIndependentContractorTraining> MstIndependentContractorTrainings { get; set; }

    public virtual DbSet<MstLocalization> MstLocalizations { get; set; }

    public virtual DbSet<MstMarketingCompany> MstMarketingCompanies { get; set; }

    public virtual DbSet<MstMarketingCompanyBranch> MstMarketingCompanyBranches { get; set; }

    public virtual DbSet<MstMarketingCompanyCampaign> MstMarketingCompanyCampaigns { get; set; }

    public virtual DbSet<MstMarketingCompanyEmail> MstMarketingCompanyEmails { get; set; }

    public virtual DbSet<MstMarketingCompanyStaff> MstMarketingCompanyStaffs { get; set; }

    public virtual DbSet<MstMasterCode> MstMasterCodes { get; set; }

    public virtual DbSet<MstMcbatypeMapping> MstMcbatypeMappings { get; set; }

    public virtual DbSet<MstMcexclusion> MstMcexclusions { get; set; }

    public virtual DbSet<MstMenu> MstMenus { get; set; }

    public virtual DbSet<MstMovementType> MstMovementTypes { get; set; }

    public virtual DbSet<MstPrCustomBankInfo> MstPrCustomBankInfos { get; set; }

    public virtual DbSet<MstPrMaster> MstPrMasters { get; set; }

    public virtual DbSet<MstPrPayout> MstPrPayouts { get; set; }

    public virtual DbSet<MstPrRoadTripLink> MstPrRoadTripLinks { get; set; }

    public virtual DbSet<MstRecruiter> MstRecruiters { get; set; }

    public virtual DbSet<MstRecruitmentCandidate> MstRecruitmentCandidates { get; set; }

    public virtual DbSet<MstRecruitmentCandidateActivityLog> MstRecruitmentCandidateActivityLogs { get; set; }

    public virtual DbSet<MstRecruitmentCandidateArchive> MstRecruitmentCandidateArchives { get; set; }

    public virtual DbSet<MstRecruitmentCandidateAssignment> MstRecruitmentCandidateAssignments { get; set; }

    public virtual DbSet<MstRecruitmentCandidateCompliance> MstRecruitmentCandidateCompliances { get; set; }

    public virtual DbSet<MstRecruitmentCandidateInduction> MstRecruitmentCandidateInductions { get; set; }

    public virtual DbSet<MstRecruitmentComparisonSummary> MstRecruitmentComparisonSummaries { get; set; }

    public virtual DbSet<MstReport> MstReports { get; set; }

    public virtual DbSet<MstReportCategory> MstReportCategories { get; set; }

    public virtual DbSet<MstReportRole> MstReportRoles { get; set; }

    public virtual DbSet<MstSpecialAccessRole> MstSpecialAccessRoles { get; set; }

    public virtual DbSet<MstSuspensionArchived> MstSuspensionArchiveds { get; set; }

    public virtual DbSet<MstSuspensionTempTable> MstSuspensionTempTables { get; set; }

    public virtual DbSet<MstTptcountryPoint> MstTptcountryPoints { get; set; }

    public virtual DbSet<MstUploadFileHistory> MstUploadFileHistories { get; set; }

    public virtual DbSet<MstUser> MstUsers { get; set; }

    public virtual DbSet<MstUserResetPasswordToken> MstUserResetPasswordTokens { get; set; }

    public virtual DbSet<MstUserRole> MstUserRoles { get; set; }

    public virtual DbSet<MstWeekending> MstWeekendings { get; set; }

    public virtual DbSet<RecruiterList> RecruiterLists { get; set; }

    public virtual DbSet<ReportSubscription> ReportSubscriptions { get; set; }

    public virtual DbSet<ReportingRecruitmentActivity> ReportingRecruitmentActivities { get; set; }

    public virtual DbSet<RptOverviewDetailByCountry> RptOverviewDetailByCountries { get; set; }

    public virtual DbSet<RptOverviewDigitalAppNewdMethod> RptOverviewDigitalAppNewdMethods { get; set; }

    public virtual DbSet<RptOverviewDigitalAppOldMethod> RptOverviewDigitalAppOldMethods { get; set; }

    public virtual DbSet<RptOverviewRecruitment> RptOverviewRecruitments { get; set; }

    public virtual DbSet<Sheet1> Sheet1s { get; set; }

    public virtual DbSet<TempApplicationFormUrl> TempApplicationFormUrls { get; set; }

    public virtual DbSet<TempApplicationFormUrlmo> TempApplicationFormUrlmos { get; set; }

    public virtual DbSet<TxnAutoAdvancementConfirmation> TxnAutoAdvancementConfirmations { get; set; }

    public virtual DbSet<TxnAutoAdvancementResult> TxnAutoAdvancementResults { get; set; }

    public virtual DbSet<TxnAutoAdvancementResult2> TxnAutoAdvancementResult2s { get; set; }

    public virtual DbSet<TxnBonu> TxnBonus { get; set; }

    public virtual DbSet<TxnCampaignDocument> TxnCampaignDocuments { get; set; }

    public virtual DbSet<TxnCampaignDocumentArchive> TxnCampaignDocumentArchives { get; set; }

    public virtual DbSet<TxnClientIdentification> TxnClientIdentifications { get; set; }

    public virtual DbSet<TxnClientIdentification2> TxnClientIdentification2s { get; set; }

    public virtual DbSet<TxnClientIdentification20240122> TxnClientIdentification20240122s { get; set; }

    public virtual DbSet<TxnEmailQueue> TxnEmailQueues { get; set; }

    public virtual DbSet<TxnEmailQueue2> TxnEmailQueue2s { get; set; }

    public virtual DbSet<TxnEmailQueue3> TxnEmailQueue3s { get; set; }

    public virtual DbSet<TxnEmailQueue5> TxnEmailQueue5s { get; set; }

    public virtual DbSet<TxnEmailQueueArchive> TxnEmailQueueArchives { get; set; }

    public virtual DbSet<TxnHuddleRpt> TxnHuddleRpts { get; set; }

    public virtual DbSet<TxnIcweekEndingStatusTest> TxnIcweekEndingStatusTests { get; set; }

    public virtual DbSet<TxnIcweekendingStatus> TxnIcweekendingStatuses { get; set; }

    public virtual DbSet<TxnOnfieldHeadcountDetail> TxnOnfieldHeadcountDetails { get; set; }

    public virtual DbSet<TxnOnfieldHeadcountHeader> TxnOnfieldHeadcountHeaders { get; set; }

    public virtual DbSet<TxnPrDetail> TxnPrDetails { get; set; }

    public virtual DbSet<TxnPrIncentiveRaw> TxnPrIncentiveRaws { get; set; }

    public virtual DbSet<TxnPrIncentiveRawTemp> TxnPrIncentiveRawTemps { get; set; }

    public virtual DbSet<TxnPrSingapore> TxnPrSingapores { get; set; }

    public virtual DbSet<TxnPrbonu> TxnPrbonus { get; set; }

    public virtual DbSet<TxnRegionalSalesBonu> TxnRegionalSalesBonus { get; set; }

    public virtual DbSet<TxnRegionalSalesSummary> TxnRegionalSalesSummaries { get; set; }

    public virtual DbSet<TxnRegionalSalesSummaryUat> TxnRegionalSalesSummaryUats { get; set; }

    public virtual DbSet<TxnReportingBadgeKr> TxnReportingBadgeKrs { get; set; }

    public virtual DbSet<TxnTempManualLastSalesDate> TxnTempManualLastSalesDates { get; set; }

    public virtual DbSet<TxnTempStarhubCpq> TxnTempStarhubCpqs { get; set; }

    public virtual DbSet<TxnTptsummary> TxnTptsummaries { get; set; }

    public virtual DbSet<TxnTptdetails> TxnTptdetails1 { get; set; }


    public virtual DbSet<TxnValidation> TxnValidations { get; set; }

    public virtual DbSet<TxnWeeklyBasummary> TxnWeeklyBasummaries { get; set; }
    public virtual DbSet<TXN_SalesSummaryBonus> TXN_SalesSummaryBonuses { get; set; }

    #endregion

    #region View
    public virtual DbSet<VwIcdetail> VwIcdetails { get; set; }

    public virtual DbSet<VwIndependentContractorsPreview> VwIndependentContractorsPreviews { get; set; }

    public virtual DbSet<VwKoreaBalist> VwKoreaBalists { get; set; }

    public virtual DbSet<VwPrMaster> VwPrMasters { get; set; }

    public virtual DbSet<VwRecruitmentCandidateActivityLog> VwRecruitmentCandidateActivityLogs { get; set; }

    public virtual DbSet<VwReportingBa> VwReportingBas { get; set; }

    public virtual DbSet<VwReportingDivisionCampaign> VwReportingDivisionCampaigns { get; set; }

    public virtual DbSet<VwReportingMc> VwReportingMcs { get; set; }

    public virtual DbSet<VwReportingNoChange> VwReportingNoChanges { get; set; }

    public virtual DbSet<VwReportingRecruiter> VwReportingRecruiters { get; set; }

    public virtual DbSet<VwReportingTxnBaMovement> VwReportingTxnBaMovements { get; set; }

    public virtual DbSet<VwReportingTxnRecruitment> VwReportingTxnRecruitments { get; set; }

    public virtual DbSet<VwReportingTxnRecruitmentArchived> VwReportingTxnRecruitmentArchiveds { get; set; }

    public virtual DbSet<VwUsersPreview> VwUsersPreviews { get; set; }
    public virtual DbSet<VW_BARelationship> VW_BARelationships { get; set; }

    public virtual DbSet<YtCampaign> YtCampaigns { get; set; }

    public virtual DbSet<YtMarketingCompany> YtMarketingCompanies { get; set; }
    public virtual DbSet<VwIndependentContractorBainfoWeekending> VwIndependentContractorBainfoWeekendings { get; set; }

    public virtual DbSet<YtUser> YtUsers { get; set; }


    #endregion


    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<TPTSalesSummaryResult>().HasNoKey();  // No primary key for this result type
        modelBuilder.Entity<BAListResult>().HasNoKey();  // No primary key for this result type



        modelBuilder.Entity<TXN_SalesSummaryBonus>(entity =>
          {
              entity.HasKey(e => new { e.BadgeNo, e.CountryCode, e.MOCode });
              entity.ToTable("TXN_SalesSummaryBonus");
          });

        modelBuilder.Entity<TxnRegionalRoadtrip>(entity =>
        {
            entity.HasKey(e => new { e.RTCountryCode, e.RTBadgeNo });
            entity.ToTable("TXN_RegionalRoadtrip");

        });

        modelBuilder.Entity<VwIndependentContractorBainfoWeekending>(entity =>
        {
           
                //entity.Metadata.IsKeyless = false;
                entity.HasKey(e => e.IndependentContractorBainfoId);
            entity.ToTable("VW_IndependentContractor_BAInfo_Weekending");

        });




        modelBuilder.Entity<CoursesGrouping>(entity =>
        {
            entity.HasKey(e => e.GroupId);

            entity.ToTable("Courses_Grouping");

            entity.HasIndex(e => new { e.IsDeleted, e.IsCompulsory }, "IX_IsDeleted_IsCompulsory");

            entity.Property(e => e.Campaign).HasMaxLength(200);
            entity.Property(e => e.CountryCode).HasMaxLength(5);
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });


        modelBuilder.Entity<CoursesModuleSetting>(entity =>
        {
            entity.HasKey(e => e.CourseModuleSettingId);

            entity.ToTable("Courses_Module_Settings");

            entity.HasIndex(e => e.GroupId, "IX_GroupId");

            entity.HasIndex(e => e.IsDeleted, "IX_IsDeleted");

            entity.Property(e => e.CourseName).HasMaxLength(100);
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<CoursesModuleSettingsBackup>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("Courses_Module_Settings_Backup");

            entity.Property(e => e.CourseModuleSettingId).ValueGeneratedOnAdd();
            entity.Property(e => e.CourseName).HasMaxLength(100);
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<CoursesUsersExclusion>(entity =>
        {
            entity.ToTable("Courses_Users_Exclusion");

            entity.HasIndex(e => e.BadgeNo, "IX_BadgeNo");

            entity.HasIndex(e => e.UserName, "IX_UserName");

            entity.Property(e => e.BadgeNo)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.DateAdded)
                .HasColumnType("datetime")
                .HasColumnName("dateAdded");
            entity.Property(e => e.ExType)
                .IsRequired()
                .HasMaxLength(5);
            entity.Property(e => e.ExclusionReason)
                .HasMaxLength(200)
                .HasColumnName("exclusionReason");
            entity.Property(e => e.Mcid)
                .HasMaxLength(5)
                .HasColumnName("MCID");
            entity.Property(e => e.UserName)
                .IsRequired()
                .HasMaxLength(50);
        });

        modelBuilder.Entity<CoursesUsersResult>(entity =>
        {
            entity.ToTable("Courses_Users_results");

            entity.HasIndex(e => new { e.EloomiUserId, e.CourseId }, "IX_EloomiUserId_CourseId");

            entity.Property(e => e.DataCreatedAt)
                .HasColumnType("datetime")
                .HasColumnName("data_created_at");
            entity.Property(e => e.DataUpdatedAt)
                .HasColumnType("datetime")
                .HasColumnName("data_updated_at");
        });

        modelBuilder.Entity<EloomiCourseCategoriesArchive>(entity =>
        {
            entity.ToTable("Eloomi_Course_Categories_Archive");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CategoriesId).HasColumnName("categories_id");
            entity.Property(e => e.DataArchivedAt)
                .HasColumnType("datetime")
                .HasColumnName("data_archived_at");
            entity.Property(e => e.DataInsertedAt)
                .HasColumnType("datetime")
                .HasColumnName("data_inserted_at");
            entity.Property(e => e.Name)
                .HasMaxLength(150)
                .HasColumnName("name");
            entity.Property(e => e.ParentId).HasColumnName("parent_id");
        });

        modelBuilder.Entity<EloomiCourseCategory>(entity =>
        {
            entity.HasKey(e => e.CategoriesId);

            entity.ToTable("Eloomi_Course_Categories");

            entity.Property(e => e.CategoriesId)
                .ValueGeneratedNever()
                .HasColumnName("categories_id");
            entity.Property(e => e.DataInsertedAt)
                .HasColumnType("datetime")
                .HasColumnName("data_inserted_at");
            entity.Property(e => e.Name)
                .HasMaxLength(150)
                .HasColumnName("name");
            entity.Property(e => e.ParentId).HasColumnName("parent_id");
        });

        modelBuilder.Entity<EloomiCourseParticipantsDataArchive>(entity =>
        {
            entity.ToTable("Eloomi_Course_Participants_Data_Archive");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.AssignedAt)
                .HasMaxLength(30)
                .HasColumnName("assigned_at");
            entity.Property(e => e.Attempts).HasColumnName("attempts");
            entity.Property(e => e.CompanyId).HasColumnName("company_id");
            entity.Property(e => e.CompletedAt)
                .HasMaxLength(30)
                .HasColumnName("completed_at");
            entity.Property(e => e.CompletedBy)
                .HasMaxLength(50)
                .HasColumnName("completed_by");
            entity.Property(e => e.CourseDescription).HasColumnName("course_description");
            entity.Property(e => e.CourseId).HasColumnName("course_id");
            entity.Property(e => e.CourseName)
                .HasMaxLength(50)
                .HasColumnName("course_name");
            entity.Property(e => e.CourseParticipantId).HasColumnName("course_participant_id");
            entity.Property(e => e.CourseType)
                .HasMaxLength(50)
                .HasColumnName("course_type");
            entity.Property(e => e.DataArchivedAt)
                .HasColumnType("datetime")
                .HasColumnName("data_archived_at");
            entity.Property(e => e.DataInsertedAt)
                .HasColumnType("datetime")
                .HasColumnName("data_inserted_at");
            entity.Property(e => e.Deadline)
                .HasMaxLength(30)
                .HasColumnName("deadline");
            entity.Property(e => e.DoNotify).HasColumnName("do_notify");
            entity.Property(e => e.ExpiredAt)
                .HasMaxLength(30)
                .HasColumnName("expired_at");
            entity.Property(e => e.ImageId).HasColumnName("image_id");
            entity.Property(e => e.Name)
                .HasMaxLength(100)
                .HasColumnName("name");
            entity.Property(e => e.ParticipantType)
                .HasMaxLength(50)
                .HasColumnName("participant_type");
            entity.Property(e => e.Progress).HasColumnName("progress");
            entity.Property(e => e.RenewalApplyFrom)
                .HasMaxLength(50)
                .HasColumnName("renewal_apply_from");
            entity.Property(e => e.RenewalAt)
                .HasMaxLength(30)
                .HasColumnName("renewal_at");
            entity.Property(e => e.RenewalFromDate)
                .HasMaxLength(50)
                .HasColumnName("renewal_from_date");
            entity.Property(e => e.RenewalFromFunction)
                .HasMaxLength(50)
                .HasColumnName("renewal_from_function");
            entity.Property(e => e.RenewalFromInterval)
                .HasMaxLength(50)
                .HasColumnName("renewal_from_interval");
            entity.Property(e => e.RenewalPeriod)
                .HasMaxLength(10)
                .HasColumnName("renewal_period");
            entity.Property(e => e.RenewalPeriodStart)
                .HasMaxLength(30)
                .HasColumnName("renewal_period_start");
            entity.Property(e => e.RenewalType)
                .HasMaxLength(50)
                .HasColumnName("renewal_type");
            entity.Property(e => e.Score)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("score");
            entity.Property(e => e.StartedAt)
                .HasMaxLength(30)
                .HasColumnName("started_at");
            entity.Property(e => e.Status)
                .HasMaxLength(100)
                .HasColumnName("status");
            entity.Property(e => e.TimeSpentString)
                .HasMaxLength(50)
                .HasColumnName("time_spent_string");
            entity.Property(e => e.TotalRenewals).HasColumnName("total_renewals");
            entity.Property(e => e.TotalRenewed).HasColumnName("total_renewed");
            entity.Property(e => e.UserId).HasColumnName("user_id");
        });

        modelBuilder.Entity<EloomiCourseParticipantsDatum>(entity =>
        {
            entity.ToTable("Eloomi_Course_Participants_Data");

            entity.HasIndex(e => new { e.CourseId, e.UserId }, "IX_CourseId_UserId");

            entity.HasIndex(e => new { e.CourseId, e.UserId, e.Attempts }, "IX_CourseId_UserId_Attempts");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.AssignedAt)
                .HasMaxLength(30)
                .HasColumnName("assigned_at");
            entity.Property(e => e.Attempts).HasColumnName("attempts");
            entity.Property(e => e.CompanyId).HasColumnName("company_id");
            entity.Property(e => e.CompletedAt)
                .HasMaxLength(30)
                .HasColumnName("completed_at");
            entity.Property(e => e.CompletedBy)
                .HasMaxLength(50)
                .HasColumnName("completed_by");
            entity.Property(e => e.CourseDescription).HasColumnName("course_description");
            entity.Property(e => e.CourseId).HasColumnName("course_id");
            entity.Property(e => e.CourseName)
                .HasMaxLength(50)
                .HasColumnName("course_name");
            entity.Property(e => e.CourseType)
                .HasMaxLength(50)
                .HasColumnName("course_type");
            entity.Property(e => e.DataInsertedAt)
                .HasColumnType("datetime")
                .HasColumnName("data_inserted_at");
            entity.Property(e => e.Deadline)
                .HasMaxLength(30)
                .HasColumnName("deadline");
            entity.Property(e => e.DoNotify).HasColumnName("do_notify");
            entity.Property(e => e.ExpiredAt)
                .HasMaxLength(30)
                .HasColumnName("expired_at");
            entity.Property(e => e.ImageId).HasColumnName("image_id");
            entity.Property(e => e.Name)
                .HasMaxLength(100)
                .HasColumnName("name");
            entity.Property(e => e.ParticipantType)
                .HasMaxLength(50)
                .HasColumnName("participant_type");
            entity.Property(e => e.Progress).HasColumnName("progress");
            entity.Property(e => e.RenewalApplyFrom)
                .HasMaxLength(50)
                .HasColumnName("renewal_apply_from");
            entity.Property(e => e.RenewalAt)
                .HasMaxLength(30)
                .HasColumnName("renewal_at");
            entity.Property(e => e.RenewalFromDate)
                .HasMaxLength(50)
                .HasColumnName("renewal_from_date");
            entity.Property(e => e.RenewalFromFunction)
                .HasMaxLength(50)
                .HasColumnName("renewal_from_function");
            entity.Property(e => e.RenewalFromInterval)
                .HasMaxLength(50)
                .HasColumnName("renewal_from_interval");
            entity.Property(e => e.RenewalPeriod)
                .HasMaxLength(10)
                .HasColumnName("renewal_period");
            entity.Property(e => e.RenewalPeriodStart)
                .HasMaxLength(30)
                .HasColumnName("renewal_period_start");
            entity.Property(e => e.RenewalType)
                .HasMaxLength(50)
                .HasColumnName("renewal_type");
            entity.Property(e => e.Score)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("score");
            entity.Property(e => e.StartedAt)
                .HasMaxLength(30)
                .HasColumnName("started_at");
            entity.Property(e => e.Status)
                .HasMaxLength(100)
                .HasColumnName("status");
            entity.Property(e => e.TimeSpentString)
                .HasMaxLength(50)
                .HasColumnName("time_spent_string");
            entity.Property(e => e.TotalRenewals).HasColumnName("total_renewals");
            entity.Property(e => e.TotalRenewed).HasColumnName("total_renewed");
            entity.Property(e => e.UserId).HasColumnName("user_id");
        });

        modelBuilder.Entity<EloomiCoursesDataArchive>(entity =>
        {
            entity.ToTable("Eloomi_Courses_Data_Archive");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Active).HasColumnName("active");
            entity.Property(e => e.CourseId).HasColumnName("course_id");
            entity.Property(e => e.Cover).HasColumnName("cover");
            entity.Property(e => e.CreatedAt)
                .HasMaxLength(30)
                .HasColumnName("created_at");
            entity.Property(e => e.DataArchivedAt)
                .HasColumnType("datetime")
                .HasColumnName("data_archived_at");
            entity.Property(e => e.DataInsertedAt)
                .HasColumnType("datetime")
                .HasColumnName("data_inserted_at");
            entity.Property(e => e.Description).HasColumnName("description");
            entity.Property(e => e.ExpectedDuration)
                .HasMaxLength(50)
                .HasColumnName("expected_duration");
            entity.Property(e => e.InformLeaderDeadline).HasColumnName("inform_leader_deadline");
            entity.Property(e => e.LockAfterDeadline).HasColumnName("lock_after_deadline");
            entity.Property(e => e.Name)
                .HasMaxLength(100)
                .HasColumnName("name");
            entity.Property(e => e.Points)
                .HasMaxLength(50)
                .HasColumnName("points");
            entity.Property(e => e.Price)
                .HasColumnType("decimal(18, 4)")
                .HasColumnName("price");
            entity.Property(e => e.ReferenceNumber)
                .HasMaxLength(50)
                .HasColumnName("reference_number");
            entity.Property(e => e.Reward).HasColumnName("reward");
            entity.Property(e => e.UpdatedAt)
                .HasMaxLength(30)
                .HasColumnName("updated_at");
            entity.Property(e => e.Voluntary)
                .HasMaxLength(50)
                .HasColumnName("voluntary");
        });

        modelBuilder.Entity<EloomiCoursesDatum>(entity =>
        {
            entity.ToTable("Eloomi_Courses_Data");

            entity.Property(e => e.Id)
                .ValueGeneratedNever()
                .HasColumnName("id");
            entity.Property(e => e.Active).HasColumnName("active");
            entity.Property(e => e.Cover).HasColumnName("cover");
            entity.Property(e => e.CreatedAt)
                .HasMaxLength(30)
                .HasColumnName("created_at");
            entity.Property(e => e.DataInsertedAt)
                .HasColumnType("datetime")
                .HasColumnName("data_inserted_at");
            entity.Property(e => e.Description).HasColumnName("description");
            entity.Property(e => e.ExpectedDuration)
                .HasMaxLength(50)
                .HasColumnName("expected_duration");
            entity.Property(e => e.InformLeaderDeadline).HasColumnName("inform_leader_deadline");
            entity.Property(e => e.LockAfterDeadline).HasColumnName("lock_after_deadline");
            entity.Property(e => e.Name)
                .HasMaxLength(100)
                .HasColumnName("name");
            entity.Property(e => e.Points)
                .HasMaxLength(50)
                .HasColumnName("points");
            entity.Property(e => e.Price)
                .HasColumnType("decimal(18, 4)")
                .HasColumnName("price");
            entity.Property(e => e.ReferenceNumber)
                .HasMaxLength(50)
                .HasColumnName("reference_number");
            entity.Property(e => e.Reward).HasColumnName("reward");
            entity.Property(e => e.UpdatedAt)
                .HasMaxLength(30)
                .HasColumnName("updated_at");
            entity.Property(e => e.Voluntary)
                .HasMaxLength(50)
                .HasColumnName("voluntary");
        });

        modelBuilder.Entity<EloomiUsersDataArchive>(entity =>
        {
            entity.ToTable("Eloomi_Users_Data_Archive");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.AccessGroup)
                .HasMaxLength(150)
                .HasColumnName("access_group");
            entity.Property(e => e.ActivatedAt)
                .HasMaxLength(30)
                .HasColumnName("activated_at");
            entity.Property(e => e.Birthday)
                .HasMaxLength(30)
                .HasColumnName("birthday");
            entity.Property(e => e.Country)
                .HasMaxLength(50)
                .HasColumnName("country");
            entity.Property(e => e.DataArchivedAt)
                .HasColumnType("datetime")
                .HasColumnName("data_archived_at");
            entity.Property(e => e.DataInsertedAt)
                .HasColumnType("datetime")
                .HasColumnName("data_inserted_at");
            entity.Property(e => e.DepartmentId)
                .HasMaxLength(150)
                .HasColumnName("department_id");
            entity.Property(e => e.DirectManagerIds)
                .HasMaxLength(150)
                .HasColumnName("direct_manager_ids");
            entity.Property(e => e.Email)
                .HasMaxLength(80)
                .HasColumnName("email");
            entity.Property(e => e.EmployeeId)
                .HasMaxLength(50)
                .HasColumnName("employee_id");
            entity.Property(e => e.EndOfEmploymentAt)
                .HasMaxLength(30)
                .HasColumnName("end_of_employment_at");
            entity.Property(e => e.FirstName)
                .HasMaxLength(80)
                .HasColumnName("first_name");
            entity.Property(e => e.Gender)
                .HasMaxLength(10)
                .HasColumnName("gender");
            entity.Property(e => e.GenericRole)
                .HasMaxLength(50)
                .HasColumnName("generic_role");
            entity.Property(e => e.Initials)
                .HasMaxLength(50)
                .HasColumnName("initials");
            entity.Property(e => e.Language)
                .HasMaxLength(20)
                .HasColumnName("language");
            entity.Property(e => e.LastName)
                .HasMaxLength(80)
                .HasColumnName("last_name");
            entity.Property(e => e.Legal)
                .HasMaxLength(50)
                .HasColumnName("legal");
            entity.Property(e => e.Level)
                .HasMaxLength(50)
                .HasColumnName("level");
            entity.Property(e => e.Location)
                .HasMaxLength(50)
                .HasColumnName("location");
            entity.Property(e => e.MobilePhone)
                .HasMaxLength(50)
                .HasColumnName("mobile_phone");
            entity.Property(e => e.PersonalEmail)
                .HasMaxLength(50)
                .HasColumnName("personal_email");
            entity.Property(e => e.Phone)
                .HasMaxLength(50)
                .HasColumnName("phone");
            entity.Property(e => e.SalaryId)
                .HasMaxLength(50)
                .HasColumnName("salary_id");
            entity.Property(e => e.SkillLevel)
                .HasMaxLength(50)
                .HasColumnName("skill_level");
            entity.Property(e => e.StartOfEmploymentAt)
                .HasMaxLength(30)
                .HasColumnName("start_of_employment_at");
            entity.Property(e => e.SubCompany)
                .HasMaxLength(100)
                .HasColumnName("sub_company");
            entity.Property(e => e.TeamId)
                .HasMaxLength(150)
                .HasColumnName("team_id");
            entity.Property(e => e.Timezone)
                .HasMaxLength(100)
                .HasColumnName("timezone");
            entity.Property(e => e.Title)
                .HasMaxLength(100)
                .HasColumnName("title");
            entity.Property(e => e.UserId).HasColumnName("user_id");
            entity.Property(e => e.UserPermission)
                .HasMaxLength(50)
                .HasColumnName("user_permission");
            entity.Property(e => e.Username)
                .HasMaxLength(50)
                .HasColumnName("username");
        });

        modelBuilder.Entity<EloomiUsersDatum>(entity =>
        {
            entity.ToTable("Eloomi_Users_Data");

            entity.HasIndex(e => e.EmployeeId, "IX_EmployeeId");

            entity.HasIndex(e => e.Username, "IX_UserName");

            entity.Property(e => e.Id)
                .ValueGeneratedNever()
                .HasColumnName("id");
            entity.Property(e => e.AccessGroup)
                .HasMaxLength(150)
                .HasColumnName("access_group");
            entity.Property(e => e.ActivatedAt)
                .HasMaxLength(30)
                .HasColumnName("activated_at");
            entity.Property(e => e.Birthday)
                .HasMaxLength(30)
                .HasColumnName("birthday");
            entity.Property(e => e.Country)
                .HasMaxLength(50)
                .HasColumnName("country");
            entity.Property(e => e.DataInsertedAt)
                .HasColumnType("datetime")
                .HasColumnName("data_inserted_at");
            entity.Property(e => e.DepartmentId)
                .HasMaxLength(150)
                .HasColumnName("department_id");
            entity.Property(e => e.DirectManagerIds)
                .HasMaxLength(150)
                .HasColumnName("direct_manager_ids");
            entity.Property(e => e.Email)
                .HasMaxLength(80)
                .HasColumnName("email");
            entity.Property(e => e.EmployeeId)
                .HasMaxLength(50)
                .HasColumnName("employee_id");
            entity.Property(e => e.EndOfEmploymentAt)
                .HasMaxLength(30)
                .HasColumnName("end_of_employment_at");
            entity.Property(e => e.FirstName)
                .HasMaxLength(80)
                .HasColumnName("first_name");
            entity.Property(e => e.Gender)
                .HasMaxLength(10)
                .HasColumnName("gender");
            entity.Property(e => e.GenericRole)
                .HasMaxLength(50)
                .HasColumnName("generic_role");
            entity.Property(e => e.Initials)
                .HasMaxLength(50)
                .HasColumnName("initials");
            entity.Property(e => e.Language)
                .HasMaxLength(20)
                .HasColumnName("language");
            entity.Property(e => e.LastName)
                .HasMaxLength(80)
                .HasColumnName("last_name");
            entity.Property(e => e.Legal)
                .HasMaxLength(50)
                .HasColumnName("legal");
            entity.Property(e => e.Level)
                .HasMaxLength(50)
                .HasColumnName("level");
            entity.Property(e => e.Location)
                .HasMaxLength(50)
                .HasColumnName("location");
            entity.Property(e => e.MobilePhone)
                .HasMaxLength(50)
                .HasColumnName("mobile_phone");
            entity.Property(e => e.PersonalEmail)
                .HasMaxLength(50)
                .HasColumnName("personal_email");
            entity.Property(e => e.Phone)
                .HasMaxLength(50)
                .HasColumnName("phone");
            entity.Property(e => e.SalaryId)
                .HasMaxLength(50)
                .HasColumnName("salary_id");
            entity.Property(e => e.SkillLevel)
                .HasMaxLength(50)
                .HasColumnName("skill_level");
            entity.Property(e => e.StartOfEmploymentAt)
                .HasMaxLength(30)
                .HasColumnName("start_of_employment_at");
            entity.Property(e => e.SubCompany)
                .HasMaxLength(100)
                .HasColumnName("sub_company");
            entity.Property(e => e.TeamId)
                .HasMaxLength(150)
                .HasColumnName("team_id");
            entity.Property(e => e.Timezone)
                .HasMaxLength(100)
                .HasColumnName("timezone");
            entity.Property(e => e.Title)
                .HasMaxLength(100)
                .HasColumnName("title");
            entity.Property(e => e.UserPermission)
                .HasMaxLength(50)
                .HasColumnName("user_permission");
            entity.Property(e => e.Username)
                .HasMaxLength(50)
                .HasColumnName("username");
        });

        modelBuilder.Entity<HkbaleaderCount>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("HKBALeaderCount");

            entity.Property(e => e.Badgeno)
                .HasMaxLength(50)
                .HasColumnName("badgeno");
            entity.Property(e => e.Country).HasMaxLength(10);
            entity.Property(e => e.Mccode)
                .HasMaxLength(10)
                .HasColumnName("MCCode");
        });

        modelBuilder.Entity<Icdeactivationlist>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("ICDEACTIVATIONLIST");
        });

        modelBuilder.Entity<MigrationHistory>(entity =>
        {
            entity.HasKey(e => new { e.MigrationId, e.ContextKey }).HasName("PK_dbo.__MigrationHistory");

            entity.ToTable("__MigrationHistory");

            entity.Property(e => e.MigrationId).HasMaxLength(150);
            entity.Property(e => e.ContextKey).HasMaxLength(300);
            entity.Property(e => e.Model).IsRequired();
            entity.Property(e => e.ProductVersion)
                .IsRequired()
                .HasMaxLength(32);
        });

        modelBuilder.Entity<MstAdvancementCriterion>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("Mst_AdvancementCriteria");

            entity.Property(e => e.AdvancementId).ValueGeneratedOnAdd();
            entity.Property(e => e.CountryCode)
                .IsRequired()
                .HasMaxLength(10);
            entity.Property(e => e.CreatedBy)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.EndDate).HasColumnType("datetime");
            entity.Property(e => e.Province).HasMaxLength(50);
            entity.Property(e => e.SalesValue).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.StartDate).HasColumnType("datetime");
            entity.Property(e => e.TeamSizeSale).HasMaxLength(100);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<MstAutoAdvancementSale>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("Mst_AutoAdvancementSales");

            entity.Property(e => e.BadgeNo)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.BulletinPoint).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.CountryCode)
                .IsRequired()
                .HasMaxLength(10);
            entity.Property(e => e.CreatedBy)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Mocode)
                .IsRequired()
                .HasMaxLength(10)
                .HasColumnName("MOCode");
            entity.Property(e => e.PersonalPayable).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.SalesId).ValueGeneratedOnAdd();
            entity.Property(e => e.TeamPayable).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<MstAutoAdvancementSalesJenny>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("Mst_AutoAdvancementSales_Jenny");

            entity.Property(e => e.BadgeNo)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.BulletinPoint).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.CountryCode)
                .IsRequired()
                .HasMaxLength(10);
            entity.Property(e => e.CreatedBy)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Mocode)
                .IsRequired()
                .HasMaxLength(10)
                .HasColumnName("MOCode");
            entity.Property(e => e.PersonalPayable).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.SalesId).ValueGeneratedOnAdd();
            entity.Property(e => e.TeamPayable).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<MstBank>(entity =>
        {
            entity.HasKey(e => e.BankId).HasName("PK_dbo.Mst_Bank");

            entity.ToTable("Mst_Bank");

            entity.Property(e => e.BankCode).HasMaxLength(10);
            entity.Property(e => e.BankName)
                .IsRequired()
                .HasMaxLength(150);
            entity.Property(e => e.CountryCode)
                .IsRequired()
                .HasMaxLength(10);
            entity.Property(e => e.CreatedBy).HasMaxLength(20);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.HubsBankName).HasMaxLength(150);
            entity.Property(e => e.LocalBankName).HasMaxLength(150);
            entity.Property(e => e.UpdatedBy).HasMaxLength(20);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<MstBatype>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("Mst_BAType");

            entity.Property(e => e.Id)
                .ValueGeneratedOnAdd()
                .HasColumnName("ID");
        });

        modelBuilder.Entity<MstCampaign>(entity =>
        {
            entity.HasKey(e => e.CampaignId).HasName("PK_dbo.Mst_Campaign");

            entity.ToTable("Mst_Campaign");

            entity.HasIndex(e => e.DivisionId, "IX_DivisionId");

            entity.Property(e => e.CampaignCode)
                .IsRequired()
                .HasMaxLength(20);
            entity.Property(e => e.CampaignName)
                .IsRequired()
                .HasMaxLength(150);
            entity.Property(e => e.ClientCode).HasMaxLength(10);
            entity.Property(e => e.CountryCode)
                .IsRequired()
                .HasMaxLength(10);
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.SerialPrefix).HasMaxLength(10);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.Division).WithMany(p => p.MstCampaigns)
                .HasForeignKey(d => d.DivisionId)
                .HasConstraintName("FK_dbo.Mst_Campaign_dbo.Mst_Division_DivisionId");
        });

        modelBuilder.Entity<MstCandidateApplicationForm1>(entity =>
        {
            entity.HasKey(e => e.CandidateApplicationForm1Id).HasName("PK_dbo.Mst_CandidateApplication_Form1");

            entity.ToTable("Mst_CandidateApplication_Form1");

            entity.HasIndex(e => e.RecruitmentCandidateId, "IX_RecruitmentCandidateId");

            entity.Property(e => e.City).HasMaxLength(80);
            entity.Property(e => e.Country).HasMaxLength(30);
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.CurrentCompanyCurrency).HasMaxLength(255);
            entity.Property(e => e.CurrentCompanyIncomeType).HasMaxLength(255);
            entity.Property(e => e.DateofAvailability).HasColumnType("datetime");
            entity.Property(e => e.DateofCommenceWork).HasColumnType("datetime");
            entity.Property(e => e.Dob).HasColumnType("datetime");
            entity.Property(e => e.Email).HasMaxLength(150);
            entity.Property(e => e.ExpectedIncome).HasMaxLength(20);
            entity.Property(e => e.ExpectedIncomeCurrency).HasMaxLength(255);
            entity.Property(e => e.ExpectedIncomeType).HasMaxLength(255);
            entity.Property(e => e.FirstName).HasMaxLength(100);
            entity.Property(e => e.Gender).HasMaxLength(6);
            entity.Property(e => e.Ic).HasMaxLength(30);
            entity.Property(e => e.LastName).HasMaxLength(100);
            entity.Property(e => e.LocalFirstName).HasMaxLength(255);
            entity.Property(e => e.LocalLastName).HasMaxLength(50);
            entity.Property(e => e.MiddleName).HasMaxLength(100);
            entity.Property(e => e.MobileNumberHeader).HasMaxLength(255);
            entity.Property(e => e.Nationality).HasMaxLength(50);
            entity.Property(e => e.NickName).HasMaxLength(100);
            entity.Property(e => e.PhoneNumber).HasMaxLength(50);
            entity.Property(e => e.PhoneNumberHeader).HasMaxLength(255);
            entity.Property(e => e.Postcode).HasMaxLength(20);
            entity.Property(e => e.PreviousCompany1Currency).HasMaxLength(255);
            entity.Property(e => e.PreviousCompany1IncomeType).HasMaxLength(255);
            entity.Property(e => e.PreviousCompany2Currency).HasMaxLength(255);
            entity.Property(e => e.Referee1ContacNumberPrefixCode).HasMaxLength(255);
            entity.Property(e => e.Referee1Type)
                .HasMaxLength(150)
                .IsUnicode(false);
            entity.Property(e => e.Referee2ContacNumberPrefixCode).HasMaxLength(255);
            entity.Property(e => e.Referee2Type)
                .HasMaxLength(150)
                .IsUnicode(false);
            entity.Property(e => e.State).HasMaxLength(50);
            entity.Property(e => e.Status).IsRequired();
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.RecruitmentCandidate).WithMany(p => p.MstCandidateApplicationForm1s)
                .HasForeignKey(d => d.RecruitmentCandidateId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_dbo.Mst_CandidateApplication_Form1_dbo.Mst_RecruitmentCandidate_RecruitmentCandidateId");
        });

        modelBuilder.Entity<MstChannel>(entity =>
        {
            entity.HasKey(e => e.ChannelId).HasName("PK_dbo.Mst_Channel");

            entity.ToTable("Mst_Channel");

            entity.Property(e => e.ChannelCode)
                .IsRequired()
                .HasMaxLength(5);
            entity.Property(e => e.ChannelName)
                .IsRequired()
                .HasMaxLength(255);
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<MstComplianceChecklist>(entity =>
        {
            entity.HasKey(e => e.ComplianceChecklistId).HasName("PK_dbo.Mst_ComplianceChecklist");

            entity.ToTable("Mst_ComplianceChecklist");

            entity.HasIndex(e => e.CampaignId, "IX_CampaignId");

            entity.Property(e => e.CountryCode).HasMaxLength(10);
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Description)
                .IsRequired()
                .HasMaxLength(255);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.Campaign).WithMany(p => p.MstComplianceChecklists)
                .HasForeignKey(d => d.CampaignId)
                .HasConstraintName("FK_dbo.Mst_ComplianceChecklist_dbo.Mst_Campaign_CampaignId");
        });

        modelBuilder.Entity<MstCountryCallCodeCurrency>(entity =>
        {
            entity.HasKey(e => e.CountryId).HasName("PK_MST_CountryCallCode_Currency");

            entity.ToTable("Mst_CountryCallCode_Currency");

            entity.Property(e => e.CountryCode)
                .HasMaxLength(5)
                .IsUnicode(false);
            entity.Property(e => e.CountryName)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.CurOrdering).HasDefaultValueSql("('999')");
            entity.Property(e => e.CurrencyCode)
                .HasMaxLength(8)
                .IsUnicode(false);
            entity.Property(e => e.DialCode)
                .HasMaxLength(8)
                .IsUnicode(false);
        });

        modelBuilder.Entity<MstCountryPoint>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("MST_CountryPoint");

            entity.Property(e => e.Country).HasMaxLength(2);
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.EndWe).HasColumnName("EndWE");
            entity.Property(e => e.PointConversion).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.StartWe).HasColumnName("StartWE");
        });

        modelBuilder.Entity<MstCountryPostcode>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("Mst_Country_Postcode");

            entity.Property(e => e.City)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.Country)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.State)
                .IsRequired()
                .HasMaxLength(50);
        });

        modelBuilder.Entity<MstDigitalFormRequiredField>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("Mst_DigitalFormRequiredField");

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Field).HasMaxLength(50);
            entity.Property(e => e.FormRequiredId).ValueGeneratedOnAdd();
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<MstDigitalFormSetting>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("Mst_DigitalFormSettings");

            entity.Property(e => e.BankruptDescription).HasDefaultValue(true);
            entity.Property(e => e.BusinessGoals).HasDefaultValue(true);
            entity.Property(e => e.BusinessInvolvementDescription).HasDefaultValue(true);
            entity.Property(e => e.BusinessOpportunityRate).HasDefaultValue(true);
            entity.Property(e => e.ChallengingProjectsRate).HasDefaultValue(true);
            entity.Property(e => e.City).HasDefaultValue(true);
            entity.Property(e => e.Country).HasDefaultValue(true);
            entity.Property(e => e.CourseName).HasDefaultValue(true);
            entity.Property(e => e.CreatedBy).HasMaxLength(100);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.CriminalConvictionsDescription).HasDefaultValue(true);
            entity.Property(e => e.CurrentCompanyLastofIncome).HasDefaultValue(true);
            entity.Property(e => e.CurrentCompanyName).HasDefaultValue(true);
            entity.Property(e => e.CurrentCompanyPeriodofEmployment).HasDefaultValue(true);
            entity.Property(e => e.CurrentCompanyPosition).HasDefaultValue(true);
            entity.Property(e => e.CurrentCompanyReasonofLeaving).HasDefaultValue(true);
            entity.Property(e => e.CustomerServiceRate).HasDefaultValue(true);
            entity.Property(e => e.DateofAvailability).HasDefaultValue(true);
            entity.Property(e => e.DateofCommenceWork).HasDefaultValue(true);
            entity.Property(e => e.Dob).HasDefaultValue(true);
            entity.Property(e => e.Email).HasDefaultValue(true);
            entity.Property(e => e.ExpectedIncome).HasDefaultValue(true);
            entity.Property(e => e.FaceToFaceConfifdentDescription).HasDefaultValue(true);
            entity.Property(e => e.FirstName).HasDefaultValue(true);
            entity.Property(e => e.FormType).HasMaxLength(8);
            entity.Property(e => e.Gender).HasDefaultValue(true);
            entity.Property(e => e.HasCriminalConvictions).HasDefaultValue(true);
            entity.Property(e => e.HasPassport).HasDefaultValue(true);
            entity.Property(e => e.HighEarningRate).HasDefaultValue(true);
            entity.Property(e => e.HighestQualification).HasDefaultValue(true);
            entity.Property(e => e.Ic).HasDefaultValue(true);
            entity.Property(e => e.LanguageSpeaking).HasDefaultValue(true);
            entity.Property(e => e.LanguageWriting).HasDefaultValue(true);
            entity.Property(e => e.LastName).HasDefaultValue(true);
            entity.Property(e => e.LeadershipRate).HasDefaultValue(true);
            entity.Property(e => e.LearningOpportunityRate).HasDefaultValue(true);
            entity.Property(e => e.LocalFirstName).HasDefaultValue(true);
            entity.Property(e => e.LocalLastName).HasDefaultValue(true);
            entity.Property(e => e.MaritalStatus).HasDefaultValue(true);
            entity.Property(e => e.MiddleName).HasDefaultValue(true);
            entity.Property(e => e.MobileNumber).HasDefaultValue(true);
            entity.Property(e => e.NameOfInstituition).HasDefaultValue(true);
            entity.Property(e => e.Nationality).HasDefaultValue(true);
            entity.Property(e => e.NickName).HasDefaultValue(true);
            entity.Property(e => e.PersonalGoals).HasDefaultValue(true);
            entity.Property(e => e.PhoneNumber).HasDefaultValue(true);
            entity.Property(e => e.Postcode).HasDefaultValue(true);
            entity.Property(e => e.PreviousCompany1LastofIncome).HasDefaultValue(true);
            entity.Property(e => e.PreviousCompany1Name).HasDefaultValue(true);
            entity.Property(e => e.PreviousCompany1PeriodofEmployment).HasDefaultValue(true);
            entity.Property(e => e.PreviousCompany1Position).HasDefaultValue(true);
            entity.Property(e => e.PreviousCompany1ReasonofLeaving).HasDefaultValue(true);
            entity.Property(e => e.PreviousCompany2LastofIncome).HasDefaultValue(true);
            entity.Property(e => e.PreviousCompany2Name).HasDefaultValue(true);
            entity.Property(e => e.PreviousCompany2PeriodofEmployment).HasDefaultValue(true);
            entity.Property(e => e.PreviousCompany2Position).HasDefaultValue(true);
            entity.Property(e => e.PreviousCompany2ReasonofLeaving).HasDefaultValue(true);
            entity.Property(e => e.ReasonForApplying).HasDefaultValue(true);
            entity.Property(e => e.RecognitionRate).HasDefaultValue(true);
            entity.Property(e => e.Referee1CompanyName).HasDefaultValue(true);
            entity.Property(e => e.Referee1ContacNumber).HasDefaultValue(true);
            entity.Property(e => e.Referee1Designation).HasDefaultValue(true);
            entity.Property(e => e.Referee1Name).HasDefaultValue(true);
            entity.Property(e => e.Referee1Type).HasDefaultValue(true);
            entity.Property(e => e.Referee2CompanyName).HasDefaultValue(true);
            entity.Property(e => e.Referee2ContacNumber).HasDefaultValue(true);
            entity.Property(e => e.Referee2Designation).HasDefaultValue(true);
            entity.Property(e => e.Referee2Name).HasDefaultValue(true);
            entity.Property(e => e.Referee2Type).HasDefaultValue(true);
            entity.Property(e => e.ResidentialAddress).HasDefaultValue(true);
            entity.Property(e => e.State).HasDefaultValue(true);
            entity.Property(e => e.SufferMedicalDescription).HasDefaultValue(true);
            entity.Property(e => e.TriggerPoint).HasMaxLength(50);
            entity.Property(e => e.UpdatedBy).HasMaxLength(100);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
            entity.Property(e => e.YearofGraduation).HasDefaultValue(true);
        });

        modelBuilder.Entity<MstDivision>(entity =>
        {
            entity.HasKey(e => e.DivisionId).HasName("PK_dbo.Mst_Division");

            entity.ToTable("Mst_Division");

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.DivisionCode)
                .IsRequired()
                .HasMaxLength(5);
            entity.Property(e => e.DivisionName)
                .IsRequired()
                .HasMaxLength(255);
            entity.Property(e => e.ParentDivision).HasMaxLength(5);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<MstEmailReceiver>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("Mst_EmailReceiver");

            entity.Property(e => e.CountryCode)
                .IsRequired()
                .HasMaxLength(5);
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Email)
                .IsRequired()
                .HasMaxLength(300);
            entity.Property(e => e.EmailType)
                .IsRequired()
                .HasMaxLength(300);
            entity.Property(e => e.ReceiverDescription)
                .IsRequired()
                .HasMaxLength(300);
            entity.Property(e => e.ReceiverId).ValueGeneratedOnAdd();
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<MstIcOverviewHeadcount>(entity =>
        {
            entity.HasKey(e => e.IcOverviewHeadcountId).HasName("PK_dbo.Mst_IcOverview_Headcount");

            entity.ToTable("Mst_IcOverview_Headcount");

            entity.HasIndex(e => e.IndependentContractorLevelId, "IX_IndependentContractorLevelId");

            entity.HasIndex(e => e.MarketingCompanyId, "IX_MarketingCompanyId");

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.RecruitmentType)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.Status)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.IndependentContractorLevel).WithMany(p => p.MstIcOverviewHeadcounts)
                .HasForeignKey(d => d.IndependentContractorLevelId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_dbo.Mst_IcOverview_Headcount_dbo.Mst_IndependentContractorLevel_IndependentContractorLevelId");

            entity.HasOne(d => d.MarketingCompany).WithMany(p => p.MstIcOverviewHeadcounts)
                .HasForeignKey(d => d.MarketingCompanyId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_dbo.Mst_IcOverview_Headcount_dbo.Mst_MarketingCompany_MarketingCompanyId");
        });

        modelBuilder.Entity<MstIcOverviewNetwork>(entity =>
        {
            entity.HasKey(e => e.IcOverviewNetworkId).HasName("PK_dbo.Mst_IcOverview_Network");

            entity.ToTable("Mst_IcOverview_Network");

            entity.HasIndex(e => e.IndependentContractorId, "IX_IndependentContractorId");

            entity.HasIndex(e => e.IndependentContractorLevelId, "IX_IndependentContractorLevelId");

            entity.HasIndex(e => e.MarketingCompanyId, "IX_MarketingCompanyId");

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.ReportingBadgeNo).HasMaxLength(50);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.IndependentContractor).WithMany(p => p.MstIcOverviewNetworks)
                .HasForeignKey(d => d.IndependentContractorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_dbo.Mst_IcOverview_Network_dbo.Mst_IndependentContractor_IndependentContractorId");

            entity.HasOne(d => d.IndependentContractorLevel).WithMany(p => p.MstIcOverviewNetworks)
                .HasForeignKey(d => d.IndependentContractorLevelId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_dbo.Mst_IcOverview_Network_dbo.Mst_IndependentContractorLevel_IndependentContractorLevelId");

            entity.HasOne(d => d.MarketingCompany).WithMany(p => p.MstIcOverviewNetworks)
                .HasForeignKey(d => d.MarketingCompanyId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_dbo.Mst_IcOverview_Network_dbo.Mst_MarketingCompany_MarketingCompanyId");
        });

        modelBuilder.Entity<MstIndependentContractor>(entity =>
        {
            entity.HasKey(e => e.IndependentContractorId);

            entity.ToTable("Mst_IndependentContractor");

            entity.HasIndex(e => e.BadgeNo, "IX_BadgeNo");

            entity.HasIndex(e => e.IndependentContractorLevelId, "IX_IndependentContractorLevelId");

            entity.HasIndex(e => e.Status, "IX_IndependentContractor_Status ");

            entity.HasIndex(e => e.MarketingCompanyId, "IX_MarketingCompanyId");

            entity.HasIndex(e => e.OriginalIndependentContractorId, "IX_OriginalIndependentContractorId");

            entity.HasIndex(e => e.RecruitmentCandidateId, "IX_RecruitmentCandidateId");

            entity.HasIndex(e => new { e.IsDeleted, e.LastDeactivateDate }, "idx_IndependentContractor");

            entity.HasIndex(e => new { e.IsDeleted, e.IsSuspended }, "idx_IndependentContractor_suspended");

            entity.Property(e => e.AddressCity).HasMaxLength(80);
            entity.Property(e => e.AddressCountry).HasMaxLength(30);
            entity.Property(e => e.AddressLine1).HasMaxLength(150);
            entity.Property(e => e.AddressLine2).HasMaxLength(150);
            entity.Property(e => e.AddressLine3).HasMaxLength(150);
            entity.Property(e => e.AddressPostCode).HasMaxLength(20);
            entity.Property(e => e.AddressState).HasMaxLength(100);
            entity.Property(e => e.AdvertisementTitle).HasMaxLength(50);
            entity.Property(e => e.AgreementSignedDate).HasColumnType("datetime");
            entity.Property(e => e.AppPassword).HasMaxLength(10);
            entity.Property(e => e.BadgeNo)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.BankAccountName).HasMaxLength(100);
            entity.Property(e => e.BankAccountNo).HasMaxLength(50);
            entity.Property(e => e.BankBranch).HasMaxLength(200);
            entity.Property(e => e.BankCountryCode)
                .HasMaxLength(200)
                .IsUnicode(false);
            entity.Property(e => e.BankName).HasMaxLength(200);
            entity.Property(e => e.BankSwiftCode).HasMaxLength(50);
            entity.Property(e => e.Batype)
                .HasMaxLength(10)
                .HasColumnName("BAType");
            entity.Property(e => e.Beneficiary1).HasMaxLength(150);
            entity.Property(e => e.Beneficiary2).HasMaxLength(150);
            entity.Property(e => e.BirthPlace).HasMaxLength(50);
            entity.Property(e => e.BondLimit).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.BondPercentage).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.DateFirstOnField).HasColumnType("datetime");
            entity.Property(e => e.Dob).HasColumnType("datetime");
            entity.Property(e => e.EducationLevel).HasMaxLength(50);
            entity.Property(e => e.EffectiveAdvancementDate).HasColumnType("datetime");
            entity.Property(e => e.Email).HasMaxLength(150);
            entity.Property(e => e.EmergencyContactPerson).HasMaxLength(150);
            entity.Property(e => e.EmergencyContactPhoneNumber).HasMaxLength(20);
            entity.Property(e => e.EmergencyContactRelationship).HasMaxLength(20);
            entity.Property(e => e.FirstAttemptScore).HasMaxLength(50);
            entity.Property(e => e.FirstAttemptSubDate).HasColumnType("datetime");
            entity.Property(e => e.FirstName)
                .IsRequired()
                .HasMaxLength(100);
            entity.Property(e => e.Gender).HasMaxLength(6);
            entity.Property(e => e.Ic).HasMaxLength(30);
            entity.Property(e => e.Icsavings)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("ICSavings");
            entity.Property(e => e.IsQrenabled).HasColumnName("IsQREnabled");
            entity.Property(e => e.LastDeactivateDate).HasColumnType("datetime");
            entity.Property(e => e.LastName).HasMaxLength(100);
            entity.Property(e => e.LastSalesSubmissionDate).HasColumnType("datetime");
            entity.Property(e => e.LocalFirstName).HasMaxLength(255);
            entity.Property(e => e.LocalLastName).HasMaxLength(50);
            entity.Property(e => e.MaritalStatus).HasMaxLength(50);
            entity.Property(e => e.MiddleName).HasMaxLength(100);
            entity.Property(e => e.MobileNumber).HasMaxLength(50);
            entity.Property(e => e.Nationality)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.Nickname).HasMaxLength(100);
            entity.Property(e => e.OriginalBadgeNo).HasMaxLength(50);
            entity.Property(e => e.OverridesSavings).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.PassportExpiredDate).HasColumnType("datetime");
            entity.Property(e => e.PassportIssueCountry).HasMaxLength(50);
            entity.Property(e => e.PassportIssueDate).HasColumnType("datetime");
            entity.Property(e => e.PassportName).HasMaxLength(150);
            entity.Property(e => e.PassportNo).HasMaxLength(30);
            entity.Property(e => e.PaymentSchema).HasMaxLength(50);
            entity.Property(e => e.PermanentAddress).HasMaxLength(255);
            entity.Property(e => e.PhoneNumber).HasMaxLength(50);
            entity.Property(e => e.RecruiterBadgeNoOrName).HasMaxLength(100);
            entity.Property(e => e.RecruitmentSource).HasMaxLength(50);
            entity.Property(e => e.RecruitmentSubSource).HasMaxLength(50);
            entity.Property(e => e.RecruitmentType).HasMaxLength(25);
            entity.Property(e => e.ReportBadgeNo).HasMaxLength(50);
            entity.Property(e => e.ReturnMaterialRemarks).HasMaxLength(255);
            entity.Property(e => e.SalesBranch).HasMaxLength(50);
            entity.Property(e => e.SecondAttemptScore).HasMaxLength(50);
            entity.Property(e => e.SecondAttemptSubDate).HasColumnType("datetime");
            entity.Property(e => e.StartDate).HasColumnType("datetime");
            entity.Property(e => e.Status)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.TaxNumber).HasMaxLength(500);
            entity.Property(e => e.TeamName).HasMaxLength(50);
            entity.Property(e => e.TransferFromId)
                .HasMaxLength(10)
                .HasDefaultValueSql("(NULL)")
                .HasColumnName("TransferFromID");
            entity.Property(e => e.TransferLatestId)
                .HasMaxLength(10)
                .HasDefaultValueSql("(NULL)")
                .HasColumnName("TransferLatestID");
            entity.Property(e => e.TransferToId)
                .HasMaxLength(10)
                .HasDefaultValueSql("(NULL)")
                .HasColumnName("TransferToID");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.IndependentContractorLevel).WithMany(p => p.MstIndependentContractors)
                .HasForeignKey(d => d.IndependentContractorLevelId)
                .HasConstraintName("FK_dbo.Mst_IndependentContractor_dbo.Mst_IndependentContractorLevel_IndependentContractorLevelId");

            entity.HasOne(d => d.MarketingCompany).WithMany(p => p.MstIndependentContractors)
                .HasForeignKey(d => d.MarketingCompanyId)
                .HasConstraintName("FK_dbo.Mst_IndependentContractor_dbo.Mst_MarketingCompany_MarketingCompanyId");

            entity.HasOne(d => d.OriginalIndependentContractor).WithMany(p => p.InverseOriginalIndependentContractor)
                .HasForeignKey(d => d.OriginalIndependentContractorId)
                .HasConstraintName("FK_dbo.Mst_IndependentContractor_dbo.Mst_IndependentContractor_OriginalIndependentContractorId");

            entity.HasOne(d => d.RecruitmentCandidate).WithMany(p => p.MstIndependentContractors)
                .HasForeignKey(d => d.RecruitmentCandidateId)
                .HasConstraintName("FK_dbo.Mst_IndependentContractor_dbo.Mst_RecruitmentCandidate_RecruitmentCandidateId");
        });

        modelBuilder.Entity<MstIndependentContractorArchive>(entity =>
        {
            entity.HasKey(e => e.IndependentContractorArchiveId);

            entity.ToTable("Mst_IndependentContractor_Archive");

            entity.Property(e => e.AddressCity).HasMaxLength(80);
            entity.Property(e => e.AddressCountry).HasMaxLength(30);
            entity.Property(e => e.AddressLine1).HasMaxLength(150);
            entity.Property(e => e.AddressLine2).HasMaxLength(150);
            entity.Property(e => e.AddressLine3).HasMaxLength(150);
            entity.Property(e => e.AddressPostCode).HasMaxLength(20);
            entity.Property(e => e.AddressState).HasMaxLength(100);
            entity.Property(e => e.AdvertisementTitle).HasMaxLength(50);
            entity.Property(e => e.AgreementSignedDate).HasColumnType("datetime");
            entity.Property(e => e.AppPassword).HasMaxLength(10);
            entity.Property(e => e.BadgeNo).HasMaxLength(50);
            entity.Property(e => e.BankAccountName).HasMaxLength(100);
            entity.Property(e => e.BankAccountNo).HasMaxLength(50);
            entity.Property(e => e.BankBranch).HasMaxLength(200);
            entity.Property(e => e.BankCountryCode)
                .HasMaxLength(200)
                .IsUnicode(false);
            entity.Property(e => e.BankName).HasMaxLength(200);
            entity.Property(e => e.BankSwiftCode).HasMaxLength(50);
            entity.Property(e => e.Batype)
                .HasMaxLength(10)
                .HasColumnName("BAType");
            entity.Property(e => e.Beneficiary1).HasMaxLength(150);
            entity.Property(e => e.Beneficiary2).HasMaxLength(150);
            entity.Property(e => e.BirthPlace).HasMaxLength(50);
            entity.Property(e => e.BondLimit).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.BondPercentage).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.DateFirstOnField).HasColumnType("datetime");
            entity.Property(e => e.Dob).HasColumnType("datetime");
            entity.Property(e => e.EducationLevel).HasMaxLength(50);
            entity.Property(e => e.EffectiveAdvancementDate).HasColumnType("datetime");
            entity.Property(e => e.Email).HasMaxLength(150);
            entity.Property(e => e.EmergencyContactPerson).HasMaxLength(150);
            entity.Property(e => e.EmergencyContactPhoneNumber).HasMaxLength(20);
            entity.Property(e => e.EmergencyContactRelationship).HasMaxLength(20);
            entity.Property(e => e.FirstAttemptScore).HasMaxLength(50);
            entity.Property(e => e.FirstAttemptSubDate).HasColumnType("datetime");
            entity.Property(e => e.FirstName)
                .IsRequired()
                .HasMaxLength(100);
            entity.Property(e => e.Gender).HasMaxLength(6);
            entity.Property(e => e.Ic).HasMaxLength(30);
            entity.Property(e => e.IsQrenabled).HasColumnName("IsQREnabled");
            entity.Property(e => e.LastDeactivateDate).HasColumnType("datetime");
            entity.Property(e => e.LastName).HasMaxLength(100);
            entity.Property(e => e.LastSalesSubmissionDate).HasColumnType("datetime");
            entity.Property(e => e.LocalFirstName).HasMaxLength(255);
            entity.Property(e => e.LocalLastName).HasMaxLength(50);
            entity.Property(e => e.MaritalStatus).HasMaxLength(50);
            entity.Property(e => e.MiddleName).HasMaxLength(100);
            entity.Property(e => e.MobileNumber).HasMaxLength(50);
            entity.Property(e => e.Nationality)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.Nickname).HasMaxLength(100);
            entity.Property(e => e.OriginalBadgeNo).HasMaxLength(50);
            entity.Property(e => e.PassportExpiredDate).HasColumnType("datetime");
            entity.Property(e => e.PassportIssueCountry).HasMaxLength(50);
            entity.Property(e => e.PassportIssueDate).HasColumnType("datetime");
            entity.Property(e => e.PassportName).HasMaxLength(150);
            entity.Property(e => e.PassportNo).HasMaxLength(30);
            entity.Property(e => e.PaymentSchema).HasMaxLength(50);
            entity.Property(e => e.PermanentAddress).HasMaxLength(255);
            entity.Property(e => e.PhoneNumber).HasMaxLength(50);
            entity.Property(e => e.RecruiterBadgeNoOrName).HasMaxLength(100);
            entity.Property(e => e.RecruitmentSource).HasMaxLength(50);
            entity.Property(e => e.RecruitmentType).HasMaxLength(25);
            entity.Property(e => e.ReportBadgeNo).HasMaxLength(50);
            entity.Property(e => e.ReturnMaterialRemarks).HasMaxLength(255);
            entity.Property(e => e.SalesBranch).HasMaxLength(50);
            entity.Property(e => e.SecondAttemptScore).HasMaxLength(50);
            entity.Property(e => e.SecondAttemptSubDate).HasColumnType("datetime");
            entity.Property(e => e.StartDate).HasColumnType("datetime");
            entity.Property(e => e.Status).IsRequired();
            entity.Property(e => e.TaxNumber).HasMaxLength(500);
            entity.Property(e => e.TeamName).HasMaxLength(50);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<MstIndependentContractorAssignment>(entity =>
        {
            entity.HasKey(e => e.IndependentContractorAssigmentId).HasName("PK_dbo.Mst_IndependentContractor_Assignment");

            entity.ToTable("Mst_IndependentContractor_Assignment");

            entity.HasIndex(e => new { e.IsDeleted, e.EndDate }, "<IX_IsDeleted_CampaignId_StartDate");

            entity.HasIndex(e => new { e.IsDeleted, e.EndDate }, "<Name of Missing Index, sysname,>");

            entity.HasIndex(e => e.CampaignId, "IX_CampaignId");

            entity.HasIndex(e => e.IndependentContractorId, "IX_IndependentContractorId");

            entity.HasIndex(e => e.IsDeleted, "IX_IsDeleted_CampaignId_StartDate >");

            entity.HasIndex(e => e.IsDeleted, "IX_IsDeleted_CampaignId_StartDate2 >");

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.EndDate).HasColumnType("datetime");
            entity.Property(e => e.Remark).HasMaxLength(255);
            entity.Property(e => e.StartDate).HasColumnType("datetime");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.Campaign).WithMany(p => p.MstIndependentContractorAssignments)
                .HasForeignKey(d => d.CampaignId)
                .HasConstraintName("FK_dbo.Mst_IndependentContractor_Assignment_dbo.Mst_Campaign_CampaignId");

            entity.HasOne(d => d.IndependentContractor).WithMany(p => p.MstIndependentContractorAssignments)
                .HasForeignKey(d => d.IndependentContractorId)
                .HasConstraintName("FK_dbo.Mst_IndependentContractor_Assignment_dbo.Mst_IndependentContractor_IndependentContractorId");
        });

        modelBuilder.Entity<MstIndependentContractorBadgeCard>(entity =>
        {
            entity.HasKey(e => e.IndependentContractorBadgeCardId).HasName("PK_dbo.Mst_IndependentContractor_BadgeCard");

            entity.ToTable("Mst_IndependentContractor_BadgeCard");

            entity.HasIndex(e => e.CampaignId, "IX_CampaignId");

            entity.HasIndex(e => e.IndependentContractorId, "IX_IndependentContractorId");

            entity.Property(e => e.BadgeType).IsRequired();
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.ExpiredDate).HasColumnType("datetime");
            entity.Property(e => e.IssueDate).HasColumnType("datetime");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.Campaign).WithMany(p => p.MstIndependentContractorBadgeCards)
                .HasForeignKey(d => d.CampaignId)
                .HasConstraintName("FK_dbo.Mst_IndependentContractor_BadgeCard_dbo.Mst_Campaign_CampaignId");

            entity.HasOne(d => d.IndependentContractor).WithMany(p => p.MstIndependentContractorBadgeCards)
                .HasForeignKey(d => d.IndependentContractorId)
                .HasConstraintName("FK_dbo.Mst_IndependentContractor_BadgeCard_dbo.Mst_IndependentContractor_IndependentContractorId");
        });

        modelBuilder.Entity<MstIndependentContractorBainfoWeekending>(entity =>
        {
            entity.HasKey(e => e.IndependentContractorBainfoId).HasName("PK_dbo.Mst_IndependentContractor_BAInfo_Weekending");

            entity.ToTable("Mst_IndependentContractor_BAInfo_Weekending");

            entity.Property(e => e.IndependentContractorBainfoId).HasColumnName("IndependentContractorBAInfoId");
            entity.Property(e => e.Batype)
                .HasMaxLength(10)
                .HasColumnName("BAType");
            entity.Property(e => e.CreatedBy).HasMaxLength(100);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.ReportBadgeNo).HasMaxLength(100);
            entity.Property(e => e.Status).HasMaxLength(10);
            entity.Property(e => e.UpdatedBy).HasMaxLength(100);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.IndependentContractor).WithMany(p => p.MstIndependentContractorBainfoWeekendings)
                .HasForeignKey(d => d.IndependentContractorId)
                .HasConstraintName("FK_IndependentContractor");

            entity.HasOne(d => d.IndependentContractorLevel).WithMany(p => p.MstIndependentContractorBainfoWeekendings)
                .HasForeignKey(d => d.IndependentContractorLevelId)
                .HasConstraintName("FK_IndependentContractorLevelId");
        });

        modelBuilder.Entity<MstIndependentContractorBranchOut>(entity =>
        {
            entity.HasKey(e => e.IndependentContractorBranchOutId).HasName("PK_dbo.Mst_IndependentContractor_BranchOut");

            entity.ToTable("Mst_IndependentContractor_BranchOut");

            entity.HasIndex(e => e.IndependentContractorId, "IX_IndependentContractorId");

            entity.HasIndex(e => e.IndependentContractorLevelId, "IX_IndependentContractorLevelId");

            entity.HasIndex(e => e.MarketingCompanyId, "IX_MarketingCompanyId");

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.CurrentCompanyReactivateDate).HasColumnType("datetime");
            entity.Property(e => e.DeactivateDate).HasColumnType("datetime");
            entity.Property(e => e.GroupRefId).IsRequired();
            entity.Property(e => e.NewBadgeNo).IsRequired();
            entity.Property(e => e.NewCompanyStartDate).HasColumnType("datetime");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.IndependentContractor).WithMany(p => p.MstIndependentContractorBranchOuts)
                .HasForeignKey(d => d.IndependentContractorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_dbo.Mst_IndependentContractor_BranchOut_dbo.Mst_IndependentContractor_IndependentContractorId");

            entity.HasOne(d => d.IndependentContractorLevel).WithMany(p => p.MstIndependentContractorBranchOuts)
                .HasForeignKey(d => d.IndependentContractorLevelId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_dbo.Mst_IndependentContractor_BranchOut_dbo.Mst_IndependentContractorLevel_IndependentContractorLevelId");

            entity.HasOne(d => d.MarketingCompany).WithMany(p => p.MstIndependentContractorBranchOuts)
                .HasForeignKey(d => d.MarketingCompanyId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_dbo.Mst_IndependentContractor_BranchOut_dbo.Mst_MarketingCompany_MarketingCompanyId");
        });

        modelBuilder.Entity<MstIndependentContractorCheckIn>(entity =>
        {
            entity.HasKey(e => e.CheckInId).HasName("PK_dbo.Mst_IndependentContractor_CheckIn");

            entity.ToTable("Mst_IndependentContractor_CheckIn");

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Location)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.Session)
                .IsRequired()
                .HasMaxLength(10);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.Campaign).WithMany(p => p.MstIndependentContractorCheckIns)
                .HasForeignKey(d => d.CampaignId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Mst_Indep__Campa__7D2E8C24");

            entity.HasOne(d => d.Channel).WithMany(p => p.MstIndependentContractorCheckIns)
                .HasForeignKey(d => d.ChannelId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Mst_Indep__Chann__7E22B05D");
        });

        modelBuilder.Entity<MstIndependentContractorCompliance>(entity =>
        {
            entity.HasKey(e => e.IndependentContractorComplianceId).HasName("PK_dbo.Mst_IndependentContractor_Compliance");

            entity.ToTable("Mst_IndependentContractor_Compliance");

            entity.HasIndex(e => e.ComplianceChecklistId, "IX_ComplianceChecklistId");

            entity.HasIndex(e => e.IndependentContractorId, "IX_IndependentContractorId");

            entity.Property(e => e.ComplianceEffectiveDate).HasColumnType("datetime");
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
            entity.Property(e => e.UploadedBy).HasMaxLength(50);
            entity.Property(e => e.UploadedDate).HasColumnType("datetime");

            entity.HasOne(d => d.ComplianceChecklist).WithMany(p => p.MstIndependentContractorCompliances)
                .HasForeignKey(d => d.ComplianceChecklistId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_dbo.Mst_IndependentContractor_Compliance_dbo.Mst_ComplianceChecklist_ComplianceChecklistId");

            entity.HasOne(d => d.IndependentContractor).WithMany(p => p.MstIndependentContractorCompliances)
                .HasForeignKey(d => d.IndependentContractorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_dbo.Mst_IndependentContractor_Compliance_dbo.Mst_IndependentContractor_IndependentContractorId");
        });

        modelBuilder.Entity<MstIndependentContractorComplianceArchive>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("Mst_IndependentContractor_Compliance_Archive");

            entity.Property(e => e.ComplianceEffectiveDate).HasColumnType("datetime");
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
            entity.Property(e => e.UploadedBy).HasMaxLength(50);
            entity.Property(e => e.UploadedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<MstIndependentContractorEventHistory>(entity =>
        {
            entity.HasKey(e => e.IndependentContractorEventHistoryId).HasName("PK_dbo.Mst_IndependentContractor_EventHistory");

            entity.ToTable("Mst_IndependentContractor_EventHistory");

            entity.HasIndex(e => e.IndependentContractorId, "IX_IndependentContractorId");

            entity.HasIndex(e => e.IndependentContractorLevelId, "IX_IndependentContractorLevelId");

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.EventName).IsRequired();
            entity.Property(e => e.Month).IsRequired();
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.IndependentContractor).WithMany(p => p.MstIndependentContractorEventHistories)
                .HasForeignKey(d => d.IndependentContractorId)
                .HasConstraintName("FK_dbo.Mst_IndependentContractor_EventHistory_dbo.Mst_IndependentContractor_IndependentContractorId");

            entity.HasOne(d => d.IndependentContractorLevel).WithMany(p => p.MstIndependentContractorEventHistories)
                .HasForeignKey(d => d.IndependentContractorLevelId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_dbo.Mst_IndependentContractor_EventHistory_dbo.Mst_IndependentContractorLevel_IndependentContractorLevelId");
        });

        modelBuilder.Entity<MstIndependentContractorLevel>(entity =>
        {
            entity.HasKey(e => e.IndependentContractorLevelId);

            entity.ToTable("Mst_IndependentContractorLevel");

            entity.HasIndex(e => e.LevelCode, "IX_LevelCode").IsUnique();

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Level)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.LevelCode)
                .IsRequired()
                .HasMaxLength(10);
            entity.Property(e => e.ParentLevel).HasMaxLength(50);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<MstIndependentContractorMovement>(entity =>
        {
            entity.HasKey(e => e.IndependentContractorMovementId);

            entity.ToTable("Mst_IndependentContractor_Movement");

            entity.HasIndex(e => new { e.HasExecuted, e.IsDeleted }, "<IX_IndependentContractor_Movement_IndependentContractorId_LevelIDDate>");

            entity.HasIndex(e => e.IndependentContractorId, "IX_IndependentContractorId");

            entity.HasIndex(e => e.IndependentContractorLevelId, "IX_IndependentContractorLevelId");

            entity.HasIndex(e => e.MovementTypeId, "IX_MovementTypeId");

            entity.HasIndex(e => new { e.IsDeleted, e.IndependentContractorLevelId }, "idx_IndependentContractor_MovementEffectiveDate");

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Description).IsRequired();
            entity.Property(e => e.EffectiveDate).HasColumnType("datetime");
            entity.Property(e => e.PromotionDemotionDate).HasColumnType("datetime");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.IndependentContractor).WithMany(p => p.MstIndependentContractorMovements)
                .HasForeignKey(d => d.IndependentContractorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_dbo.Mst_IndependentContractor_Movement_dbo.Mst_IndependentContractor_IndependentContractorId");

            entity.HasOne(d => d.IndependentContractorLevel).WithMany(p => p.MstIndependentContractorMovements)
                .HasForeignKey(d => d.IndependentContractorLevelId)
                .HasConstraintName("FK_dbo.Mst_IndependentContractor_Movement_dbo.Mst_IndependentContractorLevel_IndependentContractorLevelId");

            entity.HasOne(d => d.MovementType).WithMany(p => p.MstIndependentContractorMovements)
                .HasForeignKey(d => d.MovementTypeId)
                .HasConstraintName("FK_dbo.Mst_IndependentContractor_Movement_dbo.Mst_MovementType_MovementTypeId");
        });

        modelBuilder.Entity<MstIndependentContractorPayableTraining>(entity =>
        {
            entity.HasKey(e => e.IndependentContractorPayableTrainingId).HasName("PK_dbo.Mst_IndependentContractor_PayableTraining");

            entity.ToTable("Mst_IndependentContractor_PayableTraining");

            entity.HasIndex(e => e.CampaignId, "IX_CampaignId");

            entity.HasIndex(e => e.IndependentContractorId, "IX_IndependentContractorId");

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.EndDate).HasColumnType("datetime");
            entity.Property(e => e.StartDate).HasColumnType("datetime");
            entity.Property(e => e.TrainingFee).IsRequired();
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.Campaign).WithMany(p => p.MstIndependentContractorPayableTrainings)
                .HasForeignKey(d => d.CampaignId)
                .HasConstraintName("FK_dbo.Mst_IndependentContractor_PayableTraining_dbo.Mst_Campaign_CampaignId");

            entity.HasOne(d => d.IndependentContractor).WithMany(p => p.MstIndependentContractorPayableTrainings)
                .HasForeignKey(d => d.IndependentContractorId)
                .HasConstraintName("FK_dbo.Mst_IndependentContractor_PayableTraining_dbo.Mst_IndependentContractor_IndependentContractorId");
        });

        modelBuilder.Entity<MstIndependentContractorReportingNoChange>(entity =>
        {
            entity.HasKey(e => e.IndependentContractorReportingNoChangesId);

            entity.ToTable("Mst_IndependentContractor_ReportingNoChanges");

            entity.HasIndex(e => e.IndependentContractorBranchOutId, "IX_IndependentContractorBranchOutId");

            entity.HasIndex(e => e.IndependentContractorId, "IX_IndependentContractorId");

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.EffectiveDate).HasColumnType("datetime");
            entity.Property(e => e.EndDate).HasColumnType("datetime");
            entity.Property(e => e.NewReportingBadgeNo).IsRequired();
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.IndependentContractorBranchOut).WithMany(p => p.MstIndependentContractorReportingNoChanges)
                .HasForeignKey(d => d.IndependentContractorBranchOutId)
                .HasConstraintName("FK_dbo.Mst_IndependentContractor_ReportingNoChanges_dbo.Mst_IndependentContractor_BranchOut_IndependentContractorBranchOutId");

            entity.HasOne(d => d.IndependentContractor).WithMany(p => p.MstIndependentContractorReportingNoChanges)
                .HasForeignKey(d => d.IndependentContractorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_dbo.Mst_IndependentContractor_ReportingNoChanges_dbo.Mst_IndependentContractor_IndependentContractorId");
        });

        modelBuilder.Entity<MstIndependentContractorSaving>(entity =>
        {
            entity.HasKey(e => e.IndependentContractorSavingId).HasName("PK_dbo.Mst_IndependentContractor_Saving");

            entity.ToTable("Mst_IndependentContractor_Saving");

            entity.HasIndex(e => e.IndependentContractorId, "IX_IndependentContractorId");

            entity.Property(e => e.Amount).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.AmountType)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.EndDate).HasColumnType("datetime");
            entity.Property(e => e.MaxLimit).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.SavingType)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.StartDate).HasColumnType("datetime");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.IndependentContractor).WithMany(p => p.MstIndependentContractorSavings)
                .HasForeignKey(d => d.IndependentContractorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_dbo.Mst_IndependentContractor_Saving_dbo.Mst_IndependentContractor_IndependentContractorId");
        });

        modelBuilder.Entity<MstIndependentContractorSuspension>(entity =>
        {
            entity.HasKey(e => e.IndependentContractorSuspensionId);

            entity.ToTable("Mst_IndependentContractor_Suspension");

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Description).IsRequired();
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<MstIndependentContractorSuspensionReason>(entity =>
        {
            entity.HasKey(e => e.SuspensionReasonId).HasName("PK_dbo.Mst_IndependentContractor_SuspensionReason");

            entity.ToTable("Mst_IndependentContractor_SuspensionReason");

            entity.Property(e => e.CountryCode)
                .IsRequired()
                .HasMaxLength(10);
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Description)
                .IsRequired()
                .HasMaxLength(300);
        });

        modelBuilder.Entity<MstIndependentContractorTraining>(entity =>
        {
            entity.HasKey(e => e.IndependentContractorTrainingId);

            entity.ToTable("Mst_IndependentContractor_Training");

            entity.HasIndex(e => e.CampaignId, "IX_CampaignId");

            entity.HasIndex(e => e.IndependentContractorId, "IX_IndependentContractorId");

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.EndDate).HasColumnType("datetime");
            entity.Property(e => e.StartDate).HasColumnType("datetime");
            entity.Property(e => e.TrainingFee).IsRequired();
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.Campaign).WithMany(p => p.MstIndependentContractorTrainings)
                .HasForeignKey(d => d.CampaignId)
                .HasConstraintName("FK_dbo.Mst_IndependentContractor_Training_dbo.Mst_Campaign_CampaignId");

            entity.HasOne(d => d.IndependentContractor).WithMany(p => p.MstIndependentContractorTrainings)
                .HasForeignKey(d => d.IndependentContractorId)
                .HasConstraintName("FK_dbo.Mst_IndependentContractor_Training_dbo.Mst_IndependentContractor_IndependentContractorId");
        });

        modelBuilder.Entity<MstLocalization>(entity =>
        {
            entity.HasKey(e => e.LocalizationId).HasName("PK_dbo.Mst_Localization");

            entity.ToTable("Mst_Localization");

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Endescription)
                .IsRequired()
                .HasMaxLength(2000)
                .HasColumnName("ENDescription");
            entity.Property(e => e.Hkdescription)
                .HasMaxLength(2000)
                .HasColumnName("HKDescription");
            entity.Property(e => e.Iddescription)
                .HasMaxLength(2500)
                .HasColumnName("IDDescription");
            entity.Property(e => e.Krdescription)
                .HasMaxLength(2000)
                .HasColumnName("KRDescription");
            entity.Property(e => e.Mydescription)
                .HasMaxLength(2000)
                .HasColumnName("MYDescription");
            entity.Property(e => e.Page).HasMaxLength(150);
            entity.Property(e => e.Phdescription)
                .HasMaxLength(2000)
                .HasColumnName("PHDescription");
            entity.Property(e => e.Remark).HasMaxLength(255);
            entity.Property(e => e.TextTag)
                .IsRequired()
                .HasMaxLength(100);
            entity.Property(e => e.TextType)
                .IsRequired()
                .HasMaxLength(100);
            entity.Property(e => e.Thdescription)
                .HasMaxLength(2000)
                .HasColumnName("THDescription");
            entity.Property(e => e.Twdescription)
                .HasMaxLength(2000)
                .HasColumnName("TWDescription");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<MstMarketingCompany>(entity =>
        {
            entity.HasKey(e => e.MarketingCompanyId);

            entity.ToTable("Mst_MarketingCompany");

            entity.Property(e => e.BankAccountNo).HasMaxLength(50);
            entity.Property(e => e.BankName).HasMaxLength(200);
            entity.Property(e => e.BgColor)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.Code)
                .IsRequired()
                .HasMaxLength(10);
            entity.Property(e => e.CountryCode)
                .IsRequired()
                .HasMaxLength(10);
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.MarketingCompanyType).HasMaxLength(50);
            entity.Property(e => e.Name)
                .IsRequired()
                .HasMaxLength(150);
            entity.Property(e => e.Province).HasMaxLength(50);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<MstMarketingCompanyBranch>(entity =>
        {
            entity.HasKey(e => e.MarketingCompanyBranchId).HasName("PK_dbo.Mst_MarketingCompany_Branch");

            entity.ToTable("Mst_MarketingCompany_Branch");

            entity.HasIndex(e => e.MarketingCompanyId, "IX_MarketingCompanyId");

            entity.Property(e => e.City).HasMaxLength(50);
            entity.Property(e => e.Country).HasMaxLength(50);
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.FaxNo).HasMaxLength(50);
            entity.Property(e => e.Postcode).HasMaxLength(50);
            entity.Property(e => e.State).HasMaxLength(50);
            entity.Property(e => e.TelephoneNo).HasMaxLength(50);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.MarketingCompany).WithMany(p => p.MstMarketingCompanyBranches)
                .HasForeignKey(d => d.MarketingCompanyId)
                .HasConstraintName("FK_dbo.Mst_MarketingCompany_Branch_dbo.Mst_MarketingCompany_MarketingCompanyId");
        });

        modelBuilder.Entity<MstMarketingCompanyCampaign>(entity =>
        {
            entity.HasKey(e => e.MarketingCompanyCampaignId).HasName("PK_dbo.Mst_MarketingCompany_Campaign");

            entity.ToTable("Mst_MarketingCompany_Campaign");

            entity.HasIndex(e => e.CampaignId, "IX_CampaignId");

            entity.HasIndex(e => e.MarketingCompanyId, "IX_MarketingCompanyId");

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.EndDate).HasColumnType("datetime");
            entity.Property(e => e.StartDate).HasColumnType("datetime");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.Campaign).WithMany(p => p.MstMarketingCompanyCampaigns)
                .HasForeignKey(d => d.CampaignId)
                .HasConstraintName("FK_dbo.Mst_MarketingCompany_Campaign_dbo.Mst_Campaign_CampaignId");

            entity.HasOne(d => d.MarketingCompany).WithMany(p => p.MstMarketingCompanyCampaigns)
                .HasForeignKey(d => d.MarketingCompanyId)
                .HasConstraintName("FK_dbo.Mst_MarketingCompany_Campaign_dbo.Mst_MarketingCompany_MarketingCompanyId");
        });

        modelBuilder.Entity<MstMarketingCompanyEmail>(entity =>
        {
            entity.HasKey(e => e.MarketingCompanyEmailId);

            entity.ToTable("Mst_MarketingCompanyEmail");

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.EmailProvider).HasMaxLength(100);
            entity.Property(e => e.EnableSsl)
                .HasDefaultValue(true)
                .HasColumnName("EnableSSL");
            entity.Property(e => e.Password)
                .IsRequired()
                .HasMaxLength(100);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<MstMarketingCompanyStaff>(entity =>
        {
            entity.HasKey(e => e.MarketingCompanyStaffId).HasName("PK_dbo.Mst_MarketingCompany_Staff");

            entity.ToTable("Mst_MarketingCompany_Staff");

            entity.HasIndex(e => e.MarketingCompanyId, "IX_MarketingCompanyId");

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.Name).HasMaxLength(255);
            entity.Property(e => e.PhoneNumber).HasMaxLength(50);
            entity.Property(e => e.Postion).HasMaxLength(50);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.MarketingCompany).WithMany(p => p.MstMarketingCompanyStaffs)
                .HasForeignKey(d => d.MarketingCompanyId)
                .HasConstraintName("FK_dbo.Mst_MarketingCompany_Staff_dbo.Mst_MarketingCompany_MarketingCompanyId");
        });

        modelBuilder.Entity<MstMasterCode>(entity =>
        {
            entity.ToTable("Mst_MasterCode");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CodeDescription).HasMaxLength(100);
            entity.Property(e => e.CodeIcon).HasMaxLength(50);
            entity.Property(e => e.CodeId).HasMaxLength(50);
            entity.Property(e => e.CodeName)
                .IsRequired()
                .HasMaxLength(100);
            entity.Property(e => e.CodeType)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.CreatedBy)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.RefBooleanDescription).HasMaxLength(256);
            entity.Property(e => e.RefDecimal).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.RefDecimalDescription).HasMaxLength(256);
            entity.Property(e => e.RefMessage).HasMaxLength(256);
            entity.Property(e => e.RefString1).HasMaxLength(256);
            entity.Property(e => e.RefString1Description).HasMaxLength(256);
            entity.Property(e => e.RefString2).HasMaxLength(256);
            entity.Property(e => e.RefString2Description).HasMaxLength(256);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<MstMcbatypeMapping>(entity =>
        {
            entity.ToTable("MST_MCBATypeMapping");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.Batype).HasColumnName("BAType");
            entity.Property(e => e.Mctype).HasColumnName("MCType");
        });

        modelBuilder.Entity<MstMcexclusion>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("Mst_MCExclusion");

            entity.Property(e => e.ExclusionCode)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Id)
                .ValueGeneratedOnAdd()
                .HasColumnName("ID");
        });

        modelBuilder.Entity<MstMenu>(entity =>
        {
            entity.HasKey(e => e.MenuId);

            entity.ToTable("Mst_Menu");

            entity.Property(e => e.CreatedBy)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.MenuCode)
                .IsRequired()
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.MenuDescription).HasMaxLength(255);
            entity.Property(e => e.MenuName).HasMaxLength(255);
            entity.Property(e => e.ParentMenuCode)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Path).HasMaxLength(4000);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<MstMovementType>(entity =>
        {
            entity.HasKey(e => e.MovementTypeId).HasName("PK_dbo.Mst_MovementType");

            entity.ToTable("Mst_MovementType");

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.MovementCode)
                .IsRequired()
                .HasMaxLength(5);
            entity.Property(e => e.Type)
                .IsRequired()
                .HasMaxLength(300);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<MstPrCustomBankInfo>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("MST_PR_CustomBankInfo");

            entity.Property(e => e.BadgeNo).HasMaxLength(10);
            entity.Property(e => e.BankAccountName).HasMaxLength(200);
            entity.Property(e => e.BankAccountNo).HasMaxLength(200);
            entity.Property(e => e.BankName).HasMaxLength(200);
            entity.Property(e => e.CountryCode).HasMaxLength(2);
            entity.Property(e => e.Icno)
                .HasMaxLength(200)
                .HasColumnName("ICNo");
            entity.Property(e => e.Mccode)
                .HasMaxLength(2)
                .HasColumnName("MCCode");
        });

        modelBuilder.Entity<MstPrMaster>(entity =>
        {
            entity.HasKey(e => e.Prid);

            entity.ToTable("MST_PR_Master");

            entity.Property(e => e.Prid).HasColumnName("PRID");
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.IndependentContractorId).HasColumnName("IndependentContractorID");
            entity.Property(e => e.RecruiterIndependentContractorId).HasColumnName("RecruiterIndependentContractorID");
            entity.Property(e => e.RecruiterIndependentContractorLevelId).HasColumnName("RecruiterIndependentContractorLevelID");
            entity.Property(e => e.StartDateWe).HasColumnName("StartDateWE");
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<MstPrPayout>(entity =>
        {
            entity.HasKey(e => e.PayoutId);

            entity.ToTable("MST_PR_Payout");

            entity.Property(e => e.PayoutId).HasColumnName("PayoutID");
            entity.Property(e => e.Country).HasMaxLength(2);
            entity.Property(e => e.Mc)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("MC");
            entity.Property(e => e.PayoutType).HasMaxLength(50);
            entity.Property(e => e.Po)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("PO");
            entity.Property(e => e.Sw)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("SW");
        });

        modelBuilder.Entity<MstPrRoadTripLink>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("MST_PR_RoadTripLink");

            entity.Property(e => e.OriginalIndependentContractorId).HasColumnName("OriginalIndependentContractorID");
            entity.Property(e => e.RtindependentContractorId).HasColumnName("RTIndependentContractorID");
        });

        modelBuilder.Entity<MstRecruiter>(entity =>
        {
            entity.HasKey(e => e.RecruiterId).HasName("PK_dbo.Mst_Recruiter");

            entity.ToTable("Mst_Recruiter");

            entity.HasIndex(e => e.MarketingCompanyId, "IX_MarketingCompanyId");

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.FirstName)
                .IsRequired()
                .HasMaxLength(150);
            entity.Property(e => e.LastName).HasMaxLength(150);
            entity.Property(e => e.LocalFirstName).HasMaxLength(255);
            entity.Property(e => e.LocalLastName).HasMaxLength(255);
            entity.Property(e => e.MiddleName).HasMaxLength(150);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.MarketingCompany).WithMany(p => p.MstRecruiters)
                .HasForeignKey(d => d.MarketingCompanyId)
                .HasConstraintName("FK_dbo.Mst_Recruiter_dbo.Mst_MarketingCompany_MarketingCompanyId");
        });

        modelBuilder.Entity<MstRecruitmentCandidate>(entity =>
        {
            entity.HasKey(e => e.RecruitmentCandidateId).HasName("PK_dbo.Mst_RecruitmentCandidate");

            entity.ToTable("Mst_RecruitmentCandidate");

            entity.HasIndex(e => e.MarketingCompanyId, "IX_MarketingCompanyId");

            entity.Property(e => e.AccessCode)
                .IsRequired()
                .HasMaxLength(20);
            entity.Property(e => e.AddressCity).HasMaxLength(80);
            entity.Property(e => e.AddressCountry).HasMaxLength(30);
            entity.Property(e => e.AddressLine1).HasMaxLength(150);
            entity.Property(e => e.AddressLine2).HasMaxLength(150);
            entity.Property(e => e.AddressLine3).HasMaxLength(150);
            entity.Property(e => e.AddressPostCode).HasMaxLength(20);
            entity.Property(e => e.AddressState).HasMaxLength(100);
            entity.Property(e => e.AdvertisementTitle).HasMaxLength(50);
            entity.Property(e => e.BadgeNo).HasMaxLength(50);
            entity.Property(e => e.BankAccountName).HasMaxLength(100);
            entity.Property(e => e.BankAccountNo).HasMaxLength(50);
            entity.Property(e => e.BankBranch).HasMaxLength(200);
            entity.Property(e => e.BankCountryCode)
                .HasMaxLength(200)
                .IsUnicode(false);
            entity.Property(e => e.BankName).HasMaxLength(200);
            entity.Property(e => e.BankSwiftCode).HasMaxLength(50);
            entity.Property(e => e.Batype)
                .HasMaxLength(10)
                .HasColumnName("BAType");
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Dob).HasColumnType("datetime");
            entity.Property(e => e.EducationLevel).HasMaxLength(50);
            entity.Property(e => e.Email).HasMaxLength(150);
            entity.Property(e => e.EmergencyContactPerson).HasMaxLength(150);
            entity.Property(e => e.EmergencyContactPhoneNumber).HasMaxLength(20);
            entity.Property(e => e.EmergencyContactRelationship).HasMaxLength(20);
            entity.Property(e => e.FirstName)
                .IsRequired()
                .HasMaxLength(100);
            entity.Property(e => e.Gender).HasMaxLength(6);
            entity.Property(e => e.Ic).HasMaxLength(30);
            entity.Property(e => e.LastName).HasMaxLength(100);
            entity.Property(e => e.LocalFirstName).HasMaxLength(255);
            entity.Property(e => e.LocalLastName).HasMaxLength(50);
            entity.Property(e => e.MiddleName).HasMaxLength(100);
            entity.Property(e => e.Nationality).HasMaxLength(50);
            entity.Property(e => e.Nickname).HasMaxLength(100);
            entity.Property(e => e.PassportExpiredDate).HasColumnType("datetime");
            entity.Property(e => e.PassportIssueCountry).HasMaxLength(50);
            entity.Property(e => e.PassportIssueDate).HasColumnType("datetime");
            entity.Property(e => e.PassportName).HasMaxLength(150);
            entity.Property(e => e.PassportNo).HasMaxLength(30);
            entity.Property(e => e.PhoneNumber).HasMaxLength(50);
            entity.Property(e => e.RecruiterBadgeNoOrName).HasMaxLength(100);
            entity.Property(e => e.RecruitmentSource).HasMaxLength(50);
            entity.Property(e => e.RecruitmentSubSource).HasMaxLength(50);
            entity.Property(e => e.RecruitmentType).HasMaxLength(25);
            entity.Property(e => e.Status)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.TeamName).HasMaxLength(50);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.MarketingCompany).WithMany(p => p.MstRecruitmentCandidates)
                .HasForeignKey(d => d.MarketingCompanyId)
                .HasConstraintName("FK_dbo.Mst_RecruitmentCandidate_dbo.Mst_MarketingCompany_MarketingCompanyId");
        });

        modelBuilder.Entity<MstRecruitmentCandidateActivityLog>(entity =>
        {
            entity.HasKey(e => e.RecruitmentCandidateActivityLogId).HasName("PK_dbo.Mst_RecruitmentCandidate_ActivityLog");

            entity.ToTable("Mst_RecruitmentCandidate_ActivityLog");

            entity.HasIndex(e => e.MarketingCompanyBranchId, "IX_MarketingCompanyBranchId");

            entity.HasIndex(e => e.RecruitmentCandidateId, "IX_RecruitmentCandidateId");

            entity.Property(e => e.AppointmentStatus)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.ConductedBy).HasMaxLength(250);
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Description)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.NotSucceedReason).HasMaxLength(50);
            entity.Property(e => e.ScheduleEndDateTime).HasColumnType("datetime");
            entity.Property(e => e.ScheduleStartDateTime).HasColumnType("datetime");
            entity.Property(e => e.Stage)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.UnsuitableStatus).HasMaxLength(50);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.MarketingCompanyBranch).WithMany(p => p.MstRecruitmentCandidateActivityLogs)
                .HasForeignKey(d => d.MarketingCompanyBranchId)
                .HasConstraintName("FK_dbo.Mst_RecruitmentCandidate_ActivityLog_dbo.Mst_MarketingCompany_Branch_MarketingCompanyBranchId");

            entity.HasOne(d => d.RecruitmentCandidate).WithMany(p => p.MstRecruitmentCandidateActivityLogs)
                .HasForeignKey(d => d.RecruitmentCandidateId)
                .HasConstraintName("FK_dbo.Mst_RecruitmentCandidate_ActivityLog_dbo.Mst_RecruitmentCandidate_RecruitmentCandidateId");
        });

        modelBuilder.Entity<MstRecruitmentCandidateArchive>(entity =>
        {
            entity.HasKey(e => e.RecruitmentCandidateArchiveId).HasName("PK_dbo.Mst_RecruitmentCandidate_Archive");

            entity.ToTable("Mst_RecruitmentCandidate_Archive");

            entity.Property(e => e.AccessCode)
                .IsRequired()
                .HasMaxLength(20);
            entity.Property(e => e.AddressState).HasMaxLength(100);
            entity.Property(e => e.AdvertisementTitle).HasMaxLength(50);
            entity.Property(e => e.BadgeNo).HasMaxLength(50);
            entity.Property(e => e.BankAccountName).HasMaxLength(100);
            entity.Property(e => e.BankAccountNo).HasMaxLength(50);
            entity.Property(e => e.BankBranch).HasMaxLength(200);
            entity.Property(e => e.BankCountryCode)
                .HasMaxLength(200)
                .IsUnicode(false);
            entity.Property(e => e.BankName).HasMaxLength(200);
            entity.Property(e => e.BankSwiftCode).HasMaxLength(50);
            entity.Property(e => e.Batype)
                .HasMaxLength(10)
                .HasColumnName("BAType");
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Dob).HasColumnType("datetime");
            entity.Property(e => e.Email).HasMaxLength(50);
            entity.Property(e => e.FirstName)
                .IsRequired()
                .HasMaxLength(100);
            entity.Property(e => e.Gender).HasMaxLength(6);
            entity.Property(e => e.Ic).HasMaxLength(30);
            entity.Property(e => e.LastName).HasMaxLength(100);
            entity.Property(e => e.LocalFirstName).HasMaxLength(255);
            entity.Property(e => e.LocalLastName).HasMaxLength(50);
            entity.Property(e => e.MiddleName).HasMaxLength(100);
            entity.Property(e => e.Nationality).HasMaxLength(50);
            entity.Property(e => e.Nickname).HasMaxLength(100);
            entity.Property(e => e.PassportExpiredDate).HasColumnType("datetime");
            entity.Property(e => e.PassportIssueCountry).HasMaxLength(50);
            entity.Property(e => e.PassportIssueDate).HasColumnType("datetime");
            entity.Property(e => e.PassportName).HasMaxLength(150);
            entity.Property(e => e.PassportNo).HasMaxLength(30);
            entity.Property(e => e.PhoneNumber).HasMaxLength(50);
            entity.Property(e => e.RecruiterBadgeNoOrName).HasMaxLength(100);
            entity.Property(e => e.RecruitmentSource).HasMaxLength(50);
            entity.Property(e => e.RecruitmentType).HasMaxLength(25);
            entity.Property(e => e.Status)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.TeamName).HasMaxLength(50);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<MstRecruitmentCandidateAssignment>(entity =>
        {
            entity.HasKey(e => e.RecruitmentCandidateAssignmentId).HasName("PK_dbo.Mst_RecruitmentCandidate_Assignment");

            entity.ToTable("Mst_RecruitmentCandidate_Assignment");

            entity.HasIndex(e => e.CampaignId, "IX_CampaignId");

            entity.HasIndex(e => e.RecruitmentCandidateId, "IX_RecruitmentCandidateId");

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.EndDate).HasColumnType("datetime");
            entity.Property(e => e.StartDate).HasColumnType("datetime");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.Campaign).WithMany(p => p.MstRecruitmentCandidateAssignments)
                .HasForeignKey(d => d.CampaignId)
                .HasConstraintName("FK_dbo.Mst_RecruitmentCandidate_Assignment_dbo.Mst_Campaign_CampaignId");

            entity.HasOne(d => d.RecruitmentCandidate).WithMany(p => p.MstRecruitmentCandidateAssignments)
                .HasForeignKey(d => d.RecruitmentCandidateId)
                .HasConstraintName("FK_dbo.Mst_RecruitmentCandidate_Assignment_dbo.Mst_RecruitmentCandidate_RecruitmentCandidateId");
        });

        modelBuilder.Entity<MstRecruitmentCandidateCompliance>(entity =>
        {
            entity.HasKey(e => e.RecruitmentCandidateComplianceId).HasName("PK_dbo.Mst_RecruitmentCandidate_Compliance");

            entity.ToTable("Mst_RecruitmentCandidate_Compliance");

            entity.HasIndex(e => e.ComplianceChecklistId, "IX_ComplianceChecklistId");

            entity.HasIndex(e => e.RecruitmentCandidateId, "IX_RecruitmentCandidateId");

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.ComplianceChecklist).WithMany(p => p.MstRecruitmentCandidateCompliances)
                .HasForeignKey(d => d.ComplianceChecklistId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_dbo.Mst_RecruitmentCandidate_Compliance_dbo.Mst_ComplianceChecklist_ComplianceChecklistId");

            entity.HasOne(d => d.RecruitmentCandidate).WithMany(p => p.MstRecruitmentCandidateCompliances)
                .HasForeignKey(d => d.RecruitmentCandidateId)
                .HasConstraintName("FK_dbo.Mst_RecruitmentCandidate_Compliance_dbo.Mst_RecruitmentCandidate_RecruitmentCandidateId");
        });

        modelBuilder.Entity<MstRecruitmentCandidateInduction>(entity =>
        {
            entity.HasKey(e => e.RecruitmentCandidateInductionId).HasName("PK_dbo.Mst_RecruitmentCandidate_Induction");

            entity.ToTable("Mst_RecruitmentCandidate_Induction");

            entity.HasIndex(e => e.CampaignId, "IX_CampaignId");

            entity.HasIndex(e => e.RecruitmentCandidateId, "IX_RecruitmentCandidateId");

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.EndDate).HasColumnType("datetime");
            entity.Property(e => e.StartDate).HasColumnType("datetime");
            entity.Property(e => e.TrainingFee).IsRequired();
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

            entity.HasOne(d => d.Campaign).WithMany(p => p.MstRecruitmentCandidateInductions)
                .HasForeignKey(d => d.CampaignId)
                .HasConstraintName("FK_dbo.Mst_RecruitmentCandidate_Induction_dbo.Mst_Campaign_CampaignId");

            entity.HasOne(d => d.RecruitmentCandidate).WithMany(p => p.MstRecruitmentCandidateInductions)
                .HasForeignKey(d => d.RecruitmentCandidateId)
                .HasConstraintName("FK_dbo.Mst_RecruitmentCandidate_Induction_dbo.Mst_RecruitmentCandidate_RecruitmentCandidateId");
        });

        modelBuilder.Entity<MstRecruitmentComparisonSummary>(entity =>
        {
            entity.HasKey(e => e.RecruitmentComparisonSummaryId).HasName("PK_dbo.Mst_RecruitmentComparisonSummary");

            entity.ToTable("Mst_RecruitmentComparisonSummary");

            entity.HasIndex(e => e.MarketingCompanyId, "IX_MarketingCompanyId");

            entity.HasIndex(e => e.OwnerIndependentContractorId, "IX_OwnerIndependentContractorId");

            entity.Property(e => e.Channel)
                .IsRequired()
                .HasMaxLength(100);
            entity.Property(e => e.CountryCode)
                .IsRequired()
                .HasMaxLength(10);
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.RecruiterNameOrBadgeNo)
                .IsRequired()
                .HasMaxLength(150);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
            entity.Property(e => e.WeekendingDate).HasColumnType("datetime");

            entity.HasOne(d => d.MarketingCompany).WithMany(p => p.MstRecruitmentComparisonSummaries)
                .HasForeignKey(d => d.MarketingCompanyId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_dbo.Mst_RecruitmentComparisonSummary_dbo.Mst_MarketingCompany_MarketingCompanyId");

            entity.HasOne(d => d.OwnerIndependentContractor).WithMany(p => p.MstRecruitmentComparisonSummaries)
                .HasForeignKey(d => d.OwnerIndependentContractorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_dbo.Mst_RecruitmentComparisonSummary_dbo.Mst_IndependentContractor_OwnerIndependentContractorId");
        });

        modelBuilder.Entity<MstReport>(entity =>
        {
            entity.HasKey(e => e.ReportId).HasName("PK_MST_Report");

            entity.ToTable("Mst_Report");

            entity.Property(e => e.Description).HasMaxLength(200);
            entity.Property(e => e.Name)
                .IsRequired()
                .HasMaxLength(100);
            entity.Property(e => e.ReportCategoryCode)
                .IsRequired()
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.ReportRdl)
                .HasMaxLength(50)
                .IsUnicode(false)
                .HasColumnName("ReportRDL");
            entity.Property(e => e.ServerPath)
                .IsRequired()
                .HasMaxLength(200)
                .IsUnicode(false);
        });

        modelBuilder.Entity<MstReportCategory>(entity =>
        {
            entity.HasKey(e => e.ReportCategoryId).HasName("PK_MST_ReportCategory");

            entity.ToTable("Mst_ReportCategory");

            entity.Property(e => e.Description).HasMaxLength(200);
            entity.Property(e => e.Name)
                .IsRequired()
                .HasMaxLength(100);
            entity.Property(e => e.ReportCategoryCode)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<MstReportRole>(entity =>
        {
            entity.HasKey(e => new { e.ReportId, e.RoleId });

            entity.ToTable("Mst_ReportRole");

            entity.Property(e => e.RoleId).HasMaxLength(100);
        });

        modelBuilder.Entity<MstSpecialAccessRole>(entity =>
        {
            entity.HasKey(e => e.AccessId);

            entity.ToTable("Mst_SpecialAccessRole");

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Route)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.UserId)
                .IsRequired()
                .HasMaxLength(255)
                .IsUnicode(false);
        });

        modelBuilder.Entity<MstSuspensionArchived>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("Mst_SuspensionArchived");

            entity.Property(e => e.BadgeNo).HasMaxLength(10);
            entity.Property(e => e.Correctedlastdate)
                .HasColumnType("datetime")
                .HasColumnName("CORRECTEDLASTDATE");
            entity.Property(e => e.CountryCode).HasMaxLength(5);
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Description).HasMaxLength(255);
            entity.Property(e => e.EffectiveDate).HasColumnType("datetime");
            entity.Property(e => e.EndDate).HasColumnType("datetime");
            entity.Property(e => e.IndependentContractorId).HasMaxLength(10);
            entity.Property(e => e.IndependentContractorLevelId).HasMaxLength(10);
            entity.Property(e => e.LastSalesDate).HasColumnType("datetime");
            entity.Property(e => e.LastSalesSubmissionDate).HasColumnType("datetime");
            entity.Property(e => e.LeavingReasonCategory).HasMaxLength(255);
            entity.Property(e => e.LeavingReasonDescription).HasMaxLength(255);
            entity.Property(e => e.Mccode)
                .HasMaxLength(5)
                .HasColumnName("MCCode");
            entity.Property(e => e.StartDate).HasColumnType("datetime");
            entity.Property(e => e.SuspensionArchiveId).ValueGeneratedOnAdd();
            entity.Property(e => e.SuspensionRunDate).HasColumnType("datetime");
            entity.Property(e => e.Type).HasMaxLength(50);
        });

        modelBuilder.Entity<MstSuspensionTempTable>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("Mst_Suspension_TempTable");

            entity.Property(e => e.BadgeNo).HasMaxLength(10);
            entity.Property(e => e.Correctedlastdate)
                .HasColumnType("datetime")
                .HasColumnName("CORRECTEDLASTDATE");
            entity.Property(e => e.CountryCode).HasMaxLength(5);
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Description).HasMaxLength(255);
            entity.Property(e => e.EffectiveDate).HasColumnType("datetime");
            entity.Property(e => e.EndDate).HasColumnType("datetime");
            entity.Property(e => e.Id).ValueGeneratedOnAdd();
            entity.Property(e => e.IndependentContractorId).HasMaxLength(10);
            entity.Property(e => e.IndependentContractorLevelId).HasMaxLength(10);
            entity.Property(e => e.LastSalesDate).HasColumnType("datetime");
            entity.Property(e => e.LastSalesSubmissionDate).HasColumnType("datetime");
            entity.Property(e => e.LeavingReasonCategory).HasMaxLength(255);
            entity.Property(e => e.LeavingReasonDescription).HasMaxLength(255);
            entity.Property(e => e.Mccode)
                .HasMaxLength(5)
                .HasColumnName("MCCode");
            entity.Property(e => e.StartDate).HasColumnType("datetime");
            entity.Property(e => e.SuspensionRunDate).HasColumnType("datetime");
            entity.Property(e => e.Type).HasMaxLength(50);
        });

        modelBuilder.Entity<MstTptcountryPoint>(entity =>
        {
            entity.ToTable("MST_TPTCountryPoint");
            entity.HasKey(e => new { e.Country, e.Balevel, e.StartWe, e.EndWe });

            entity.Property(e => e.Balevel)
                .HasMaxLength(10)
                .HasColumnName("BALevel");
            entity.Property(e => e.Country).HasMaxLength(2);
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.EndWe).HasColumnName("EndWE");
            entity.Property(e => e.PointConversion).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.StartWe).HasColumnName("StartWE");
        });

        modelBuilder.Entity<MstUploadFileHistory>(entity =>
        {
            entity.HasKey(e => e.UploadFileHistoryId).HasName("PK_dbo.Mst_UploadFileHistory");

            entity.ToTable("Mst_UploadFileHistory");

            entity.Property(e => e.Action)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.FileName)
                .IsRequired()
                .HasMaxLength(150);
            entity.Property(e => e.FullPath)
                .IsRequired()
                .HasMaxLength(255);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<MstUser>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("PK_dbo.Mst_User");

            entity.ToTable("Mst_User");

            entity.HasIndex(e => e.MarketingCompanyId, "IX_MarketingCompanyId");

            entity.HasIndex(e => e.UserRoleId, "IX_UserRoleId");

            entity.Property(e => e.UserId).HasMaxLength(35);
            entity.Property(e => e.CountryAccess).HasMaxLength(50);
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.DefaultPath).HasMaxLength(255);
            entity.Property(e => e.Displayname)
                .IsRequired()
                .HasMaxLength(100);
            entity.Property(e => e.Email)
                .IsRequired()
                .HasMaxLength(150);
            entity.Property(e => e.Fullname)
                .IsRequired()
                .HasMaxLength(300);
            entity.Property(e => e.PhoneNumber).HasMaxLength(20);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
            entity.Property(e => e.UserPassword)
                .IsRequired()
                .HasMaxLength(255);
            entity.Property(e => e.Username)
                .IsRequired()
                .HasMaxLength(50);

            entity.HasOne(d => d.MarketingCompany).WithMany(p => p.MstUsers)
                .HasForeignKey(d => d.MarketingCompanyId)
                .HasConstraintName("FK_dbo.Mst_User_dbo.Mst_MarketingCompany_MarketingCompanyId");

            entity.HasOne(d => d.UserRole).WithMany(p => p.MstUsers)
                .HasForeignKey(d => d.UserRoleId)
                .HasConstraintName("FK_dbo.Mst_User_dbo.Mst_UserRole_UserRoleId");
        });

        modelBuilder.Entity<MstUserResetPasswordToken>(entity =>
        {
            entity.HasKey(e => e.UserResetPasswordTokenId).HasName("PK_dbo.Mst_UserResetPasswordToken");

            entity.ToTable("Mst_UserResetPasswordToken");

            entity.HasIndex(e => e.UserId, "IX_UserId");

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Email)
                .IsRequired()
                .HasMaxLength(150);
            entity.Property(e => e.Token)
                .IsRequired()
                .HasMaxLength(255);
            entity.Property(e => e.TokenExpiredDateTime).HasColumnType("datetime");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
            entity.Property(e => e.UserId)
                .IsRequired()
                .HasMaxLength(35);

            entity.HasOne(d => d.User).WithMany(p => p.MstUserResetPasswordTokens)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("FK_dbo.Mst_UserResetPasswordToken_dbo.Mst_User_UserId");
        });

        modelBuilder.Entity<MstUserRole>(entity =>
        {
            entity.HasKey(e => e.UserRoleId).HasName("PK_dbo.Mst_UserRole");

            entity.ToTable("Mst_UserRole");

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Description)
                .IsRequired()
                .HasMaxLength(300);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
            entity.Property(e => e.UserRoleCode)
                .IsRequired()
                .HasMaxLength(5);
        });

        modelBuilder.Entity<MstWeekending>(entity =>
        {
            entity.ToTable("Mst_Weekending");

            entity.Property(e => e.Id).HasMaxLength(100);
            entity.Property(e => e.CreatedBy)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
            entity.Property(e => e.Wedate).HasColumnName("WEdate");
        });

        modelBuilder.Entity<RecruiterList>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("RecruiterList$");

            entity.Property(e => e.Country).HasMaxLength(255);
            entity.Property(e => e.MarketingCompany)
                .HasMaxLength(255)
                .HasColumnName("Marketing Company");
            entity.Property(e => e.McCode)
                .HasMaxLength(255)
                .HasColumnName("MC Code");
            entity.Property(e => e.RecruiterAdministratorSName)
                .HasMaxLength(255)
                .HasColumnName("Recruiter / Administrator's Name");
        });

        modelBuilder.Entity<ReportSubscription>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("REPORT_Subscriptions");

            entity.Property(e => e.DataSettings)
                .UseCollation("Latin1_General_100_CI_AS_KS_WS")
                .HasColumnType("ntext");
            entity.Property(e => e.DeliveryExtension)
                .HasMaxLength(260)
                .UseCollation("Latin1_General_100_CI_AS_KS_WS");
            entity.Property(e => e.Description)
                .HasMaxLength(512)
                .UseCollation("Latin1_General_100_CI_AS_KS_WS");
            entity.Property(e => e.EventType)
                .IsRequired()
                .HasMaxLength(260)
                .UseCollation("Latin1_General_100_CI_AS_KS_WS");
            entity.Property(e => e.ExtensionSettings)
                .UseCollation("Latin1_General_100_CI_AS_KS_WS")
                .HasColumnType("ntext");
            entity.Property(e => e.LastRunTime).HasColumnType("datetime");
            entity.Property(e => e.LastStatus)
                .HasMaxLength(260)
                .UseCollation("Latin1_General_100_CI_AS_KS_WS");
            entity.Property(e => e.Locale)
                .IsRequired()
                .HasMaxLength(128)
                .UseCollation("Latin1_General_100_CI_AS_KS_WS");
            entity.Property(e => e.MatchData)
                .UseCollation("Latin1_General_100_CI_AS_KS_WS")
                .HasColumnType("ntext");
            entity.Property(e => e.ModifiedById).HasColumnName("ModifiedByID");
            entity.Property(e => e.ModifiedDate).HasColumnType("datetime");
            entity.Property(e => e.OwnerId).HasColumnName("OwnerID");
            entity.Property(e => e.Parameters)
                .UseCollation("Latin1_General_100_CI_AS_KS_WS")
                .HasColumnType("ntext");
            entity.Property(e => e.ReportOid).HasColumnName("Report_OID");
            entity.Property(e => e.SubscriptionId).HasColumnName("SubscriptionID");
        });

        modelBuilder.Entity<ReportingRecruitmentActivity>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("Reporting_Recruitment_Activity");

            entity.Property(e => e.ActivityAppointment).HasMaxLength(50);
            entity.Property(e => e.ActivityConductedBy).HasMaxLength(250);
            entity.Property(e => e.ActivityCreatedDate).HasColumnType("datetime");
            entity.Property(e => e.ActivityDescription).HasMaxLength(50);
            entity.Property(e => e.ActivityGroupWeekending).HasColumnType("datetime");
            entity.Property(e => e.ActivityNotSucceedReason).HasMaxLength(50);
            entity.Property(e => e.ActivityScheduleEndDateTime).HasColumnType("datetime");
            entity.Property(e => e.ActivityScheduleStartDateTime).HasColumnType("datetime");
            entity.Property(e => e.ActivityScheduleStartWeekending).HasColumnType("datetime");
            entity.Property(e => e.ActivityStage).HasMaxLength(50);
            entity.Property(e => e.ActivityUnsuitableStatus).HasMaxLength(50);
            entity.Property(e => e.ActivityUpdatedDate).HasColumnType("datetime");
            entity.Property(e => e.AddressCity).HasMaxLength(80);
            entity.Property(e => e.AddressCountry).HasMaxLength(30);
            entity.Property(e => e.AddressLine1).HasMaxLength(150);
            entity.Property(e => e.AddressLine2).HasMaxLength(150);
            entity.Property(e => e.AddressLine3).HasMaxLength(150);
            entity.Property(e => e.AddressPostCode).HasMaxLength(20);
            entity.Property(e => e.AddressState).HasMaxLength(100);
            entity.Property(e => e.AdvertisementTitle).HasMaxLength(50);
            entity.Property(e => e.BadgeNo).HasMaxLength(50);
            entity.Property(e => e.BankAccountName).HasMaxLength(100);
            entity.Property(e => e.BankAccountNo).HasMaxLength(50);
            entity.Property(e => e.BankBranch).HasMaxLength(200);
            entity.Property(e => e.BankCountryCode)
                .HasMaxLength(200)
                .IsUnicode(false);
            entity.Property(e => e.BankName).HasMaxLength(200);
            entity.Property(e => e.BankSwiftCode).HasMaxLength(50);
            entity.Property(e => e.BastartDate)
                .HasColumnType("datetime")
                .HasColumnName("BAStartDate");
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Dob).HasColumnType("datetime");
            entity.Property(e => e.EducationLevel).HasMaxLength(50);
            entity.Property(e => e.Email).HasMaxLength(150);
            entity.Property(e => e.EmergencyContactPerson).HasMaxLength(150);
            entity.Property(e => e.EmergencyContactPhoneNumber).HasMaxLength(20);
            entity.Property(e => e.EmergencyContactRelationship).HasMaxLength(20);
            entity.Property(e => e.FirstName)
                .IsRequired()
                .HasMaxLength(100);
            entity.Property(e => e.Gender).HasMaxLength(6);
            entity.Property(e => e.Ic).HasMaxLength(30);
            entity.Property(e => e.LastName).HasMaxLength(100);
            entity.Property(e => e.LocalFirstName).HasMaxLength(255);
            entity.Property(e => e.LocalLastName).HasMaxLength(50);
            entity.Property(e => e.Mccode)
                .HasMaxLength(10)
                .HasColumnName("MCCode");
            entity.Property(e => e.Mccountry)
                .HasMaxLength(10)
                .HasColumnName("MCCountry");
            entity.Property(e => e.Mcid).HasColumnName("MCId");
            entity.Property(e => e.Mcname)
                .HasMaxLength(150)
                .HasColumnName("MCName");
            entity.Property(e => e.Mcstatus)
                .HasMaxLength(10)
                .HasColumnName("MCStatus");
            entity.Property(e => e.MiddleName).HasMaxLength(100);
            entity.Property(e => e.Nationality)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.Nickname).HasMaxLength(100);
            entity.Property(e => e.PassportExpiredDate).HasColumnType("datetime");
            entity.Property(e => e.PassportIssueCountry).HasMaxLength(50);
            entity.Property(e => e.PassportIssueDate).HasColumnType("datetime");
            entity.Property(e => e.PassportName).HasMaxLength(150);
            entity.Property(e => e.PassportNo).HasMaxLength(30);
            entity.Property(e => e.PhoneNumber).HasMaxLength(50);
            entity.Property(e => e.RecruiterBadgeNoOrName).HasMaxLength(100);
            entity.Property(e => e.RecruitmentCandidateId)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.RecruitmentSource).HasMaxLength(50);
            entity.Property(e => e.RecruitmentSubSource).HasMaxLength(50);
            entity.Property(e => e.RecruitmentType).HasMaxLength(25);
            entity.Property(e => e.Status)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.TeamLeaderAdvanceDate).HasColumnType("datetime");
            entity.Property(e => e.TeamName).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<RptOverviewDetailByCountry>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("RPT_OverviewDetailByCountry");

            entity.Property(e => e.ActiveIc).HasColumnName("ActiveIC");
            entity.Property(e => e.Country).HasMaxLength(10);
            entity.Property(e => e.MoCode).HasMaxLength(10);
            entity.Property(e => e.Recruitment).HasMaxLength(10);
        });

        modelBuilder.Entity<RptOverviewDigitalAppNewdMethod>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("RPT_OverviewDigitalAppNewdMethod");

            entity.Property(e => e.Average).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.McHongkong).HasColumnName("MC_Hongkong");
            entity.Property(e => e.McIndia).HasColumnName("MC_India");
            entity.Property(e => e.McIndonesia).HasColumnName("MC_Indonesia");
            entity.Property(e => e.McKorea).HasColumnName("MC_Korea");
            entity.Property(e => e.McMalaysia).HasColumnName("MC_Malaysia");
            entity.Property(e => e.McPhilippines).HasColumnName("MC_Philippines");
            entity.Property(e => e.McSingapore).HasColumnName("MC_Singapore");
            entity.Property(e => e.McTaiwan).HasColumnName("MC_Taiwan");
            entity.Property(e => e.McThailand).HasColumnName("MC_Thailand");
            entity.Property(e => e.RHongkong).HasColumnName("R_Hongkong");
            entity.Property(e => e.RIndia).HasColumnName("R_India");
            entity.Property(e => e.RIndonesia).HasColumnName("R_Indonesia");
            entity.Property(e => e.RKorea).HasColumnName("R_Korea");
            entity.Property(e => e.RMalaysia).HasColumnName("R_Malaysia");
            entity.Property(e => e.RPhilippines).HasColumnName("R_Philippines");
            entity.Property(e => e.RSingapore).HasColumnName("R_Singapore");
            entity.Property(e => e.RTaiwan).HasColumnName("R_Taiwan");
            entity.Property(e => e.RThailand).HasColumnName("R_Thailand");
        });

        modelBuilder.Entity<RptOverviewDigitalAppOldMethod>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("RPT_OverviewDigitalAppOldMethod");

            entity.Property(e => e.Average).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.McHongkong).HasColumnName("MC_Hongkong");
            entity.Property(e => e.McIndia).HasColumnName("MC_India");
            entity.Property(e => e.McIndonesia).HasColumnName("MC_Indonesia");
            entity.Property(e => e.McKorea).HasColumnName("MC_Korea");
            entity.Property(e => e.McMalaysia).HasColumnName("MC_Malaysia");
            entity.Property(e => e.McPhilippines).HasColumnName("MC_Philippines");
            entity.Property(e => e.McSingapore).HasColumnName("MC_Singapore");
            entity.Property(e => e.McTaiwan).HasColumnName("MC_Taiwan");
            entity.Property(e => e.McThailand).HasColumnName("MC_Thailand");
            entity.Property(e => e.RHongkong).HasColumnName("R_Hongkong");
            entity.Property(e => e.RIndia).HasColumnName("R_India");
            entity.Property(e => e.RIndonesia).HasColumnName("R_Indonesia");
            entity.Property(e => e.RKorea).HasColumnName("R_Korea");
            entity.Property(e => e.RMalaysia).HasColumnName("R_Malaysia");
            entity.Property(e => e.RPhilippines).HasColumnName("R_Philippines");
            entity.Property(e => e.RSingapore).HasColumnName("R_Singapore");
            entity.Property(e => e.RTaiwan).HasColumnName("R_Taiwan");
            entity.Property(e => e.RThailand).HasColumnName("R_Thailand");
            entity.Property(e => e.TotalMc).HasColumnName("TotalMC");
        });

        modelBuilder.Entity<RptOverviewRecruitment>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("RPT_OverviewRecruitment");

            entity.Property(e => e.AverageMcactive)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("AverageMCActive");
            entity.Property(e => e.McHongkong).HasColumnName("MC_Hongkong");
            entity.Property(e => e.McIndia).HasColumnName("MC_India");
            entity.Property(e => e.McIndonesia).HasColumnName("MC_Indonesia");
            entity.Property(e => e.McKorea).HasColumnName("MC_Korea");
            entity.Property(e => e.McMalaysia).HasColumnName("MC_Malaysia");
            entity.Property(e => e.McPhilippines).HasColumnName("MC_Philippines");
            entity.Property(e => e.McSingapore).HasColumnName("MC_Singapore");
            entity.Property(e => e.McTaiwan).HasColumnName("MC_Taiwan");
            entity.Property(e => e.McThailand).HasColumnName("MC_Thailand");
            entity.Property(e => e.RHongkong).HasColumnName("R_Hongkong");
            entity.Property(e => e.RIndia).HasColumnName("R_India");
            entity.Property(e => e.RIndonesia).HasColumnName("R_Indonesia");
            entity.Property(e => e.RKorea).HasColumnName("R_Korea");
            entity.Property(e => e.RMalaysia).HasColumnName("R_Malaysia");
            entity.Property(e => e.RPhilippines).HasColumnName("R_Philippines");
            entity.Property(e => e.RSingapore).HasColumnName("R_Singapore");
            entity.Property(e => e.RTaiwan).HasColumnName("R_Taiwan");
            entity.Property(e => e.RThailand).HasColumnName("R_Thailand");
            entity.Property(e => e.TotalMc).HasColumnName("TotalMC");
            entity.Property(e => e.TotalMcactive).HasColumnName("TotalMCActive");
        });

        modelBuilder.Entity<Sheet1>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("Sheet1");

            entity.Property(e => e.AccessGroups)
                .HasMaxLength(255)
                .HasColumnName("access_groups");
            entity.Property(e => e.ActivatedAt)
                .HasMaxLength(255)
                .HasColumnName("activated_at");
            entity.Property(e => e.Birthday)
                .HasMaxLength(255)
                .HasColumnName("birthday");
            entity.Property(e => e.Country)
                .HasMaxLength(255)
                .HasColumnName("country");
            entity.Property(e => e.DepartmentId)
                .HasMaxLength(255)
                .HasColumnName("department_id");
            entity.Property(e => e.DirectManagerIds)
                .HasMaxLength(255)
                .HasColumnName("direct_manager_ids");
            entity.Property(e => e.Email)
                .HasMaxLength(255)
                .HasColumnName("email");
            entity.Property(e => e.EmployeeId)
                .HasMaxLength(255)
                .HasColumnName("employee_id");
            entity.Property(e => e.EndOfEmploymentAt)
                .HasMaxLength(255)
                .HasColumnName("end_of_employment_at");
            entity.Property(e => e.FirstName)
                .HasMaxLength(255)
                .HasColumnName("first_name");
            entity.Property(e => e.Gender)
                .HasMaxLength(255)
                .HasColumnName("gender");
            entity.Property(e => e.GenericRole)
                .HasMaxLength(255)
                .HasColumnName("generic_role");
            entity.Property(e => e.Id)
                .HasMaxLength(255)
                .HasColumnName("id");
            entity.Property(e => e.Initials)
                .HasMaxLength(255)
                .HasColumnName("initials");
            entity.Property(e => e.Language)
                .HasMaxLength(255)
                .HasColumnName("language");
            entity.Property(e => e.LastLogin)
                .HasMaxLength(255)
                .HasColumnName("last_login");
            entity.Property(e => e.LastName)
                .HasMaxLength(255)
                .HasColumnName("last_name");
            entity.Property(e => e.Legal)
                .HasMaxLength(255)
                .HasColumnName("legal");
            entity.Property(e => e.Level)
                .HasMaxLength(255)
                .HasColumnName("level");
            entity.Property(e => e.Location)
                .HasMaxLength(255)
                .HasColumnName("location");
            entity.Property(e => e.MobilePhone)
                .HasMaxLength(255)
                .HasColumnName("mobile_phone");
            entity.Property(e => e.Name).HasMaxLength(255);
            entity.Property(e => e.PersonalEmail)
                .HasMaxLength(255)
                .HasColumnName("personal_email");
            entity.Property(e => e.Phone)
                .HasMaxLength(255)
                .HasColumnName("phone");
            entity.Property(e => e.PhoneCode)
                .HasMaxLength(255)
                .HasColumnName("phone_code");
            entity.Property(e => e.SalaryId)
                .HasMaxLength(255)
                .HasColumnName("salary_id");
            entity.Property(e => e.SkillLevel)
                .HasMaxLength(255)
                .HasColumnName("skill_level");
            entity.Property(e => e.StartOfEmploymentAt)
                .HasMaxLength(255)
                .HasColumnName("start_of_employment_at");
            entity.Property(e => e.Status)
                .HasMaxLength(255)
                .HasColumnName("status");
            entity.Property(e => e.SubCompany)
                .HasMaxLength(255)
                .HasColumnName("sub_company");
            entity.Property(e => e.TeamId)
                .HasMaxLength(255)
                .HasColumnName("team_id");
            entity.Property(e => e.Timezone)
                .HasMaxLength(255)
                .HasColumnName("timezone");
            entity.Property(e => e.Title)
                .HasMaxLength(255)
                .HasColumnName("title");
            entity.Property(e => e.UserPermission)
                .HasMaxLength(255)
                .HasColumnName("user_permission");
            entity.Property(e => e.Username)
                .HasMaxLength(255)
                .HasColumnName("username");
        });

        modelBuilder.Entity<TempApplicationFormUrl>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("Temp_ApplicationFormUrl");

            entity.Property(e => e.ApplicationFormUrl).HasMaxLength(255);
            entity.Property(e => e.BadgeNo).HasMaxLength(50);
            entity.Property(e => e.CountryCode).HasMaxLength(50);
            entity.Property(e => e.Email).HasMaxLength(500);
            entity.Property(e => e.IndependentContractorId)
                .HasMaxLength(50)
                .HasColumnName("IndependentContractorID");
            entity.Property(e => e.MarketingCompanyId)
                .HasMaxLength(50)
                .HasColumnName("MarketingCompanyID");
            entity.Property(e => e.Mocode)
                .HasMaxLength(50)
                .HasColumnName("MOCode");
            entity.Property(e => e.NewApplicationFormUrl).HasMaxLength(500);
        });

        modelBuilder.Entity<TempApplicationFormUrlmo>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("Temp_ApplicationFormURLMO");

            entity.Property(e => e.ApplicationFormUrl).HasMaxLength(500);
            entity.Property(e => e.CountryCode).HasMaxLength(50);
            entity.Property(e => e.MarketingCompanyId)
                .HasMaxLength(50)
                .HasColumnName("MarketingCompanyID");
            entity.Property(e => e.Mocode)
                .HasMaxLength(50)
                .HasColumnName("MOCode");
            entity.Property(e => e.NewApplicationFormUrl).HasMaxLength(500);
        });

        modelBuilder.Entity<TxnAutoAdvancementConfirmation>(entity =>
        {
            entity.HasKey(e => e.AdvancementId);

            entity.ToTable("Txn_AutoAdvancementConfirmation");

            entity.Property(e => e.AdvancementId).HasColumnName("AdvancementID");
            entity.Property(e => e.CreatedBy).HasMaxLength(100);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.IsDeleted).HasColumnName("isDeleted");
            entity.Property(e => e.Mcagreement).HasColumnName("MCAgreement");
            entity.Property(e => e.Mta).HasColumnName("MTA");
            entity.Property(e => e.Remark).HasMaxLength(200);
            entity.Property(e => e.Status).HasMaxLength(10);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<TxnAutoAdvancementResult>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("TXN_AutoAdvancementResult");

            entity.Property(e => e.BabulettinPoint)
                .HasColumnType("decimal(18, 4)")
                .HasColumnName("BABulettinPoint");
            entity.Property(e => e.BabulettinPoint2)
                .HasColumnType("decimal(18, 4)")
                .HasColumnName("BABulettinPoint2");
            entity.Property(e => e.BadgeNo).HasMaxLength(50);
            entity.Property(e => e.BafirstGenLeader).HasColumnName("BAFirstGenLeader");
            entity.Property(e => e.BafirstGenLeader2).HasColumnName("BAFirstGenLeader2");
            entity.Property(e => e.Balevel)
                .HasMaxLength(50)
                .HasColumnName("BALevel");
            entity.Property(e => e.Balevel2)
                .HasMaxLength(50)
                .HasColumnName("BALevel2");
            entity.Property(e => e.Balink).HasColumnName("BALink");
            entity.Property(e => e.Balink2).HasColumnName("BALink2");
            entity.Property(e => e.BapersonalPoint)
                .HasColumnType("decimal(18, 4)")
                .HasColumnName("BAPersonalPoint");
            entity.Property(e => e.BapersonalPoint2)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("BAPersonalPoint2");
            entity.Property(e => e.BapersonalSalesValue)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("BAPersonalSalesValue");
            entity.Property(e => e.BapersonalSalesValue2)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("BAPersonalSalesValue2");
            entity.Property(e => e.Baprovince)
                .HasMaxLength(50)
                .HasColumnName("BAProvince");
            entity.Property(e => e.Baprovince2)
                .HasMaxLength(50)
                .HasColumnName("BAProvince2");
            entity.Property(e => e.BasalesPcs).HasColumnName("BASalesPcs");
            entity.Property(e => e.BasalesPcs2).HasColumnName("BASalesPcs2");
            entity.Property(e => e.BasalesValue)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("BASalesValue");
            entity.Property(e => e.BasalesValue2)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("BASalesValue2");
            entity.Property(e => e.Bastatus)
                .HasMaxLength(50)
                .HasColumnName("BAStatus");
            entity.Property(e => e.Bastatus2)
                .HasMaxLength(50)
                .HasColumnName("BAStatus2");
            entity.Property(e => e.BasubPcs).HasColumnName("BASubPcs");
            entity.Property(e => e.BasubPcs2).HasColumnName("BASubPcs2");
            entity.Property(e => e.BateamSize).HasColumnName("BATeamSize");
            entity.Property(e => e.BateamSize2).HasColumnName("BATeamSize2");
            entity.Property(e => e.CountryCode).HasMaxLength(10);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.CriteriaBuletinPoint).HasColumnType("decimal(18, 4)");
            entity.Property(e => e.CriteriaBuletinPoint2).HasColumnType("decimal(18, 4)");
            entity.Property(e => e.CriteriaProvince).HasMaxLength(50);
            entity.Property(e => e.CriteriaProvince2).HasMaxLength(50);
            entity.Property(e => e.CriteriaSalesValue).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.CriteriaSalesValue2).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.CriteriaSubPcs).HasMaxLength(100);
            entity.Property(e => e.CriteriaSubPcs2).HasMaxLength(100);
            entity.Property(e => e.CriteriaTeamSizeLevel).HasMaxLength(100);
            entity.Property(e => e.CriteriaTeamSizeLevel2).HasMaxLength(100);
            entity.Property(e => e.DirectReportBadgeNo).HasMaxLength(50);
            entity.Property(e => e.DirectReportBadgeNo2).HasMaxLength(50);
            entity.Property(e => e.FinalResult).HasMaxLength(20);
            entity.Property(e => e.IndependentContractorId).HasColumnName("IndependentContractorID");
            entity.Property(e => e.Remark).HasMaxLength(1000);
            entity.Property(e => e.ScheduleBalevel)
                .HasMaxLength(100)
                .HasColumnName("ScheduleBALevel");
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
            entity.Property(e => e.We1hitLevelRequirement).HasColumnName("WE1HitLevelRequirement");
            entity.Property(e => e.We2hitLevelRequirement).HasColumnName("WE2HitLevelRequirement");
            entity.Property(e => e.Webalevel)
                .HasMaxLength(50)
                .HasColumnName("WEBALevel");
            entity.Property(e => e.Webalevel2)
                .HasMaxLength(50)
                .HasColumnName("WEBALevel2");
            entity.Property(e => e.Week1Result).HasMaxLength(20);
            entity.Property(e => e.Week2Result).HasMaxLength(20);
        });

        modelBuilder.Entity<TxnAutoAdvancementResult2>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("TXN_AutoAdvancementResult2");

            entity.Property(e => e.BabulettinPoint)
                .HasColumnType("decimal(18, 4)")
                .HasColumnName("BABulettinPoint");
            entity.Property(e => e.BabulettinPoint2)
                .HasColumnType("decimal(18, 4)")
                .HasColumnName("BABulettinPoint2");
            entity.Property(e => e.BadgeNo).HasMaxLength(50);
            entity.Property(e => e.BafirstGenLeader).HasColumnName("BAFirstGenLeader");
            entity.Property(e => e.BafirstGenLeader2).HasColumnName("BAFirstGenLeader2");
            entity.Property(e => e.Balevel)
                .HasMaxLength(50)
                .HasColumnName("BALevel");
            entity.Property(e => e.Balink).HasColumnName("BALink");
            entity.Property(e => e.Balink2).HasColumnName("BALink2");
            entity.Property(e => e.BapersonalPoint)
                .HasColumnType("decimal(18, 4)")
                .HasColumnName("BAPersonalPoint");
            entity.Property(e => e.BapersonalPoint2)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("BAPersonalPoint2");
            entity.Property(e => e.BapersonalSalesValue)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("BAPersonalSalesValue");
            entity.Property(e => e.BapersonalSalesValue2)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("BAPersonalSalesValue2");
            entity.Property(e => e.Baprovince)
                .HasMaxLength(50)
                .HasColumnName("BAProvince");
            entity.Property(e => e.Baprovince2)
                .HasMaxLength(50)
                .HasColumnName("BAProvince2");
            entity.Property(e => e.BasalesPcs).HasColumnName("BASalesPcs");
            entity.Property(e => e.BasalesPcs2).HasColumnName("BASalesPcs2");
            entity.Property(e => e.BasalesValue)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("BASalesValue");
            entity.Property(e => e.BasalesValue2)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("BASalesValue2");
            entity.Property(e => e.Bastatus)
                .HasMaxLength(50)
                .HasColumnName("BAStatus");
            entity.Property(e => e.Bastatus2)
                .HasMaxLength(50)
                .HasColumnName("BAStatus2");
            entity.Property(e => e.BasubPcs).HasColumnName("BASubPcs");
            entity.Property(e => e.BasubPcs2).HasColumnName("BASubPcs2");
            entity.Property(e => e.BateamSize).HasColumnName("BATeamSize");
            entity.Property(e => e.BateamSize2).HasColumnName("BATeamSize2");
            entity.Property(e => e.CountryCode).HasMaxLength(10);
            entity.Property(e => e.CriteriaBuletinPoint).HasColumnType("decimal(18, 4)");
            entity.Property(e => e.CriteriaBuletinPoint2).HasColumnType("decimal(18, 4)");
            entity.Property(e => e.CriteriaProvince).HasMaxLength(50);
            entity.Property(e => e.CriteriaProvince2).HasMaxLength(50);
            entity.Property(e => e.CriteriaSalesValue).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.CriteriaSalesValue2).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.CriteriaSubPcs).HasMaxLength(100);
            entity.Property(e => e.CriteriaSubPcs2).HasMaxLength(100);
            entity.Property(e => e.CriteriaTeamSizeLevel).HasMaxLength(100);
            entity.Property(e => e.CriteriaTeamSizeLevel2).HasMaxLength(100);
            entity.Property(e => e.DirectReportBadgeNo).HasMaxLength(50);
            entity.Property(e => e.DirectReportBadgeNo2).HasMaxLength(50);
            entity.Property(e => e.FinalResult).HasMaxLength(20);
            entity.Property(e => e.IndependentContractorId).HasColumnName("IndependentContractorID");
            entity.Property(e => e.Remark).HasMaxLength(1000);
            entity.Property(e => e.ScheduleBalevel)
                .HasMaxLength(100)
                .HasColumnName("ScheduleBALevel");
            entity.Property(e => e.Webalevel)
                .HasMaxLength(50)
                .HasColumnName("WEBALevel");
            entity.Property(e => e.Webalevel2)
                .HasMaxLength(50)
                .HasColumnName("WEBALevel2");
            entity.Property(e => e.Week1Result).HasMaxLength(20);
            entity.Property(e => e.Week2Result).HasMaxLength(20);
        });

        modelBuilder.Entity<TxnBonu>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("Txn_Bonus");

            entity.Property(e => e.BonusAmount).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.BonusDescription).HasMaxLength(255);
            entity.Property(e => e.BonusType).HasMaxLength(50);
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<TxnCampaignDocument>(entity =>
        {
            entity.HasKey(e => e.CampaignDocId);

            entity.ToTable("TXN_CampaignDocument");

            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.DocPath).HasMaxLength(200);
            entity.Property(e => e.DocumentName).HasMaxLength(100);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<TxnCampaignDocumentArchive>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("TXN_CampaignDocument_Archive");

            entity.Property(e => e.Adate)
                .HasColumnType("datetime")
                .HasColumnName("ADate");
            entity.Property(e => e.Atask)
                .HasMaxLength(50)
                .HasColumnName("ATask");
            entity.Property(e => e.Auser)
                .HasMaxLength(50)
                .HasColumnName("AUser");
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.DocPath).HasMaxLength(200);
            entity.Property(e => e.DocumentName).HasMaxLength(100);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<TxnClientIdentification>(entity =>
        {
            entity.HasKey(e => e.ClientIdentificationId);

            entity.ToTable("TXN_ClientIdentification");

            entity.Property(e => e.ClientIdentificationId).HasColumnName("ClientIdentificationID");
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.IdentificationId)
                .HasMaxLength(100)
                .HasColumnName("identificationID");
            entity.Property(e => e.IsDeleted).HasColumnName("isDeleted");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<TxnClientIdentification2>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("TXN_ClientIdentification2");

            entity.Property(e => e.ClientIdentificationId)
                .ValueGeneratedOnAdd()
                .HasColumnName("ClientIdentificationID");
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.IdentificationId)
                .HasMaxLength(100)
                .HasColumnName("identificationID");
            entity.Property(e => e.IsDeleted).HasColumnName("isDeleted");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<TxnClientIdentification20240122>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("TXN_ClientIdentification_20240122");

            entity.Property(e => e.ClientIdentificationId)
                .ValueGeneratedOnAdd()
                .HasColumnName("ClientIdentificationID");
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.IdentificationId)
                .HasMaxLength(100)
                .HasColumnName("identificationID");
            entity.Property(e => e.IsDeleted).HasColumnName("isDeleted");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<TxnEmailQueue>(entity =>
        {
            entity.HasKey(e => e.TxnId);

            entity.ToTable("TXN_EmailQueue");

            entity.Property(e => e.TxnId)
                .HasMaxLength(100)
                .HasColumnName("TxnID");
            entity.Property(e => e.Attachment).HasMaxLength(2000);
            entity.Property(e => e.Bcc)
                .HasMaxLength(200)
                .HasColumnName("BCC");
            entity.Property(e => e.Cc)
                .HasMaxLength(200)
                .HasColumnName("CC");
            entity.Property(e => e.CreateBy).HasMaxLength(50);
            entity.Property(e => e.CreateDate).HasColumnType("datetime");
            entity.Property(e => e.Description).HasMaxLength(100);
            entity.Property(e => e.Recipient).HasMaxLength(1000);
            entity.Property(e => e.Subject).HasMaxLength(200);
        });

        modelBuilder.Entity<TxnEmailQueue2>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("TXN_EmailQueue2");

            entity.Property(e => e.Attachment).HasMaxLength(2000);
            entity.Property(e => e.Bcc)
                .HasMaxLength(200)
                .HasColumnName("BCC");
            entity.Property(e => e.Cc)
                .HasMaxLength(200)
                .HasColumnName("CC");
            entity.Property(e => e.CreateBy).HasMaxLength(50);
            entity.Property(e => e.CreateDate).HasColumnType("datetime");
            entity.Property(e => e.Description).HasMaxLength(100);
            entity.Property(e => e.Recipient).HasMaxLength(1000);
            entity.Property(e => e.Subject).HasMaxLength(200);
            entity.Property(e => e.TxnId)
                .IsRequired()
                .HasMaxLength(100)
                .HasColumnName("TxnID");
        });

        modelBuilder.Entity<TxnEmailQueue3>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("TXN_EmailQueue3");

            entity.Property(e => e.Attachment).HasMaxLength(2000);
            entity.Property(e => e.Bcc)
                .HasMaxLength(200)
                .HasColumnName("BCC");
            entity.Property(e => e.Cc)
                .HasMaxLength(200)
                .HasColumnName("CC");
            entity.Property(e => e.CreateBy).HasMaxLength(50);
            entity.Property(e => e.CreateDate).HasColumnType("datetime");
            entity.Property(e => e.Description).HasMaxLength(100);
            entity.Property(e => e.Recipient).HasMaxLength(1000);
            entity.Property(e => e.Subject).HasMaxLength(200);
            entity.Property(e => e.TxnId)
                .IsRequired()
                .HasMaxLength(100)
                .HasColumnName("TxnID");
        });

        modelBuilder.Entity<TxnEmailQueue5>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("TXN_EmailQueue5");

            entity.Property(e => e.Attachment).HasMaxLength(2000);
            entity.Property(e => e.Bcc)
                .HasMaxLength(200)
                .HasColumnName("BCC");
            entity.Property(e => e.Cc)
                .HasMaxLength(200)
                .HasColumnName("CC");
            entity.Property(e => e.CreateBy).HasMaxLength(50);
            entity.Property(e => e.CreateDate).HasColumnType("datetime");
            entity.Property(e => e.Description).HasMaxLength(100);
            entity.Property(e => e.Recipient).HasMaxLength(1000);
            entity.Property(e => e.Subject).HasMaxLength(200);
            entity.Property(e => e.TxnId)
                .IsRequired()
                .HasMaxLength(100)
                .HasColumnName("TxnID");
        });

        modelBuilder.Entity<TxnEmailQueueArchive>(entity =>
        {
            entity.HasKey(e => e.TxnId);

            entity.ToTable("TXN_EmailQueueArchive");

            entity.Property(e => e.TxnId)
                .HasMaxLength(100)
                .HasColumnName("TxnID");
            entity.Property(e => e.Attachment).HasMaxLength(2000);
            entity.Property(e => e.Bcc)
                .HasMaxLength(200)
                .HasColumnName("BCC");
            entity.Property(e => e.Cc)
                .HasMaxLength(200)
                .HasColumnName("CC");
            entity.Property(e => e.CreateBy).HasMaxLength(50);
            entity.Property(e => e.CreateDate).HasColumnType("datetime");
            entity.Property(e => e.Description).HasMaxLength(100);
            entity.Property(e => e.Recipient).HasMaxLength(1000);
            entity.Property(e => e.SendDate).HasColumnType("datetime");
            entity.Property(e => e.Subject).HasMaxLength(200);
        });

        modelBuilder.Entity<TxnHuddleRpt>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("TXN_HUDDLE_RPT");

            entity.Property(e => e.BuletinPoint).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.Country).HasMaxLength(20);
            entity.Property(e => e.CountryCampaignHc).HasColumnName("CountryCampaignHC");
            entity.Property(e => e.CountryDivHc).HasColumnName("CountryDivHC");
            entity.Property(e => e.CountryHc).HasColumnName("CountryHC");
            entity.Property(e => e.CountryUshc).HasColumnName("CountryUSHC");
            entity.Property(e => e.Customer).HasMaxLength(50);
            entity.Property(e => e.DivUsch).HasColumnName("DivUSCH");
            entity.Property(e => e.Division).HasMaxLength(20);
            entity.Property(e => e.GrossBaearning)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("GrossBAEarning");
            entity.Property(e => e.GrossSales).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.NetBaearning)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("NetBAEarning");
            entity.Property(e => e.OneTimePieces).HasColumnName("One Time Pieces");
            entity.Property(e => e.RejectPieceOt).HasColumnName("RejectPieceOT");
            entity.Property(e => e.RejectPieceRec).HasColumnName("RejectPieceREC");
            entity.Property(e => e.RejectPieces).HasColumnName("Reject Pieces");
            entity.Property(e => e.ResubPieceOt).HasColumnName("ResubPieceOT");
            entity.Property(e => e.ResubPieceRec).HasColumnName("ResubPieceREC");
            entity.Property(e => e.ResubPieces).HasColumnName("Resub Pieces");
            entity.Property(e => e.Rmonth)
                .HasMaxLength(50)
                .HasColumnName("RMonth");
            entity.Property(e => e.Rquarter)
                .HasMaxLength(50)
                .HasColumnName("RQuarter");
            entity.Property(e => e.Swbonus)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("SWBonus");
            entity.Property(e => e.Usch).HasColumnName("USCH");
        });

        modelBuilder.Entity<TxnIcweekEndingStatusTest>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("TXN_ICWeekEndingStatus_Test");

            entity.Property(e => e.BadgeNo)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.Baid).HasColumnName("BAID");
            entity.Property(e => e.Balevel)
                .HasMaxLength(50)
                .HasColumnName("BALevel");
            entity.Property(e => e.CountryCode).HasMaxLength(50);
            entity.Property(e => e.LastDeactivateDate).HasColumnType("datetime");
            entity.Property(e => e.Mccode)
                .HasMaxLength(50)
                .HasColumnName("MCCode");
            entity.Property(e => e.Mcid).HasColumnName("MCID");
            entity.Property(e => e.Mcname)
                .HasMaxLength(150)
                .HasColumnName("MCName");
            entity.Property(e => e.RecruitmentType).HasMaxLength(25);
            entity.Property(e => e.StartDate).HasColumnType("datetime");
            entity.Property(e => e.Status)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.Westage)
                .HasMaxLength(50)
                .HasColumnName("WESTage");
            entity.Property(e => e.Westatus).HasColumnName("WEStatus");
        });

        modelBuilder.Entity<TxnIcweekendingStatus>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("TXN_ICWeekendingStatus");

            entity.Property(e => e.BadgeNo)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.Baid).HasColumnName("BAID");
            entity.Property(e => e.Balevel)
                .HasMaxLength(50)
                .HasColumnName("BALevel");
            entity.Property(e => e.CountryCode).HasMaxLength(50);
            entity.Property(e => e.LastDeactivateDate).HasColumnType("datetime");
            entity.Property(e => e.Mccode)
                .HasMaxLength(50)
                .HasColumnName("MCCode");
            entity.Property(e => e.Mcid).HasColumnName("MCID");
            entity.Property(e => e.Mcname)
                .HasMaxLength(150)
                .HasColumnName("MCName");
            entity.Property(e => e.RecruitmentType).HasMaxLength(25);
            entity.Property(e => e.StartDate).HasColumnType("datetime");
            entity.Property(e => e.Status)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.Westage)
                .HasMaxLength(50)
                .HasColumnName("WESTage");
            entity.Property(e => e.Westatus).HasColumnName("WEStatus");
        });

        modelBuilder.Entity<TxnOnfieldHeadcountDetail>(entity =>
        {
            entity.HasKey(e => e.DetailId);

            entity.ToTable("TXN_OnfieldHeadcountDetail");

            entity.Property(e => e.DetailId).HasColumnName("DetailID");
            entity.Property(e => e.CampaignId).HasColumnName("CampaignID");
            entity.Property(e => e.Channel).HasMaxLength(50);
            entity.Property(e => e.Location).HasMaxLength(20);
            entity.Property(e => e.OnfieldHeadcountId).HasColumnName("OnfieldHeadcountID");
            entity.Property(e => e.Session).HasMaxLength(50);
        });

        modelBuilder.Entity<TxnOnfieldHeadcountHeader>(entity =>
        {
            entity.HasKey(e => e.OnfieldHeadcountId);

            entity.ToTable("TXN_OnfieldHeadcountHeader");

            entity.Property(e => e.OnfieldHeadcountId).HasColumnName("OnfieldHeadcountID");
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<TxnPrDetail>(entity =>
        {
            entity.HasKey(e => e.RowId);

            entity.ToTable("TXN_PR_Detail");

            entity.Property(e => e.RowId).HasColumnName("RowID");
            entity.Property(e => e.Campaign).HasMaxLength(500);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.IndependentContractorLevelId).HasColumnName("IndependentContractorLevelID");
            entity.Property(e => e.IsDeleted)
                .HasMaxLength(10)
                .IsFixedLength();
            entity.Property(e => e.MileStonesPoint).HasColumnType("decimal(18, 4)");
            entity.Property(e => e.MileStonesValue).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.MilestoneHitWe).HasColumnName("MilestoneHitWE");
            entity.Property(e => e.MilestonePayoutWe).HasColumnName("MilestonePayoutWE");
            entity.Property(e => e.MilestonesData).HasMaxLength(200);
            entity.Property(e => e.PayoutId).HasColumnName("PayoutID");
            entity.Property(e => e.Prid).HasColumnName("PRID");
            entity.Property(e => e.RecruiterIndependentContractorLevelId).HasColumnName("RecruiterIndependentContractorLevelID");
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<TxnPrIncentiveRaw>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("TXN_PR_Incentive_Raw");

            entity.Property(e => e.BadgeNo).HasMaxLength(50);
            entity.Property(e => e.Bonus).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.Campaign).HasMaxLength(500);
            entity.Property(e => e.CountryCode).HasMaxLength(10);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Mocode)
                .HasMaxLength(10)
                .HasColumnName("MOCode");
            entity.Property(e => e.NetEarning).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
            entity.Property(e => e.Wedate).HasColumnName("WEDate");
        });

        modelBuilder.Entity<TxnPrIncentiveRawTemp>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("TXN_PR_Incentive_Raw_Temp");

            entity.Property(e => e.BadgeNo).HasMaxLength(50);
            entity.Property(e => e.Bonus).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.Campaign).HasMaxLength(500);
            entity.Property(e => e.CountryCode).HasMaxLength(10);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Mocode)
                .HasMaxLength(10)
                .HasColumnName("MOCode");
            entity.Property(e => e.NetEarning).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
            entity.Property(e => e.Wedate).HasColumnName("WEDate");
        });

        modelBuilder.Entity<TxnPrSingapore>(entity =>
        {
            entity.HasKey(e => e.RowNo);

            entity.ToTable("TXN_PR_Singapore");

            entity.Property(e => e.BadgeNo).HasMaxLength(10);
            entity.Property(e => e.BanetBonus1)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("BANetBonus1");
            entity.Property(e => e.BanetBonus2)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("BANetBonus2");
            entity.Property(e => e.BanetEarning)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("BANetEarning");
            entity.Property(e => e.BasubPcs).HasColumnName("BASubPcs");
            entity.Property(e => e.Division).HasMaxLength(50);
            entity.Property(e => e.Mocode)
                .HasMaxLength(10)
                .HasColumnName("MOCode");
        });

        modelBuilder.Entity<TxnPrbonu>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("TXN_PRBonus");

            entity.Property(e => e.BadgeNo)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.Code).HasMaxLength(10);
            entity.Property(e => e.CountryCode).HasMaxLength(10);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.FirstName)
                .IsRequired()
                .HasMaxLength(100);
            entity.Property(e => e.LastDeactivateDate).HasColumnType("datetime");
            entity.Property(e => e.LastName).HasMaxLength(100);
            entity.Property(e => e.LastSalesSubmissionDate).HasColumnType("datetime");
            entity.Property(e => e.Name).HasMaxLength(150);
            entity.Property(e => e.RecruiterBadgeNo).HasMaxLength(50);
            entity.Property(e => e.RecruiterBadgeNoOrName).HasMaxLength(100);
            entity.Property(e => e.RecruiterFirstName).HasMaxLength(100);
            entity.Property(e => e.RecruiterLastName).HasMaxLength(100);
            entity.Property(e => e.RecruiterStatus).HasMaxLength(50);
            entity.Property(e => e.ScheduleWeekending)
                .IsRequired()
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.StartDate).HasColumnType("datetime");
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<TxnRegionalSalesBonu>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("TXN_RegionalSalesBonus");

            entity.Property(e => e.BuletinPoint).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.ConversionRate).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.Country).HasMaxLength(20);
            entity.Property(e => e.GrossBaearning)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("GrossBAEarning");
            entity.Property(e => e.Mocode)
                .HasMaxLength(20)
                .HasColumnName("MOCode");
            entity.Property(e => e.Moname)
                .HasMaxLength(100)
                .HasColumnName("MOName");
            entity.Property(e => e.NetBaearning)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("NetBAEarning");
            entity.Property(e => e.Rmonth)
                .HasMaxLength(50)
                .HasColumnName("RMonth");
            entity.Property(e => e.Rquarter)
                .HasMaxLength(50)
                .HasColumnName("RQuarter");
            entity.Property(e => e.Swbonus)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("SWBonus");
        });

        modelBuilder.Entity<TxnRegionalSalesSummary>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("TXN_RegionalSalesSummary");

            entity.Property(e => e.BadgeNo).HasMaxLength(10);
            entity.Property(e => e.Campaign).HasMaxLength(50);
            entity.Property(e => e.Channel).HasMaxLength(10);
            entity.Property(e => e.Client).HasMaxLength(50);
            entity.Property(e => e.CountryCode).HasMaxLength(2);
            entity.Property(e => e.Division).HasMaxLength(50);
            entity.Property(e => e.DoboType).HasMaxLength(20);
            entity.Property(e => e.DonationAmount).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.EventCode).HasMaxLength(200);
            entity.Property(e => e.Guid).HasColumnName("GUID");
            entity.Property(e => e.Icstroke)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("ICStroke");
            entity.Property(e => e.IsDeleted).HasMaxLength(2);
            entity.Property(e => e.IsDobo).HasMaxLength(2);
            entity.Property(e => e.IsUnderAge).HasMaxLength(2);
            entity.Property(e => e.LiveStatus).HasMaxLength(20);
            entity.Property(e => e.Mocode)
                .HasMaxLength(10)
                .HasColumnName("MOCode");
            entity.Property(e => e.OwnerStroke).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.PaymentMode).HasMaxLength(20);
            entity.Property(e => e.Status).HasMaxLength(50);
            entity.Property(e => e.Tcv)
                .HasColumnType("decimal(18, 4)")
                .HasColumnName("TCV");
            entity.Property(e => e.TeritoryCode).HasMaxLength(200);
            entity.Property(e => e.TxnCreatedDate).HasColumnType("datetime");
            entity.Property(e => e.TxnId)
                .HasMaxLength(200)
                .HasColumnName("TxnID");
        });

        modelBuilder.Entity<TxnRegionalSalesSummaryUat>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("TXN_RegionalSalesSummary_UAT");

            entity.Property(e => e.BadgeNo).HasMaxLength(10);
            entity.Property(e => e.Campaign).HasMaxLength(50);
            entity.Property(e => e.Channel).HasMaxLength(10);
            entity.Property(e => e.Client).HasMaxLength(50);
            entity.Property(e => e.CountryCode).HasMaxLength(2);
            entity.Property(e => e.Division).HasMaxLength(50);
            entity.Property(e => e.DoboType).HasMaxLength(20);
            entity.Property(e => e.DonationAmount).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.EventCode).HasMaxLength(20);
            entity.Property(e => e.Guid).HasColumnName("GUID");
            entity.Property(e => e.Icstroke)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("ICStroke");
            entity.Property(e => e.IsDeleted).HasMaxLength(2);
            entity.Property(e => e.IsDobo).HasMaxLength(2);
            entity.Property(e => e.IsUnderAge).HasMaxLength(2);
            entity.Property(e => e.LiveStatus).HasMaxLength(20);
            entity.Property(e => e.Mocode)
                .HasMaxLength(10)
                .HasColumnName("MOCode");
            entity.Property(e => e.OwnerStroke).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.PaymentMode).HasMaxLength(20);
            entity.Property(e => e.Status).HasMaxLength(50);
            entity.Property(e => e.TeritoryCode).HasMaxLength(20);
            entity.Property(e => e.TxnCreatedDate).HasColumnType("datetime");
            entity.Property(e => e.TxnId)
                .HasMaxLength(200)
                .HasColumnName("TxnID");
        });

        modelBuilder.Entity<TxnReportingBadgeKr>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("TXN_ReportingBadge_KR");

            entity.Property(e => e.BadgeNo).HasMaxLength(20);
            entity.Property(e => e.BadgeNolink).HasMaxLength(500);
            entity.Property(e => e.CurrentLevel).HasMaxLength(20);
            entity.Property(e => e.DirectReportBadgeNumber).HasMaxLength(20);
            entity.Property(e => e.LevelCode).HasMaxLength(20);
            entity.Property(e => e.RowId)
                .ValueGeneratedOnAdd()
                .HasColumnName("RowID");
            entity.Property(e => e.Wedate).HasColumnName("WEDate");
        });

        modelBuilder.Entity<TxnTempManualLastSalesDate>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("txn_Temp_ManualLastSalesDate");

            entity.Property(e => e.BadgeNo).HasMaxLength(20);
            entity.Property(e => e.MoCode).HasMaxLength(10);
        });

        modelBuilder.Entity<TxnTempStarhubCpq>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__TXN_Temp_Star__3214EC07855F50F5");

            entity.ToTable("TXN_Temp_Starhub_CPQ");

            entity.Property(e => e.BusinessRegNo).HasMaxLength(50);
            entity.Property(e => e.Ccv)
                .HasColumnType("decimal(18, 4)")
                .HasColumnName("CCV");
            entity.Property(e => e.Ccvcurrency)
                .HasMaxLength(10)
                .HasColumnName("CCVCurrency");
            entity.Property(e => e.ChannelPartner).HasMaxLength(150);
            entity.Property(e => e.CompanyName).HasMaxLength(200);
            entity.Property(e => e.Contact1).HasMaxLength(40);
            entity.Property(e => e.Contact1Email).HasMaxLength(100);
            entity.Property(e => e.ContactEmail).HasMaxLength(100);
            entity.Property(e => e.ContactOfficePhone).HasMaxLength(20);
            entity.Property(e => e.Cpqopportunity).HasColumnName("CPQOpportunity");
            entity.Property(e => e.Crdate)
                .HasMaxLength(50)
                .HasColumnName("CRDate");
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.ExistingAccountDate).HasMaxLength(50);
            entity.Property(e => e.Mrc)
                .HasColumnType("decimal(18, 4)")
                .HasColumnName("MRC");
            entity.Property(e => e.Mrccurrency)
                .HasMaxLength(10)
                .HasColumnName("MRCCurrency");
            entity.Property(e => e.NewAccountDate).HasMaxLength(50);
            entity.Property(e => e.NewAccountType).HasMaxLength(20);
            entity.Property(e => e.OpportunityNo).HasMaxLength(30);
            entity.Property(e => e.OpportunityOwner).HasMaxLength(150);
            entity.Property(e => e.OpportunityStatus).HasMaxLength(100);
            entity.Property(e => e.OwnerDivision).HasMaxLength(50);
            entity.Property(e => e.PrimaryContact).HasMaxLength(100);
            entity.Property(e => e.ProductName).HasMaxLength(200);
            entity.Property(e => e.Promotion).HasMaxLength(50);
            entity.Property(e => e.Reseller).HasMaxLength(50);
            entity.Property(e => e.StarhubServiceId)
                .HasMaxLength(200)
                .HasColumnName("StarhubServiceID");
            entity.Property(e => e.SystemTransactionKey).HasColumnName("System_TransactionKey");
            entity.Property(e => e.TypeOfContract).HasMaxLength(20);
        });
        modelBuilder.Entity<VW_BARelationship>(entity =>
        {
            entity.HasNoKey();
            entity.ToTable("VW_BARelationship");


        });
        modelBuilder.Entity<TxnTptdetails>(entity =>
        {
            entity.ToTable("TXN_TPT_Details");

            entity.HasKey(e => e.DetailsId);

            entity.Property(e => e.DetailsId)
                .HasColumnName("DetailsID")
                .ValueGeneratedOnAdd();

        });

        modelBuilder.Entity<TxnTptsummary>(entity =>
        {
            entity.HasKey(e => e.SummaryId);

            entity.ToTable("TXN_TPTSummary");

            entity.Property(e => e.SummaryId).HasColumnName("SummaryID");
            entity.Property(e => e.BadgeNo).HasMaxLength(20);
            entity.Property(e => e.BadgeNoLink).HasMaxLength(500);
            entity.Property(e => e.Baname)
                .HasMaxLength(300)
                .HasColumnName("BAName"); 
            entity.Property(e => e.CountryCode).HasMaxLength(10);
            entity.Property(e => e.CurrentLevel).HasMaxLength(10);
            entity.Property(e => e.Level).HasMaxLength(50);
            entity.Property(e => e.Mccode)
                .HasMaxLength(10)
                .HasColumnName("MCCode");
            entity.Property(e => e.Mcname)
                .HasMaxLength(150)
                .HasColumnName("MCName");
            entity.Property(e => e.NetValue).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.Point).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.Rate).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.TeamProduction).HasColumnType("decimal(18, 2)");
        });

        modelBuilder.Entity<TxnValidation>(entity =>
        {
            entity.HasKey(e => e.TxnId);

            entity.ToTable("TXN_Validation");

            entity.Property(e => e.CreatedBy)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Status).HasMaxLength(10);
            entity.Property(e => e.TxnName)
                .IsRequired()
                .HasMaxLength(100)
                .IsUnicode(false);
        });

        modelBuilder.Entity<TxnWeeklyBasummary>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("TXN_WeeklyBASummary");

            entity.Property(e => e.BadgeNo).HasMaxLength(20);
            entity.Property(e => e.BadgeNoLink).HasMaxLength(500);
            entity.Property(e => e.CountryCode).HasMaxLength(10);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.CurrentLevel).HasMaxLength(10);
            entity.Property(e => e.DirectReportBadgeNo).HasMaxLength(10);
            entity.Property(e => e.IndependentContractorId).HasColumnName("IndependentContractorID");
            entity.Property(e => e.Mccode)
                .HasMaxLength(10)
                .HasColumnName("MCCode");
            entity.Property(e => e.NetPoint).HasColumnType("decimal(18, 4)");
            entity.Property(e => e.NetValue).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
            entity.Property(e => e.Welevel)
                .HasMaxLength(10)
                .HasColumnName("WELevel");
        });

        modelBuilder.Entity<VwIcdetail>(entity =>
        {
              entity.ToView("VW_ICDetail"); 
                entity.HasKey(e => e.IndependentContractorLevelId);

            entity.Property(e => e.AddressCity).HasMaxLength(80);
            entity.Property(e => e.AddressCountry).HasMaxLength(30);
            entity.Property(e => e.AddressLine1).HasMaxLength(150);
            entity.Property(e => e.AddressLine2).HasMaxLength(150);
            entity.Property(e => e.AddressLine3).HasMaxLength(150);
            entity.Property(e => e.AddressPostCode).HasMaxLength(20);
            entity.Property(e => e.AddressState).HasMaxLength(100);
            entity.Property(e => e.AdvertisementTitle).HasMaxLength(50);
            entity.Property(e => e.AgreementSignedDate).HasColumnType("datetime");
            entity.Property(e => e.AppPassword).HasMaxLength(10);
            entity.Property(e => e.BadgeNo)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.BankAccountName).HasMaxLength(100);
            entity.Property(e => e.BankAccountNo).HasMaxLength(50);
            entity.Property(e => e.BankBranch).HasMaxLength(200);
            entity.Property(e => e.BankCountryCode)
                .HasMaxLength(200)
                .IsUnicode(false);
            entity.Property(e => e.BankName).HasMaxLength(200);
            entity.Property(e => e.BankSwiftCode).HasMaxLength(50);
            entity.Property(e => e.Batype)
                .HasMaxLength(10)
                .HasColumnName("BAType");
            entity.Property(e => e.BatypeDesc)
                .HasMaxLength(100)
                .HasColumnName("BATypeDesc");
            entity.Property(e => e.Beneficiary1).HasMaxLength(150);
            entity.Property(e => e.Beneficiary2).HasMaxLength(150);
            entity.Property(e => e.BgColor)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.BirthPlace).HasMaxLength(50);
            entity.Property(e => e.BondLimit).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.BondPercentage).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.Code).HasMaxLength(10);
            entity.Property(e => e.CountryCode).HasMaxLength(10);
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.DateFirstOnField).HasColumnType("datetime");
            entity.Property(e => e.Dob).HasColumnType("datetime");
            entity.Property(e => e.EducationLevel).HasMaxLength(50);
            entity.Property(e => e.EffectiveAdvancementDate).HasColumnType("datetime");
            entity.Property(e => e.Email).HasMaxLength(150);
            entity.Property(e => e.EmergencyContactPerson).HasMaxLength(150);
            entity.Property(e => e.EmergencyContactPhoneNumber).HasMaxLength(20);
            entity.Property(e => e.EmergencyContactRelationship).HasMaxLength(20);
            entity.Property(e => e.FirstAttemptScore).HasMaxLength(50);
            entity.Property(e => e.FirstAttemptSubDate).HasColumnType("datetime");
            entity.Property(e => e.FirstName)
                .IsRequired()
                .HasMaxLength(100);
            entity.Property(e => e.Gender).HasMaxLength(6);
            entity.Property(e => e.Ic).HasMaxLength(30);
            entity.Property(e => e.Icsavings)
                .HasColumnType("decimal(18, 2)")
                .HasColumnName("ICSavings");
            entity.Property(e => e.IsQrenabled).HasColumnName("IsQREnabled");
            entity.Property(e => e.LastDeactivateDate).HasColumnType("datetime");
            entity.Property(e => e.LastName).HasMaxLength(100);
            entity.Property(e => e.LastSalesSubmissionDate).HasColumnType("datetime");
            entity.Property(e => e.LocalFirstName).HasMaxLength(255);
            entity.Property(e => e.LocalLastName).HasMaxLength(50);
            entity.Property(e => e.MaritalStatus).HasMaxLength(50);
            entity.Property(e => e.MarketingCompanyType).HasMaxLength(50);
            entity.Property(e => e.McApplicationFormUrl).HasColumnName("MC_ApplicationFormUrl");
            entity.Property(e => e.McBankAccountNo)
                .HasMaxLength(50)
                .HasColumnName("MC_BankAccountNo");
            entity.Property(e => e.McBankName)
                .HasMaxLength(200)
                .HasColumnName("MC_BankName");
            entity.Property(e => e.McCreatedBy)
                .HasMaxLength(50)
                .HasColumnName("MC_CreatedBy");
            entity.Property(e => e.McCreatedDate)
                .HasColumnType("datetime")
                .HasColumnName("MC_CreatedDate");
            entity.Property(e => e.McEmail)
                .HasMaxLength(100)
                .HasColumnName("MC_Email");
            entity.Property(e => e.McIsActive).HasColumnName("MC_IsActive");
            entity.Property(e => e.McIsDeleted).HasColumnName("MC_IsDeleted");
            entity.Property(e => e.McUpdatedBy)
                .HasMaxLength(50)
                .HasColumnName("MC_UpdatedBy");
            entity.Property(e => e.McUpdatedDate)
                .HasColumnType("datetime")
                .HasColumnName("MC_UpdatedDate");
            entity.Property(e => e.MiddleName).HasMaxLength(100);
            entity.Property(e => e.MobileNumber).HasMaxLength(50);
            entity.Property(e => e.Name).HasMaxLength(150);
            entity.Property(e => e.Nationality)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.Nickname).HasMaxLength(100);
            entity.Property(e => e.OriginalBadgeNo).HasMaxLength(50);
            entity.Property(e => e.OverridesSavings).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.PassportExpiredDate).HasColumnType("datetime");
            entity.Property(e => e.PassportIssueCountry).HasMaxLength(50);
            entity.Property(e => e.PassportIssueDate).HasColumnType("datetime");
            entity.Property(e => e.PassportName).HasMaxLength(150);
            entity.Property(e => e.PassportNo).HasMaxLength(30);
            entity.Property(e => e.PaymentSchema).HasMaxLength(50);
            entity.Property(e => e.PermanentAddress).HasMaxLength(255);
            entity.Property(e => e.PhoneNumber).HasMaxLength(50);
            entity.Property(e => e.Province).HasMaxLength(50);
            entity.Property(e => e.RecruiterBadgeNoOrName).HasMaxLength(100);
            entity.Property(e => e.RecruitmentSource).HasMaxLength(50);
            entity.Property(e => e.RecruitmentSubSource).HasMaxLength(50);
            entity.Property(e => e.RecruitmentType).HasMaxLength(25);
            entity.Property(e => e.ReportBadgeNo).HasMaxLength(50);
            entity.Property(e => e.ReturnMaterialRemarks).HasMaxLength(255);
            entity.Property(e => e.SalesBranch).HasMaxLength(50);
            entity.Property(e => e.SecondAttemptScore).HasMaxLength(50);
            entity.Property(e => e.SecondAttemptSubDate).HasColumnType("datetime");
            entity.Property(e => e.StartDate).HasColumnType("datetime");
            entity.Property(e => e.Status)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.TaxNumber).HasMaxLength(500);
            entity.Property(e => e.TeamName).HasMaxLength(50);
            entity.Property(e => e.TransferFromId)
                .HasMaxLength(10)
                .HasColumnName("TransferFromID");
            entity.Property(e => e.TransferLatestId)
                .HasMaxLength(10)
                .HasColumnName("TransferLatestID");
            entity.Property(e => e.TransferToId)
                .HasMaxLength(10)
                .HasColumnName("TransferToID");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<VwIndependentContractorsPreview>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("VW_IndependentContractorsPreview");

            entity.Property(e => e.BadgeNo)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.CountryCode).HasMaxLength(10);
            entity.Property(e => e.DateFirstOnField).HasColumnType("datetime");
            entity.Property(e => e.Fullname)
                .IsRequired()
                .HasMaxLength(302);
            entity.Property(e => e.Level).HasMaxLength(50);
            entity.Property(e => e.McCode).HasMaxLength(10);
            entity.Property(e => e.McName).HasMaxLength(150);
            entity.Property(e => e.OriginalBadgeNo).HasMaxLength(50);
            entity.Property(e => e.ReportBadgeNo).HasMaxLength(50);
            entity.Property(e => e.StartDate).HasColumnType("datetime");
            entity.Property(e => e.Status)
                .IsRequired()
                .HasMaxLength(50);
        });

        modelBuilder.Entity<VwKoreaBalist>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("VW_KoreaBAList");

            entity.Property(e => e.BadgeNo)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.MoCode).HasMaxLength(10);
        });

        modelBuilder.Entity<VwPrMaster>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("VW_PR_Master");

            entity.Property(e => e.BadgeNo).HasMaxLength(50);
            entity.Property(e => e.CountryCode).HasMaxLength(10);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.IndependentContractorId).HasColumnName("IndependentContractorID");
            entity.Property(e => e.IndependentContractorLevelId).HasColumnName("IndependentContractorLevelID");
            entity.Property(e => e.IsDeleted)
                .HasMaxLength(10)
                .IsFixedLength();
            entity.Property(e => e.MileStonesPoint).HasColumnType("decimal(18, 4)");
            entity.Property(e => e.MileStonesValue).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.MilestoneHitWe).HasColumnName("MilestoneHitWE");
            entity.Property(e => e.MilestonePayoutWe).HasColumnName("MilestonePayoutWE");
            entity.Property(e => e.MilestonesData).HasMaxLength(200);
            entity.Property(e => e.Mocode)
                .HasMaxLength(10)
                .HasColumnName("MOCode");
            entity.Property(e => e.PayoutId).HasColumnName("PayoutID");
            entity.Property(e => e.Prid).HasColumnName("PRID");
            entity.Property(e => e.RecruiterBadgeNo).HasMaxLength(50);
            entity.Property(e => e.RecruiterIndependentContractorId).HasColumnName("RecruiterIndependentContractorID");
            entity.Property(e => e.RecruiterIndependentContractorLevelId).HasColumnName("RecruiterIndependentContractorLevelID");
            entity.Property(e => e.RowId).HasColumnName("RowID");
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<VwRecruitmentCandidateActivityLog>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("VW_RecruitmentCandidate_ActivityLog");

            entity.Property(e => e.AppointmentStatus)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.BranchAddressLine1).HasColumnName("Branch_AddressLine1");
            entity.Property(e => e.BranchAddressLine2).HasColumnName("Branch_AddressLine2");
            entity.Property(e => e.BranchAddressLine3).HasColumnName("Branch_AddressLine3");
            entity.Property(e => e.BranchCity)
                .HasMaxLength(50)
                .HasColumnName("Branch_City");
            entity.Property(e => e.BranchFaxNo)
                .HasMaxLength(50)
                .HasColumnName("Branch_FaxNo");
            entity.Property(e => e.BranchIsDeleted).HasColumnName("Branch_isDeleted");
            entity.Property(e => e.BranchPostcode)
                .HasMaxLength(50)
                .HasColumnName("Branch_Postcode");
            entity.Property(e => e.BranchState)
                .HasMaxLength(50)
                .HasColumnName("Branch_State");
            entity.Property(e => e.BranchTelephoneNo)
                .HasMaxLength(50)
                .HasColumnName("Branch_TelephoneNo");
            entity.Property(e => e.ConductedBy).HasMaxLength(250);
            entity.Property(e => e.CountryCode)
                .IsRequired()
                .HasMaxLength(10);
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Description)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.McCode)
                .IsRequired()
                .HasMaxLength(10)
                .HasColumnName("MC_Code");
            entity.Property(e => e.McIsActive).HasColumnName("MC_IsActive");
            entity.Property(e => e.McIsDeleted).HasColumnName("MC_IsDeleted");
            entity.Property(e => e.McName)
                .IsRequired()
                .HasMaxLength(150)
                .HasColumnName("MC_Name");
            entity.Property(e => e.NotSucceedReason).HasMaxLength(50);
            entity.Property(e => e.ScheduleEndDateTime).HasColumnType("datetime");
            entity.Property(e => e.ScheduleStartDateTime).HasColumnType("datetime");
            entity.Property(e => e.Stage)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.UnsuitableStatus).HasMaxLength(50);
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<VwReportingBa>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("VW_Reporting_BA");

            entity.Property(e => e.AddressCity).HasMaxLength(80);
            entity.Property(e => e.AddressCountry).HasMaxLength(30);
            entity.Property(e => e.AddressLine1).HasMaxLength(150);
            entity.Property(e => e.AddressLine2).HasMaxLength(150);
            entity.Property(e => e.AddressLine3).HasMaxLength(150);
            entity.Property(e => e.AddressPostCode).HasMaxLength(20);
            entity.Property(e => e.AddressState).HasMaxLength(100);
            entity.Property(e => e.AdvertisementTitle).HasMaxLength(50);
            entity.Property(e => e.AgreementSignedDate).HasColumnType("datetime");
            entity.Property(e => e.BadgeNo)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.Baid).HasColumnName("BAId");
            entity.Property(e => e.BankAccountName).HasMaxLength(100);
            entity.Property(e => e.BankAccountNo).HasMaxLength(50);
            entity.Property(e => e.BankBranch).HasMaxLength(200);
            entity.Property(e => e.BankName).HasMaxLength(200);
            entity.Property(e => e.BankSwiftCode).HasMaxLength(50);
            entity.Property(e => e.Beneficiary1).HasMaxLength(150);
            entity.Property(e => e.Beneficiary2).HasMaxLength(150);
            entity.Property(e => e.BirthPlace).HasMaxLength(50);
            entity.Property(e => e.BondLimit).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.BondPercentage).HasColumnType("decimal(18, 2)");
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Dob).HasColumnType("datetime");
            entity.Property(e => e.EducationLevel).HasMaxLength(50);
            entity.Property(e => e.EffectiveAdvancementDate).HasColumnType("datetime");
            entity.Property(e => e.Email).HasMaxLength(150);
            entity.Property(e => e.EmergencyContactPerson).HasMaxLength(150);
            entity.Property(e => e.EmergencyContactPhoneNumber).HasMaxLength(20);
            entity.Property(e => e.EmergencyContactRelationship).HasMaxLength(20);
            entity.Property(e => e.FirstAttemptScore).HasMaxLength(50);
            entity.Property(e => e.FirstAttemptSubDate).HasColumnType("datetime");
            entity.Property(e => e.FirstDayOnField).HasColumnType("datetime");
            entity.Property(e => e.FirstName)
                .IsRequired()
                .HasMaxLength(100);
            entity.Property(e => e.Gender).HasMaxLength(6);
            entity.Property(e => e.Ic).HasMaxLength(30);
            entity.Property(e => e.LastDeactivateDate).HasColumnType("datetime");
            entity.Property(e => e.LastName).HasMaxLength(100);
            entity.Property(e => e.LastSalesSubmissionDate).HasColumnType("datetime");
            entity.Property(e => e.Level).HasMaxLength(50);
            entity.Property(e => e.LevelCode).HasMaxLength(10);
            entity.Property(e => e.LocalFirstName).HasMaxLength(255);
            entity.Property(e => e.LocalLastName).HasMaxLength(50);
            entity.Property(e => e.MaritalStatus).HasMaxLength(50);
            entity.Property(e => e.Mccode)
                .HasMaxLength(10)
                .HasColumnName("MCCode");
            entity.Property(e => e.Mccountry)
                .HasMaxLength(10)
                .HasColumnName("MCCountry");
            entity.Property(e => e.Mcid).HasColumnName("MCId");
            entity.Property(e => e.Mcname)
                .HasMaxLength(150)
                .HasColumnName("MCName");
            entity.Property(e => e.Mcstatus)
                .HasMaxLength(10)
                .HasColumnName("MCStatus");
            entity.Property(e => e.MiddleName).HasMaxLength(100);
            entity.Property(e => e.MobileNumber).HasMaxLength(50);
            entity.Property(e => e.Nationality)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.Nickname).HasMaxLength(100);
            entity.Property(e => e.OriginalBadgeNo).HasMaxLength(50);
            entity.Property(e => e.ParentLevel).HasMaxLength(50);
            entity.Property(e => e.PaymentSchema).HasMaxLength(50);
            entity.Property(e => e.PermanentAddress).HasMaxLength(255);
            entity.Property(e => e.PhoneNumber).HasMaxLength(50);
            entity.Property(e => e.RecruiterBadgeNoOrName).HasMaxLength(100);
            entity.Property(e => e.RecruitmentSource).HasMaxLength(50);
            entity.Property(e => e.RecruitmentType).HasMaxLength(25);
            entity.Property(e => e.ReportBadgeNo).HasMaxLength(50);
            entity.Property(e => e.ReturnMaterialRemarks).HasMaxLength(255);
            entity.Property(e => e.SalesBranch).HasMaxLength(50);
            entity.Property(e => e.SecondAttemptScore).HasMaxLength(50);
            entity.Property(e => e.SecondAttemptSubDate).HasColumnType("datetime");
            entity.Property(e => e.StartDate).HasColumnType("datetime");
            entity.Property(e => e.Status)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.TaxNumber).HasMaxLength(500);
            entity.Property(e => e.TeamName).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<VwReportingDivisionCampaign>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("VW_Reporting_DivisionCampaign");

            entity.Property(e => e.CampaignCode).HasMaxLength(20);
            entity.Property(e => e.CampaignName).HasMaxLength(150);
            entity.Property(e => e.CountryCode).HasMaxLength(10);
            entity.Property(e => e.DivisionCode)
                .IsRequired()
                .HasMaxLength(5);
            entity.Property(e => e.DivisionName)
                .IsRequired()
                .HasMaxLength(255);
        });

        modelBuilder.Entity<VwReportingMc>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("VW_Reporting_MC");

            entity.Property(e => e.Mccode)
                .IsRequired()
                .HasMaxLength(10)
                .HasColumnName("MCCode");
            entity.Property(e => e.Mccountry)
                .IsRequired()
                .HasMaxLength(10)
                .HasColumnName("MCCountry");
            entity.Property(e => e.Mcid)
                .ValueGeneratedOnAdd()
                .HasColumnName("MCId");
            entity.Property(e => e.Mcname)
                .IsRequired()
                .HasMaxLength(150)
                .HasColumnName("MCName");
            entity.Property(e => e.Mcstatus)
                .HasMaxLength(10)
                .HasColumnName("MCStatus");
        });

        modelBuilder.Entity<VwReportingNoChange>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("VW_ReportingNoChanges");

            entity.Property(e => e.BadgeNo)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.EndDate).HasColumnType("datetime");
            entity.Property(e => e.LeaderBadgeNo).IsRequired();
            entity.Property(e => e.StartDate).HasColumnType("datetime");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<VwReportingRecruiter>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("VW_Reporting_Recruiter");

            entity.Property(e => e.Code).HasMaxLength(10);
            entity.Property(e => e.CountryCode).HasMaxLength(10);
            entity.Property(e => e.FirstName)
                .IsRequired()
                .HasMaxLength(150);
            entity.Property(e => e.LastName).HasMaxLength(150);
            entity.Property(e => e.LocalFirstName).HasMaxLength(255);
            entity.Property(e => e.LocalLastName).HasMaxLength(255);
            entity.Property(e => e.Mcid).HasColumnName("MCId");
            entity.Property(e => e.MiddleName).HasMaxLength(150);
            entity.Property(e => e.Name).HasMaxLength(150);
            entity.Property(e => e.Status)
                .IsRequired()
                .HasMaxLength(8)
                .IsUnicode(false);
        });

        modelBuilder.Entity<VwReportingTxnBaMovement>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("VW_Reporting_TXN_BA_Movement");

            entity.Property(e => e.BadgeNo).HasMaxLength(50);
            entity.Property(e => e.Baid).HasColumnName("BAId");
            entity.Property(e => e.CreatedBy).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Description).IsRequired();
            entity.Property(e => e.EffectiveDate).HasColumnType("datetime");
            entity.Property(e => e.Level)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.LevelCode)
                .IsRequired()
                .HasMaxLength(10);
            entity.Property(e => e.Mccode)
                .HasMaxLength(10)
                .HasColumnName("MCCode");
            entity.Property(e => e.Mccountry)
                .HasMaxLength(10)
                .HasColumnName("MCCountry");
            entity.Property(e => e.Mcid).HasColumnName("MCId");
            entity.Property(e => e.Mcname)
                .HasMaxLength(150)
                .HasColumnName("MCName");
            entity.Property(e => e.Mcstatus)
                .HasMaxLength(10)
                .HasColumnName("MCStatus");
            entity.Property(e => e.OriginalBadgeNo).HasMaxLength(50);
            entity.Property(e => e.ParentLevel).HasMaxLength(50);
            entity.Property(e => e.PromotionDemotionDate).HasColumnType("datetime");
            entity.Property(e => e.UpdatedBy).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<VwReportingTxnRecruitment>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("VW_Reporting_TXN_Recruitment");

            entity.Property(e => e.AddressCity).HasMaxLength(80);
            entity.Property(e => e.AddressCountry).HasMaxLength(30);
            entity.Property(e => e.AddressLine1).HasMaxLength(150);
            entity.Property(e => e.AddressLine2).HasMaxLength(150);
            entity.Property(e => e.AddressLine3).HasMaxLength(150);
            entity.Property(e => e.AddressPostCode).HasMaxLength(20);
            entity.Property(e => e.AddressState).HasMaxLength(100);
            entity.Property(e => e.AdvertisementTitle).HasMaxLength(50);
            entity.Property(e => e.BadgeNo).HasMaxLength(50);
            entity.Property(e => e.BankAccountName).HasMaxLength(100);
            entity.Property(e => e.BankAccountNo).HasMaxLength(50);
            entity.Property(e => e.BankBranch).HasMaxLength(200);
            entity.Property(e => e.BankCountryCode)
                .HasMaxLength(200)
                .IsUnicode(false);
            entity.Property(e => e.BankName).HasMaxLength(200);
            entity.Property(e => e.BankSwiftCode).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Dob).HasColumnType("datetime");
            entity.Property(e => e.EducationLevel).HasMaxLength(50);
            entity.Property(e => e.Email).HasMaxLength(150);
            entity.Property(e => e.EmergencyContactPerson).HasMaxLength(150);
            entity.Property(e => e.EmergencyContactPhoneNumber).HasMaxLength(20);
            entity.Property(e => e.EmergencyContactRelationship).HasMaxLength(20);
            entity.Property(e => e.FirstName)
                .IsRequired()
                .HasMaxLength(100);
            entity.Property(e => e.Gender).HasMaxLength(6);
            entity.Property(e => e.Ic).HasMaxLength(30);
            entity.Property(e => e.LastName).HasMaxLength(100);
            entity.Property(e => e.LocalFirstName).HasMaxLength(255);
            entity.Property(e => e.LocalLastName).HasMaxLength(50);
            entity.Property(e => e.Mccountry)
                .HasMaxLength(10)
                .HasColumnName("MCCountry");
            entity.Property(e => e.Mcid).HasColumnName("MCId");
            entity.Property(e => e.Mcname)
                .HasMaxLength(150)
                .HasColumnName("MCName");
            entity.Property(e => e.Mcstatus)
                .HasMaxLength(10)
                .HasColumnName("MCStatus");
            entity.Property(e => e.MiddleName).HasMaxLength(100);
            entity.Property(e => e.Nationality)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.Nickname).HasMaxLength(100);
            entity.Property(e => e.PassportExpiredDate).HasColumnType("datetime");
            entity.Property(e => e.PassportIssueCountry).HasMaxLength(50);
            entity.Property(e => e.PassportIssueDate).HasColumnType("datetime");
            entity.Property(e => e.PassportName).HasMaxLength(150);
            entity.Property(e => e.PassportNo).HasMaxLength(30);
            entity.Property(e => e.PhoneNumber).HasMaxLength(50);
            entity.Property(e => e.RecruiterBadgeNoOrName).HasMaxLength(100);
            entity.Property(e => e.RecruitmentSource).HasMaxLength(50);
            entity.Property(e => e.RecruitmentSubSource).HasMaxLength(50);
            entity.Property(e => e.RecruitmentType).HasMaxLength(25);
            entity.Property(e => e.Status)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.TeamName).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<VwReportingTxnRecruitmentArchived>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("VW_Reporting_TXN_Recruitment_Archived");

            entity.Property(e => e.ActivityAppointment).HasMaxLength(50);
            entity.Property(e => e.ActivityConductedBy).HasMaxLength(250);
            entity.Property(e => e.ActivityCreatedDate).HasColumnType("datetime");
            entity.Property(e => e.ActivityDescription).HasMaxLength(50);
            entity.Property(e => e.ActivityNotSucceedReason).HasMaxLength(50);
            entity.Property(e => e.ActivityScheduleEndDateTime).HasColumnType("datetime");
            entity.Property(e => e.ActivityScheduleStartDateTime).HasColumnType("datetime");
            entity.Property(e => e.ActivityStage).HasMaxLength(50);
            entity.Property(e => e.ActivityUnsuitableStatus).HasMaxLength(50);
            entity.Property(e => e.ActivityUpdatedDate).HasColumnType("datetime");
            entity.Property(e => e.AddressCity).HasMaxLength(80);
            entity.Property(e => e.AddressCountry).HasMaxLength(30);
            entity.Property(e => e.AddressLine1).HasMaxLength(150);
            entity.Property(e => e.AddressLine2).HasMaxLength(150);
            entity.Property(e => e.AddressLine3).HasMaxLength(150);
            entity.Property(e => e.AddressPostCode).HasMaxLength(20);
            entity.Property(e => e.AddressState).HasMaxLength(100);
            entity.Property(e => e.AdvertisementTitle).HasMaxLength(50);
            entity.Property(e => e.BadgeNo).HasMaxLength(50);
            entity.Property(e => e.BankAccountName).HasMaxLength(100);
            entity.Property(e => e.BankAccountNo).HasMaxLength(50);
            entity.Property(e => e.BankBranch).HasMaxLength(200);
            entity.Property(e => e.BankCountryCode)
                .HasMaxLength(200)
                .IsUnicode(false);
            entity.Property(e => e.BankName).HasMaxLength(200);
            entity.Property(e => e.BankSwiftCode).HasMaxLength(50);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.Dob).HasColumnType("datetime");
            entity.Property(e => e.EducationLevel).HasMaxLength(50);
            entity.Property(e => e.Email).HasMaxLength(150);
            entity.Property(e => e.EmergencyContactPerson).HasMaxLength(150);
            entity.Property(e => e.EmergencyContactPhoneNumber).HasMaxLength(20);
            entity.Property(e => e.EmergencyContactRelationship).HasMaxLength(20);
            entity.Property(e => e.FirstName)
                .IsRequired()
                .HasMaxLength(100);
            entity.Property(e => e.Gender).HasMaxLength(6);
            entity.Property(e => e.Ic).HasMaxLength(30);
            entity.Property(e => e.LastName).HasMaxLength(100);
            entity.Property(e => e.LocalFirstName).HasMaxLength(255);
            entity.Property(e => e.LocalLastName).HasMaxLength(50);
            entity.Property(e => e.Mccountry)
                .HasMaxLength(10)
                .HasColumnName("MCCountry");
            entity.Property(e => e.Mcid).HasColumnName("MCId");
            entity.Property(e => e.Mcname)
                .HasMaxLength(150)
                .HasColumnName("MCName");
            entity.Property(e => e.Mcstatus)
                .HasMaxLength(10)
                .HasColumnName("MCStatus");
            entity.Property(e => e.MiddleName).HasMaxLength(100);
            entity.Property(e => e.Nationality)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.Nickname).HasMaxLength(100);
            entity.Property(e => e.PassportExpiredDate).HasColumnType("datetime");
            entity.Property(e => e.PassportIssueCountry).HasMaxLength(50);
            entity.Property(e => e.PassportIssueDate).HasColumnType("datetime");
            entity.Property(e => e.PassportName).HasMaxLength(150);
            entity.Property(e => e.PassportNo).HasMaxLength(30);
            entity.Property(e => e.PhoneNumber).HasMaxLength(50);
            entity.Property(e => e.RecruiterBadgeNoOrName).HasMaxLength(100);
            entity.Property(e => e.RecruitmentSource).HasMaxLength(50);
            entity.Property(e => e.RecruitmentSubSource).HasMaxLength(50);
            entity.Property(e => e.RecruitmentType).HasMaxLength(25);
            entity.Property(e => e.Status)
                .IsRequired()
                .HasMaxLength(50);
            entity.Property(e => e.TeamName).HasMaxLength(50);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<VwUsersPreview>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("VW_UsersPreview");

            entity.Property(e => e.CountryAccess).HasMaxLength(50);
            entity.Property(e => e.CountryCode).HasMaxLength(10);
            entity.Property(e => e.Email)
                .IsRequired()
                .HasMaxLength(150);
            entity.Property(e => e.Fullname)
                .IsRequired()
                .HasMaxLength(300);
            entity.Property(e => e.McCode).HasMaxLength(10);
            entity.Property(e => e.McName).HasMaxLength(150);
            entity.Property(e => e.Role).HasMaxLength(300);
            entity.Property(e => e.UserId)
                .IsRequired()
                .HasMaxLength(35);
            entity.Property(e => e.UserPassword)
                .IsRequired()
                .HasMaxLength(255);
            entity.Property(e => e.Username)
                .IsRequired()
                .HasMaxLength(50);
        });

        modelBuilder.Entity<YtCampaign>(entity =>
        {
            entity
                .HasNoKey()
                .ToTable("YT_Campaign");

            entity.Property(e => e.CountryId).HasColumnName("countryId");
            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Identifier)
                .HasMaxLength(100)
                .HasColumnName("identifier");
            entity.Property(e => e.Name)
                .HasMaxLength(200)
                .HasColumnName("name");
        });

        modelBuilder.Entity<YtMarketingCompany>(entity =>
        {
            entity.ToTable("YT_MarketingCompany");

            entity.Property(e => e.Id)
                .ValueGeneratedNever()
                .HasColumnName("id");
            entity.Property(e => e.McId)
                .HasMaxLength(50)
                .HasColumnName("mcId");
            entity.Property(e => e.McPin)
                .HasMaxLength(50)
                .HasColumnName("mcPin");
            entity.Property(e => e.Name)
                .HasMaxLength(200)
                .HasColumnName("name");
        });

        modelBuilder.Entity<YtUser>(entity =>
        {
            entity.ToTable("YT_User");

            entity.Property(e => e.Id)
                .ValueGeneratedNever()
                .HasColumnName("id");
            entity.Property(e => e.ActiveStatusId).HasColumnName("activeStatusId");
            entity.Property(e => e.CompanyId).HasColumnName("companyId");
            entity.Property(e => e.Email)
                .HasMaxLength(100)
                .HasColumnName("email");
            entity.Property(e => e.Forename)
                .HasMaxLength(100)
                .HasColumnName("forename");
            entity.Property(e => e.Surname)
                .HasMaxLength(100)
                .HasColumnName("surname");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
