import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final Widget child; //o anda ekranda gösterilen sayfa

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text("MENÜ", style: TextStyle(fontSize: 24)),
            ),

            ListTile(
              leading: const Icon(Icons.inventory_2),
              title: const Text("Stok Yönetimi"),
              onTap: () {
                Navigator.pop(context);         // Drawer kapansın
                context.go("/stock");
              },
            ),

            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text("Rezervasyon"),
              onTap: () {
                Navigator.pop(context);
                context.go("/reservation");
              },
            ),

            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text("Sales Confirmation"),
              onTap: () {
                Navigator.pop(context);
                context.go("/sales");
              },
            ),

            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text("Cancel"),
              onTap: () {
                Navigator.pop(context);
                context.go("/cancel");
              },
            ),
          ],
        ),
      ),

      body: child,
    );
  }
}
