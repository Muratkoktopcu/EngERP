/// 📚 ENG ERP DESIGN TOKENS - Kullanım Kılavuzu
/// 
/// Bu dosya, oluşturulan tasarım token'larının nasıl kullanılacağını gösterir.
/// Gerçek bir sayfa değil, sadece referans amaçlıdır.

/*
═══════════════════════════════════════════════════════════════════════════
📁 OLUŞTURULAN DOSYALAR
═══════════════════════════════════════════════════════════════════════════

lib/core/theme/
  ├── app_colors.dart      - 🎨 Renk paleti
  ├── app_spacing.dart     - 📏 Boşluklar ve padding
  ├── app_radius.dart      - 🔵 Border radius değerleri
  ├── app_typography.dart  - 📝 Metin stilleri
  ├── app_shadows.dart     - 🌑 Gölge ve elevation
  ├── app_theme.dart       - 🎨 Ana tema (hepsini birleştirir)
  └── theme.dart           - 📦 Barrel export file

═══════════════════════════════════════════════════════════════════════════
🚀 KULLANIM ÖRNEKLERİ
═══════════════════════════════════════════════════════════════════════════

1️⃣ IMPORT
───────────────────────────────────────────────────────────────────────────
import 'package:eng_erp/core/theme/theme.dart';


2️⃣ RENKLER (AppColors)
───────────────────────────────────────────────────────────────────────────

// Container arka plan rengi
Container(
  color: AppColors.backgroundLight,
  child: ...
)

// Buton rengi
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.textOnPrimary,
  ),
  child: Text('Giriş Yap'),
)

// Error mesajı
Container(
  decoration: BoxDecoration(
    color: AppColors.errorBackground,
    border: Border.all(color: AppColors.errorBorder),
  ),
  child: Text('Hata mesajı', style: TextStyle(color: AppColors.error)),
)


3️⃣ BOŞLUKLAR (AppSpacing)
───────────────────────────────────────────────────────────────────────────

// Padding kullanımı
Padding(
  padding: AppSpacing.allMd,  // 12px her yönden
  child: ...
)

// Farklı padding seçenekleri
Card(
  child: Padding(
    padding: AppSpacing.cardPadding,  // Kart için standart padding
    child: ...
  ),
)

// SizedBox ile boşluk
Column(
  children: [
    Text('Başlık'),
    AppSpacing.verticalSpace20,  // 20px dikey boşluk
    Text('İçerik'),
  ],
)

// Özel kombinasyonlar
Padding(
  padding: AppSpacing.buttonPadding,  // horizontal: 22, vertical: 10
  child: Text('Buton'),
)


4️⃣ BORDER RADIUS (AppRadius)
───────────────────────────────────────────────────────────────────────────

// Card border radius
Card(
  shape: AppRadius.cardBorder,  // 8px yuvarlaklık
  child: ...
)

// TextField border radius
TextField(
  decoration: InputDecoration(
    border: AppRadius.outlineInputBorder,  // 6px
  ),
)

// Custom container
Container(
  decoration: BoxDecoration(
    borderRadius: AppRadius.radiusLg,  // 12px
    color: Colors.blue,
  ),
  child: ...
)


5️⃣ TİPOGRAFİ (AppTypography)
───────────────────────────────────────────────────────────────────────────

// Başlık stilleri
Text(
  'Ana Başlık',
  style: AppTypography.h1,  // 28px, bold, letter-spacing
)

Text(
  'Alt Başlık',
  style: AppTypography.h3,  // 20px, semibold
)

// Body text
Text(
  'Normal metin içeriği',
  style: AppTypography.bodyMedium,  // 14px, regular
)

// Label (form etiketleri)
Text(
  'E-Posta',
  style: AppTypography.labelMedium,  // 13px, bold
)

// Button text
Text(
  'GİRİŞ YAP',
  style: AppTypography.buttonLarge,  // 18px, bold
)

// Error text
Text(
  'Geçersiz e-posta',
  style: AppTypography.errorText,  // error rengi ile
)


6️⃣ GÖLGELER (AppShadows)
───────────────────────────────────────────────────────────────────────────

// Card elevation
Card(
  elevation: AppShadows.cardElevation,  // 3
  child: ...
)

// Container'a box shadow
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: AppRadius.radiusMd,
    boxShadow: AppShadows.shadowMd,  // Orta gölge
  ),
  child: ...
)

// Primary renkte gölge (özel efekt)
Container(
  decoration: BoxDecoration(
    color: AppColors.primary,
    boxShadow: AppShadows.primaryShadow(),  // Mavi gölge
  ),
  child: ...
)


7️⃣ KOMPLE THEME KULLANIMI (main.dart)
───────────────────────────────────────────────────────────────────────────

import 'package:eng_erp/core/theme/theme.dart';

class EngErp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,  // ✅ Tüm token'ları içerir!
      home: HomePage(),
    );
  }
}


8️⃣ GERÇEK DÜNYA ÖRNEĞİ - LOGIN BUTTON
───────────────────────────────────────────────────────────────────────────

ElevatedButton(
  onPressed: _loading ? null : _submitForm,
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.textOnPrimary,
    shape: AppRadius.buttonBorder,
    padding: AppSpacing.buttonPadding,
    elevation: AppShadows.buttonElevation,
  ),
  child: Text(
    'GİRİŞ YAP',
    style: AppTypography.buttonLarge,
  ),
)


9️⃣ GERÇEK DÜNYA ÖRNEĞİ - INPUT FIELD
───────────────────────────────────────────────────────────────────────────

TextField(
  decoration: InputDecoration(
    labelText: "E-Posta Adresi",
    labelStyle: AppTypography.labelMedium,
    prefixIcon: Icon(Icons.email_outlined),
    border: AppRadius.outlineInputBorder,
    contentPadding: AppSpacing.inputPaddingMedium,
  ),
)


🔟 GERÇEK DÜNYA ÖRNEĞİ - CARD
───────────────────────────────────────────────────────────────────────────

Card(
  elevation: AppShadows.cardElevation,
  shape: AppRadius.cardBorder,
  child: Padding(
    padding: AppSpacing.cardPadding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Rezervasyon Bilgileri', style: AppTypography.h4),
        AppSpacing.verticalSpace12,
        Text('İçerik...', style: AppTypography.bodyMedium),
      ],
    ),
  ),
)


═══════════════════════════════════════════════════════════════════════════
💡 FAYDALAR
═══════════════════════════════════════════════════════════════════════════

✅ Tutarlılık: Tüm uygulamada aynı değerler kullanılır
✅ Bakım Kolaylığı: Bir yerden değişiklik yaparsınız, her yere yansır
✅ Ölçeklenebilirlik: Yeni sayfalar eklerken aynı standartları kullanırsınız
✅ Dark Mode Hazır: İleride dark theme eklemek çok kolay olur
✅ Tasarımcı Dostu: Tasarım değişikliklerini uygulamak 5 dakika
✅ Okunabilir Kod: AppColors.primary vs Color(0xFF2196F3)

═══════════════════════════════════════════════════════════════════════════
🔄 MEVCUT KODLARI GÜNCELLEMEDOKÜMANTASYON
═══════════════════════════════════════════════════════════════════════════

ESKİ KOD:
---------
Colors.grey.shade300  →  AppColors.grey300
Colors.blue           →  AppColors.primary
EdgeInsets.all(12)    →  AppSpacing.allMd
BorderRadius.circular(6)  →  AppRadius.radiusSm
elevation: 3          →  elevation: AppShadows.cardElevation
fontSize: 18          →  style: AppTypography.buttonLarge

YENİ KOD ÖRNEĞİ:
----------------
// Eski
Container(
  padding: EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: Colors.grey.shade300,
    borderRadius: BorderRadius.circular(8),
  ),
)

// Yeni
Container(
  padding: AppSpacing.allMd,
  decoration: BoxDecoration(
    color: AppColors.grey300,
    borderRadius: AppRadius.radiusMd,
  ),
)


═══════════════════════════════════════════════════════════════════════════
🎯 SONRAKİ ADIMLAR
═══════════════════════════════════════════════════════════════════════════

1. Mevcut sayfalardaki hard-coded değerleri token'larla değiştirin
2. Yeni özellikler eklerken SADECE token'ları kullanın
3. İleride dark theme eklemek isterseniz AppColors'ı genişletin
4. Projeye özel yeni token'lar ekleyin (örn: AppAnimations, AppSizes)

*/
