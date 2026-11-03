/* Jalankan setelah StudentRegistrationDB.sql */
USE StudentRegistrationDB;
GO

-- 1. Tampilkan seluruh data mahasiswa
SELECT * FROM dbo.Students ORDER BY StudentId;
GO

-- 2. Tampilkan seluruh program studi
SELECT * FROM dbo.Programs ORDER BY ProgramId;
GO

-- 3. INNER JOIN: mahasiswa beserta kode dan nama program studi
SELECT
    s.StudentId, s.NIM, s.Name,
    p.ProgramCode, p.ProgramName,
    s.BirthDate, s.Address, s.PhoneNumber,
    s.CreatedAt, s.UpdatedAt
FROM dbo.Students AS s
INNER JOIN dbo.Programs AS p ON s.ProgramId = p.ProgramId
ORDER BY s.StudentId;
GO

-- 4. WHERE: mahasiswa Teknik Informatika
SELECT s.NIM, s.Name, p.ProgramName
FROM dbo.Students AS s
INNER JOIN dbo.Programs AS p ON s.ProgramId = p.ProgramId
WHERE p.ProgramCode = 'TI';
GO

-- 5. COUNT: total mahasiswa
SELECT COUNT(*) AS TotalMahasiswa FROM dbo.Students;
GO

-- 6. LEFT JOIN + GROUP BY: jumlah mahasiswa per program studi (termasuk program tanpa mahasiswa)
SELECT p.ProgramName, COUNT(s.StudentId) AS JumlahMahasiswa
FROM dbo.Programs AS p
LEFT JOIN dbo.Students AS s ON p.ProgramId = s.ProgramId
GROUP BY p.ProgramId, p.ProgramName
ORDER BY p.ProgramId;
GO

-- 7. Mini assignment: tambahkan tiga mahasiswa baru jika NIM belum ada
INSERT INTO dbo.Students (NIM, Name, ProgramId, BirthDate, Address, PhoneNumber)
SELECT v.NIM, v.Name, p.ProgramId, v.BirthDate, v.Address, v.PhoneNumber
FROM (VALUES
    ('20231006', 'Nadia Putri',  'TI', CONVERT(date, '20040514', 112), 'Jl. Ketintang, Surabaya', '081234567801'),
    ('20231007', 'Rafi Pratama','SI', CONVERT(date, '20031209', 112), 'Jl. Manyar, Surabaya',    '081234567802'),
    ('20231008', 'Maya Anindita','TE',CONVERT(date, '20040830', 112), 'Jl. Keputih, Surabaya',   '081234567803')
) AS v(NIM, Name, ProgramCode, BirthDate, Address, PhoneNumber)
INNER JOIN dbo.Programs AS p ON p.ProgramCode = v.ProgramCode
WHERE NOT EXISTS (SELECT 1 FROM dbo.Students AS s WHERE s.NIM = v.NIM);
GO

-- 8. Mini assignment output: join, then order by student name
SELECT s.NIM, s.Name, p.ProgramName, s.BirthDate, s.PhoneNumber
FROM dbo.Students AS s
INNER JOIN dbo.Programs AS p ON s.ProgramId = p.ProgramId
ORDER BY s.Name;
GO

-- 9. Foreign Key test: expected to fail because ProgramId 99 does not exist.
-- Run separately. TRY/CATCH displays the expected constraint error without aborting the script.
BEGIN TRY
    INSERT INTO dbo.Students (NIM, Name, ProgramId)
    VALUES ('TEST-FK-999', 'Uji Foreign Key', 99);
    PRINT 'UNEXPECTED: invalid ProgramId was accepted.';
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ExpectedForeignKeyError;
END CATCH;
GO

-- 10. UNIQUE NIM test: expected to fail because NIM 20231001 already exists.
BEGIN TRY
    INSERT INTO dbo.Students (NIM, Name, ProgramId)
    VALUES ('20231001', 'Uji NIM Duplikat', (SELECT TOP 1 ProgramId FROM dbo.Programs ORDER BY ProgramId));
    PRINT 'UNEXPECTED: duplicate NIM was accepted.';
END TRY
BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ExpectedUniqueError;
END CATCH;
GO

-- 11. Final total
SELECT COUNT(*) AS TotalMahasiswa FROM dbo.Students;
GO
