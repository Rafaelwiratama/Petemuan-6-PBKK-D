# Checklist Pengujian - Pertemuan 6

Isi status dan bukti berdasarkan hasil aktual. Jangan menandai lulus sebelum diuji.

| No. | Pengujian | Cara | Hasil yang diharapkan | Status |
|---:|---|---|---|---|
| 1 | Koneksi SQL Server | Hubungkan SQL Server Object Explorer ke `(localdb)\MSSQLLocalDB` | Server tampil dan status connected | Belum diuji |
| 2 | Database | Jalankan `StudentRegistrationDB.sql` | Database `StudentRegistrationDB` dibuat | Belum diuji |
| 3 | Tabel Programs | Expand Tables dan View Data | `dbo.Programs` dan 5 program studi tersedia | Belum diuji |
| 4 | Tabel Students | Expand Tables dan View Data | `dbo.Students` dan 5 mahasiswa awal tersedia | Belum diuji |
| 5 | PK | Periksa struktur/keys `Programs` dan `Students` | Primary key pada ProgramId dan StudentId | Belum diuji |
| 6 | UNIQUE ProgramCode | Insert kode program yang sudah ada (uji terpisah) | SQL Server menolak duplikasi | Belum diuji |
| 7 | UNIQUE NIM | Jalankan bagian UNIQUE pada QueryChallenges | SQL Server menolak NIM duplikat | Belum diuji |
| 8 | FOREIGN KEY | Jalankan bagian FK pada QueryChallenges | SQL Server menolak ProgramId 99 | Belum diuji |
| 9 | INNER JOIN | Jalankan query join | Data mahasiswa tampil beserta ProgramName | Belum diuji |
| 10 | WHERE | Jalankan filter ProgramCode TI | Hanya mahasiswa Teknik Informatika tampil | Belum diuji |
| 11 | COUNT | Jalankan `SELECT COUNT(*)` | Total sesuai jumlah baris Students | Belum diuji |
| 12 | GROUP BY | Jalankan LEFT JOIN + GROUP BY | Jumlah mahasiswa per program tampil | Belum diuji |
| 13 | Mini assignment | Jalankan insert 3 NIM tambahan | Tiga mahasiswa baru masuk tanpa duplikasi | Belum diuji |
| 14 | WPF startup | Jalankan F5 | Jendela Student Registration terbuka | Belum diuji |
| 15 | ADO.NET read | Amati DataGrid | Data dari INNER JOIN tampil | Belum diuji |
| 16 | Total count | Amati counter | Jumlah mahasiswa sesuai database | Belum diuji |
| 17 | Refresh | Klik Refresh Data | Data dimuat ulang tanpa error | Belum diuji |

## Bukti screenshot yang disarankan

- `01-sql-server-connected.png`
- `02-database-studentregistrationdb.png`
- `03-table-programs.png`
- `04-table-students.png`
- `05-query-inner-join.png`
- `06-query-count-groupby.png`
- `07-wpf-datagrid.png`
- `08-wpf-refresh.png`
