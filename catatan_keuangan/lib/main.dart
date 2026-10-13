import 'package:flutter/material.dart';
import 'package:catatan_keuangan/pages/beranda.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // ===========================================================================
  // Wajib inisialisasi binding sebelum memanggil SharedPreferences di fungsi utama
  // ===========================================================================
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();

  // ===============================================================
  // Helper untuk mengakses state MainApp dari widget anak (Beranda)
  // ===============================================================
  static _MainAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MainAppState>();
}

class _MainAppState extends State<MainApp> {
  bool _isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  // ======================================================
  // Fungsi untuk memuat status tema dari SharedPreferences
  // ======================================================
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    });
  }

  // Fungsi untuk mengubah dan menyimpan status tema
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkTheme = !_isDarkTheme;
      prefs.setBool('isDarkTheme', _isDarkTheme);
    });
  }

  bool get isDarkTheme => _isDarkTheme;

  @override
  Widget build(BuildContext context) {
    // ==========================================================
    // MainApp() akan membuka file Beranda() sebagai halaman awal
    // ==========================================================
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      home: Beranda(),
    );
  }
}
