import 'package:flutter/material.dart';
import 'app_colors.dart';

/// 🌑 ENG ERP Uygulama Shadow & Elevation Sistemi (Design Tokens)
///
/// Projedeki tüm gölge ve elevation değerlerini merkezi bir yerden yönetir.
/// Tutarlı derinlik hissi, modern ve katmanlı bir UI sağlar.
class AppShadows {
  AppShadows._(); // Private constructor

  // ============================================================
  // ELEVATION VALUES (Material Design Elevation)
  // ============================================================
  
  /// Hiç elevation yok - 0
  static const double elevationNone = 0.0;
  
  /// Çok düşük elevation - 1
  static const double elevationXs = 1.0;
  
  /// Düşük elevation - 2 (AppBar)
  static const double elevationSm = 2.0;
  
  /// Orta elevation - 3 (Cards)
  static const double elevationMd = 3.0;
  
  /// Yüksek elevation - 4 (Large cards, login card)
  static const double elevationLg = 4.0;
  
  /// Çok yüksek elevation - 6 (Dialogs, bottom sheets)
  static const double elevationXl = 6.0;
  
  /// Ultra yüksek elevation - 8 (Modals)
  static const double elevationXxl = 8.0;
  
  /// Maksimum elevation - 12 (Floating action buttons, snackbars)
  static const double elevationMax = 12.0;

  // ============================================================
  // SPECIFIC USE CASES (Özel Kullanımlar)
  // ============================================================
  
  /// AppBar elevation
  static const double appBarElevation = elevationSm;
  
  /// Card elevation - Standart kartlar
  static const double cardElevation = elevationMd;
  
  /// Large card elevation - Login card gibi büyük kartlar
  static const double cardElevationLarge = elevationLg;
  
  /// Dialog elevation
  static const double dialogElevation = elevationXl;
  
  /// Bottom sheet elevation
  static const double bottomSheetElevation = elevationXl;
  
  /// Button elevation
  static const double buttonElevation = elevationSm;
  
  /// FAB (Floating Action Button) elevation
  static const double fabElevation = elevationMax;

  // ============================================================
  // BOX SHADOW PRESETS (Özel Gölge Efektleri)
  // ============================================================
  
  /// Hiç gölge yok
  static List<BoxShadow> get shadowNone => [];
  
  /// Çok hafif gölge - Subtle depth
  static List<BoxShadow> get shadowXs => [
    BoxShadow(
      color: AppColors.shadow.withOpacity(0.04),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];
  
  /// Hafif gölge - Small cards, elevation 2
  static List<BoxShadow> get shadowSm => [
    BoxShadow(
      color: AppColors.shadow.withOpacity(0.06),
      blurRadius: 4,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];
  
  /// Orta gölge - Standard cards, elevation 3
  static List<BoxShadow> get shadowMd => [
    BoxShadow(
      color: AppColors.shadow.withOpacity(0.08),
      blurRadius: 6,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.shadow.withOpacity(0.04),
      blurRadius: 3,
      offset: const Offset(0, 1),
      spreadRadius: 0,
    ),
  ];
  
  /// Büyük gölge - Large cards, elevation 4
  static List<BoxShadow> get shadowLg => [
    BoxShadow(
      color: AppColors.shadow.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.shadow.withOpacity(0.06),
      blurRadius: 4,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];
  
  /// Çok büyük gölge - Dialogs, elevation 6
  static List<BoxShadow> get shadowXl => [
    BoxShadow(
      color: AppColors.shadow.withOpacity(0.14),
      blurRadius: 12,
      offset: const Offset(0, 6),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.shadow.withOpacity(0.08),
      blurRadius: 6,
      offset: const Offset(0, 3),
      spreadRadius: 0,
    ),
  ];
  
  /// Ultra gölge - Modals, elevation 8
  static List<BoxShadow> get shadowXxl => [
    BoxShadow(
      color: AppColors.shadow.withOpacity(0.18),
      blurRadius: 16,
      offset: const Offset(0, 8),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.shadow.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];
  
  /// Maksimum gölge - FAB, Snackbar, elevation 12
  static List<BoxShadow> get shadowMax => [
    BoxShadow(
      color: AppColors.shadow.withOpacity(0.2),
      blurRadius: 20,
      offset: const Offset(0, 10),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: AppColors.shadow.withOpacity(0.12),
      blurRadius: 10,
      offset: const Offset(0, 5),
      spreadRadius: 0,
    ),
  ];

  // ============================================================
  // INNER SHADOW (İç Gölge - Inset Effect)
  // ============================================================
  
  /// İç gölge - Pressed states için
  static List<BoxShadow> get innerShadow => [
    BoxShadow(
      color: AppColors.shadow.withOpacity(0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
      spreadRadius: -2,
    ),
  ];

  // ============================================================
  // COLORED SHADOWS (Renkli Gölgeler - Özel efektler için)
  // ============================================================
  
  /// Primary color gölge - Önemli butonlar için
  static List<BoxShadow> primaryShadow({double opacity = 0.3}) => [
    BoxShadow(
      color: AppColors.primary.withOpacity(opacity),
      blurRadius: 12,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];
  
  /// Success color gölge
  static List<BoxShadow> successShadow({double opacity = 0.3}) => [
    BoxShadow(
      color: AppColors.success.withOpacity(opacity),
      blurRadius: 12,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];
  
  /// Error color gölge
  static List<BoxShadow> errorShadow({double opacity = 0.3}) => [
    BoxShadow(
      color: AppColors.error.withOpacity(opacity),
      blurRadius: 12,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  // ============================================================
  // HELPER METHODS (Yardımcı Metodlar)
  // ============================================================
  
  /// Elevation değerine göre otomatik gölge seç
  static List<BoxShadow> fromElevation(double elevation) {
    if (elevation <= 0) return shadowNone;
    if (elevation <= 1) return shadowXs;
    if (elevation <= 2) return shadowSm;
    if (elevation <= 3) return shadowMd;
    if (elevation <= 4) return shadowLg;
    if (elevation <= 6) return shadowXl;
    if (elevation <= 8) return shadowXxl;
    return shadowMax;
  }
  
  /// Custom shadow oluştur
  static List<BoxShadow> custom({
    required Color color,
    required double blurRadius,
    required Offset offset,
    double spreadRadius = 0,
    double opacity = 0.1,
  }) {
    return [
      BoxShadow(
        color: color.withOpacity(opacity),
        blurRadius: blurRadius,
        offset: offset,
        spreadRadius: spreadRadius,
      ),
    ];
  }
}
