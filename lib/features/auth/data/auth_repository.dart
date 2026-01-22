// lib/features/auth/data/auth_repository.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_client.dart';
import 'package:eng_erp/features/auth/data/auth_model.dart';

class AuthRepository {
  // Supabase istemcisine doğrudan erişim
  final _supabase = SupabaseClientManager().db;

  /// LOGIN
  /// UI'dan gelen isteği alır, Supabase'e sorar, Model döner.
  Future<AuthModel> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      final session = response.session;

      if (user == null || session == null) {
        throw Exception("Kullanıcı verisi alınamadı.");
      }

      return AuthModel.fromSupabase(user, session);

    } on AuthException catch (e) {
      // Supabase'den gelen özel hataları (örn: Yanlış şifre) yakalar
      throw Exception(e.message);
    } catch (e) {
      // Beklenmeyen hatalar
      throw Exception("Giriş yapılırken beklenmedik bir hata oluştu: $e");
    }
  }

  /// REGISTER
  Future<AuthModel> register(String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;
      final session = response.session;

      if (user == null) {
        throw Exception("Kullanıcı oluşturulamadı.");
      }

      // Session null olabilir (email onayı gerekiyorsa), bu yüzden kontrol ediyoruz
      if (session == null) {
        // Burada kayıt başarılı ama session yoksa (email onayı bekleniyorsa)
        // farklı bir mantık kurabilir veya kullanıcıyı bilgilendirebilirsin.
        // Şimdilik hata fırlatmayıp user üzerinden model dönüyoruz (veya hata fırlatabiliriz).
        throw Exception("Kayıt başarılı ancak oturum açılamadı. Lütfen emailinizi onaylayın.");
      }

      return AuthModel.fromSupabase(user, session);

    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Kayıt sırasında hata oluştu: $e");
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception("Çıkış yapılamadı: $e");
    }
  }

  /// SESSION GETTER
  Session? get currentSession => _supabase.auth.currentSession;

  /// USER GETTER
  User? get currentUser => _supabase.auth.currentUser;

  /// CURRENT USER MODEL
  /// Uygulama açıldığında kullanıcı zaten giriş yapmış mı kontrolü için
  AuthModel? getCurrentAuthModel() {
    final user = currentUser;
    final session = currentSession;

    if (user != null && session != null) {
      return AuthModel.fromSupabase(user, session);
    }
    return null;
  }

  /// PASSWORD RESET
  Future<void> sendPasswordReset(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Şifre sıfırlama maili gönderilemedi: $e");
    }
  }
}