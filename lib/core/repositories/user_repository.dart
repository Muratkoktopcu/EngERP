// lib/core/repositories/user_repository.dart

import 'package:flutter/foundation.dart';
import 'package:eng_erp/core/models/user_model.dart';
import 'package:eng_erp/core/services/supabase_client.dart';

/// Supabase `kullanicilar` tablosu ile iletişim kuran repository
class UserRepository {
  final _supabase = SupabaseClientManager();

  static const String _tableName = 'kullanicilar';

  /// Auth user ID ile kullanicilar tablosundan profil çeker
  /// Profil bulunamazsa null döner
  Future<UserModel?> fetchUserById(String userId) async {
    try {
      final response = await _supabase
          .table(_tableName)
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        debugPrint('⚠️ Kullanıcı profili bulunamadı: $userId');
        return null;
      }

      return UserModel.fromJson(response);
    } catch (e) {
      debugPrint('❌ Kullanıcı profili çekilemedi: $e');
      return null;
    }
  }

  /// Kullanıcı bilgilerini günceller
  Future<bool> updateUser(UserModel user) async {
    try {
      await _supabase
          .table(_tableName)
          .update(user.toJson())
          .eq('id', user.id);
      
      debugPrint('✅ Kullanıcı güncellendi: ${user.id}');
      return true;
    } catch (e) {
      debugPrint('❌ Kullanıcı güncellenemedi: $e');
      return false;
    }
  }

  /// Son giriş zamanını günceller
  Future<bool> updateLastSignIn(String userId) async {
    try {
      await _supabase
          .table(_tableName)
          .update({'last_sign_in_at': DateTime.now().toIso8601String()})
          .eq('id', userId);
      
      debugPrint('✅ Son giriş zamanı güncellendi: $userId');
      return true;
    } catch (e) {
      debugPrint('❌ Son giriş zamanı güncellenemedi: $e');
      return false;
    }
  }

  /// Belirli alanları günceller (partial update)
  Future<bool> updateUserFields(String userId, Map<String, dynamic> fields) async {
    try {
      await _supabase
          .table(_tableName)
          .update(fields)
          .eq('id', userId);
      
      debugPrint('✅ Kullanıcı alanları güncellendi: $userId');
      return true;
    } catch (e) {
      debugPrint('❌ Kullanıcı alanları güncellenemedi: $e');
      return false;
    }
  }

  /// Yeni kullanıcı profili oluşturur (auth.users.id ile eşleşen)
  Future<bool> createUserProfile({
    required String userId,
    required String email,
    String? ad,
  }) async {
    try {
      await _supabase.table(_tableName).insert({
        'id': userId,
        'email': email,
        'ad': ad,
        'created_at': DateTime.now().toIso8601String(),
        // Varsayılan izinler false olarak ayarlanır
        'admin_allow': false,
        'gpio_ops_allow': false,
        'iptal_allow': false,
        'kalite_kontrol_allow': false,
        'kullanici_yonetimi_allow': false,
        'personel_allow': false,
        'reading_allow': false,
        'rez_olustur_allow': false,
        'satis_yonetimi_allow': false,
        'sevkiyat_allow': false,
        'stok_yonetimi_allow': false,
        'urun_takip_allow': false,
        'user_settings_allow': false,
        'uretim_allow': false,
      });

      debugPrint('✅ Kullanıcı profili oluşturuldu: $userId');
      return true;
    } catch (e) {
      debugPrint('❌ Kullanıcı profili oluşturulamadı: $e');
      return false;
    }
  }

  /// Kullanıcı profilinin var olup olmadığını kontrol eder
  Future<bool> userProfileExists(String userId) async {
    try {
      final response = await _supabase
          .table(_tableName)
          .select('id')
          .eq('id', userId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      debugPrint('❌ Kullanıcı profili kontrolü başarısız: $e');
      return false;
    }
  }
}
