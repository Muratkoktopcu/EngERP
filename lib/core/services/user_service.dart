// lib/core/services/user_service.dart

import 'package:flutter/foundation.dart';
import 'package:eng_erp/core/models/user_model.dart';
import 'package:eng_erp/core/repositories/user_repository.dart';

/// Singleton pattern ile global erişilebilir kullanıcı servisi
/// 
/// Kullanım:
/// ```dart
/// final userName = UserService.instance.displayName;
/// final canAccess = UserService.instance.hasPermission('stok_yonetimi');
/// ```
class UserService {
  // Singleton pattern
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();
  
  /// Singleton instance'a erişim
  static UserService get instance => _instance;

  // Repository
  final UserRepository _repository = UserRepository();

  // Current user state
  UserModel? _currentUser;

  /// Current user getter
  UserModel? get currentUser => _currentUser;

  /// Kullanıcı yüklü mü kontrolü
  bool get isLoaded => _currentUser != null;

  /// Display name - ad varsa ad, yoksa email, o da yoksa 'Kullanıcı'
  String get displayName => _currentUser?.displayName ?? 'Kullanıcı';

  /// Email getter
  String? get email => _currentUser?.email;

  /// Ad getter
  String? get ad => _currentUser?.ad;

  /// Pozisyon getter
  String? get pozisyon => _currentUser?.pozisyon;

  /// Avatar URL getter
  String? get avatarUrl => _currentUser?.avatarUrl;

  /// Admin yetkisi kontrolü
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  /// Login sonrası kullanıcı profilini yükler
  /// 
  /// [userId] - Supabase auth.users.id
  /// Returns: Yükleme başarılı mı
  Future<bool> loadUserProfile(String userId) async {
    try {
      debugPrint('📥 Kullanıcı profili yükleniyor: $userId');
      
      final user = await _repository.fetchUserById(userId);
      
      if (user != null) {
        _currentUser = user;
        debugPrint('✅ Kullanıcı profili yüklendi: ${user.displayName}');
        
        // Son giriş zamanını güncelle (async, bekleme yok)
        _repository.updateLastSignIn(userId);
        
        return true;
      } else {
        debugPrint('⚠️ Kullanıcı profili bulunamadı, varsayılan değerler kullanılacak');
        // Profil bulunamadıysa minimal bir user oluştur
        _currentUser = UserModel(id: userId);
        return false;
      }
    } catch (e) {
      debugPrint('❌ Kullanıcı profili yüklenemedi: $e');
      // Hata durumunda minimal user oluştur
      _currentUser = UserModel(id: userId);
      return false;
    }
  }

  /// Logout sonrası state temizleme
  void clearUserProfile() {
    debugPrint('🧹 Kullanıcı profili temizleniyor');
    _currentUser = null;
  }

  /// Sayfa erişim izni kontrolü
  /// 
  /// Kullanım:
  /// ```dart
  /// if (UserService.instance.hasPermission('stok_yonetimi')) {
  ///   // Erişim izni var
  /// }
  /// ```
  bool hasPermission(String page) {
    if (_currentUser == null) return false;
    
    // Admin her şeye erişebilir
    if (_currentUser!.isAdmin) return true;
    
    return _currentUser!.hasPermission(page);
  }

  /// Birden fazla sayfa için izin kontrolü (herhangi biri)
  bool hasAnyPermission(List<String> pages) {
    return pages.any((page) => hasPermission(page));
  }

  /// Birden fazla sayfa için izin kontrolü (hepsi)
  bool hasAllPermissions(List<String> pages) {
    return pages.every((page) => hasPermission(page));
  }

  /// Kullanıcı profilini yeniden yükler (refresh)
  Future<bool> refreshProfile() async {
    if (_currentUser == null) return false;
    return await loadUserProfile(_currentUser!.id);
  }

  /// Kullanıcı bilgilerini günceller
  Future<bool> updateProfile({
    String? ad,
    String? phone,
    String? avatarUrl,
  }) async {
    if (_currentUser == null) return false;

    final fields = <String, dynamic>{};
    if (ad != null) fields['ad'] = ad;
    if (phone != null) fields['phone'] = phone;
    if (avatarUrl != null) fields['avatar_url'] = avatarUrl;
    
    if (fields.isEmpty) return true;

    final success = await _repository.updateUserFields(_currentUser!.id, fields);
    
    if (success) {
      // Local state'i güncelle
      _currentUser = _currentUser!.copyWith(
        ad: ad ?? _currentUser!.ad,
        phone: phone ?? _currentUser!.phone,
        avatarUrl: avatarUrl ?? _currentUser!.avatarUrl,
      );
    }

    return success;
  }

  /// Debug için kullanıcı bilgilerini yazdırır
  void printUserInfo() {
    if (_currentUser == null) {
      debugPrint('👤 Kullanıcı: Yüklenmemiş');
      return;
    }

    debugPrint('👤 Kullanıcı Bilgileri:');
    debugPrint('   ID: ${_currentUser!.id}');
    debugPrint('   Ad: ${_currentUser!.ad ?? "Belirtilmemiş"}');
    debugPrint('   Email: ${_currentUser!.email ?? "Belirtilmemiş"}');
    debugPrint('   Pozisyon: ${_currentUser!.pozisyon ?? "Belirtilmemiş"}');
    debugPrint('   Admin: ${_currentUser!.isAdmin}');
    debugPrint('   Stok Yönetimi: ${_currentUser!.stokYonetimiAllow}');
    debugPrint('   Satış Yönetimi: ${_currentUser!.satisYonetimiAllow}');
    debugPrint('   İptal: ${_currentUser!.iptalAllow}');
    debugPrint('   Rezervasyon: ${_currentUser!.rezOlusturAllow}');
  }
}
