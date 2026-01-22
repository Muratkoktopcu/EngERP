# ENG ERP Proje Raporu

**Tarih:** 15 Ocak 2026  
**Versiyon:** 1.0.0  
**Platform:** Flutter (Cross-Platform)

---

## 📊 Proje Özeti

ENG ERP, **mermer/granit sektörü** için geliştirilmiş kurumsal bir ERP (Enterprise Resource Planning) mobil uygulamasıdır. Flutter framework kullanılarak geliştirilmiş olup Supabase backend entegrasyonu ile çalışmaktadır.

---

## 🛠️ Teknoloji Stack

| Kategori | Teknoloji | Versiyon |
|----------|-----------|----------|
| **Framework** | Flutter | SDK ^3.6.0 |
| **Backend** | Supabase | ^1.6.3 |
| **Navigasyon** | go_router | ^16.1.0 |
| **Barkod** | mobile_scanner | ^5.1.1 |
| **PDF** | pdf + printing | ^3.10.0 / ^5.11.0 |
| **Excel** | excel | ^4.0.0 |
| **Dosya Paylaşım** | share_plus + path_provider | ^7.2.0 / ^2.1.0 |
| **Tarih Format** | intl | ^0.18.0 |
| **İzinler** | permission_handler | ^11.0.0 |

---

## 📁 Proje Mimarisi

```
lib/
├── main.dart                    # Uygulama giriş noktası
├── core/                        # Çekirdek altyapı (17 dosya)
│   ├── constant/                # Sabit değerler
│   ├── models/                  # UserModel
│   ├── navigation/              # GoRouter + AppShell
│   ├── repositories/            # UserRepository
│   ├── services/                # Supabase Client + UserService
│   ├── theme/                   # Design Tokens (8 dosya)
│   └── widgets/                 # CustomAppBar, ModernSidebar
└── features/                    # 7 Feature Modülü (50 dosya)
    ├── auth/                    # Kimlik Doğrulama
    ├── stock/                   # Stok Yönetimi
    ├── reservation/             # Rezervasyon
    ├── sales_management/        # Satış Yönetimi
    ├── sales_confirmation/      # Satış Onay
    ├── cancel/                  # İptal İşlemleri
    └── home/                    # Ana Sayfa
```

**Toplam Dart Dosya Sayısı:** 68

---

## ✨ Feature Modülleri

### 1. 🔐 Auth (Kimlik Doğrulama)
| Klasör | Dosyalar |
|--------|----------|
| data/ | `auth_model.dart`, `auth_repository.dart`, `auth_service.dart` |
| pages/ | `login_page.dart` |

**Özellikler:**
- Supabase Authentication entegrasyonu
- E-posta/şifre ile giriş
- Otomatik oturum yenileme
- Kullanıcı profil yönetimi

---

### 2. 📦 Stock (Stok Yönetimi)
| Klasör | Dosyalar |
|--------|----------|
| data/ | `stock_model.dart`, `stock_service.dart`, `stock_repository.dart` |
| pages/ | `StockManagementPage.dart`, `barcode_scanner_page.dart`, `stock_report_preview_page.dart` |
| services/ | `stock_report_service.dart` (365 satır) |
| widgets/ | 6 widget dosyası |

**Özellikler:**
- Ürün listeleme, filtreleme, güncelleme, silme
- **Barkod okuyucu** (kamera entegrasyonu)
- **PDF rapor oluşturma**
- **Excel rapor oluşturma**
- Gelişmiş filtreleme (EPC, barkod, tarih, ürün tipi, durum)

---

### 3. 📅 Reservation (Rezervasyon)
| Klasör | Dosyalar |
|--------|----------|
| data/ | `reservation_model.dart`, `reservation_repository.dart`, `reservation_service.dart`, `company_model.dart` |
| pages/ | `ReservationPage.dart` |
| widgets/ | `reservation_filter_panel.dart`, `reservation_stock_table.dart`, `reservation_cart_table.dart`, `reservation_form_card.dart`, `reservation_action_buttons.dart`, `dimension_update_dialog.dart` |

**Özellikler:**
- Rezervasyon oluşturma
- Alıcı firma seçimi
- Çift tablo görünümü (kaynak & hedef)
- Boyut güncelleme

---

### 4. 💼 Sales Management (Satış Yönetimi)
| Klasör | Dosyalar |
|--------|----------|
| data/ | `sales_management_repository.dart`, `sales_management_service.dart`, `cancel_archive_model.dart` |
| pages/ | `sales_report_preview_page.dart` |
| services/ | `sales_report_service.dart` (526 satır) |
| widgets/ | 7 widget dosyası |

**Özellikler:**
- Satış listesi görüntüleme
- Rezervasyon iptal etme
- **Satış raporu PDF oluşturma**
- **Satış raporu Excel oluşturma**
- Ürün detay görüntüleme

---

### 5. ❌ Cancel (İptal İşlemleri)
| Klasör | Dosyalar |
|--------|----------|
| data/ | `cancel_repository.dart`, `cancel_service.dart` |
| pages/ | `CancelPage.dart`, `cancel_report_preview_page.dart` |
| services/ | `cancel_report_service.dart` (591 satır) |
| widgets/ | `cancel_filter_panel.dart`, `cancel_main_table.dart`, `cancel_detail_table.dart`, `cancel_action_buttons.dart` |

**Özellikler:**
- İptal listesi görüntüleme
- İptal detay görüntüleme
- **İptal raporu PDF oluşturma** (sayfa başlık/altbilgi, filtre açıklaması)
- **İptal raporu Excel oluşturma** (2 sayfa: iptal ve detay)
- Tarih periyodu filtreleme

---

## 🎨 Design System (Tasarım Sistemi)

| Dosya | İçerik | Satır |
|-------|--------|-------|
| `app_colors.dart` | Renk paleti | ~120 |
| `app_typography.dart` | Tipografi stilleri | ~200 |
| `app_spacing.dart` | Boşluk değerleri | ~160 |
| `app_radius.dart` | Kenar yuvarlaklıkları | ~140 |
| `app_shadows.dart` | Gölge tanımları | ~180 |
| `app_theme.dart` | Birleşik tema | ~70 |
| `USAGE_GUIDE.dart` | Kullanım kılavuzu | ~280 |

---

## 👤 Kullanıcı Yönetimi

### UserService (Singleton Pattern)
```dart
// Erişim
UserService.instance.displayName
UserService.instance.hasPermission('stok_yonetimi')

// Metodlar
loadUserProfile(userId)      // Profil yükle
clearUserProfile()           // Çıkış temizliği
hasPermission(page)          // İzin kontrolü
hasAnyPermission(pages)      // Çoklu izin (OR)
hasAllPermissions(pages)     // Çoklu izin (AND)
refreshProfile()             // Profil yenile
updateProfile(...)           // Profil güncelle
```

### İzin Sistemi
- `stokYonetimiAllow` - Stok Yönetimi
- `satisYonetimiAllow` - Satış Yönetimi
- `iptalAllow` - İptal İşlemleri
- `rezOlusturAllow` - Rezervasyon Oluşturma
- `isAdmin` - Tam yetki

---

## 📄 Rapor Servisleri

### StockReportService
| Metod | Açıklama |
|-------|----------|
| `generatePdf()` | PDF rapor oluştur |
| `generateExcel()` | Excel rapor oluştur |
| `savePdfToFile()` | PDF kaydet |
| `saveExcelToFile()` | Excel kaydet |
| `shareFile()` | Dosya paylaş |

### SalesReportService
| Metod | Açıklama |
|-------|----------|
| `generatePdf()` | Rezervasyon + ürün PDF |
| `generateExcel()` | Çift sayfalı Excel |
| `showPrintPreview()` | Yazdırma önizleme |
| `buildPeriodDescription()` | Periyot açıklaması |

### CancelReportService
| Metod | Açıklama |
|-------|----------|
| `generatePdf()` | İptal + detay PDF |
| `generateExcel()` | 2 sayfalı Excel |
| `buildFilterDescription()` | Filtre açıklaması |
| `_buildIptalInfo()` | İptal bilgi bölümü |

---

## 🔄 Repository Pattern

```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────┐
│   Widget    │ → │   Service    │ → │  Repository  │ → │ Supabase │
│    (UI)     │    │ (İş Mantığı) │    │ (Veri Erişim)│    │   (DB)   │
└─────────────┘    └──────────────┘    └──────────────┘    └──────────┘
```

---

## 📱 Platform Desteği

| Platform | Durum | Açıklama |
|----------|-------|----------|
| Android | ✅ | Birincil hedef |
| iOS | ✅ | Xcode gerekli |
| Windows | ✅ | Masaüstü |
| macOS | ✅ | Apple Silicon uyumlu |
| Linux | ✅ | GTK bağımlılıkları |
| Web | ✅ | PWA desteği |

---

## 📈 Proje Metrikleri

| Metrik | Değer |
|--------|-------|
| Toplam Dart Dosyası | 68 |
| Feature Modülü | 7 |
| Core Modülü | 11 klasör |
| Tasarım Token Dosyası | 8 |
| Harici Bağımlılık | 10 |
| En Büyük Servis | `cancel_report_service.dart` (591 satır) |

---

## 🚀 Gelecek Geliştirmeler

- [ ] State Management (Cubit/BLoC) tam entegrasyonu
- [ ] Offline çalışma desteği
- [ ] RFID donanım entegrasyonu
- [ ] Push notification desteği
- [ ] Dashboard ve istatistikler
- [ ] Çoklu dil desteği (i18n)
- [ ] Birim testleri

---

## 📖 Proje Tanıtım Metni

### Giriş

**ENG ERP**, mermer ve granit sektörüne özel olarak tasarlanmış, kurumsal düzeyde bir stok ve satış yönetim sistemidir. Flutter framework'ü ile geliştirilmiş bu cross-platform uygulama, hem mobil cihazlarda (Android, iOS) hem de masaüstü platformlarda (Windows, macOS, Linux) ve web üzerinde çalışabilmektedir.

### Projenin Amacı

Mermer ve granit sektöründe faaliyet gösteren işletmelerin karşılaştığı stok takibi, rezervasyon yönetimi, satış onay süreçleri ve iptal işlemleri gibi kritik iş süreçlerini dijitalleştirmek ve optimize etmek amacıyla geliştirilmiştir. Uygulama, bu süreçleri tek bir platform üzerinden yönetmeyi mümkün kılarak operasyonel verimliliği artırmayı hedeflemektedir.

### Temel Özellikler

**1. Stok Yönetimi**
Uygulama, kapsamlı bir stok yönetim modülü sunmaktadır. Kullanıcılar ürünleri EPC kodu, barkod numarası, bandil numarası, plaka numarası gibi çeşitli kriterlere göre filtreleyebilir ve listeleyebilir. Mobil cihazlarda kamera entegrasyonu sayesinde barkod okuma özelliği ile hızlı ürün arama yapılabilir. Stok verileri PDF ve Excel formatlarında raporlanabilir ve paylaşılabilir.

**2. Rezervasyon Sistemi**
Müşteriler için ürün rezervasyonu oluşturma imkanı sunar. Alıcı firma bilgileri, rezervasyon sorumlusu ve işlem tarihi gibi detaylar kaydedilebilir. Çift tablo görünümü ile kaynak stoklardan hedef sepete ürün aktarımı yapılabilir ve ürün boyutları güncellenebilir.

**3. Satış Yönetimi**
Satış listelerinin görüntülenmesi, onay süreçlerinin takibi ve gerektiğinde rezervasyon iptali bu modül üzerinden gerçekleştirilebilir. Satış raporları PDF ve Excel formatlarında oluşturulabilir, yazdırma önizlemesi ile kontrol edilebilir.

**4. İptal İşlemleri**
Tamamlanan iptal işlemlerinin arşivlenmesi ve raporlanması bu modül ile sağlanır. Tarih periyoduna göre filtreleme yapılabilir, detaylı iptal raporları oluşturulabilir.

**5. Kullanıcı Yönetimi ve Yetkilendirme**
Kapsamlı bir kullanıcı ve izin sistemi mevcuttur. Her kullanıcı için stok yönetimi, satış yönetimi, iptal işlemleri ve rezervasyon oluşturma gibi modüllere erişim yetkileri ayrı ayrı tanımlanabilir. Admin kullanıcılar tüm modüllere tam erişime sahiptir.

### Teknik Altyapı

Uygulama, **Repository Pattern** mimarisi üzerine inşa edilmiştir. Bu yapı sayesinde kullanıcı arayüzü (Widget), iş mantığı (Service), veri erişim (Repository) ve veritabanı (Supabase) katmanları birbirinden bağımsız ve modüler bir şekilde çalışır. Bu mimari, kodun test edilebilirliğini, bakımını ve genişletilmesini kolaylaştırır.

**Supabase** backend servisi, PostgreSQL tabanlı veritabanı, gerçek zamanlı veri senkronizasyonu, satır düzeyinde güvenlik (Row Level Security) ve otomatik token yönetimi gibi özellikler sunar.

Tasarım sistemi merkezi olarak yönetilmektedir. Renk paleti, tipografi, boşluk değerleri, kenar yuvarlaklıkları ve gölge tanımları gibi tasarım token'ları ayrı dosyalarda tanımlanmış olup, tutarlı ve bakımı kolay bir kullanıcı arayüzü oluşturulmasını sağlar.

### Sonuç

ENG ERP, mermer ve granit sektörünün ihtiyaçlarına özel olarak geliştirilmiş, modern teknolojiler kullanılarak oluşturulmuş kapsamlı bir kurumsal uygulamadır. Flutter'ın cross-platform avantajları sayesinde tek bir kod tabanıyla tüm platformlara dağıtım yapılabilmektedir. Modüler yapısı, kapsamlı raporlama özellikleri ve güçlü yetkilendirme sistemi ile işletmelerin stok ve satış süreçlerini etkin bir şekilde yönetmelerine olanak tanır.

---


