# Pertemuan 6 - Student Registration (SQL Server + WPF + ADO.NET)

Proyek ini mengikuti dua Hands-On Lab:

1. **HOL Database:** membuat `StudentRegistrationDB`, tabel `Programs` dan `Students`, relasi 1:N, constraints, seed data, serta latihan query SQL.
2. **HOL WPF + ADO.NET:** membuat aplikasi WPF yang mengambil data `Students` melalui `StudentRepository` dan menampilkannya pada `DataGrid` dengan tombol Refresh.

> Catatan lingkungan Rafael: screenshot sebelumnya menunjukkan SQL Server LocalDB `(localdb)\MSSQLLocalDB`. PDF memberikan contoh `.<backslash>SQLEXPRESS`; karena itu connection string proyek ini disesuaikan ke LocalDB yang sudah tersedia. Nama database dan struktur tabel tetap mengikuti HOL, yaitu `StudentRegistrationDB`, `Programs`, dan `Students`. Database Pertemuan 5 `StudentManagementDB` tidak diubah.

## Teknologi

- C# dan WPF
- .NET 8 (`net8.0-windows`)
- ADO.NET melalui `Microsoft.Data.SqlClient` 7.1.1
- SQL Server LocalDB
- Visual Studio untuk Windows

## Struktur proyek

```text
StudentRegistration_Pertemuan6/
├── Database/
│   ├── StudentRegistrationDB.sql
│   └── QueryChallenges.sql
├── StudentRegistration/
│   ├── Models/
│   │   ├── Student.cs
│   │   └── Program.cs
│   ├── Repositories/
│   │   └── StudentRepository.cs
│   ├── App.xaml
│   ├── App.xaml.cs
│   ├── MainWindow.xaml
│   ├── MainWindow.xaml.cs
│   └── StudentRegistration.csproj
├── docs/
│   └── TEST_SCENARIOS.md
├── StudentRegistration.sln
└── README.md
```

## 1. Menyiapkan SQL Server LocalDB

Periksa LocalDB dari Command Prompt:

```powershell
sqllocaldb info
```

Jika instance `MSSQLLocalDB` belum aktif:

```powershell
sqllocaldb start MSSQLLocalDB
```

Buka Visual Studio → **View → SQL Server Object Explorer**. Hubungkan ke:

```text
(localdb)\MSSQLLocalDB
```

Gunakan Windows Authentication.

## 2. Membuat database dan tabel

1. Di SQL Server Object Explorer, klik kanan server LocalDB → **New Query**.
2. Buka `Database/StudentRegistrationDB.sql`.
3. Salin seluruh script ke jendela query dan tekan **Execute** (`Ctrl+Shift+E`).
4. Refresh Databases. Pastikan `StudentRegistrationDB` muncul.
5. Expand `StudentRegistrationDB → Tables`. Pastikan `dbo.Programs` dan `dbo.Students` tersedia.
6. Klik kanan tabel → **View Data** untuk memeriksa data awal.

Script aman dijalankan ulang: script tidak menghapus database/tabel yang sudah ada dan seed data memakai pengecekan sebelum insert.

## 3. Menjalankan query latihan

Buka `Database/QueryChallenges.sql` di New Query pada database yang sama. Script memuat:

- SELECT seluruh data Programs dan Students.
- INNER JOIN Students dengan Programs.
- WHERE untuk program studi Teknik Informatika.
- COUNT total mahasiswa.
- LEFT JOIN dan GROUP BY jumlah mahasiswa per program studi.
- Mini assignment penambahan tiga mahasiswa.
- Uji FOREIGN KEY dan UNIQUE NIM yang memang diharapkan ditolak SQL Server.

Uji constraint ditempatkan dalam TRY/CATCH agar pesan error yang diharapkan dapat ditampilkan sebagai hasil latihan, bukan membuat seluruh batch berhenti.

## 4. Menjalankan aplikasi WPF

1. Buka `StudentRegistration.sln` di Visual Studio.
2. Tunggu NuGet Package Restore. Package `Microsoft.Data.SqlClient` akan dipulihkan dari NuGet.
3. Pilih **Build → Rebuild Solution**.
4. Jika build berhasil, tekan **F5**.
5. Data mahasiswa akan dimuat ketika jendela dibuka. Tombol **Refresh Data** menjalankan ulang query.

Connection string default di `Repositories/StudentRepository.cs`:

```text
Server=(localdb)\MSSQLLocalDB;Database=StudentRegistrationDB;Integrated Security=True;TrustServerCertificate=True;
```

Jika memakai SQL Server Express bernama `SQLEXPRESS`, ubah server menjadi `Server=.\SQLEXPRESS;`.

Atau override tanpa mengubah source code melalui environment variable PowerShell:

```powershell
$env:STUDENT_REGISTRATION_SQL_CONNECTION = "Server=.\SQLEXPRESS;Database=StudentRegistrationDB;Trusted_Connection=True;TrustServerCertificate=True;"
```

## 5. Alur data ADO.NET

```text
WPF MainWindow
    ↓
StudentRepository.GetAll()
    ↓
SqlConnection.Open()
    ↓
SqlCommand (SELECT + INNER JOIN)
    ↓
SqlDataReader.Read()
    ↓
List<Student>
    ↓
StudentDataGrid.ItemsSource
    ↓
DataGrid menampilkan mahasiswa
```

`GetTotalStudents()` menggunakan `ExecuteScalar()` untuk mengisi counter jumlah mahasiswa. `GetPrograms()` menunjukkan pembacaan tabel Programs ke Model Program.

## 6. Pengujian yang perlu didokumentasikan

Ikuti `docs/TEST_SCENARIOS.md`. Minimal ambil screenshot:

1. SQL Server LocalDB terhubung.
2. Database `StudentRegistrationDB` muncul.
3. Tabel `Programs` dan data program studi.
4. Tabel `Students` dan data mahasiswa.
5. Hasil query INNER JOIN.
6. Hasil query COUNT dan GROUP BY.
7. Aplikasi WPF menampilkan hasil di DataGrid.
8. Tombol Refresh berhasil memuat data lagi.

## Batas cakupan

Sesuai HOL 2, aplikasi WPF pada tahap ini berfokus pada **membaca dan menampilkan data ke DataGrid serta Refresh**. CRUD penuh, MVVM, dashboard Rich UI, dan REST API muncul sebagai roadmap lab berikutnya, bukan syarat inti Lab 2. Operasi pembuatan tabel dan pengujian relasi dilakukan melalui SQL script.
