import 'package:flutter/material.dart';
import 'package:catatan_keuangan/pages/form_keuangan.dart' as form_keuangan;
import 'package:catatan_keuangan/pages/riwayat_keuangan.dart'
    as riwayat_keuangan;
import 'package:catatan_keuangan/main.dart'; // Diperlukan untuk mengakses MainApp.of(context)

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> with TickerProviderStateMixin {
  // =================================
  // Controller untuk TabBar & TabView
  // =================================
  late final TabController _tabBarController;

  // =====================================
  // Inisialisasi awal untuk TabController
  // =====================================
  @override
  void initState() {
    super.initState();
    _tabBarController = TabController(length: 2, vsync: this);
  }

  // =====================================================
  // (WAJIB) Dispose _tabBarController untuk menghemat RAM
  // =====================================================
  @override
  void dispose() {
    _tabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // =============================================================
    // Cek status tema saat ini untuk ikon pada FloatingActionButton
    // =============================================================
    final mainApp = MainApp.of(context);
    final isDark = mainApp?.isDarkTheme ?? false;

    return Scaffold(
      // =====================
      // AppBar utama aplikasi
      // =====================
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: Text(
          "Catatan Keuangan - SQLite",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // ===============================
        // TabBar didalam & dibawah AppBar
        // ===============================
        bottom: TabBar(
          controller: _tabBarController,
          labelColor: Colors.white,
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: [
            Tab(icon: Icon(Icons.assignment)),
            Tab(icon: Icon(Icons.schedule)),
          ],
        ),
      ),
      // ==================================================================================
      // TabBarView() yang akan menampilkan halaman dari FormKeuangan() & RiwayatKeuangan()
      // ==================================================================================
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabBarController,
        children: [
          form_keuangan.FormKeuangan(),
          riwayat_keuangan.RiwayatKeuangan(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: () {
          // =======================================
          // Tombol untuk mengganti dark/light theme
          // =======================================
          MainApp.of(context)?.toggleTheme();
        },
        child: Icon(isDark ? Icons.sunny : Icons.nightlight_round),
      ),
    );
  }
}
