﻿CREATE TABLE [dbo].[TXN_RegionalSalesSummary_UAT] (
    [GUID]             UNIQUEIDENTIFIER NULL,
    [CountryCode]      NVARCHAR (2)     NULL,
    [TxnID]            NVARCHAR (200)   NULL,
    [Client]           NVARCHAR (50)    NULL,
    [Campaign]         NVARCHAR (50)    NULL,
    [Division]         NVARCHAR (50)    NULL,
    [MOCode]           NVARCHAR (10)    NULL,
    [BadgeNo]          NVARCHAR (10)    NULL,
    [LiveStatus]       NVARCHAR (20)    NULL,
    [Status]           NVARCHAR (50)    NULL,
    [StatusDate]       DATE             NULL,
    [StatusWeDate]     DATE             NULL,
    [DonationAmount]   DECIMAL (18, 2)  NULL,
    [Frequency]        INT              NULL,
    [SignUpDate]       DATE             NULL,
    [SignUpWeDate]     DATE             NULL,
    [SubmissionDate]   DATE             NULL,
    [SubmissionWeDate] DATE             NULL,
    [PaymentMode]      NVARCHAR (20)    NULL,
    [Channel]          NVARCHAR (10)    NULL,
    [TeritoryCode]     NVARCHAR (20)    NULL,
    [EventCode]        NVARCHAR (20)    NULL,
    [DateOfBirth]      DATE             NULL,
    [IsUnderAge]       NVARCHAR (2)     NULL,
    [Age]              INT              NULL,
    [IsDobo]           NVARCHAR (2)     NULL,
    [DoboType]         NVARCHAR (20)    NULL,
    [OwnerStroke]      DECIMAL (18, 2)  NULL,
    [ICStroke]         DECIMAL (18, 2)  NULL,
    [IsDeleted]        NVARCHAR (2)     NULL,
    [Qty]              INT              NULL,
    [RejQty]           INT              NULL,
    [ResubQty]         INT              NULL,
    [TxnCreatedDate]   DATETIME         NULL
);

