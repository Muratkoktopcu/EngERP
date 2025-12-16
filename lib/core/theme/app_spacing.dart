import 'package:flutter/material.dart';

/// 📏 ENG ERP Uygulama Spacing Sistemi (Design Tokens)
///
/// Projedeki tüm boşlukları ve padding değerlerini merkezi bir yerden yönetir.
/// Tutarlı bir spacing sistemi, profesyonel ve dengeli bir UI sağlar.
class AppSpacing {
  AppSpacing._(); // Private constructor

  // ============================================================
  // BASE SPACING UNITS (Temel Birimler)
  // ============================================================
  
  /// En küçük spacing birimi - 4.0px
  static const double xs = 4.0;
  
  /// Küçük spacing - 8.0px (çok yaygın)
  static const double sm = 8.0;
  
  /// Orta spacing - 12.0px (kart padding, genel padding)
  static const double md = 12.0;
  
  /// Büyük spacing - 16.0px
  static const double lg = 16.0;
  
  /// Çok büyük spacing - 24.0px (büyük kartlar)
  static const double xl = 24.0;
  
  /// Ultra büyük spacing - 32.0px
  static const double xxl = 32.0;

  // ============================================================
  // SPECIFIC SPACING VALUES (Özel Değerler)
  // ============================================================
  
  /// Çok küçük boşluk - UI elementleri arası - 5.0px
  static const double space5 = 5.0;
  
  /// Küçük boşluk - Componentler arası - 6.0px
  static const double space6 = 6.0;
  
  /// Orta boşluk - Bölümler arası - 10.0px
  static const double space10 = 10.0;
  
  /// Standart boşluk - Section spacing - 12.0px
  static const double space12 = 12.0;
  
  /// Büyük boşluk - Major sections - 15.0px
  static const double space15 = 15.0;
  
  /// Geniş boşluk - Major separations - 20.0px
  static const double space20 = 20.0;
  
  /// Çok geniş boşluk - Page sections - 30.0px
  static const double space30 = 30.0;

  // ============================================================
  // EDGE INSETS PRESETS (Hazır EdgeInsets Değerleri)
  // ============================================================
  
  /// Sıfır padding
  static const EdgeInsets zero = EdgeInsets.zero;
  
  /// Tüm yönlere 4px
  static const EdgeInsets allXs = EdgeInsets.all(xs);
  
  /// Tüm yönlere 8px - Küçük kartlar, compact UI
  static const EdgeInsets allSm = EdgeInsets.all(sm);
  
  /// Tüm yönlere 12px - Orta kartlar, genel kullanım
  static const EdgeInsets allMd = EdgeInsets.all(md);
  
  /// Tüm yönlere 16px - Büyük kartlar
  static const EdgeInsets allLg = EdgeInsets.all(lg);
  
  /// Tüm yönlere 24px - Çok büyük kartlar, login ekranı
  static const EdgeInsets allXl = EdgeInsets.all(xl);
  
  /// Tüm yönlere 32px - Page padding
  static const EdgeInsets allXxl = EdgeInsets.all(xxl);

  // ============================================================
  // HORIZONTAL PADDING (Yatay Padding)
  // ============================================================
  
  /// Yatay 8px
  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: sm);
  
  /// Yatay 12px - Form fields, buttons
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);
  
  /// Yatay 16px
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);
  
  /// Yatay 22px - Action buttons (mevcut koddan)
  static const EdgeInsets horizontal22 = EdgeInsets.symmetric(horizontal: 22);
  
  /// Yatay 24px
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: xl);

  // ============================================================
  // VERTICAL PADDING (Dikey Padding)
  // ============================================================
  
  /// Dikey 4px - Input fields (compact)
  static const EdgeInsets verticalXs = EdgeInsets.symmetric(vertical: xs);
  
  /// Dikey 8px
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: sm);
  
  /// Dikey 10px - Medium buttons
  static const EdgeInsets vertical10 = EdgeInsets.symmetric(vertical: 10);
  
  /// Dikey 12px
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);
  
  /// Dikey 14px - Button height (mevcut koddan)
  static const EdgeInsets vertical14 = EdgeInsets.symmetric(vertical: 14);
  
  /// Dikey 16px
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: lg);

  // ============================================================
  // SYMMETRIC PADDING (Özel Kombinasyonlar)
  // ============================================================
  
  /// Input field padding - Horizontal 8, Vertical 4
  static const EdgeInsets inputPaddingCompact = EdgeInsets.symmetric(
    horizontal: sm,
    vertical: xs,
  );
  
  /// Input field padding - Horizontal 8, Vertical 10
  static const EdgeInsets inputPaddingMedium = EdgeInsets.symmetric(
    horizontal: sm,
    vertical: 10,
  );
  
  /// Button padding - Horizontal 22, Vertical 10
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: 22,
    vertical: 10,
  );
  
  /// Button padding large - Horizontal 22, Vertical 14
  static const EdgeInsets buttonPaddingLarge = EdgeInsets.symmetric(
    horizontal: 22,
    vertical: 14,
  );
  
  /// Button padding compact - Horizontal 16, Vertical 12
  static const EdgeInsets buttonPaddingCompact = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );

  // ============================================================
  // CUSTOM PADDING (Özel Kullanımlar)
  // ============================================================
  
  /// Sadece sağdan padding - 8px (liste elemanları için)
  static const EdgeInsets onlyRight8 = EdgeInsets.only(right: 8);
  
  /// Liste ögesi padding - Horizontal 12
  static const EdgeInsets listItem = EdgeInsets.symmetric(horizontal: md);
  
  /// Card padding standart - All 12
  static const EdgeInsets cardPadding = allMd;
  
  /// Card padding küçük - All 8
  static const EdgeInsets cardPaddingCompact = allSm;
  
  /// Card padding büyük - All 24
  static const EdgeInsets cardPaddingLarge = allXl;
  
  /// Page padding - All 12
  static const EdgeInsets pagePadding = allMd;

  // ============================================================
  // SIZED BOX HELPERS (Boşluk Widget'ları)
  // ============================================================
  
  /// Dikey boşluk - 5px
  static const Widget verticalSpace5 = SizedBox(height: space5);
  
  /// Dikey boşluk - 6px
  static const Widget verticalSpace6 = SizedBox(height: space6);
  
  /// Dikey boşluk - 10px
  static const Widget verticalSpace10 = SizedBox(height: space10);
  
  /// Dikey boşluk - 12px
  static const Widget verticalSpace12 = SizedBox(height: space12);
  
  /// Dikey boşluk - 20px
  static const Widget verticalSpace20 = SizedBox(height: space20);
  
  /// Dikey boşluk - 30px
  static const Widget verticalSpace30 = SizedBox(height: space30);
  
  /// Yatay boşluk - 6px
  static const Widget horizontalSpace6 = SizedBox(width: space6);
  
  /// Yatay boşluk - 10px
  static const Widget horizontalSpace10 = SizedBox(width: space10);
  
  /// Yatay boşluk - 15px
  static const Widget horizontalSpace15 = SizedBox(width: space15);
  
  /// Yatay boşluk - 20px
  static const Widget horizontalSpace20 = SizedBox(width: space20);
}
