// lib/features/stock/widgets/product_update_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eng_erp/features/stock/data/stock_model.dart';
import 'package:eng_erp/features/stock/data/stock_service.dart';

/// Ürün Güncelleme Dialog'u
/// 
/// Tek bir ürünün bilgilerini güncellemek için kullanılır.
/// Salt okunur ve düzenlenebilir alanlar ayrı ayrı gösterilir.
class ProductUpdateDialog extends StatefulWidget {
  final StockModel stock;
  final VoidCallback onUpdateSuccess;

  const ProductUpdateDialog({
    super.key,
    required this.stock,
    required this.onUpdateSuccess,
  });

  @override
  State<ProductUpdateDialog> createState() => _ProductUpdateDialogState();
}

class _ProductUpdateDialogState extends State<ProductUpdateDialog> {
  final _formKey = GlobalKey<FormState>();
  final StockService _stockService = StockService();
  bool _isLoading = false;

  // Dropdown seçenekleri
  final List<String> urunTipiOptions = ['Yarı Mamül', 'Bitmiş Mamül'];
  final List<String> urunTuruOptions = ['Granit', 'Mermer', 'Traverten'];
  final List<String> yuzeyIslemiOptions = ['Polished', 'Honed', 'Tumbled'];

  // Form controller'ları
  late TextEditingController _barkodNoController;
  late TextEditingController _bandilNoController;
  late TextEditingController _plakaNoController;
  late TextEditingController _seleksiyonController;
  late TextEditingController _kalinlikController;
  late TextEditingController _stokEnController;
  late TextEditingController _stokBoyController;
  late TextEditingController _stokTonajController;
  late TextEditingController _plakaAdediController;

  // Dropdown değerleri
  String? _selectedUrunTipi;
  String? _selectedUrunTuru;
  String? _selectedYuzeyIslemi;

  // Tarih değerleri
  DateTime? _uretimTarihi;
  DateTime? _urunCikisTarihi;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final stock = widget.stock;
    
    _barkodNoController = TextEditingController(text: stock.barkodNo);
    _bandilNoController = TextEditingController(text: stock.bandilNo ?? '');
    _plakaNoController = TextEditingController(text: stock.plakaNo ?? '');
    _seleksiyonController = TextEditingController(text: stock.seleksiyon ?? '');
    _kalinlikController = TextEditingController(
      text: stock.kalinlik?.toString() ?? '',
    );
    _stokEnController = TextEditingController(
      text: stock.stokEn?.toString() ?? '',
    );
    _stokBoyController = TextEditingController(
      text: stock.stokBoy?.toString() ?? '',
    );
    _stokTonajController = TextEditingController(
      text: stock.stokTonaj?.toString() ?? '',
    );
    _plakaAdediController = TextEditingController(
      text: stock.plakaAdedi?.toString() ?? '',
    );

    // Dropdown değerlerini set et
    _selectedUrunTipi = urunTipiOptions.contains(stock.urunTipi) 
        ? stock.urunTipi 
        : null;
    _selectedUrunTuru = urunTuruOptions.contains(stock.urunTuru) 
        ? stock.urunTuru 
        : null;
    _selectedYuzeyIslemi = yuzeyIslemiOptions.contains(stock.yuzeyIslemi) 
        ? stock.yuzeyIslemi 
        : null;

    // Tarihleri set et
    _uretimTarihi = stock.uretimTarihi;
    _urunCikisTarihi = stock.urunCikisTarihi;
  }

  @override
  void dispose() {
    _barkodNoController.dispose();
    _bandilNoController.dispose();
    _plakaNoController.dispose();
    _seleksiyonController.dispose();
    _kalinlikController.dispose();
    _stokEnController.dispose();
    _stokBoyController.dispose();
    _stokTonajController.dispose();
    _plakaAdediController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isUretimTarihi) async {
    final initialDate = isUretimTarihi 
        ? (_uretimTarihi ?? DateTime.now())
        : (_urunCikisTarihi ?? DateTime.now());

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: isUretimTarihi ? "ÜRETİM TARİHİ SEÇİN" : "ÇIKIŞ TARİHİ SEÇİN",
      cancelText: "İPTAL",
      confirmText: "SEÇ",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade700,
              onPrimary: Colors.white,
              onSurface: Colors.grey.shade800,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        if (isUretimTarihi) {
          _uretimTarihi = date;
        } else {
          _urunCikisTarihi = date;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Tarih Seçin';
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _stockService.updateStock(
        id: widget.stock.id,
        barkodNo: _barkodNoController.text,
        bandilNo: _bandilNoController.text,
        plakaNo: _plakaNoController.text,
        urunTipi: _selectedUrunTipi,
        urunTuru: _selectedUrunTuru,
        yuzeyIslemi: _selectedYuzeyIslemi,
        seleksiyon: _seleksiyonController.text,
        uretimTarihi: _uretimTarihi,
        kalinlik: double.tryParse(_kalinlikController.text),
        stokEn: double.tryParse(_stokEnController.text),
        stokBoy: double.tryParse(_stokBoyController.text),
        stokTonaj: double.tryParse(_stokTonajController.text),
        plakaAdedi: int.tryParse(_plakaAdediController.text),
        urunCikisTarihi: _urunCikisTarihi,
      );

      if (mounted) {
        Navigator.of(context).pop();
        widget.onUpdateSuccess();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Ürün başarıyla güncellendi'),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Güncelleme hatası: ${e.toString()}'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        constraints: const BoxConstraints(maxWidth: 900, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(),
            
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Salt Okunur Alanlar
                      _buildSectionTitle('Salt Okunur Bilgiler'),
                      const SizedBox(height: 12),
                      _buildReadOnlySection(),
                      
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 24),
                      
                      // Düzenlenebilir Alanlar
                      _buildSectionTitle('Düzenlenebilir Bilgiler'),
                      const SizedBox(height: 12),
                      _buildEditableSection(),
                    ],
                  ),
                ),
              ),
            ),
            
            // Footer Buttons
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.edit_note, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ürün Güncelle',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'ID: ${widget.stock.id}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade800,
      ),
    );
  }

  Widget _buildReadOnlySection() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildReadOnlyField('EPC', widget.stock.epc),
        _buildReadOnlyField('Stok Alan', widget.stock.stokAlan?.toStringAsFixed(2) ?? '-'),
        _buildReadOnlyField('Hesaplanan Tonaj', widget.stock.stokTonaj?.toStringAsFixed(2) ?? '-'),
        _buildReadOnlyField('Rezervasyon No', widget.stock.rezervasyonNo ?? '-'),
        _buildReadOnlyField('Kaydeden Personel', widget.stock.kaydedenPersonel ?? '-'),
        _buildReadOnlyField('Alıcı Firma', widget.stock.aliciFirma ?? '-'),
      ],
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return SizedBox(
      width: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableSection() {
    return Column(
      children: [
        // Text Input satırı 1
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildTextField('Barkod No', _barkodNoController, isRequired: true),
            _buildTextField('Bandıl No', _bandilNoController),
            _buildTextField('Plaka No', _plakaNoController),
          ],
        ),
        const SizedBox(height: 16),
        
        // Dropdown satırı
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildDropdown('Ürün Tipi', urunTipiOptions, _selectedUrunTipi, 
              (value) => setState(() => _selectedUrunTipi = value)),
            _buildDropdown('Ürün Türü', urunTuruOptions, _selectedUrunTuru, 
              (value) => setState(() => _selectedUrunTuru = value)),
            _buildDropdown('Yüzey İşlemi', yuzeyIslemiOptions, _selectedYuzeyIslemi, 
              (value) => setState(() => _selectedYuzeyIslemi = value)),
          ],
        ),
        const SizedBox(height: 16),
        
        // Text Input satırı 2
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildTextField('Seleksiyon', _seleksiyonController),
            _buildNumberField('Kalınlık', _kalinlikController, isDecimal: true),
            _buildNumberField('Plaka Adedi', _plakaAdediController, isDecimal: false),
          ],
        ),
        const SizedBox(height: 16),
        
        // Stok ölçü satırı
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildNumberField('Stok En', _stokEnController, isDecimal: true),
            _buildNumberField('Stok Boy', _stokBoyController, isDecimal: true),
            _buildNumberField('Stok Tonaj', _stokTonajController, isDecimal: true),
          ],
        ),
        const SizedBox(height: 16),
        
        // Tarih satırı
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildDateField('Üretim Tarihi', _uretimTarihi, true),
            _buildDateField('Ürün Çıkış Tarihi', _urunCikisTarihi, false),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isRequired = false}) {
    return SizedBox(
      width: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            validator: isRequired 
              ? (value) => (value == null || value.trim().isEmpty) 
                  ? '$label boş olamaz' 
                  : null
              : null,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberField(String label, TextEditingController controller, {required bool isDecimal}) {
    return SizedBox(
      width: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: isDecimal),
            inputFormatters: isDecimal
                ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
                : [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                if (isDecimal && double.tryParse(value) == null) {
                  return 'Geçerli bir sayı girin';
                }
                if (!isDecimal && int.tryParse(value) == null) {
                  return 'Geçerli bir tam sayı girin';
                }
              }
              return null;
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options, String? value, Function(String?) onChanged) {
    return SizedBox(
      width: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: value,
            hint: const Text('Seçiniz'),
            items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label, DateTime? date, bool isUretimTarihi) {
    return SizedBox(
      width: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          InkWell(
            onTap: () => _selectDate(context, isUretimTarihi),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _formatDate(date),
                      style: TextStyle(
                        fontSize: 14,
                        color: date != null ? Colors.black87 : Colors.grey.shade500,
                      ),
                    ),
                  ),
                  Icon(Icons.calendar_month, color: Colors.blue.shade700, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _isLoading ? null : _handleUpdate,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text('Güncelle'),
          ),
        ],
      ),
    );
  }
}
