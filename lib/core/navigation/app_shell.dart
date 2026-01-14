import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:eng_erp/features/auth/data/auth_service.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final currentUser = authService.getCurrentUser();

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            /// 🔹 USER INFO
            UserAccountsDrawerHeader(
              accountName: Text(
                currentUser?.email ?? 'Bilinmeyen Kullanıcı',
              ),
              accountEmail: Text(
                currentUser?.role ?? '',
              ),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),

            /// 🔹 MENÜ
            _DrawerItem(
              icon: Icons.inventory_2,
              label: 'Stok Yönetimi',
              route: '/stock',
            ),
            _DrawerItem(
              icon: Icons.calendar_month,
              label: 'Rezervasyon',
              route: '/reservation',
            ),
            _DrawerItem(
              icon: Icons.check_circle,
              label: 'Satış Onay',
              route: '/sales',
            ),
            _DrawerItem(
              icon: Icons.cancel,
              label: 'İptal',
              route: '/cancel',
            ),

            const Spacer(),

            /// 🔹 LOGOUT
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Çıkış Yap'),
              onTap: () async {
                Navigator.pop(context);
                await authService.logout();
                context.go('/login');
              },
            ),
          ],
        ),
      ),
      body: child,
    );
  }
}

/// Drawer item helper (temizlik + aktif route desteği için hazır)
class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final isActive = location == route;

    return ListTile(
      leading: Icon(icon, color: isActive ? Colors.blue : null),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isActive,
      onTap: () {
        Navigator.pop(context);
        context.go(route);
      },
    );
  }
}
