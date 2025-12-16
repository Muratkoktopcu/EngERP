import 'package:flutter/material.dart';

/// 🎨 ENG ERP Uygulama Renk Paleti (Design Tokens)
///
/// Projenin tüm renklerini merkezi bir yerden yönetmek için kullanılır.
/// Marka kimliği ve tutarlı bir UI deneyimi sağlar.
class AppColors {
  AppColors._(); // Private constructor - sınıfın instance'ı oluşturulamaz

  // ============================================================
  // PRIMARY COLORS (Ana Marka Renkleri)
  // ============================================================
  
  /// Ana marka rengi - Primary actions, butonlar, vurgular için
  static const Color primary = Color(0xFF2196F3); // Blue
  
  /// Koyu primary - Hover states, odaklanmış durumlar
  static const Color primaryDark = Color(0xFF1976D2);
  
  /// Açık primary - Subtle backgrounds, selections
  static const Color primaryLight = Color(0xFF64B5F6);
  
  /// Çok açık primary - Hover effects, backgrounds
  static const Color primaryLighter = Color(0xFFBBDEFB);

  // ============================================================
  // NEUTRAL COLORS (Gri Tonları)
  // ============================================================
  
  /// Nötr beyaz - Kart arkaplanları, temiz yüzeyler
  static const Color white = Color(0xFFFFFFFF);
  
  /// Çok açık gri - Ana arkaplan rengi
  static const Color backgroundLight = Color(0xFFF5F5F5); // grey.shade200 benzeri
  
  /// Hafif gri - Kartlar, AppBar arkaplanı
  static const Color surfaceLight = Color(0xFFFAFAFA); // white60/white70 benzeri
  
  /// Orta gri - Button backgrounds, disabled states
  static const Color grey300 = Color(0xFFE0E0E0); // grey.shade300
  
  /// Orta-Koyu gri - Button backgrounds alternative
  static const Color grey200 = Color(0xFFEEEEEE); // grey.shade200
  
  /// Koyu gri - İkincil metinler
  static const Color grey600 = Color(0xFF757575);
  
  /// Çok koyu gri - Ana metinler, başlıklar
  static const Color grey900 = Color(0xFF212121);
  
  /// Mavi-Gri tonu - Özel başlıklar için
  static const Color blueGrey900 = Color(0xFF263238);

  // ============================================================
  // SEMANTIC COLORS (Anlamsal Renkler)
  // ============================================================
  
  /// Başarı - Onay, tamamlanan işlemler
  static const Color success = Color(0xFF4CAF50); // Green
  
  /// Uyarı - Dikkat gerektiren durumlar
  static const Color warning = Color(0xFFFFC107); // Amber
  
  /// Hata - Validasyon hataları, kritik durumlar
  static const Color error = Color(0xFFF44336); // Red
  
  /// Bilgi - Bilgilendirme mesajları
  static const Color info = Color(0xFF2196F3); // Blue
  
  // ============================================================
  // ERROR RELATED COLORS
  // ============================================================
  
  /// Hata arkaplan rengi (alpha ile)
  static Color get errorBackground => error.withOpacity(0.08);
  
  /// Hata border rengi (alpha ile)
  static Color get errorBorder => error.withOpacity(0.3);

  // ============================================================
  // TEXT COLORS (Metin Renkleri)
  // ============================================================
  
  /// Ana metin rengi - Body text
  static const Color textPrimary = Color(0xFF212121);
  
  /// İkincil metin rengi - Alt başlıklar, açıklamalar
  static const Color textSecondary = Color(0xFF757575);
  
  /// Devre dışı metin rengi
  static const Color textDisabled = Color(0xFF9E9E9E);
  
  /// Beyaz metin - Dark backgrounds üzerinde
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  
  /// Siyah metin - Light backgrounds üzerinde
  static const Color textOnSurface = Color(0xFF000000);

  // ============================================================
  // BORDER COLORS (Kenar Renkleri)
  // ============================================================
  
  /// Varsayılan border rengi
  static const Color border = Color(0xFFE0E0E0);
  
  /// Focus border rengi
  static const Color borderFocus = primary;
  
  /// Error border rengi
  static const Color borderError = error;

  // ============================================================
  // SPECIAL PURPOSE (Özel Amaçlı)
  // ============================================================
  
  /// Divider (ayırıcı) rengi
  static const Color divider = Color(0xFFBDBDBD);
  
  /// Shadow rengi
  static const Color shadow = Color(0x1F000000);
  
  /// Overlay rengi (modal backgrounds)
  static Color get overlay => const Color(0xFF000000).withOpacity(0.5);
}
