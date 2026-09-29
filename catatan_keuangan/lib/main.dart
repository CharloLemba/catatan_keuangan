import 'package:flutter/material.dart';
import 'package:catatan_keuangan/pages/beranda.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Beranda());
  }
}
