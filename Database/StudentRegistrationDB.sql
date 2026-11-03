/*
    HANDS-ON LAB 1 - Student Registration Database
    Database : StudentRegistrationDB
    Tables   : Programs (parent), Students (child)
    Relation : One-to-Many (Programs 1 -> N Students)

    Script dibuat idempotent: tidak menghapus database/tabel yang sudah ada.
    Jalankan melalui SSMS atau SQL Server Object Explorer > New Query.
*/

IF DB_ID(N'StudentRegistrationDB') IS NULL
BEGIN
    CREATE DATABASE StudentRegistrationDB;
END;
GO

USE StudentRegistrationDB;
GO

/* 1. Master table: Programs */
IF OBJECT_ID(N'dbo.Programs', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Programs
    (
        ProgramId INT IDENTITY(1,1)
            CONSTRAINT PK_Programs PRIMARY KEY,
        ProgramCode VARCHAR(20) NOT NULL
            CONSTRAINT UQ_Programs_ProgramCode UNIQUE,
        ProgramName VARCHAR(100) NOT NULL,
        IsActive BIT NOT NULL
            CONSTRAINT DF_Programs_IsActive DEFAULT (1),
        CreatedAt DATETIME2 NOT NULL
            CONSTRAINT DF_Programs_CreatedAt DEFAULT (SYSDATETIME())
    );
END;
GO

/* 2. Seed Programs only when ProgramCode does not exist */
INSERT INTO dbo.Programs (ProgramCode, ProgramName, IsActive)
SELECT v.ProgramCode, v.ProgramName, 1
FROM (VALUES
    ('TI',  'Teknik Informatika'),
    ('SI',  'Sistem Informasi'),
    ('MNJ', 'Manajemen'),
    ('TE',  'Teknik Elektro'),
    ('DKV', 'Desain Komunikasi Visual')
) AS v(ProgramCode, ProgramName)
WHERE NOT EXISTS
(
    SELECT 1 FROM dbo.Programs AS p WHERE p.ProgramCode = v.ProgramCode
);
GO

/* 3. Transaction table: Students */
IF OBJECT_ID(N'dbo.Students', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Students
    (
        StudentId INT IDENTITY(1,1)
            CONSTRAINT PK_Students PRIMARY KEY,
        NIM VARCHAR(20) NOT NULL
            CONSTRAINT UQ_Students_NIM UNIQUE,
        Name VARCHAR(100) NOT NULL,
        ProgramId INT NOT NULL,
        BirthDate DATE NULL,
        Address VARCHAR(250) NULL,
        PhoneNumber VARCHAR(20) NULL,
        CreatedAt DATETIME2 NOT NULL
            CONSTRAINT DF_Students_CreatedAt DEFAULT (SYSDATETIME()),
        UpdatedAt DATETIME2 NULL,
        CONSTRAINT FK_Students_Programs
            FOREIGN KEY (ProgramId) REFERENCES dbo.Programs(ProgramId)
    );
END;
GO

/* 4. Seed five initial students only when NIM does not exist */
INSERT INTO dbo.Students (NIM, Name, ProgramId, BirthDate, Address, PhoneNumber)
SELECT v.NIM, v.Name, p.ProgramId, v.BirthDate, v.Address, v.PhoneNumber
FROM (VALUES
    ('20231001', 'Ahmad Rizki',  'TI',  CONVERT(date, '20030312', 112), 'Jl. Merdeka No. 123, Surabaya',       '081234567890'),
    ('20231002', 'Siti Aisyah',  'SI',  CONVERT(date, '20040721', 112), 'Jl. Diponegoro No. 45, Surabaya',    '082233445566'),
    ('20231003', 'Budi Santoso', 'TI',  CONVERT(date, '20031105', 112), 'Jl. Ahmad Yani No. 10, Surabaya',    '081355667788'),
    ('20231004', 'Citra Lestari','MNJ', CONVERT(date, '20040118', 112), 'Jl. Darmo No. 20, Surabaya',         '089900112233'),
    ('20231005', 'Dimas Prayoga','TE',  CONVERT(date, '20030927', 112), 'Jl. Raya ITS, Surabaya',             '081288776655')
) AS v(NIM, Name, ProgramCode, BirthDate, Address, PhoneNumber)
INNER JOIN dbo.Programs AS p ON p.ProgramCode = v.ProgramCode
WHERE NOT EXISTS
(
    SELECT 1 FROM dbo.Students AS s WHERE s.NIM = v.NIM
);
GO

/* 5. Basic verification */
SELECT DB_NAME() AS CurrentDatabase;
SELECT * FROM dbo.Programs ORDER BY ProgramId;
SELECT * FROM dbo.Students ORDER BY StudentId;
GO
