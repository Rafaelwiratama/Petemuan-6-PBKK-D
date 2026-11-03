using System.Windows;
using StudentRegistration.Repositories;

namespace StudentRegistration;

public partial class MainWindow : Window
{
    private readonly StudentRepository _studentRepository;

    public MainWindow()
    {
        InitializeComponent();
        _studentRepository = new StudentRepository();
        LoadStudents();
    }

    private void LoadStudents()
    {
        try
        {
            StatusText.Text = "Mengambil data dari SQL Server...";
            var students = _studentRepository.GetAll();
            StudentDataGrid.ItemsSource = students;
            TotalStudentsText.Text = _studentRepository.GetTotalStudents().ToString();
            StatusText.Text = $"Berhasil memuat {students.Count} baris dari StudentRegistrationDB.";
        }
        catch (Exception ex)
        {
            StatusText.Text = "Gagal memuat data. Periksa koneksi database.";
            MessageBox.Show(
                "Aplikasi tidak dapat mengambil data dari SQL Server.\n\n" +
                "Periksa apakah database StudentRegistrationDB sudah dibuat dan connection string sesuai.\n\n" +
                $"Detail: {ex.Message}",
                "Database Connection Error",
                MessageBoxButton.OK,
                MessageBoxImage.Error);
        }
    }

    private void RefreshButton_Click(object sender, RoutedEventArgs e)
    {
        LoadStudents();
    }
}
