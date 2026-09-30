import 'package:flutter/material.dart';
import 'package:catatan_keuangan/database/database_helper.dart';

class RiwayatKeuangan extends StatefulWidget {
  const RiwayatKeuangan({super.key});

  @override
  State<RiwayatKeuangan> createState() => _RiwayatKeuanganState();
}

class _RiwayatKeuanganState extends State<RiwayatKeuangan> {
  Future<List<CatatanKeuangan>> _catatanKeuangan() async {
    return await DatabaseHelper.instance.getCatatanKeuangan();
  }

  Future<int> _saldoTerakhir() async {
    return await DatabaseHelper.instance.getSaldoTerakhir();
  }

  // =======================================================
  // Fungsi untuk hapus transaksi berdasarkan data yang dipilih
  // =======================================================
  Future<void> hapusTransaksi(CatatanKeuangan transaksi) async {
    bool? konfirmasi = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Transaksi'),
        content: Text('Yakin ingin menghapus ${transaksi.judulTransaksi}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (konfirmasi == true) {
      // Hapus data dari database menggunakan idTransaksi
      await DatabaseHelper.instance.deleteCatatanKeuangan(
        transaksi.idTransaksi!,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaksi berhasil dihapus!')),
      );

      // Refresh tampilan halaman setelah data dihapus
      _refreshData();
    }
  }

  // -------------------------
  // Fungsi untuk refresh data
  // -------------------------
  void _refreshData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              "Riwayat Transaksi",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Divider(
              height: 20,
              thickness: 2,
              color: Colors.green,
              indent: 16,
              endIndent: 16,
            ),
            SizedBox(height: 25),
            // =========================================================================
            // Menggunakan FutureBuilder untuk menampilkan Saldo Terakhir secara dinamis
            // =========================================================================
            FutureBuilder<int>(
              future: _saldoTerakhir(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(
                    "Saldo anda: Rp. Memuat...",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  );
                }
                final int saldo = snapshot.data ?? 0;
                return Text(
                  "Saldo anda: Rp. $saldo",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                );
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                future: _catatanKeuangan(),
                builder: (context, snapshot) {
                  // ---------------------------------------------------------------------------
                  // Fungsi jika masih mengambil data dari database, menampilkan animasi loading
                  // ---------------------------------------------------------------------------
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // ----------------------------------------------------------------------
                  // Fungsi untuk menampilkan error saat gagal mengambil data dari database
                  // ----------------------------------------------------------------------
                  else if (snapshot.hasError) {
                    return Center(
                      child: Text("Terjadi kesalahan: ${snapshot.error}"),
                    );
                  }
                  // -------------------------------------------------------------
                  // Fungsi untuk menampilkan data yang masih kosong dari database
                  // -------------------------------------------------------------
                  else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'Belum ada transaksi tersimpan.\nSilahkan menambah transaksi di Form Catatan Keuangan',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }
                  // -----------------------------------------------
                  // Menampilkan daftar data transaksi dari database
                  // -----------------------------------------------
                  final listTransaksi = snapshot.data!;
                  return Padding(
                    padding: EdgeInsets.all(12),
                    child: ListView.builder(
                      itemCount: listTransaksi.length,
                      itemBuilder: (context, index) {
                        final transaksi = listTransaksi[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Card Timeline Tanggal
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10.0,
                                bottom: 4.0,
                              ),
                              child: Card(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    transaksi.tanggalTransaksi,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Card Transaksi Asli Milik Lu (Utuh 100%)
                            Card(
                              clipBehavior: Clip.antiAlias,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: transaksi.tipeTransaksi == "Pemasukan"
                                    ? Icon(Icons.upload, color: Colors.green)
                                    : Icon(Icons.download, color: Colors.red),
                                title: Text(transaksi.judulTransaksi),
                                subtitle: Text(
                                  transaksi.tipeTransaksi == "Pemasukan"
                                      ? "Rp. ${transaksi.uangMasuk.toString()}"
                                      : "Rp. ${transaksi.uangKeluar.toString()}",
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    hapusTransaksi(transaksi);
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
