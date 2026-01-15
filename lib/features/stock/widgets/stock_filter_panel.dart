import 'package:flutter/material.dart';
import 'package:eng_erp/core/theme/theme.dart';
import 'package:eng_erp/features/stock/pages/barcode_scanner_page.dart';

/// Filtre paneli için kullanılan data class
class StockFilterData {
  final String epc;
  final String barkod;
  final String bandilNo;
  final String uretimTarihi;
  final String plakaNo;
  final String tarihPeriyodu;
  final String? urunTipi;
  final String? urunTuru;
  final String? yuzeyIslemi;
  final String? filtreDurum;

  const StockFilterData({
    this.epc = '',
    this.barkod = '',
    this.bandilNo = '',
    this.uretimTarihi = '',
    this.plakaNo = '',
    this.tarihPeriyodu = 'Günlük',
    this.urunTipi,
    this.urunTuru,
    this.yuzeyIslemi,
    this.filtreDurum,
  });

  StockFilterData copyWith({
    String? epc,
    String? barkod,
    String? bandilNo,
    String? uretimTarihi,
    String? plakaNo,
    String? tarihPeriyodu,
    String? urunTipi,
    String? urunTuru,
    String? yuzeyIslemi,
    String? filtreDurum,
  }) {
    return StockFilterData(
      epc: epc ?? this.epc,
      barkod: barkod ?? this.barkod,
      bandilNo: bandilNo ?? this.bandilNo,
      uretimTarihi: uretimTarihi ?? this.uretimTarihi,
      plakaNo: plakaNo ?? this.plakaNo,
      tarihPeriyodu: tarihPeriyodu ?? this.tarihPeriyodu,
      urunTipi: urunTipi ?? this.urunTipi,
      urunTuru: urunTuru ?? this.urunTuru,
      yuzeyIslemi: yuzeyIslemi ?? this.yuzeyIslemi,
      filtreDurum: filtreDurum ?? this.filtreDurum,
    );
  }
}

/// Stok filtre paneli widget'ı
class StockFilterPanel extends StatefulWidget {
  final StockFilterData initialData;
  final VoidCallback onFilterChanged;
  final VoidCallback onClearFilters;
  final Function(StockFilterData) onDataChanged;
  final VoidCallback? onBarcodeScanned;

  const StockFilterPanel({
    super.key,
    required this.initialData,
    required this.onFilterChanged,
    required this.onClearFilters,
    required this.onDataChanged,
    this.onBarcodeScanned,
  });

  @override
  State<StockFilterPanel> createState() => _StockFilterPanelState();
}

class _StockFilterPanelState extends State<StockFilterPanel> {
  late TextEditingController epcController;
  late TextEditingController barkodController;
  late TextEditingController bandilController;
  late TextEditingController uretimTarihiController;
  late TextEditingController plakaController;

  late String tarihPeriyodu;
  String? urunTipi;
  String? urunTuru;
  String? yuzeyIslemi;
  String? filtreDurum;

  final List<String> periyotList = ["Günlük", "Haftalık", "Aylık", "Yıllık"];
  final List<String> secenek = ["Hepsi", "Yarı Mamül", "Bitmiş Mamül"];
  final List<String> secenekTuru = ["Hepsi", "Granit", "Mermer", "Traverten"];
  final List<String> secenekYuzeyIslemi = ["Hepsi", "Polished", "Honed", "Tumbled"];
  final List<String> durumFiltre = ["Hepsi", "Stokta", "Onay Bekliyor", "Onaylandı", "Sevkiyat Tamamlandı"];

  @override
  void initState() {
    super.initState();
    epcController = TextEditingController(text: widget.initialData.epc);
    barkodController = TextEditingController(text: widget.initialData.barkod);
    bandilController = TextEditingController(text: widget.initialData.bandilNo);
    uretimTarihiController = TextEditingController(text: widget.initialData.uretimTarihi);
    plakaController = TextEditingController(text: widget.initialData.plakaNo);
    tarihPeriyodu = widget.initialData.tarihPeriyodu;
    urunTipi = widget.initialData.urunTipi;
    urunTuru = widget.initialData.urunTuru;
    yuzeyIslemi = widget.initialData.yuzeyIslemi;
    filtreDurum = widget.initialData.filtreDurum;
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

  void _notifyChange() {
    widget.onDataChanged(StockFilterData(
      epc: epcController.text,
      barkod: barkodController.text,
      bandilNo: bandilController.text,
      uretimTarihi: uretimTarihiController.text,
      plakaNo: plakaController.text,
      tarihPeriyodu: tarihPeriyodu,
      urunTipi: urunTipi,
      urunTuru: urunTuru,
      yuzeyIslemi: yuzeyIslemi,
      filtreDurum: filtreDurum,
    ));
    widget.onFilterChanged();
  }

  void _clearAllFilters() {
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
    widget.onClearFilters();
  }

  /// Barkod tarayıcı sayfasını aç
  Future<void> _openBarcodeScanner() async {
    final String? scannedBarcode = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => const BarcodeScannerPage(),
      ),
    );

    if (scannedBarcode != null && scannedBarcode.isNotEmpty) {
      setState(() {
        barkodController.text = scannedBarcode;
      });
      _notifyChange();
    }
  }

  Future<void> _showCustomDatePicker(TextEditingController controller) async {
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
              primary: Colors.blue.shade700,
              onPrimary: Colors.white,
              onSurface: Colors.grey.shade800,
              surface: Colors.white,
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
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      controller.text = "$day.$month.${date.year}";
      _notifyChange();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SizedBox(
        height: 90,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInput("EPC", epcController),
              _buildInput("Barkod", barkodController, hasButton: true, buttonText: "Barkodu Oku", onButtonPressed: _openBarcodeScanner),
              _buildInput("Bandıl No", bandilController),
              _buildInput("Üretim Tarihi", uretimTarihiController, isDate: true),
              _buildDropdown("Tarih Periyodu", periyotList, tarihPeriyodu, (v) {
                setState(() => tarihPeriyodu = v!);
                _notifyChange();
              }),
              _buildInput("Plaka No", plakaController),
              _buildDropdown("Ürün Tipi", secenek, urunTipi, (v) {
                setState(() => urunTipi = v);
                _notifyChange();
              }),
              _buildDropdown("Ürün Türü", secenekTuru, urunTuru, (v) {
                setState(() => urunTuru = v);
                _notifyChange();
              }),
              _buildDropdown("Yüzey İşlemi", secenekYuzeyIslemi, yuzeyIslemi, (v) {
                setState(() => yuzeyIslemi = v);
                _notifyChange();
              }),
              _buildDropdown("Durum ile Filtrele", durumFiltre, filtreDurum, (v) {
                setState(() => filtreDurum = v);
                _notifyChange();
              }),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("", style: TextStyle(fontSize: 13)),
                  const SizedBox(height: 5),
                  _buildActionButton(
                    label: 'Filtreleri Temizle',
                    icon: Icons.clear_all,
                    onPressed: _clearAllFilters,
                    color: AppColors.error,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller,
      {bool isDate = false, bool hasButton = false, String? buttonText, VoidCallback? onButtonPressed}) {
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
                  onChanged: (value) => _notifyChange(),
                  onTap: isDate ? () => _showCustomDatePicker(controller) : null,
                  decoration: InputDecoration(
                    hintText: isDate ? "Tarih seçin..." : null,
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
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
                                    _notifyChange();
                                  },
                                  tooltip: "Tarihi Temizle",
                                ),
                              Icon(Icons.calendar_month, size: 20, color: AppColors.primary),
                              const SizedBox(width: 8),
                            ],
                          )
                        : null,
                  ),
                ),
              ),
              if (hasButton) const SizedBox(width: 6),
              if (hasButton)
                _buildActionButton(
                  label: buttonText ?? "...",
                  icon: Icons.qr_code_scanner,
                  onPressed: onButtonPressed ?? () {},
                  color: AppColors.primary,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? value, Function(String?) onChange) {
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
            onChanged: onChange,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          side: BorderSide(color: color.withOpacity(0.3)),
        ),
        disabledBackgroundColor: AppColors.grey200,
        disabledForegroundColor: AppColors.textDisabled,
      ),
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
