import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class FormKeuangan extends StatefulWidget {
  const FormKeuangan({super.key});

  @override
  State<FormKeuangan> createState() => _FormKeuanganState();
}

class _FormKeuanganState extends State<FormKeuangan> {
  final _formKey = GlobalKey<FormState>();
  bool _switchOn = true;
  // 1. Buat TextEditingController untuk mengontrol teks di TextField
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _uangController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  // 2. Fungsi untuk menampilkan Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Batas minimum tahun
      lastDate: DateTime(2101), // Batas maksimum tahun
    );

    if (picked != null) {
      setState(() {
        // 3. Format tanggal sesuai kebutuhan (Format: DD-MM-YYYY)
        _dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
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
          SizedBox(height: 20), // Disesuaikan dikit biar gak terlalu jauh
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ), // Dirapikan padding kiri-kanannya
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _switchOn ? "Pemasukan" : "Pengeluaran",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(width: 10),
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
          SizedBox(height: 10), // Tambahan jarak tipis sebelum masuk area form
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ), // Padding dipercantik biar lega
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 8,
                    ), // Jarak aman di atas TextFormField pertama
                    TextFormField(
                      controller: _judulController,
                      decoration: InputDecoration(
                        labelText: 'Judul Transaksi',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ), // Dikasih border tipis biar rapi (opsional, tapi struktur tetap aman)
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ), // Biar gak terlalu kurus/mepet
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ), // Jarak antar input diperlebar dikit biar gak padet
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Rp. ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(width: 10),
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
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9]'),
                              ),
                            ],
                            onChanged: (value) {
                              // Hilangkan spasi tambahan (jaga-jaga kalau lolos) dan parse ke int biar nol di depan "auto-destroy"
                              String cleanedValue = value.replaceAll(' ', '');

                              if (cleanedValue.isNotEmpty) {
                                // Ubah ke integer (int.tryParse otomatis buang semua angka 0 di depan, misal "0001200" jadi 1200)
                                int.tryParse(cleanedValue);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24), // Konsisten jaraknya
                    TextFormField(
                      controller: _dateController,
                      readOnly:
                          true, // KUNCI: Pengguna tidak bisa mengetik manual
                      onTap: () => _selectDate(
                        context,
                      ), // Memicu date picker saat di-klik
                      decoration: const InputDecoration(
                        labelText: 'Pilih Tanggal',
                        hintText: 'DD-MM-YYYY',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        suffixIcon: Icon(
                          Icons.calendar_today,
                        ), // Ikon kalender di kanan
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ), // Jarak sebelum tombol simpan diperlonggar
                    SizedBox(
                      width: double.infinity, // Opsional: Biar tombolnya agak panjang rapi ke samping, kalau mau pas ukurannya tinggal hapus
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Eksekusi data
                          }
                          setState(() {
                            _dateController.clear();
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
                            vertical: 14, // Ditinggikan dikit biar tombolnya empuk ditekan
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Simpan', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    // Tambahin jarak ekstra di bawah biar tombol gak ketempelan mentok bawah banget
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
