import 'package:flutter/material.dart';
import 'package:eng_erp/core/services/supabase_client.dart';
import 'package:eng_erp/core/services/user_service.dart';
import 'package:eng_erp/features/auth/data/auth_service.dart';
import 'package:eng_erp/core/navigation/app_router.dart';
import 'package:eng_erp/core/theme/theme.dart'; // 🎨 DESIGN TOKENS

Future<void> testAuth() async {
  final authService = AuthService();

  try {
    final model = await authService.login(
      "afsuamrfid@gmail.com",
      "123456",
    );

    print("✅ LOGIN BAŞARILI");
    print("USER ID: ${model.userId}");
    print("EMAIL: ${model.email}");
    print("ROLE: ${model.role}");
    print("DEPARTMENT: ${model.departmentId}");
    print("TOKEN: ${model.accessToken}");
    print("EXPIRES: ${model.expiresAt}");
    print("FULL METADATA: ${model.metadata}");
  } catch (e) {
    print("❌ HATA: $e");
  }
}

/// Uygulama başlarken mevcut session varsa kullanıcı profilini yükler
Future<void> _loadExistingUserProfile() async {
  final authService = AuthService();
  final currentUser = authService.getCurrentUser();
  
  if (currentUser != null) {
    debugPrint('📥 Mevcut session bulundu, profil yükleniyor...');
    await UserService.instance.loadUserProfile(currentUser.userId);
    UserService.instance.printUserInfo();
  } else {
    debugPrint('🔓 Mevcut session yok, login gerekiyor');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseClientManager().initialize();
  
  // Mevcut session varsa kullanıcı profilini yükle
  await _loadExistingUserProfile();
  
  //await testAuth();

  runApp(const EngErp());
}

class EngErp extends StatelessWidget {
  const EngErp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      title: 'ENG ERP',
      theme: AppTheme.lightTheme, // 🎨 Merkezi tema sistemi
    );
  }
}
