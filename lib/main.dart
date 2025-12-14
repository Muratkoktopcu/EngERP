import 'package:flutter/material.dart';
import 'package:eng_erp/core/services/supabase_client.dart';
import 'package:eng_erp/features/auth/data/auth_service.dart';
import 'package:eng_erp/core/navigation/app_router.dart';  // <-- ROUTER BURADA
import 'package:go_router/go_router.dart';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseClientManager().initialize();
  await testAuth();

  runApp(const EngErp());
}

class EngErp extends StatelessWidget {
  const EngErp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,               // <-- GO ROUTER ENTEGRASYONU
      title: 'ENG ERP',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
    );
  }
}
