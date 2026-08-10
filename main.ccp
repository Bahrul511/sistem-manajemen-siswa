#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <sstream>
#include <iomanip>

using namespace std;

// Struktur data siswa
struct Siswa {
    string nis;
    string nama;
    int umur;
    string jurusan;
};

// Nama file penyimpanan
const string NAMA_FILE = "siswa.txt";

// ======================================================
// FUNGSI MEMBACA DATA DARI FILE
// ======================================================
vector<Siswa> bacaData() {
    vector<Siswa> daftarSiswa;
    ifstream file(NAMA_FILE);

    if (!file.is_open()) {
        return daftarSiswa;
    }

    string baris;

    while (getline(file, baris)) {
        if (baris.empty()) {
            continue;
        }

        stringstream ss(baris);
        string umurString;

        Siswa siswa;

        getline(ss, siswa.nis, '|');
        getline(ss, siswa.nama, '|');
        getline(ss, umurString, '|');
        getline(ss, siswa.jurusan, '|');

        try {
            siswa.umur = stoi(umurString);
            daftarSiswa.push_back(siswa);
        } catch (...) {
            // Abaikan data yang formatnya tidak valid
        }
    }

    file.close();

    return daftarSiswa;
}

// ======================================================
// FUNGSI MENYIMPAN DATA KE FILE
// ======================================================
void simpanData(const vector<Siswa>& daftarSiswa) {
    ofstream file(NAMA_FILE);

    if (!file.is_open()) {
        cout << "\nGagal membuka file penyimpanan!\n";
        return;
    }

    for (const Siswa& siswa : daftarSiswa) {
        file << siswa.nis << "|"
             << siswa.nama << "|"
             << siswa.umur << "|"
             << siswa.jurusan << endl;
    }

    file.close();
}

// ======================================================
// MENCARI INDEX SISWA BERDASARKAN NIS
// ======================================================
int cariSiswa(const vector<Siswa>& daftarSiswa, const string& nis) {
    for (int i = 0; i < daftarSiswa.size(); i++) {
        if (daftarSiswa[i].nis == nis) {
            return i;
        }
    }

    return -1;
}

// ======================================================
// MENAMBAHKAN DATA SISWA
// ======================================================
void tambahSiswa(vector<Siswa>& daftarSiswa) {
    Siswa siswa;

    cout << "\n========================================\n";
    cout << "          TAMBAH DATA SISWA\n";
    cout << "========================================\n";

    cout << "Masukkan NIS     : ";
    getline(cin, siswa.nis);

    // Cek NIS agar tidak duplikat
    if (cariSiswa(daftarSiswa, siswa.nis) != -1) {
        cout << "\nNIS tersebut sudah terdaftar!\n";
        return;
    }

    cout << "Masukkan Nama    : ";
    getline(cin, siswa.nama);

    cout << "Masukkan Umur    : ";
    string umurInput;
    getline(cin, umurInput);

    try {
        siswa.umur = stoi(umurInput);
    } catch (...) {
        cout << "\nUmur harus berupa angka!\n";
        return;
    }

    if (siswa.umur <= 0) {
        cout << "\nUmur tidak valid!\n";
        return;
    }

    cout << "Masukkan Jurusan : ";
    getline(cin, siswa.jurusan);

    daftarSiswa.push_back(siswa);

    simpanData(daftarSiswa);

    cout << "\nData siswa berhasil ditambahkan!\n";
}

// ======================================================
// MENAMPILKAN DATA SISWA
// ======================================================
void tampilkanSiswa(const vector<Siswa>& daftarSiswa) {
    cout << "\n====================================================================\n";
    cout << "                     DATA SELURUH SISWA\n";
    cout << "====================================================================\n";

    if (daftarSiswa.empty()) {
        cout << "Belum ada data siswa.\n";
        cout << "====================================================================\n";
        return;
    }

    cout << left
         << setw(5)  << "No"
         << setw(15) << "NIS"
         << setw(25) << "Nama"
         << setw(10) << "Umur"
         << setw(25) << "Jurusan"
         << endl;

    cout << "--------------------------------------------------------------------\n";

    for (int i = 0; i < daftarSiswa.size(); i++) {
        cout << left
             << setw(5)  << i + 1
             << setw(15) << daftarSiswa[i].nis
             << setw(25) << daftarSiswa[i].nama
             << setw(10) << daftarSiswa[i].umur
             << setw(25) << daftarSiswa[i].jurusan
             << endl;
    }

    cout << "====================================================================\n";
}

// ======================================================
// MENGUPDATE DATA SISWA
// ======================================================
void updateSiswa(vector<Siswa>& daftarSiswa) {
    cout << "\n========================================\n";
    cout << "           UPDATE DATA SISWA\n";
    cout << "========================================\n";

    string nis;
    cout << "Masukkan NIS siswa yang ingin diubah: ";
    getline(cin, nis);

    int index = cariSiswa(daftarSiswa, nis);

    if (index == -1) {
        cout << "\nData siswa dengan NIS tersebut tidak ditemukan!\n";
        return;
    }

    cout << "\nData saat ini:\n";
    cout << "NIS     : " << daftarSiswa[index].nis << endl;
    cout << "Nama    : " << daftarSiswa[index].nama << endl;
    cout << "Umur    : " << daftarSiswa[index].umur << endl;
    cout << "Jurusan : " << daftarSiswa[index].jurusan << endl;

    cout << "\nMasukkan data baru.\n";

    cout << "Nama baru    : ";
    getline(cin, daftarSiswa[index].nama);

    cout << "Umur baru    : ";
    string umurInput;
    getline(cin, umurInput);

    try {
        int umurBaru = stoi(umurInput);

        if (umurBaru <= 0) {
            cout << "\nUmur tidak valid!\n";
            return;
        }

        daftarSiswa[index].umur = umurBaru;

    } catch (...) {
        cout << "\nUmur harus berupa angka!\n";
        return;
    }

    cout << "Jurusan baru : ";
    getline(cin, daftarSiswa[index].jurusan);

    simpanData(daftarSiswa);

    cout << "\nData siswa berhasil diperbarui!\n";
}

// ======================================================
// MENGHAPUS DATA SISWA
// ======================================================
void hapusSiswa(vector<Siswa>& daftarSiswa) {
    cout << "\n========================================\n";
    cout << "           HAPUS DATA SISWA\n";
    cout << "========================================\n";

    string nis;

    cout << "Masukkan NIS siswa yang ingin dihapus: ";
    getline(cin, nis);

    int index = cariSiswa(daftarSiswa, nis);

    if (index == -1) {
        cout << "\nData siswa tidak ditemukan!\n";
        return;
    }

    cout << "\nData yang akan dihapus:\n";
    cout << "NIS     : " << daftarSiswa[index].nis << endl;
    cout << "Nama    : " << daftarSiswa[index].nama << endl;
    cout << "Umur    : " << daftarSiswa[index].umur << endl;
    cout << "Jurusan : " << daftarSiswa[index].jurusan << endl;

    cout << "\nApakah Anda yakin ingin menghapus data ini? (y/n): ";

    string konfirmasi;
    getline(cin, konfirmasi);

    if (konfirmasi == "y" || konfirmasi == "Y") {

        daftarSiswa.erase(daftarSiswa.begin() + index);

        simpanData(daftarSiswa);

        cout << "\nData siswa berhasil dihapus!\n";

    } else {
        cout << "\nPenghapusan dibatalkan.\n";
    }
}

// ======================================================
// MENU UTAMA
// ======================================================
void tampilkanMenu() {
    cout << "\n";
    cout << "===============================================\n";
    cout << "          SISTEM MANAJEMEN SISWA\n";
    cout << "===============================================\n";
    cout << "1. Tambah Data Siswa\n";
    cout << "2. Tampilkan Data Siswa\n";
    cout << "3. Update Data Siswa\n";
    cout << "4. Hapus Data Siswa\n";
    cout << "5. Keluar\n";
    cout << "===============================================\n";
    cout << "Pilih menu: ";
}

// ======================================================
// PROGRAM UTAMA
// ======================================================
int main() {

    vector<Siswa> daftarSiswa = bacaData();

    string pilihan;

    cout << "===============================================\n";
    cout << "     SELAMAT DATANG DI SISTEM MANAJEMEN SISWA\n";
    cout << "===============================================\n";

    do {

        tampilkanMenu();
        getline(cin, pilihan);

        if (pilihan == "1") {

            tambahSiswa(daftarSiswa);

        } else if (pilihan == "2") {

            tampilkanSiswa(daftarSiswa);

        } else if (pilihan == "3") {

            updateSiswa(daftarSiswa);

        } else if (pilihan == "4") {

            hapusSiswa(daftarSiswa);

        } else if (pilihan == "5") {

            cout << "\n===============================================\n";
            cout << "Terima kasih telah menggunakan program ini.\n";
            cout << "Program selesai.\n";
            cout << "===============================================\n";

        } else {

            cout << "\nPilihan tidak tersedia!\n";
            cout << "Silakan pilih menu 1 - 5.\n";
        }

    } while (pilihan != "5");

    return 0;
}
