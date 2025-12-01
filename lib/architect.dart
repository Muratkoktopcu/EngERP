import 'package:flutter/material.dart';
import 'package:eng_erp/features/cancel/pages/CancelPage.dart';
import 'package:eng_erp/features/reservation/pages/ReservationPage.dart';
import 'package:eng_erp/features/sales_confirmation/pages/SalesConfirmationPage.dart';
import 'package:eng_erp/features/stock/pages/StockManagementPage.dart';

class AnaIskelet extends StatefulWidget {
  const AnaIskelet({super.key});

  @override
  State<AnaIskelet> createState() => _AnaIskeletState();
}

class _AnaIskeletState extends State<AnaIskelet> {
  int _seciliIndex = 0;

  final List<Widget> _sayfalar = [
    const StokYonetimiPage(),
    const ReservationPage(),
    const SalesConfirmationPage(),
    const CancelPage(),
  ];

  void _sayfaDegistir(int index) {
    setState(() {
      _seciliIndex = index;
    });
    Navigator.pop(context); // Drawer'ı otomatik kapat
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // SOL TARAFTA AÇILAN MENU
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text(
                "MENÜ",
                style: TextStyle(fontSize: 24),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.inventory_2),
              title: const Text("Stok Yönetimi"),
              onTap: () => _sayfaDegistir(0),
            ),

            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text("Rezervasyon"),
              onTap: () => _sayfaDegistir(1),
            ),

            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text("Sales Confirmation"),
              onTap: () => _sayfaDegistir(2),
            ),

            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text("Cancel"),
              onTap: () => _sayfaDegistir(3),
            ),
          ],
        ),
      ),

      body: _sayfalar[_seciliIndex],
    );
  }
}
