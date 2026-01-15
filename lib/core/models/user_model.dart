// lib/core/models/user_model.dart

/// Supabase `kullanicilar` tablosundaki kullanıcı profil ve izin bilgilerini temsil eder.
class UserModel {
  final String id;
  final String? email;
  final String? ad;
  final String? pozisyon;
  final String? avatarUrl;
  final String? phone;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastSignInAt;

  // İzin alanları (boolean)
  final bool adminAllow;
  final bool gpioOpsAllow;
  final bool iptalAllow;
  final bool kaliteKontrolAllow;
  final bool kullaniciYonetimiAllow;
  final bool personelAllow;
  final bool readingAllow;
  final bool rezOlusturAllow;
  final bool satisYonetimiAllow;
  final bool sevkiyatAllow;
  final bool stokYonetimiAllow;
  final bool urunTakipAllow;
  final bool userSettingsAllow;
  final bool uretimAllow;

  UserModel({
    required this.id,
    this.email,
    this.ad,
    this.pozisyon,
    this.avatarUrl,
    this.phone,
    this.createdAt,
    this.updatedAt,
    this.lastSignInAt,
    this.adminAllow = false,
    this.gpioOpsAllow = false,
    this.iptalAllow = false,
    this.kaliteKontrolAllow = false,
    this.kullaniciYonetimiAllow = false,
    this.personelAllow = false,
    this.readingAllow = false,
    this.rezOlusturAllow = false,
    this.satisYonetimiAllow = false,
    this.sevkiyatAllow = false,
    this.stokYonetimiAllow = false,
    this.urunTakipAllow = false,
    this.userSettingsAllow = false,
    this.uretimAllow = false,
  });

  /// Ad varsa ad, yoksa email, o da yoksa 'Kullanıcı' döndürür
  String get displayName {
    if (ad != null && ad!.isNotEmpty) return ad!;
    if (email != null && email!.isNotEmpty) return email!;
    return 'Kullanıcı';
  }

  /// Sayfa adına göre izin kontrolü
  /// Kullanım: hasPermission('stok_yonetimi') veya hasPermission('satis_yonetimi')
  bool hasPermission(String page) {
    switch (page.toLowerCase()) {
      case 'admin':
        return adminAllow;
      case 'gpio_ops':
        return gpioOpsAllow;
      case 'iptal':
        return iptalAllow;
      case 'kalite_kontrol':
        return kaliteKontrolAllow;
      case 'kullanici_yonetimi':
        return kullaniciYonetimiAllow;
      case 'personel':
        return personelAllow;
      case 'reading':
        return readingAllow;
      case 'rez_olustur':
      case 'rezervasyon':
        return rezOlusturAllow;
      case 'satis_yonetimi':
      case 'sales':
        return satisYonetimiAllow;
      case 'sevkiyat':
        return sevkiyatAllow;
      case 'stok_yonetimi':
      case 'stock':
        return stokYonetimiAllow;
      case 'urun_takip':
        return urunTakipAllow;
      case 'user_settings':
        return userSettingsAllow;
      case 'uretim':
        return uretimAllow;
      default:
        return false;
    }
  }

  /// Admin yetkisi kontrolü
  bool get isAdmin => adminAllow;

  /// Supabase JSON'dan model oluşturur
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String?,
      ad: json['ad'] as String?,
      pozisyon: json['pozisyon'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      phone: json['phone'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
      lastSignInAt: json['last_sign_in_at'] != null
          ? DateTime.tryParse(json['last_sign_in_at'] as String)
          : null,
      adminAllow: json['admin_allow'] as bool? ?? false,
      gpioOpsAllow: json['gpio_ops_allow'] as bool? ?? false,
      iptalAllow: json['iptal_allow'] as bool? ?? false,
      kaliteKontrolAllow: json['kalite_kontrol_allow'] as bool? ?? false,
      kullaniciYonetimiAllow: json['kullanici_yonetimi_allow'] as bool? ?? false,
      personelAllow: json['personel_allow'] as bool? ?? false,
      readingAllow: json['reading_allow'] as bool? ?? false,
      rezOlusturAllow: json['rez_olustur_allow'] as bool? ?? false,
      satisYonetimiAllow: json['satis_yonetimi_allow'] as bool? ?? false,
      sevkiyatAllow: json['sevkiyat_allow'] as bool? ?? false,
      stokYonetimiAllow: json['stok_yonetimi_allow'] as bool? ?? false,
      urunTakipAllow: json['urun_takip_allow'] as bool? ?? false,
      userSettingsAllow: json['user_settings_allow'] as bool? ?? false,
      uretimAllow: json['uretim_allow'] as bool? ?? false,
    );
  }

  /// Model'i JSON'a çevirir
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'ad': ad,
      'pozisyon': pozisyon,
      'avatar_url': avatarUrl,
      'phone': phone,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'last_sign_in_at': lastSignInAt?.toIso8601String(),
      'admin_allow': adminAllow,
      'gpio_ops_allow': gpioOpsAllow,
      'iptal_allow': iptalAllow,
      'kalite_kontrol_allow': kaliteKontrolAllow,
      'kullanici_yonetimi_allow': kullaniciYonetimiAllow,
      'personel_allow': personelAllow,
      'reading_allow': readingAllow,
      'rez_olustur_allow': rezOlusturAllow,
      'satis_yonetimi_allow': satisYonetimiAllow,
      'sevkiyat_allow': sevkiyatAllow,
      'stok_yonetimi_allow': stokYonetimiAllow,
      'urun_takip_allow': urunTakipAllow,
      'user_settings_allow': userSettingsAllow,
      'uretim_allow': uretimAllow,
    };
  }

  /// Immutable update için copyWith
  UserModel copyWith({
    String? id,
    String? email,
    String? ad,
    String? pozisyon,
    String? avatarUrl,
    String? phone,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSignInAt,
    bool? adminAllow,
    bool? gpioOpsAllow,
    bool? iptalAllow,
    bool? kaliteKontrolAllow,
    bool? kullaniciYonetimiAllow,
    bool? personelAllow,
    bool? readingAllow,
    bool? rezOlusturAllow,
    bool? satisYonetimiAllow,
    bool? sevkiyatAllow,
    bool? stokYonetimiAllow,
    bool? urunTakipAllow,
    bool? userSettingsAllow,
    bool? uretimAllow,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      ad: ad ?? this.ad,
      pozisyon: pozisyon ?? this.pozisyon,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
      adminAllow: adminAllow ?? this.adminAllow,
      gpioOpsAllow: gpioOpsAllow ?? this.gpioOpsAllow,
      iptalAllow: iptalAllow ?? this.iptalAllow,
      kaliteKontrolAllow: kaliteKontrolAllow ?? this.kaliteKontrolAllow,
      kullaniciYonetimiAllow: kullaniciYonetimiAllow ?? this.kullaniciYonetimiAllow,
      personelAllow: personelAllow ?? this.personelAllow,
      readingAllow: readingAllow ?? this.readingAllow,
      rezOlusturAllow: rezOlusturAllow ?? this.rezOlusturAllow,
      satisYonetimiAllow: satisYonetimiAllow ?? this.satisYonetimiAllow,
      sevkiyatAllow: sevkiyatAllow ?? this.sevkiyatAllow,
      stokYonetimiAllow: stokYonetimiAllow ?? this.stokYonetimiAllow,
      urunTakipAllow: urunTakipAllow ?? this.urunTakipAllow,
      userSettingsAllow: userSettingsAllow ?? this.userSettingsAllow,
      uretimAllow: uretimAllow ?? this.uretimAllow,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, ad: $ad, pozisyon: $pozisyon)';
  }
}
