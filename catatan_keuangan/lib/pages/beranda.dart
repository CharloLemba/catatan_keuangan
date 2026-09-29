import 'package:flutter/material.dart';
import 'package:catatan_keuangan/pages/form_keuangan.dart' as form_keuangan;
import 'package:catatan_keuangan/pages/riwayat_keuangan.dart'
    as riwayat_keuangan;

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> with TickerProviderStateMixin {
  late final TabController _tabBarController;

  @override
  void initState() {
    super.initState();
    _tabBarController = TabController(length: 2, vsync: this);
    _tabBarController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: Text(
          "Catatan Keuangan - SQLite",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
      body: TabBarView(
        controller: _tabBarController,
        children: [
          form_keuangan.FormKeuangan(),
          riwayat_keuangan.RiwayatKeuangan(),
        ],
      ),
      floatingActionButton: _tabBarController.index == 0
          ? FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
