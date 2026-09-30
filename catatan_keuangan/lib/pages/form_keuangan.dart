import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:catatan_keuangan/database/database_helper.dart';

class FormKeuangan extends StatefulWidget {
  const FormKeuangan({super.key});

  @override
  State<FormKeuangan> createState() => _FormKeuanganState();
}

class _FormKeuanganState extends State<FormKeuangan> {
  // ======================================================================================
  // Variabel _formKey sebagai kunci dari Form() & _switchOn untuk mengatur tombol Switch()
  // ======================================================================================
  final _formKey = GlobalKey<FormState>();
  bool _switchOn = true;

  // ========================================================
  // TextEditingController untuk mengontrol teks di TextField
  // ========================================================
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _uangController = TextEditingController();

  // ===========================================================
  // Fungsi untuk menampilkan Date Picker pada TextField tanggal
  // ===========================================================
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        // Format tanggal sesuai kebutuhan (Format: DD-MM-YYYY)
        _tanggalController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  // ==============================================================
  // (WAJIB) Dispose semua TextField controller untuk menghemat RAM
  // ==============================================================
  @override
  void dispose() {
    _tanggalController.dispose();
    _judulController.dispose();
    _uangController.dispose();
    super.dispose();
  }

  Future<void> simpanTransaksi() async {
    final String judulTransaksi = _judulController.text.trim();
    final int nominalTransaksi = int.tryParse(_uangController.text.trim()) ?? 0;
    final String tanggalTransaksi = _tanggalController.text.trim();
    final String tipeTransaksi = _switchOn ? "Pemasukan" : "Pengeluaran";
    final int saldoTerakhir = await DatabaseHelper.instance.getSaldoTerakhir();

    try {
      // ==================================================
      // Hitung jumlah saldo baru berdasarkan status switch
      // ==================================================
      final int jumlahSaldoBaru = _switchOn
          ? saldoTerakhir + nominalTransaksi
          : saldoTerakhir - nominalTransaksi;

      // ==============================================================
      // Buat objek transaksi dengan uangMasuk / uangKeluar yang sesuai
      // ==============================================================
      final transaksiBaru = CatatanKeuangan(
        idTransaksi: null,
        judulTransaksi: judulTransaksi,
        jumlahSaldo: jumlahSaldoBaru,
        uangMasuk: _switchOn ? nominalTransaksi : null,
        uangKeluar: !_switchOn ? nominalTransaksi : null,
        tipeTransaksi: tipeTransaksi,
        tanggalTransaksi: tanggalTransaksi,
      );

      // ==================
      // Simpan ke database
      // ==================
      await DatabaseHelper.instance.insertCatatanKeuangan(transaksiBaru);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaksi berhasil disimpan!')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Transaksi gagal disimpan!\n$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        // =================================================================================
        // Column() untuk menampung Text judul Form(), tombol Switch() dan Form() didalamnya
        // =================================================================================
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.all(12),
            child:
                // =================
                // Text judul Form()
                // =================
                Text(
                  "Form Catatan Keuangan",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
          ),
          Divider(
            height: 20,
            thickness: 2,
            color: Colors.green,
            indent: 16,
            endIndent: 16,
          ),
          SizedBox(height: 20),
          // ==================================================
          // Padding pembungkus Tombol Switch() & keterangannya
          // ==================================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ===========================================================
                // Text untuk Switch() yang berubah sesuai tombol yang dipilih
                // ===========================================================
                Text(
                  _switchOn ? "Pemasukan" : "Pengeluaran",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(width: 10),
                // ========================================================
                // Switch() untuk memilih antara Pemasukan atau Pengeluaran
                // ========================================================
                Switch(
                  value: _switchOn,
                  activeThumbColor: Colors.green,
                  inactiveThumbColor: Colors.red,
                  inactiveTrackColor: const Color.fromARGB(255, 225, 129, 122),
                  onChanged: (bool value) {
                    setState(() {
                      _switchOn = value;
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          // =============================================================
          // Exxpanded untuk membungkus SingleChildScrollView() dan Form()
          // =============================================================
          Expanded(
            child:
                // ===================================================================
                // SingleChildScrollView() membungkus Form() agar bisa digulir kebawah
                // ===================================================================
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child:
                      // ======================================================================================================
                      // Form() untuk mengisi judul transaksi, nominal uang masuk/keluar, tannggal transaksi, dan tombol simpan
                      // ======================================================================================================
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(height: 8),
                            // =============================================
                            // TextFormField() untuk mengisi judul transaksi
                            // =============================================
                            TextFormField(
                              controller: _judulController,
                              decoration: InputDecoration(
                                labelText: 'Judul Transaksi',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                            SizedBox(height: 24),
                            // ==================================================================
                            // Row() untuk baris placeholder 'Rp. ' dan nominal uang masuk/keluar
                            // ==================================================================
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // =======================
                                // Text placeholder 'Rp. '
                                // =======================
                                Text(
                                  "Rp. ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(width: 10),
                                // ===============================================================================
                                // TextFormField() untuk menginput uang masuk/keluar, sesuai Switch() yang dipilih
                                // ===============================================================================
                                Expanded(
                                  child: TextFormField(
                                    controller: _uangController,
                                    decoration: InputDecoration(
                                      labelText: _switchOn
                                          ? "Uang Masuk"
                                          : "Uang Keluar",
                                      hintText: "Contoh: 15000",
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 14,
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    // ==========================================
                                    // (WAJIB) Agar input hanya berupa angka saja
                                    // ==========================================
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]'),
                                      ),
                                    ],
                                    // ================================================
                                    // Hilangkan spasi tambahan (jaga-jaga kalau lolos)
                                    // ================================================
                                    onChanged: (value) {
                                      String cleanedValue = value.replaceAll(
                                        ' ',
                                        '',
                                      );
                                      // ===============================================================================================
                                      // Ubah ke integer (int.tryParse otomatis buang semua angka 0 di depan, misal "0001500" jadi 1500)
                                      // ===============================================================================================
                                      if (cleanedValue.isNotEmpty) {
                                        int.tryParse(cleanedValue);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                            // ===================================
                            // TextFormField() sebagai date picker
                            // ===================================
                            TextFormField(
                              controller: _tanggalController,
                              // ===================================================
                              // (WAJIB) Pengguna tidak bisa mengetik manual tanggal
                              // ===================================================
                              readOnly: true,
                              onTap: () => _selectDate(context),
                              // ===============================
                              // Memicu date picker saat di-klik
                              // ===============================
                              decoration: const InputDecoration(
                                labelText: 'Pilih Tanggal',
                                hintText: 'DD-MM-YYYY',
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                // ======================
                                // Ikon kalender di kanan
                                // ======================
                                suffixIcon: Icon(Icons.calendar_today),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 35),
                            SizedBox(
                              // =================================================
                              // double.infinity  agar tombol memanjang ke samping
                              // =================================================
                              width: double.infinity,
                              child: ElevatedButton(
                                // ==============================
                                // Tombol simpan data ke database
                                // ==============================
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    simpanTransaksi();
                                  }
                                  // ==============================================
                                  // Menghapus semua isi dari semua Text(Form)Field
                                  // ==============================================
                                  setState(() {
                                    _tanggalController.clear();
                                    _judulController.clear();
                                    _uangController.clear();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  elevation: 5,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Simpan',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            // ===============================================================
                            // Tambahin jarak ekstra di bawah biar tombol tidak mentok dibawah
                            // ===============================================================
                            SizedBox(height: 40),
                          ],
                        ),
                      ),
                ),
          ),
        ],
      ),
    );
  }
}
