import 'package:flutter/material.dart';
import 'package:catatan_keuangan/pages/beranda.dart';

void main() {
  // ===========================================================================
  // Fungsi untama sebagai entry point aplikasi, yang akan menjalankan MainApp()
  // ===========================================================================
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ==========================================================
    // MainApp() akan membuka file Beranda() sebagai halaman awal
    // ==========================================================
    return MaterialApp(debugShowCheckedModeBanner: false, home: Beranda());
  }
}
