import 'package:flutter/material.dart';
import 'app_colors.dart';

/// 📝 ENG ERP Uygulama Typography Sistemi (Design Tokens)
///
/// Projedeki tüm metin stillerini merkezi bir yerden yönetir.
/// Tutarlı tipografi, profesyonel ve okunabilir bir UI sağlar.
class AppTypography {
  AppTypography._(); // Private constructor

  // ============================================================
  // FONT FAMILY
  // ============================================================
  
  /// Varsayılan font ailesi (Material Design default)
  /// İsterseniz Google Fonts veya custom font kullanabilirsiniz
  static const String defaultFontFamily = 'Roboto';

  // ============================================================
  // FONT SIZES (Font Boyutları)
  // ============================================================
  
  /// Çok küçük font - 10px
  static const double fontSizeXs = 10.0;
  
  /// Küçük font - 12px
  static const double fontSizeSm = 12.0;
  
  /// Normal font - 13px (Label text)
  static const double fontSizeMd = 13.0;
  
  /// Standart font - 14px
  static const double fontSizeBase = 14.0;
  
  /// Alt başlık/açıklama - 16px
  static const double fontSizeLg = 16.0;
  
  /// Büyük font - 18px (Button text)
  static const double fontSizeXl = 18.0;
  
  /// Çok büyük - 20px
  static const double fontSize20 = 20.0;
  
  /// Başlık - 24px
  static const double fontSize24 = 24.0;
  
  /// Ana başlık - 28px (Login title)
  static const double fontSize28 = 28.0;
  
  /// Hero başlık - 32px
  static const double fontSize32 = 32.0;

  // ============================================================
  // FONT WEIGHTS (Font Kalınlıkları)
  // ============================================================
  
  /// Normal kalınlık - 400
  static const FontWeight weightRegular = FontWeight.w400;
  
  /// Orta kalınlık - 500
  static const FontWeight weightMedium = FontWeight.w500;
  
  /// Yarı kalın - 600
  static const FontWeight weightSemiBold = FontWeight.w600;
  
  /// Kalın - 700
  static const FontWeight weightBold = FontWeight.w700;
  
  /// Çok kalın - 800
  static const FontWeight weightExtraBold = FontWeight.w800;

  // ============================================================
  // LETTER SPACING (Harf Aralığı)
  // ============================================================
  
  /// Normal harf aralığı
  static const double letterSpacingNormal = 0.0;
  
  /// Geniş harf aralığı - 0.5
  static const double letterSpacingWide = 0.5;
  
  /// Çok geniş harf aralığı - 1.5 (Başlıklar için)
  static const double letterSpacingExtraWide = 1.5;

  // ============================================================
  // LINE HEIGHT (Satır Yüksekliği)
  // ============================================================
  
  /// Sıkı satır aralığı
  static const double lineHeightTight = 1.2;
  
  /// Normal satır aralığı
  static const double lineHeightNormal = 1.5;
  
  /// Geniş satır aralığı
  static const double lineHeightLoose = 1.8;

  // ============================================================
  // HEADING STYLES (Başlık Stilleri)
  // ============================================================
  
  /// Hero başlık - En büyük başlık (Login screen)
  static TextStyle get h1 => const TextStyle(
    fontSize: fontSize28,
    fontWeight: weightBold,
    letterSpacing: letterSpacingExtraWide,
    color: AppColors.blueGrey900,
    height: lineHeightTight,
  );
  
  /// Ana başlık - Sayfa başlıkları
  static TextStyle get h2 => const TextStyle(
    fontSize: fontSize24,
    fontWeight: weightBold,
    color: AppColors.blueGrey900,
    height: lineHeightTight,
  );
  
  /// Alt başlık - Section başlıkları
  static TextStyle get h3 => const TextStyle(
    fontSize: fontSize20,
    fontWeight: weightSemiBold,
    color: AppColors.blueGrey900,
    height: lineHeightNormal,
  );
  
  /// Küçük başlık - Kart başlıkları
  static TextStyle get h4 => const TextStyle(
    fontSize: fontSizeXl,
    fontWeight: weightMedium,
    color: AppColors.blueGrey900,
    height: lineHeightNormal,
  );
  
  /// Mini başlık
  static TextStyle get h5 => const TextStyle(
    fontSize: fontSizeLg,
    fontWeight: weightMedium,
    color: AppColors.textPrimary,
    height: lineHeightNormal,
  );

  // ============================================================
  // BODY STYLES (Gövde Metin Stilleri)
  // ============================================================
  
  /// Ana body text - Standart metin
  static TextStyle get bodyLarge => const TextStyle(
    fontSize: fontSizeLg,
    fontWeight: weightRegular,
    color: AppColors.textPrimary,
    height: lineHeightNormal,
  );
  
  /// Orta body text
  static TextStyle get bodyMedium => const TextStyle(
    fontSize: fontSizeBase,
    fontWeight: weightRegular,
    color: AppColors.textPrimary,
    height: lineHeightNormal,
  );
  
  /// Küçük body text
  static TextStyle get bodySmall => const TextStyle(
    fontSize: fontSizeSm,
    fontWeight: weightRegular,
    color: AppColors.textSecondary,
    height: lineHeightNormal,
  );

  // ============================================================
  // LABEL STYLES (Etiket Stilleri)
  // ============================================================
  
  /// Büyük label - Form etiketleri
  static TextStyle get labelLarge => const TextStyle(
    fontSize: fontSizeBase,
    fontWeight: weightMedium,
    color: AppColors.textPrimary,
  );
  
  /// Orta label - Form field labels
  static TextStyle get labelMedium => const TextStyle(
    fontSize: fontSizeMd,
    fontWeight: weightBold,
    color: AppColors.textPrimary,
  );
  
  /// Küçük label - Help text
  static TextStyle get labelSmall => const TextStyle(
    fontSize: fontSizeSm,
    fontWeight: weightRegular,
    color: AppColors.textSecondary,
  );

  // ============================================================
  // BUTTON STYLES (Buton Text Stilleri)
  // ============================================================
  
  /// Büyük buton text - Primary buttons
  static TextStyle get buttonLarge => const TextStyle(
    fontSize: fontSizeXl,
    fontWeight: weightBold,
    letterSpacing: letterSpacingWide,
  );
  
  /// Orta buton text - Standart buttons
  static TextStyle get buttonMedium => const TextStyle(
    fontSize: fontSizeBase,
    fontWeight: weightMedium,
  );
  
  /// Küçük buton text - Compact buttons
  static TextStyle get buttonSmall => const TextStyle(
    fontSize: fontSizeMd,
    fontWeight: weightMedium,
  );

  // ============================================================
  // SPECIAL PURPOSE STYLES (Özel Amaçlı Stiller)
  // ============================================================
  
  /// Alt başlık/Açıklama metni - Login screen subtitle
  static TextStyle get subtitle => TextStyle(
    fontSize: fontSizeLg,
    color: AppColors.grey600,
    fontWeight: weightRegular,
  );
  
  /// Caption - Çok küçük açıklama metni
  static TextStyle get caption => const TextStyle(
    fontSize: fontSizeSm,
    color: AppColors.textSecondary,
    fontWeight: weightRegular,
  );
  
  /// Overline - Üst etiket
  static TextStyle get overline => const TextStyle(
    fontSize: fontSizeXs,
    color: AppColors.textSecondary,
    fontWeight: weightMedium,
    letterSpacing: letterSpacingWide,
  );
  
  /// Error text - Hata mesajları
  static TextStyle get errorText => const TextStyle(
    fontSize: fontSizeBase,
    color: AppColors.error,
    fontWeight: weightRegular,
  );
  
  /// Hint text - Input placeholder
  static TextStyle get hintText => const TextStyle(
    fontSize: fontSizeBase,
    color: AppColors.textSecondary,
    fontWeight: weightRegular,
  );

  // ============================================================
  // DATA TABLE STYLES (Tablo Stilleri)
  // ============================================================
  
  /// Tablo başlık
  static TextStyle get tableHeader => const TextStyle(
    fontSize: fontSizeMd,
    fontWeight: weightBold,
    color: AppColors.textPrimary,
  );
  
  /// Tablo cell
  static TextStyle get tableCell => const TextStyle(
    fontSize: fontSizeMd,
    fontWeight: weightRegular,
    color: AppColors.textPrimary,
  );

  // ============================================================
  // APP BAR STYLES (AppBar Text Stilleri)
  // ============================================================
  
  /// AppBar title
  static TextStyle get appBarTitle => const TextStyle(
    fontSize: fontSize20,
    fontWeight: weightMedium,
    color: AppColors.textPrimary,
  );
}
