namespace StudentRegistration.Models;

/// <summary>Model untuk merepresentasikan satu program studi.</summary>
public class Program
{
    public int ProgramId { get; set; }
    public string ProgramCode { get; set; } = string.Empty;
    public string ProgramName { get; set; } = string.Empty;
    public bool IsActive { get; set; }
    public DateTime CreatedAt { get; set; }
}
