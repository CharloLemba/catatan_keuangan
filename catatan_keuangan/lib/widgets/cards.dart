import 'package:flutter/material.dart';
import 'package:catatan_keuangan/database/database_helper.dart';

class CardTransaksi extends StatefulWidget {
  const CardTransaksi({super.key});

  @override
  State<CardTransaksi> createState() => _CardTransaksiState();
}

class _CardTransaksiState extends State<CardTransaksi> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: EdgeInsets.all(12), child: ListTile()),
    );
  }
}
