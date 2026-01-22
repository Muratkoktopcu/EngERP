import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:eng_erp/features/auth/data/auth_service.dart';
import 'package:eng_erp/core/services/user_service.dart';
import 'package:eng_erp/core/widgets/modern_sidebar.dart';

/// 🏠 App Shell - Ana uygulama kabuğu
/// Tüm sayfalar için paylaşılan Drawer/Sidebar içerir
class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final userService = UserService.instance;
    final currentLocation = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      drawer: ModernSidebar(
        userDisplayName: userService.displayName,
        userEmail: userService.email,
        userRole: userService.pozisyon,
        currentRoute: currentLocation,
        onNavigate: (route) => context.go(route),
        onLogout: () async {
          await authService.logout();
          context.go('/login');
        },
      ),
      body: child,
    );
  }
}
