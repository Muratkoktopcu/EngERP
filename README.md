# ENG ERP Mobil Uygulama Projesi
## Kapsamlı Teknik Rapor

**Proje Adı:** ENG ERP  
**Platform:** Flutter (Cross-Platform Mobile/Desktop)  
**Versiyon:** 1.0.0  
**Rapor Tarihi:** 25 Aralık 2024

---

## 1. Yönetici Özeti

ENG ERP, Flutter framework'ü kullanılarak geliştirilen, **mermer/granit sektörüne özel** kurumsal bir Kaynak Planlama (ERP) uygulamasıdır. Uygulama, stok yönetimi, rezervasyon oluşturma, satış onayı ve iptal işlemlerini kapsayan çok modüllü bir yapıya sahiptir.

### Temel Özellikler
- ✅ **Stok Yönetimi:** Ürün listeleme, filtreleme, güncelleme ve silme
- ✅ **Barkod Okuyucu:** Kamera entegrasyonu ile barkod tarama
- ✅ **Kullanıcı Kimlik Doğrulama:** Supabase ile güvenli oturum yönetimi
- ✅ **Rezervasyon Sistemi:** Ürün rezervasyonu oluşturma
- ✅ **Satış Onay/İptal:** Satış süreç yönetimi
- ✅ **Responsive Tasarım:** Mobil ve masaüstü uyumlu arayüz

---

## 2. Teknik Altyapı

### 2.1 Teknoloji Yığını

| Kategori | Teknoloji | Versiyon | Açıklama |
|----------|-----------|----------|----------|
| **Framework** | Flutter | SDK ^3.6.0 | Cross-platform geliştirme |
| **Backend** | Supabase | ^1.6.3 | PostgreSQL tabanlı BaaS |
| **Navigasyon** | go_router | ^16.1.0 | Deklaratif routing |
| **Barkod** | mobile_scanner | ^5.1.1 | Kamera ile barkod okuma |
| **Tasarım** | Material Design 3 | - | Google tasarım sistemi |

### 2.2 Proje Mimarisi

```
lib/
├── main.dart                 # Uygulama giriş noktası
├── core/                     # Çekirdek altyapı modülleri
│   ├── constant/             # Sabit değerler
│   ├── navigation/           # Router ve Shell yapısı
│   │   ├── app_router.dart   # GoRouter konfigürasyonu
│   │   └── app_shell.dart    # Drawer menü yapısı
│   ├── services/             # Supabase istemci yönetimi
│   └── theme/                # Tasarım token'ları
│       ├── app_colors.dart   # Renk paleti
│       ├── app_typography.dart # Tipografi
│       ├── app_spacing.dart  # Boşluk değerleri
│       ├── app_radius.dart   # Kenar yuvarlaklığı
│       ├── app_shadows.dart  # Gölge tanımları
│       └── app_theme.dart    # Birleşik tema
└── features/                 # Özellik modülleri
    ├── auth/                 # Kimlik doğrulama
    ├── stock/                # Stok yönetimi
    ├── reservation/          # Rezervasyon
    ├── sales_confirmation/   # Satış onayı
    └── cancel/               # İptal işlemleri
```

---

## 3. Özellik Modülleri

### 3.1 Kimlik Doğrulama Modülü (auth/)

**Kaynak Dosyalar:**
- `lib/features/auth/pages/login_page.dart` - Giriş ekranı
- `lib/features/auth/data/auth_service.dart` - İş mantığı
- `lib/features/auth/data/auth_repository.dart` - Veri katmanı
- `lib/features/auth/data/auth_model.dart` - Veri modeli

**Özellikler:**
- 🔐 Supabase Authentication entegrasyonu
- 📧 E-posta ve şifre ile giriş
- 🔄 Otomatik oturum yenileme
- 👤 Kullanıcı rol ve departman bilgisi desteği

**Kullanıcı Modeli Özellikleri:**
```dart
- userId        // Kullanıcı kimliği
- email         // E-posta adresi
- role          // Kullanıcı rolü
- departmentId  // Departman kimliği
- accessToken   // Erişim token'ı
- expiresAt     // Token geçerlilik süresi
- metadata      // Ek meta veriler
```

---

### 3.2 Stok Yönetimi Modülü (stock/)

Bu modül projenin **en kapsamlı ve gelişmiş** modülüdür.

**Kaynak Dosyalar:**

#### Sayfalar:
- `lib/features/stock/pages/StockManagementPage.dart` - Ana stok yönetim sayfası
- `lib/features/stock/pages/barcode_scanner_page.dart` - Barkod tarayıcı sayfası

#### Widget'lar:
- `lib/features/stock/widgets/stock_filter_panel.dart` - Gelişmiş filtreleme paneli
- `lib/features/stock/widgets/stock_data_table.dart` - Veri tablosu
- `lib/features/stock/widgets/product_update_dialog.dart` - Ürün güncelleme dialog'u
- `lib/features/stock/widgets/delete_confirmation_dialog.dart` - Silme onay dialog'u
- `lib/features/stock/widgets/stock_action_buttons.dart` - Aksiyon butonları

#### Veri Katmanı:
- `lib/features/stock/data/stock_model.dart` - Stok veri modeli
- `lib/features/stock/data/stock_service.dart` - İş mantığı katmanı
- `lib/features/stock/data/stock_repository.dart` - Veritabanı işlemleri

---

#### 3.2.1 Stok Veri Modeli

Supabase `UrunStok` tablosunu temsil eden kapsamlı model:

| Alan | Tip | Açıklama |
|------|-----|----------|
| `id` | int | Benzersiz tanımlayıcı |
| `epc` | String | RFID EPC kodu |
| `barkodNo` | String | Ürün barkodu |
| `bandilNo` | String? | Bandil numarası |
| `plakaNo` | String? | Plaka numarası |
| `urunTipi` | String? | Yarı Mamül / Bitmiş Mamül |
| `urunTuru` | String? | Granit / Mermer / Traverten |
| `yuzeyIslemi` | String? | Polished / Honed / Tumbled |
| `seleksiyon` | String? | Kalite sınıfı |
| `uretimTarihi` | DateTime? | Üretim tarihi |
| `kalinlik` | double? | Kalınlık (cm) |
| `plakaAdedi` | int? | Plaka sayısı |
| `stokEn` | double? | Stok genişliği |
| `stokBoy` | double? | Stok boyu |
| `stokAlan` | double? | Stok alanı (m²) |
| `stokTonaj` | double? | Stok ağırlığı (ton) |
| `satisEn` | double? | Satış genişliği |
| `satisBoy` | double? | Satış boyu |
| `satisAlan` | double? | Satış alanı (m²) |
| `satisTonaj` | double? | Satış ağırlığı (ton) |
| `durum` | String? | Stokta / Onay Bekliyor / Onaylandı |
| `rezervasyonNo` | String? | Rezervasyon numarası |
| `kaydedenPersonel` | String? | Kaydeden personel |
| `urunCikisTarihi` | DateTime? | Çıkış tarihi |
| `aliciFirma` | String? | Alıcı firma bilgisi |

---

#### 3.2.2 Filtreleme Sistemi

Kullanıcıların stoğu hızlıca filtrelemesini sağlayan gelişmiş panel:

**Metin Filtreleri:**
- EPC kodu
- Barkod numarası (barkod okuyucu entegrasyonlu)
- Bandil numarası
- Plaka numarası

**Tarih Filtreleri:**
- Üretim tarihi (tek tarih veya tarih aralığı)
- Hızlı periyot seçimi (Günlük, Haftalık, Aylık, Yıllık)

**Dropdown Filtreleri:**
- Ürün Tipi (Seçiniz, Hepsi, Yarı Mamül, Bitmiş Mamül)
- Ürün Türü (Seçiniz, Hepsi, Granit, Mermer, Traverten)
- Yüzey İşlemi (Seçiniz, Hepsi, Polished, Honed, Tumbled)
- Durum (Hepsi, Stokta, Onay Bekliyor, Onaylandı, Sevkiyat Tamamlandı)

---

#### 3.2.3 Barkod Tarayıcı Özelliği

Kamera kullanarak ürün barkodu okuma özelliği:

**Teknik Özellikler:**
- `mobile_scanner` paketi ile entegrasyon
- Arka kamera varsayılan
- Flaş açma/kapama desteği
- Ön/arka kamera geçişi
- Otomatik barkod tanıma
- Tarama sonrası otomatik filtre alanına yazma

**Kullanım Akışı:**
```
Barkod Oku Butonu → Kamera Ekranı → Barkod Tarama → Sonuç Döndürme → Filtre Alanına Yazma → Otomatik Filtreleme
```

---

#### 3.2.4 CRUD İşlemleri

**Create (Oluşturma):** Henüz implemente edilmedi

**Read (Okuma):**
- Tüm stok verilerini listeleme
- Filtrelere göre sorgulama
- ID, EPC veya Barkod ile tekil kayıt getirme

**Update (Güncelleme):**
- Kapsamlı güncelleme dialog'u
- Salt okunur alanlar: ID, EPC
- Düzenlenebilir alanlar: Barkod, Bandil No, Plaka No, Ürün Tipi/Türü, Yüzey İşlemi, Seleksiyon, Üretim Tarihi, Kalınlık, Stok Boyutları, Plaka Adedi
- Veri tipi validasyonu (sayısal/ondalık/metin)
- Date picker ile tarih seçimi

**Delete (Silme):**
- Onay dialog'u ile güvenli silme
- Silme sonrası otomatik liste yenileme

---

### 3.3 Rezervasyon Modülü (reservation/)

**Kaynak:** `lib/features/reservation/pages/ReservationPage.dart`

**Özellikler:**
- 📅 İşlem tarihi seçimi
- 🔢 Rezervasyon kodu ve numarası
- 🏢 Alıcı firma seçimi/ekleme
- 👤 Rezervasyon sorumlusu ataması
- 📊 Çift veri tablosu görünümü (kaynak ve hedef)
- 🎯 Filtreleme: EPC, Barkod, Bandıl No, Üretim Tarihi, Periyot, Durum

**İşlem Butonları:**
- Rezervasyon Ekle
- Rezervasyondan Çıkar
- Boyutları Güncelle
- Rezervasyon Oluştur

---

### 3.4 Satış Onay Modülü (sales_confirmation/)

**Kaynak:** `lib/features/sales_confirmation/pages/SalesConfirmationPage.dart`

Satış onay süreçlerinin yönetildiği modül.

---

### 3.5 İptal Modülü (cancel/)

**Kaynak:** `lib/features/cancel/pages/CancelPage.dart`

Satış ve rezervasyon iptal işlemlerinin yönetildiği modül.

---

## 4. Navigasyon ve Yönlendirme

### 4.1 Router Yapısı

**Kaynak:** `lib/core/navigation/app_router.dart`

```
                    /login
                       │
                       ▼
              ┌─────────────────┐
              │ Oturum Kontrolü │
              └─────────────────┘
                 │           │
        Oturum Yok         Oturum Var
                 │           │
                 ▼           ▼
           LoginScreen    ShellRoute
                              │
              ┌───────┬───────┼───────┬───────┐
              ▼       ▼       ▼       ▼       
           /stock  /reservation  /sales  /cancel
```

**Güvenlik Özellikleri:**
- ✅ Otomatik oturum kontrolü (redirect)
- ✅ Giriş yapmadan sayfaya erişim engeli
- ✅ Oturum durumu değişiminde otomatik yenileme
- ✅ `SupabaseAuthNotifier` ile reaktif yetkilendirme

---

### 4.2 Uygulama Shell'i

**Kaynak:** `lib/core/navigation/app_shell.dart`

Sol menü (Drawer) yapısı ile tutarlı navigasyon deneyimi:

**Menü Öğeleri:**
| İkon | Etiket | Route |
|------|--------|-------|
| 📦 | Stok Yönetimi | /stock |
| 📅 | Rezervasyon | /reservation |
| ✅ | Sales Confirmation | /sales |
| ❌ | Cancel | /cancel |

**Ek Özellikler:**
- 👤 Kullanıcı bilgisi header'da görüntüleme
- 🔵 Aktif sayfa vurgulama
- 🚪 Çıkış yapma fonksiyonu

---

## 5. Tasarım Sistemi (Design Tokens)

Tutarlı ve bakımı kolay bir UI için merkezi tasarım token sistemi oluşturulmuştur.

### 5.1 Renk Paleti

**Kaynak:** `lib/core/theme/app_colors.dart`

| Kategori | Renk | Hex Kodu | Kullanım |
|----------|------|----------|----------|
| **Primary** | Mavi | `#2196F3` | Ana butonlar, vurgular |
| **Primary Dark** | Koyu Mavi | `#1976D2` | Hover durumları |
| **Success** | Yeşil | `#4CAF50` | Onay mesajları |
| **Warning** | Amber | `#FFC107` | Uyarılar |
| **Error** | Kırmızı | `#F44336` | Hatalar |
| **Background** | Açık Gri | `#F5F5F5` | Sayfa arkaplanı |

### 5.2 Tipografi

**Kaynak:** `lib/core/theme/app_typography.dart`

Başlıklar, alt başlıklar, body metinler ve buton metinleri için standartlaştırılmış metin stilleri.

### 5.3 Boşluk Sistemi

**Kaynak:** `lib/core/theme/app_spacing.dart`

4px tabanlı modüler boşluk sistemi (4, 8, 12, 16, 20, 24, 32, 48, 64px).

### 5.4 Kenar Yuvarlaklığı

**Kaynak:** `lib/core/theme/app_radius.dart`

Butonlar, kartlar ve dialoglar için standart radius değerleri.

### 5.5 Gölge Sistemi

**Kaynak:** `lib/core/theme/app_shadows.dart`

Elevation seviyeleri için önceden tanımlanmış gölge stilleri.

---

## 6. Veritabanı Entegrasyonu

### 6.1 Supabase Konfigürasyonu

**Kaynak:** `lib/core/services/supabase_client.dart`

- PostgreSQL tabanlı veritabanı
- Gerçek zamanlı veri senkronizasyonu
- Row Level Security (RLS) desteği
- Otomatik token yönetimi

### 6.2 Repository Pattern

Veri katmanı, **Repository Pattern** kullanılarak yapılandırılmıştır:

```
UI Widget → Service Layer → Repository Layer → Supabase
```

**Avantajları:**
- ✅ Test edilebilirlik
- ✅ Veri kaynağı soyutlama
- ✅ İş mantığı ve veri erişimi ayrımı
- ✅ Kolay bakım ve genişletme

---

## 7. Platform Desteği

Uygulama aşağıdaki platformlar için derlenebilir:

| Platform | Durum | Notlar |
|----------|-------|--------|
| Android | ✅ Destekleniyor | Birincil hedef platform |
| iOS | ✅ Destekleniyor | Xcode ile derleme gerekli |
| Windows | ✅ Destekleniyor | Masaüstü kullanım |
| macOS | ✅ Destekleniyor | Apple Silicon uyumlu |
| Linux | ✅ Destekleniyor | GTK bağımlılıkları gerekli |
| Web | ✅ Destekleniyor | PWA olarak dağıtılabilir |

---

## 8. Kurulum ve Çalıştırma

### Gereksinimler
- Flutter SDK ^3.6.0
- Dart SDK
- Android Studio / VS Code
- Supabase hesabı

### Kurulum Adımları

```bash
# 1. Projeyi klonlayın
git clone <repository-url>
cd eng_erp

# 2. Bağımlılıkları yükleyin
flutter pub get

# 3. Uygulamayı çalıştırın
flutter run
```

---

## 9. Gelecek Geliştirmeler

### Önerilen İyileştirmeler:

1. **State Management:** Cubit/BLoC pattern tam entegrasyonu
2. **Offline Desteği:** Çevrimdışı çalışma ve senkronizasyon
3. **RFID Entegrasyonu:** RFID okuyucu donanım desteği
4. **Raporlama:** PDF/Excel export özellikleri
5. **Bildirimler:** Push notification entegrasyonu
6. **Dashboard:** Özet istatistikler ve grafikler
7. **Çoklu Dil:** i18n/l10n desteği
8. **Birim Testleri:** Kapsamlı test coverage

---

## 10. Sonuç

ENG ERP projesi, mermer/granit sektörü için özel olarak tasarlanmış, modern ve ölçeklenebilir bir kurumsal uygulamadır. Flutter'ın cross-platform avantajları ile tek kod tabanından tüm platformlara dağıtım sağlanmaktadır. Supabase entegrasyonu ile güvenli ve performanslı bir backend altyapısı sunulmaktadır.

**Proje Metrikleri:**
- 📁 Toplam Modül Sayısı: 5 (Auth, Stock, Reservation, Sales, Cancel)
- 📄 Dart Dosya Sayısı: ~30+
- 🎨 Tasarım Token Dosyası: 8
- 📦 Harici Bağımlılık: 4 (supabase_flutter, go_router, mobile_scanner, cupertino_icons)

---

**Hazırlayan:** Geliştirme Ekibi  
**Tarih:** 25 Aralık 2024
