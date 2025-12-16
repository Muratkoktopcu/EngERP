import 'package:flutter/material.dart';

/// 🔵 ENG ERP Uygulama Border Radius Sistemi (Design Tokens)
///
/// Projedeki tüm border radius değerlerini merkezi bir yerden yönetir.
/// Tutarlı yuvarlak köşeler, modern ve profesyonel bir görünüm sağlar.
class AppRadius {
  AppRadius._(); // Private constructor

  // ============================================================
  // RADIUS VALUES (Temel Değerler)
  // ============================================================
  
  /// Hiç yuvarlaklık yok - 0
  static const double none = 0.0;
  
  /// Çok küçük yuvarlaklık - 4px
  static const double xs = 4.0;
  
  /// Küçük yuvarlaklık - 6px (Input fields, dropdowns)
  static const double sm = 6.0;
  
  /// Orta yuvarlaklık - 8px (Cards, buttons)
  static const double md = 8.0;
  
  /// Büyük yuvarlaklık - 12px (Buttons, error containers)
  static const double lg = 12.0;
  
  /// Çok büyük yuvarlaklık - 16px (Large cards, login card)
  static const double xl = 16.0;
  
  /// Ultra büyük yuvarlaklık - 24px
  static const double xxl = 24.0;
  
  /// Tam yuvarlak - 999px (Pills, avatars)
  static const double full = 999.0;

  // ============================================================
  // BORDER RADIUS OBJECTS (Hazır BorderRadius Nesneleri)
  // ============================================================
  
  /// Hiç yuvarlaklık yok
  static BorderRadius get radiusNone => BorderRadius.circular(none);
  
  /// Çok küçük yuvarlaklık - 4px
  static BorderRadius get radiusXs => BorderRadius.circular(xs);
  
  /// Küçük yuvarlaklık - 6px (Input fields)
  static BorderRadius get radiusSm => BorderRadius.circular(sm);
  
  /// Orta yuvarlaklık - 8px (Cards)
  static BorderRadius get radiusMd => BorderRadius.circular(md);
  
  /// Büyük yuvarlaklık - 12px (Buttons)
  static BorderRadius get radiusLg => BorderRadius.circular(lg);
  
  /// Çok büyük yuvarlaklık - 16px (Large cards)
  static BorderRadius get radiusXl => BorderRadius.circular(xl);
  
  /// Ultra büyük yuvarlaklık - 24px
  static BorderRadius get radiusXxl => BorderRadius.circular(xxl);
  
  /// Tam yuvarlak - 999px
  static BorderRadius get radiusFull => BorderRadius.circular(full);

  // ============================================================
  // SPECIFIC USE CASE SHORTCUTS (Özel Kullanım Kısayolları)
  // ============================================================
  
  /// Input field border radius - 6px
  static BorderRadius get inputRadius => radiusSm;
  
  /// Dropdown border radius - 6px
  static BorderRadius get dropdownRadius => radiusSm;
  
  /// Button border radius - 12px
  static BorderRadius get buttonRadius => radiusLg;
  
  /// Card border radius - 8px
  static BorderRadius get cardRadius => radiusMd;
  
  /// Large card border radius - 16px
  static BorderRadius get cardRadiusLarge => radiusXl;
  
  /// Dialog border radius - 12px
  static BorderRadius get dialogRadius => radiusLg;
  
  /// Bottom sheet border radius - Sadece üst köşeler
  static BorderRadius get bottomSheetRadius => const BorderRadius.only(
    topLeft: Radius.circular(xl),
    topRight: Radius.circular(xl),
  );

  // ============================================================
  // ROUNDED RECTANGLE BORDER (RoundedRectangleBorder)
  // ============================================================
  
  /// Input field için RoundedRectangleBorder
  static RoundedRectangleBorder get inputBorder => RoundedRectangleBorder(
    borderRadius: inputRadius,
  );
  
  /// Button için RoundedRectangleBorder
  static RoundedRectangleBorder get buttonBorder => RoundedRectangleBorder(
    borderRadius: buttonRadius,
  );
  
  /// Card için RoundedRectangleBorder
  static RoundedRectangleBorder get cardBorder => RoundedRectangleBorder(
    borderRadius: cardRadius,
  );
  
  /// Large card için RoundedRectangleBorder
  static RoundedRectangleBorder get cardBorderLarge => RoundedRectangleBorder(
    borderRadius: cardRadiusLarge,
  );
  
  /// Dialog için RoundedRectangleBorder
  static RoundedRectangleBorder get dialogBorder => RoundedRectangleBorder(
    borderRadius: dialogRadius,
  );

  // ============================================================
  // OUTLINE INPUT BORDER (Input Decoration için)
  // ============================================================
  
  /// Standart input border - 6px
  static OutlineInputBorder get outlineInputBorder => OutlineInputBorder(
    borderRadius: inputRadius,
  );
  
  /// Dropdown border - 6px
  static OutlineInputBorder get outlineDropdownBorder => OutlineInputBorder(
    borderRadius: dropdownRadius,
  );

  // ============================================================
  // CUSTOM RADIUS (Özel Kombinasyonlar)
  // ============================================================
  
  /// Sadece sol taraf yuvarlatılmış
  static BorderRadius get leftRounded => BorderRadius.only(
    topLeft: Radius.circular(md),
    bottomLeft: Radius.circular(md),
  );
  
  /// Sadece sağ taraf yuvarlatılmış
  static BorderRadius get rightRounded => BorderRadius.only(
    topRight: Radius.circular(md),
    bottomRight: Radius.circular(md),
  );
  
  /// Sadece üst kısım yuvarlatılmış
  static BorderRadius get topRounded => BorderRadius.only(
    topLeft: Radius.circular(md),
    topRight: Radius.circular(md),
  );
  
  /// Sadece alt kısım yuvarlatılmış
  static BorderRadius get bottomRounded => BorderRadius.only(
    bottomLeft: Radius.circular(md),
    bottomRight: Radius.circular(md),
  );
}
