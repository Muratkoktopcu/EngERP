import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:eng_erp/core/services/supabase_client.dart';
import 'package:eng_erp/core/services/user_service.dart';
import 'package:eng_erp/features/auth/data/auth_service.dart';

// Pages
import '../../features/auth/pages/login_page.dart';
import '../../features/stock/pages/StockManagementPage.dart';
import '../../features/reservation/pages/ReservationPage.dart';
import '../../features/sales_confirmation/pages/SalesConfirmationPage.dart';
import '../../features/cancel/pages/CancelPage.dart';

// Shell
import '../navigation/app_shell.dart';

/// Supabase auth değişince GoRouter refresh etsin diye
/// Ayrıca kullanıcı profilini de yükler
class SupabaseAuthNotifier extends ChangeNotifier {
  late final StreamSubscription<AuthState> _sub;

  SupabaseAuthNotifier() {
    // ⚠️ burada NEW yaratma: initialize edilmiş aynı instance'ı kullan
    final supabase = SupabaseClientManager().db;

    _sub = supabase.auth.onAuthStateChange.listen((authState) async {
      final event = authState.event;
      final session = authState.session;
      
      debugPrint('🔐 Auth state değişti: $event');
      
      // Session varsa ve sign in/token refresh ise profil yükle
      if (session != null) {
        if (event == AuthChangeEvent.signedIn || 
            event == AuthChangeEvent.tokenRefreshed) {
          debugPrint('📥 Auth event: $event - Profil yükleniyor...');
          await UserService.instance.loadUserProfile(session.user.id);
        }
      } else if (event == AuthChangeEvent.signedOut) {
        // Çıkış yapıldıysa profili temizle
        debugPrint('🧹 Signed out - Profil temizleniyor');
        UserService.instance.clearUserProfile();
      }
      
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final SupabaseAuthNotifier _authNotifier = SupabaseAuthNotifier();
final AuthService _authService = AuthService();

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  refreshListenable: _authNotifier,
  redirect: (context, state) {
    // AuthService -> Repository -> local/session model (sync)
    final currentUser = _authService.getCurrentUser();
    final loggedIn = currentUser != null;

    final goingToLogin = state.matchedLocation == '/login';

    // Giriş yoksa: her şeyi login'e zorla
    if (!loggedIn && !goingToLogin) return '/login';

    // Giriş varsa: login'e gitmeye çalışma, içeri at
    if (loggedIn && goingToLogin) return '/stock';

    return null;
  },
  routes: [
    /// ✅ LOGIN: ShellRoute'un DIŞINDA (sidebar yok)
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    /// ✅ UYGULAMA: ShellRoute'un İÇİNDE (sidebar var)
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/stock',
          name: 'stock',
          builder: (context, state) => const StokYonetimiPage(),
        ),
        GoRoute(
          path: '/reservation',
          name: 'reservation',
          builder: (context, state) => const ReservationPage(),
        ),
        GoRoute(
          path: '/sales',
          name: 'sales',
          builder: (context, state) => const SalesConfirmationPage(),
        ),
        GoRoute(
          path: '/cancel',
          name: 'cancel',
          builder: (context, state) => const CancelPage(),
        ),
      ],
    ),
  ],
);
