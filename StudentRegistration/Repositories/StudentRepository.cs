using Microsoft.Data.SqlClient;
using StudentRegistration.Models;

namespace StudentRegistration.Repositories;

/// <summary>
/// Data access layer untuk membaca data Programs dan Students dari SQL Server
/// menggunakan ADO.NET: SqlConnection, SqlCommand, dan SqlDataReader.
/// </summary>
public sealed class StudentRepository
{
    // Pengguna dapat mengganti server melalui environment variable tanpa mengubah kode.
    // Default disesuaikan dengan komputer pengembang yang memakai SQL Server LocalDB.
    private readonly string _connectionString =
        Environment.GetEnvironmentVariable("STUDENT_REGISTRATION_SQL_CONNECTION")
        ?? @"Server=(localdb)\MSSQLLocalDB;Database=StudentRegistrationDB;Integrated Security=True;TrustServerCertificate=True;";

    public List<Student> GetAll()
    {
        var students = new List<Student>();

        const string sql = @"
            SELECT
                s.StudentId,
                s.NIM,
                s.Name,
                s.ProgramId,
                p.ProgramName,
                s.BirthDate,
                s.Address,
                s.PhoneNumber,
                s.CreatedAt,
                s.UpdatedAt
            FROM dbo.Students AS s
            INNER JOIN dbo.Programs AS p
                ON s.ProgramId = p.ProgramId
            ORDER BY s.StudentId;";

        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand(sql, connection);

        connection.Open();
        using var reader = command.ExecuteReader();

        int studentIdOrdinal = reader.GetOrdinal("StudentId");
        int nimOrdinal = reader.GetOrdinal("NIM");
        int nameOrdinal = reader.GetOrdinal("Name");
        int programIdOrdinal = reader.GetOrdinal("ProgramId");
        int programNameOrdinal = reader.GetOrdinal("ProgramName");
        int birthDateOrdinal = reader.GetOrdinal("BirthDate");
        int addressOrdinal = reader.GetOrdinal("Address");
        int phoneOrdinal = reader.GetOrdinal("PhoneNumber");
        int createdAtOrdinal = reader.GetOrdinal("CreatedAt");
        int updatedAtOrdinal = reader.GetOrdinal("UpdatedAt");

        while (reader.Read())
        {
            students.Add(new Student
            {
                StudentId = reader.GetInt32(studentIdOrdinal),
                NIM = reader.GetString(nimOrdinal),
                Name = reader.GetString(nameOrdinal),
                ProgramId = reader.GetInt32(programIdOrdinal),
                ProgramName = reader.GetString(programNameOrdinal),
                BirthDate = reader.IsDBNull(birthDateOrdinal)
                    ? null
                    : reader.GetDateTime(birthDateOrdinal),
                Address = reader.IsDBNull(addressOrdinal)
                    ? string.Empty
                    : reader.GetString(addressOrdinal),
                PhoneNumber = reader.IsDBNull(phoneOrdinal)
                    ? string.Empty
                    : reader.GetString(phoneOrdinal),
                CreatedAt = reader.GetDateTime(createdAtOrdinal),
                UpdatedAt = reader.IsDBNull(updatedAtOrdinal)
                    ? null
                    : reader.GetDateTime(updatedAtOrdinal)
            });
        }

        return students;
    }

    public List<Program> GetPrograms()
    {
        var programs = new List<Program>();
        const string sql = @"
            SELECT ProgramId, ProgramCode, ProgramName, IsActive, CreatedAt
            FROM dbo.Programs
            ORDER BY ProgramId;";

        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand(sql, connection);
        connection.Open();
        using var reader = command.ExecuteReader();

        while (reader.Read())
        {
            programs.Add(new Program
            {
                ProgramId = reader.GetInt32(reader.GetOrdinal("ProgramId")),
                ProgramCode = reader.GetString(reader.GetOrdinal("ProgramCode")),
                ProgramName = reader.GetString(reader.GetOrdinal("ProgramName")),
                IsActive = reader.GetBoolean(reader.GetOrdinal("IsActive")),
                CreatedAt = reader.GetDateTime(reader.GetOrdinal("CreatedAt"))
            });
        }

        return programs;
    }

    public int GetTotalStudents()
    {
        const string sql = "SELECT COUNT(*) FROM dbo.Students;";
        using var connection = new SqlConnection(_connectionString);
        using var command = new SqlCommand(sql, connection);
        connection.Open();
        return Convert.ToInt32(command.ExecuteScalar());
    }
}
