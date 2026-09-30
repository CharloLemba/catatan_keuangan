import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// =============================================================================
// Membuat sebuah kelas (Blueprint) bernama CatatanKeuangan untuk menampung data
// =============================================================================
class CatatanKeuangan {
  final int? idTransaksi;
  final String judulTransaksi;
  final int jumlahSaldo;
  final int? uangMasuk;
  final int? uangKeluar;
  final String tipeTransaksi;
  final String tanggalTransaksi;
  CatatanKeuangan({
    required this.idTransaksi,
    required this.judulTransaksi,
    required this.jumlahSaldo,
    required this.uangMasuk,
    required this.uangKeluar,
    required this.tipeTransaksi,
    required this.tanggalTransaksi,
  });

  // ====================================================================================================================================
  // Fungsi untuk mengubah objek CatatanKeuangan menjadi bentuk Map (pasangan key-value) agar bisa dibaca oleh sqflite saat Insert/Update
  // ====================================================================================================================================
  Map<String, Object?> toMap() {
    return {
      'idTransaksi': idTransaksi,
      'judulTransaksi': judulTransaksi,
      'jumlahSaldo': jumlahSaldo,
      'uangMasuk': uangMasuk,
      'uangKeluar': uangKeluar,
      'tipeTransaksi': tipeTransaksi,
      'tanggalTransaksi': tanggalTransaksi,
    };
  }

  // ========================================================================================================================
  // Konstruktor tambahan (Factory) untuk mengubah data dari format Map/Database kembali menjadi bentuk objek CatatanKeuangan
  // ========================================================================================================================
  factory CatatanKeuangan.fromMap(Map<String, dynamic> map) {
    return CatatanKeuangan(
      idTransaksi: map['idTransaksi'] as int?,
      judulTransaksi: map['judulTransaksi'] as String,
      jumlahSaldo: map['jumlahSaldo'] as int,
      uangMasuk: map['uangMasuk'] as int?,
      uangKeluar: map['uangKeluar'] as int?,
      tipeTransaksi: map['tipeTransaksi'] as String,
      tanggalTransaksi: map['tanggalTransaksi'] as String,
    );
  }

  // =============================================================================================
  // Override fungsi toString agar saat objek dicetak/di-print ke console, bentuknya terbaca jelas
  // =============================================================================================
  @override
  String toString() =>
      "catatan_keuangan{idTransaksi: $idTransaksi, judulTransaksi: $judulTransaksi, jumlahSaldo: $jumlahSaldo, uangMasuk: $uangMasuk, uangKeluar: $uangKeluar, tipeTransaksi: $tipeTransaksi, tanggalTransaksi: $tanggalTransaksi}";
}

// ==================================================
// Membuat database dengan nama 'catatan_keuangan.db'
// ==================================================
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('catatan_keuangan.db');
    return _database!;
  }

  // ========================================================================================================
  // Membuka database pada path, menentukan versi database, dan membuat tabel jika baru pertama kali dipasang
  // ========================================================================================================
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE catatan_keuangan (
            idTransaksi INTEGER PRIMARY KEY AUTOINCREMENT,
            judulTransaksi TEXT,
            jumlahSaldo INTEGER,
            uangMasuk INTEGER,
            uangKeluar INTEGER,
            tipeTransaksi TEXT,
            tanggalTransaksi TEXT
          )
        ''');
      },
    );
  }

  // ===============================================================
  // Fungsi CREATE (Menambah Data baru ke database dengan SQL Murni)
  // ===============================================================
  Future<int> insertCatatanKeuangan(CatatanKeuangan catatanKeuangan) async {
    final db = await instance.database;
    // ==================================================================================
    // Menggunakan rawInsert dengan placeholder '?' untuk keamanan terhadap SQL Injection
    // ==================================================================================
    return await db.rawInsert(
      'INSERT INTO catatan_keuangan (idTransaksi, judulTransaksi, jumlahSaldo, uangMasuk, uangKeluar, tipeTransaksi, tanggalTransaksi) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [
        catatanKeuangan.idTransaksi,
        catatanKeuangan.judulTransaksi,
        catatanKeuangan.jumlahSaldo,
        catatanKeuangan.uangMasuk,
        catatanKeuangan.uangKeluar,
        catatanKeuangan.tipeTransaksi,
        catatanKeuangan.tanggalTransaksi,
      ],
    );
  }

  // ===========================================================================
  // Fungsi READ (Mengambil / Membaca Semua Data dari database dengan SQL Murni)
  // ===========================================================================
  Future<List<CatatanKeuangan>> getCatatanKeuangan() async {
    final db = await instance.database;
    // ============================================
    // Menggunakan rawQuery untuk SELECT semua data
    // ============================================
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * FROM catatan_keuangan',
    );
    return result.map((json) => CatatanKeuangan.fromMap(json)).toList();
  }

  // ===========================================================================
  // Fungsi UPDATE (Mengubah / Memperbarui Data berdasarkan ID dengan SQL Murni)
  // ===========================================================================
  Future<int> updateCatatanKeuangan(CatatanKeuangan catatanKeuangan) async {
    final db = await instance.database;
    // Menggunakan rawUpdate
    return await db.rawUpdate(
      'UPDATE catatan_keuangan SET judulTransaksi = ?, jumlahSaldo = ?, uangMasuk = ?, uangKeluar = ?, tipeTransaksi = ?, tanggalTransaksi = ? WHERE idTransaksi = ?',
      [
        catatanKeuangan.judulTransaksi,
        catatanKeuangan.jumlahSaldo,
        catatanKeuangan.uangMasuk,
        catatanKeuangan.uangKeluar,
        catatanKeuangan.tipeTransaksi,
        catatanKeuangan.tanggalTransaksi,
        catatanKeuangan.idTransaksi,
      ],
    );
  }

  // =====================================================================================
  // Fungsi DELETE (Menghapus Data dari database berdasarkan ID tertentu dengan SQL Murni)
  // =====================================================================================
  Future<int> deleteCatatanKeuangan(int idTransaksi) async {
    final db = await instance.database;
    // =====================
    // Menggunakan rawDelete
    // =====================
    return await db.rawDelete(
      'DELETE FROM catatan_keuangan WHERE idTransaksi = ?',
      [idTransaksi],
    );
  }

  // =====================================================================
  // Fungsi untuk mendapatkan jumlahSaldo terakhir dari transaksi terakhir
  // =====================================================================
  Future<int> getSaldoTerakhir() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT jumlahSaldo FROM catatan_keuangan ORDER BY idTransaksi DESC LIMIT 1',
    );

    if (result.isNotEmpty) {
      return result.first['jumlahSaldo'] as int? ?? 0;
    }
    return 0; // Jika belum ada transaksi sama sekali, saldo awal = 0
  }
}
