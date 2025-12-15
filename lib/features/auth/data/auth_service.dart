// lib/features/auth/data/auth_service.dart

import 'package:eng_erp/features/auth/data/auth_model.dart';
import 'package:eng_erp/features/auth/data/auth_repository.dart';

class AuthService {
  // Service, Repository'i kullanır.
  final AuthRepository _repository;

  // Constructor'da Dependency Injection yapılabilir veya varsayılan atanabilir.
  AuthService({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  /// LOGIN SERVICE
  /// Burada şifre uzunluğu, email formatı gibi kontroller yapılır.
  Future<AuthModel> login(String email, String password) async {
    // 1. Validasyonlar (İş Mantığı)
    if (email.trim().isEmpty) {
      throw Exception("Email alanı boş bırakılamaz.");
    }

    if (password.trim().isEmpty) {
      throw Exception("Şifre alanı boş bırakılamaz.");
    }

    // 2. Her şey uygunsa Repository çağrılır
    try {
      return await _repository.login(email.trim(), password.trim());
    } catch (e) {
      // Gerekirse hatayı loglayabilir veya değiştirebilirsin
      rethrow;
    }
  }

  /// REGISTER SERVICE
  Future<AuthModel> register(String email, String password) async {
    // 1. Kayıt Kuralları (Business Rules)
    if (password.length < 6) {
      throw Exception("Şifre en az 6 karakter olmalıdır.");
    }

    if (!email.contains('@')) {
      throw Exception("Geçerli bir email adresi giriniz.");
    }

    // 2. Kurallar geçildiyse kayıt işlemini başlat
    return await _repository.register(email.trim(), password.trim());
  }

  /// LOGOUT SERVICE
  Future<void> logout() async {
    // Çıkış yapmadan önce yapılması gereken temizlikler varsa burada yapılır.
    // Örn: LocalStorage temizleme, Analytics event atma vb.
    await _repository.logout();
  }

  /// CURRENT USER & SESSION
  /// Bu metodlar genellikle iş mantığı içermez, direkt iletir.
  AuthModel? getCurrentUser() {
    return _repository.getCurrentAuthModel();
  }

  /// PASSWORD RESET
  Future<void> sendPasswordReset(String email) async {
    if (email.trim().isEmpty || !email.contains('@')) {
      throw Exception("Şifre sıfırlamak için geçerli bir email giriniz.");
    }

    await _repository.sendPasswordReset(email.trim());
  }
}
