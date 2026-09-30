import 'package:flutter/material.dart';
import 'package:catatan_keuangan/widgets/cards.dart';

class RiwayatKeuangan extends StatefulWidget {
  const RiwayatKeuangan({super.key});

  @override
  State<RiwayatKeuangan> createState() => _RiwayatKeuanganState();
}

class _RiwayatKeuanganState extends State<RiwayatKeuangan> {
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
            Text(
              "Saldo anda: Rp. ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(child: ListView(children: [CardTransaksi()])),
          ],
        ),
      ),
    );
  }
}
