import 'package:flutter/material.dart';
import 'package:eng_erp/features/stock/data/stock_service.dart';
import 'package:eng_erp/features/stock/data/stock_model.dart';
import 'package:eng_erp/features/stock/widgets/product_update_dialog.dart';

class StokYonetimiPage extends StatefulWidget {
  const StokYonetimiPage({super.key});

  @override
  State<StokYonetimiPage> createState() => _StokYonetimiPageState();
}

class _StokYonetimiPageState extends State<StokYonetimiPage> {
  // ============================================================
  // DATA & STATE MANAGEMENT
  // ============================================================
  final StockService _stockService = StockService();
  List<StockModel> _stockList = [];
  bool _isLoading = false;
  String? _errorMessage;
  StockModel? _selectedStock; // Seçilen ürün

  // ============================================================
  // FILTER CONTROLLERS
  // ============================================================
  final TextEditingController epcController = TextEditingController();
  final TextEditingController barkodController = TextEditingController();
  final TextEditingController bandilController = TextEditingController();
  final TextEditingController uretimTarihiController = TextEditingController();
  final TextEditingController plakaController = TextEditingController();

  String tarihPeriyodu = "Günlük";
  String? urunTipi;
  String? urunTuru;
  String? yuzeyIslemi;
  String? filtreDurum;

  List<String> periyotList = ["Günlük", "Haftalık", "Aylık", "Yıllık"];
  List<String> secenek = ["Hepsi", "Yarı Mamül", "Bitmiş Mamül"];
  List<String> secenekTuru = ["Hepsi", "Granit", "Mermer", "Traverten"];
  List<String> secenekYuzeyIslemi = ["Hepsi", "Polished", "Honed", "Tumbled"];
  List<String> durumFiltre = ["Hepsi", "Stokta", "Onay Bekliyor", "Onaylandı", "Sevkiyat Tamamlandı"];

  @override
  void initState() {
    super.initState();
    _fetchStockData(); // Sayfa açıldığında verileri yükle
  }

  @override
  void dispose() {
    epcController.dispose();
    barkodController.dispose();
    bandilController.dispose();
    uretimTarihiController.dispose();
    plakaController.dispose();
    super.dispose();
  }

  /// Özelleştirilmiş tarih seçici göster
  Future<void> _showCustomDatePicker(TextEditingController controller) async {
    // Eğer controller'da tarih varsa, onu başlangıç tarihi olarak kullan
    DateTime initialDate = DateTime.now();
    if (controller.text.isNotEmpty) {
      try {
        final parts = controller.text.split('.');
        if (parts.length == 3) {
          initialDate = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } catch (_) {}
    }

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: "ÜRETİM TARİHİ SEÇİN",
      cancelText: "İPTAL",
      confirmText: "SEÇ",
      fieldLabelText: "Tarih girin",
      fieldHintText: "GG.AA.YYYY",
      errorFormatText: "Geçersiz tarih formatı",
      errorInvalidText: "Geçersiz tarih",
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade700,      // Header arka plan
              onPrimary: Colors.white,            // Header metin
              onSurface: Colors.grey.shade800,    // Takvim metinleri
              surface: Colors.white,              // Takvim arka plan
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade700,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Colors.white,
              headerBackgroundColor: Colors.blue.shade700,
              headerForegroundColor: Colors.white,
              dayStyle: const TextStyle(fontSize: 14),
              todayBorder: BorderSide(color: Colors.blue.shade700, width: 2),
              todayForegroundColor: WidgetStateProperty.all(Colors.blue.shade700),
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return Colors.grey.shade800;
              }),
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.blue.shade700;
                }
                return null;
              }),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      // Tarihi dd.MM.yyyy formatında göster
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      controller.text = "$day.$month.${date.year}";
      _fetchStockData();
    }
  }

  /// Tüm filtreleri temizle ve varsayılan değerlere döndür
  void _clearFilters() {
    setState(() {
      epcController.clear();
      barkodController.clear();
      bandilController.clear();
      uretimTarihiController.clear();
      plakaController.clear();
      tarihPeriyodu = "Günlük";
      urunTipi = null;
      urunTuru = null;
      yuzeyIslemi = null;
      filtreDurum = null;
    });
    _fetchStockData();
  }

  /// Verileri Supabase'den çek (filtrelerle)
  Future<void> _fetchStockData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Üretim tarihi aralığını hesapla
      DateTime? uretimTarihiBaslangic;
      DateTime? uretimTarihiBitis;
      
      if (uretimTarihiController.text.isNotEmpty) {
        // Tarihi parse et (dd.MM.yyyy formatından)
        final parts = uretimTarihiController.text.split('.');
        if (parts.length == 3) {
          uretimTarihiBaslangic = DateTime(
            int.parse(parts[2]), // yıl
            int.parse(parts[1]), // ay
            int.parse(parts[0]), // gün
          );
          
          // Periyoda göre bitiş tarihini hesapla
          switch (tarihPeriyodu) {
            case "Günlük":
              uretimTarihiBitis = uretimTarihiBaslangic.add(const Duration(days: 1));
              break;
            case "Haftalık":
              uretimTarihiBitis = uretimTarihiBaslangic.add(const Duration(days: 7));
              break;
            case "Aylık":
              uretimTarihiBitis = DateTime(
                uretimTarihiBaslangic.year,
                uretimTarihiBaslangic.month + 1,
                uretimTarihiBaslangic.day,
              );
              break;
            case "Yıllık":
              uretimTarihiBitis = DateTime(
                uretimTarihiBaslangic.year + 1,
                uretimTarihiBaslangic.month,
                uretimTarihiBaslangic.day,
              );
              break;
          }
        }
      }

      final stocks = await _stockService.getFilteredStock(
        epc: epcController.text.trim().isEmpty ? null : epcController.text,
        barkod: barkodController.text.trim().isEmpty ? null : barkodController.text,
        bandilNo: bandilController.text.trim().isEmpty ? null : bandilController.text,
        plakaNo: plakaController.text.trim().isEmpty ? null : plakaController.text,
        urunTipi: urunTipi == null || urunTipi == 'Hepsi' ? null : urunTipi,
        urunTuru: urunTuru == null || urunTuru == 'Hepsi' ? null : urunTuru,
        yuzeyIslemi: yuzeyIslemi == null || yuzeyIslemi == 'Hepsi' ? null : yuzeyIslemi,
        durum: filtreDurum == null || filtreDurum == 'Hepsi' ? null : filtreDurum,
        uretimTarihiBaslangic: uretimTarihiBaslangic,
        uretimTarihiBitis: uretimTarihiBitis,
      );

      setState(() {
        _stockList = stocks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔥 SAYFAYA ÖZEL APPBAR – Drawer ANA İSKELETTEN gelir!
        AppBar(
          title: const Text("Stok Yönetimi"),
          backgroundColor: Colors.white70,
          centerTitle: false,
        ),

        // 🔥 BODY
        Expanded(
          child: Container(
            color: Colors.grey.shade200,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  _buildTopFilters(),
                  const SizedBox(height: 12),

                  Expanded(child: _buildDataTable()),
                  const SizedBox(height: 10),

                  _buildBottomButtons(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------- FILTERS ------------------------
  Widget _buildTopFilters() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          height: 140,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _input("EPC", epcController),
                _input("Barkod", barkodController, hasButton: true, buttonText: "Barkodu Oku"),
                _input("Bandıl No", bandilController),
                _input("Üretim Tarihi", uretimTarihiController, isDate: true),
                _dropdown("Tarih Periyodu", periyotList, tarihPeriyodu, (v) => setState(() => tarihPeriyodu = v!)),
                _input("Plaka No", plakaController),
                _dropdown("Ürün Tipi", secenek, urunTipi, (v) => setState(() => urunTipi = v)),
                _dropdown("Ürün Türü", secenekTuru, urunTuru, (v) => setState(() => urunTuru = v)),
                _dropdown("Yüzey İşlemi", secenekYuzeyIslemi, yuzeyIslemi, (v) => setState(() => yuzeyIslemi = v)),
                _dropdown("Durum ile Filtrele", durumFiltre, filtreDurum, (v) => setState(() => filtreDurum = v)),
                const SizedBox(width: 16),
                // Filtreleri Temizle Butonu
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("", style: TextStyle(fontSize: 13)), // Boşluk için
                    const SizedBox(height: 5),
                    ElevatedButton.icon(
                      onPressed: _clearFilters,
                      icon: const Icon(Icons.clear_all, size: 20),
                      label: const Text("Filtreleri Temizle"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------- Input Builder -------------------
  Widget _input(String label, TextEditingController controller,
      {bool isDate = false, bool hasButton = false, String? buttonText}) {
    return SizedBox(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  readOnly: isDate,
                  onChanged: (value) => _fetchStockData(), // Filtre değişince veri çek
                  onTap: isDate ? () => _showCustomDatePicker(controller) : null,
                  decoration: InputDecoration(
                    hintText: isDate ? "Tarih seçin..." : null,
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    suffixIcon: isDate
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (controller.text.isNotEmpty)
                                IconButton(
                                  icon: Icon(Icons.clear, size: 18, color: Colors.grey.shade600),
                                  onPressed: () {
                                    controller.clear();
                                    _fetchStockData();
                                  },
                                  tooltip: "Tarihi Temizle",
                                ),
                              Icon(Icons.calendar_month, size: 20, color: Colors.blue.shade700),
                              const SizedBox(width: 8),
                            ],
                          )
                        : null,
                  ),
                ),
              ),
              if (hasButton) const SizedBox(width: 6),
              if (hasButton)
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade300, foregroundColor: Colors.black),
                  child: Text(buttonText ?? "..."),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------- Dropdown ------------------------
  Widget _dropdown(String label, List<String> items, String? value, Function(String?) onChange) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 5),
          DropdownButtonFormField<String>(
            value: value,
            hint: const Text("Seçiniz", style: TextStyle(color: Colors.grey)),
            items: items.map((e) => DropdownMenuItem<String>(value: e, child: Text(e))).toList(),
            onChanged: (newValue) {
              onChange(newValue); // State'i güncelle
              _fetchStockData(); // Dropdown değişince veri çek
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------- TABLE ---------------------------
  Widget _buildDataTable() {
    // Loading durumunu göster
    if (_isLoading) {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(50.0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    // Hata durumunu göster
    if (_errorMessage != null) {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Hata: $_errorMessage',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _fetchStockData,
                  child: const Text('Tekrar Dene'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Veri yoksa mesaj göster
    if (_stockList.isEmpty) {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(50.0),
            child: Text(
              'Henüz stok verisi bulunmamaktadır.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ),
      );
    }

    // Veri varsa tabloyu göster
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          showCheckboxColumn: false,
          columns: const [
            DataColumn(label: Text("ID")),
            DataColumn(label: Text("EPC")),
            DataColumn(label: Text("BarkodNo")),
            DataColumn(label: Text("BandılNo")),
            DataColumn(label: Text("PlakaNo")),
            DataColumn(label: Text("ÜrünTipi")),
            DataColumn(label: Text("ÜrünTürü")),
            DataColumn(label: Text("Yüzeyİşlemi")),
            DataColumn(label: Text("Seleksiyon")),
            DataColumn(label: Text("ÜretimTarihi")),
            DataColumn(label: Text("Kalinlik")),
            DataColumn(label: Text("PlakaAdedi")),
            DataColumn(label: Text("StokEn")),
            DataColumn(label: Text("StokBoy")),
            DataColumn(label: Text("StokAlan")),
            DataColumn(label: Text("StokTonaj")),
            DataColumn(label: Text("SatisEn")),
            DataColumn(label: Text("SatisBoy")),
            DataColumn(label: Text("SatisAlan")),
            DataColumn(label: Text("SatisTonaj")),
            DataColumn(label: Text("Durum")),
            DataColumn(label: Text("RezervasyonNo")),
            DataColumn(label: Text("KaydedenPersonel")),
            DataColumn(label: Text("ÜrünCikisTarihi")),
            DataColumn(label: Text("AliciFirma")),
          ],
          rows: _stockList.map((stock) {
            final isSelected = _selectedStock?.id == stock.id;
            return DataRow(
              selected: isSelected,
              color: WidgetStateProperty.resolveWith<Color?>((states) {
                if (isSelected) return Colors.blue.shade100;
                return null;
              }),
              onSelectChanged: (selected) {
                setState(() {
                  _selectedStock = selected == true ? stock : null;
                });
              },
              cells: [
              DataCell(Text(stock.id.toString())),
              DataCell(Text(stock.epc)),
              DataCell(Text(stock.barkodNo)),
              DataCell(Text(stock.bandilNo ?? '-')),
              DataCell(Text(stock.plakaNo ?? '-')),
              DataCell(Text(stock.urunTipi ?? '-')),
              DataCell(Text(stock.urunTuru ?? '-')),
              DataCell(Text(stock.yuzeyIslemi ?? '-')),
              DataCell(Text(stock.seleksiyon ?? '-')),
              DataCell(Text(stock.uretimTarihi != null
                  ? '${stock.uretimTarihi!.day}.${stock.uretimTarihi!.month}.${stock.uretimTarihi!.year}'
                  : '-')),
              DataCell(Text(stock.kalinlik?.toString() ?? '-')),
              DataCell(Text(stock.plakaAdedi?.toString() ?? '-')),
              DataCell(Text(stock.stokEn?.toStringAsFixed(2) ?? '-')),
              DataCell(Text(stock.stokBoy?.toStringAsFixed(2) ?? '-')),
              DataCell(Text(stock.stokAlan?.toStringAsFixed(2) ?? '-')),
              DataCell(Text(stock.stokTonaj?.toStringAsFixed(2) ?? '-')),
              DataCell(Text(stock.satisEn?.toStringAsFixed(2) ?? '-')),
              DataCell(Text(stock.satisBoy?.toStringAsFixed(2) ?? '-')),
              DataCell(Text(stock.satisAlan?.toStringAsFixed(2) ?? '-')),
              DataCell(Text(stock.satisTonaj?.toStringAsFixed(2) ?? '-')),
              DataCell(Text(stock.durum ?? '-')),
              DataCell(Text(stock.rezervasyonNo ?? '-')),
              DataCell(Text(stock.kaydedenPersonel ?? '-')),
              DataCell(Text(stock.urunCikisTarihi != null
                  ? '${stock.urunCikisTarihi!.day}.${stock.urunCikisTarihi!.month}.${stock.urunCikisTarihi!.year}'
                  : '-')),
              DataCell(Text(stock.aliciFirma ?? '-')),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  // ----------------------- BUTTONS ------------------------
  Widget _buildBottomButtons() {
    return SizedBox(
      height: 64,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            _actionBtn("Stok Raporu", onPressed: () {}),
            _actionBtn("Ürün Güncelle", onPressed: _handleUpdateProduct, isPrimary: true),
            _actionBtn("Sil", onPressed: _handleDeleteProduct),
            _actionBtn("Rezervasyon Bilgisi", onPressed: () {}),
            _actionBtn("Yenile", onPressed: () {
              setState(() => _selectedStock = null);
              _fetchStockData();
            }),
          ],
        ),
      ),
    );
  }

  /// Ürün güncelleme dialog'ını aç
  void _handleUpdateProduct() {
    if (_selectedStock == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Lütfen güncellemek istediğiniz ürünü seçin'),
          backgroundColor: Colors.orange.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProductUpdateDialog(
        stock: _selectedStock!,
        onUpdateSuccess: () {
          setState(() => _selectedStock = null);
          _fetchStockData();
        },
      ),
    );
  }

  /// Seçili ürünü sil
  Future<void> _handleDeleteProduct() async {
    if (_selectedStock == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Lütfen silmek istediğiniz ürünü seçin'),
          backgroundColor: Colors.orange.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Onay dialogu göster
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red.shade600, size: 28),
            const SizedBox(width: 8),
            const Text('Ürün Silme Onayı'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bu ürünü silmek istediğinizden emin misiniz?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${_selectedStock!.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('EPC: ${_selectedStock!.epc}'),
                  Text('Barkod: ${_selectedStock!.barkodNo}'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Bu işlem geri alınamaz!',
              style: TextStyle(color: Colors.red.shade600, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Silme işlemini gerçekleştir
    try {
      await _stockService.deleteStock(_selectedStock!.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Ürün başarıyla silindi'),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        setState(() => _selectedStock = null);
        _fetchStockData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Silme hatası: $e'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _actionBtn(String text, {required VoidCallback onPressed, bool isPrimary = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.blue.shade700 : Colors.grey.shade200,
          foregroundColor: isPrimary ? Colors.white : Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        ),
        child: Text(text),
      ),
    );
  }
}
