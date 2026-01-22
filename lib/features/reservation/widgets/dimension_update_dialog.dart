// lib/features/reservation/widgets/dimension_update_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eng_erp/features/stock/data/stock_model.dart';

/// Satış boyutlarını düzenlemek için dialog
class DimensionUpdateDialog extends StatefulWidget {
  final StockModel stock;
  final Map<String, double>? currentDimensions;
  final Function(Map<String, double>) onSave;

  const DimensionUpdateDialog({
    super.key,
    required this.stock,
    required this.currentDimensions,
    required this.onSave,
  });

  @override
  State<DimensionUpdateDialog> createState() => _DimensionUpdateDialogState();
}

class _DimensionUpdateDialogState extends State<DimensionUpdateDialog> {
  late TextEditingController _satisEnController;
  late TextEditingController _satisBoyController;
  late TextEditingController _satisAlanController;
  late TextEditingController _satisTonajController;

  @override
  void initState() {
    super.initState();

    // Önce mevcut güncellenmiş değerleri, yoksa stok değerlerini kullan
    final satisEn = widget.currentDimensions?['satisEn'] ??
        widget.stock.satisEn ??
        widget.stock.stokEn ??
        0;
    final satisBoy = widget.currentDimensions?['satisBoy'] ??
        widget.stock.satisBoy ??
        widget.stock.stokBoy ??
        0;
    final satisAlan = widget.currentDimensions?['satisAlan'] ??
        widget.stock.satisAlan ??
        widget.stock.stokAlan ??
        0;
    final satisTonaj = widget.currentDimensions?['satisTonaj'] ??
        widget.stock.satisTonaj ??
        widget.stock.stokTonaj ??
        0;

    _satisEnController = TextEditingController(text: satisEn.toStringAsFixed(2));
    _satisBoyController = TextEditingController(text: satisBoy.toStringAsFixed(2));
    _satisAlanController = TextEditingController(text: satisAlan.toStringAsFixed(2));
    _satisTonajController = TextEditingController(text: satisTonaj.toStringAsFixed(2));

    // En ve Boy değiştiğinde alanı otomatik hesapla
    _satisEnController.addListener(_calculateArea);
    _satisBoyController.addListener(_calculateArea);
  }

  @override
  void dispose() {
    _satisEnController.dispose();
    _satisBoyController.dispose();
    _satisAlanController.dispose();
    _satisTonajController.dispose();
    super.dispose();
  }

  void _calculateArea() {
    final en = double.tryParse(_satisEnController.text) ?? 0;
    final boy = double.tryParse(_satisBoyController.text) ?? 0;
    final alan = en * boy;
    _satisAlanController.text = alan.toStringAsFixed(2);
  }

  void _handleSave() {
    final dimensions = <String, double>{
      'satisEn': double.tryParse(_satisEnController.text) ?? 0,
      'satisBoy': double.tryParse(_satisBoyController.text) ?? 0,
      'satisAlan': double.tryParse(_satisAlanController.text) ?? 0,
      'satisTonaj': double.tryParse(_satisTonajController.text) ?? 0,
    };

    widget.onSave(dimensions);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.straighten, color: Colors.orange.shade600),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              "Satış Boyutlarını Güncelle",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ürün bilgisi
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ürün: ${widget.stock.barkodNo}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "EPC: ${widget.stock.epc}",
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Stok boyutları (referans)
              Text(
                "Stok Boyutları (Referans):",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "En: ${widget.stock.stokEn?.toStringAsFixed(2) ?? '-'} | "
                "Boy: ${widget.stock.stokBoy?.toStringAsFixed(2) ?? '-'} | "
                "Alan: ${widget.stock.stokAlan?.toStringAsFixed(2) ?? '-'} | "
                "Tonaj: ${widget.stock.stokTonaj?.toStringAsFixed(2) ?? '-'}",
                style: const TextStyle(fontSize: 13),
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),

              // Satış boyutları
              Text(
                "Satış Boyutları:",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      label: "Satış En",
                      controller: _satisEnController,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInputField(
                      label: "Satış Boy",
                      controller: _satisBoyController,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      label: "Satış Alan (otomatik)",
                      controller: _satisAlanController,
                      readOnly: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInputField(
                      label: "Satış Tonaj",
                      controller: _satisTonajController,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("İptal"),
        ),
        ElevatedButton.icon(
          onPressed: _handleSave,
          icon: const Icon(Icons.save, size: 18),
          label: const Text("Kaydet"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    Color? fillColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          decoration: InputDecoration(
            filled: fillColor != null,
            fillColor: fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }
}

/// Dialog'u göstermek için helper fonksiyon
Future<void> showDimensionUpdateDialog({
  required BuildContext context,
  required StockModel stock,
  Map<String, double>? currentDimensions,
  required Function(Map<String, double>) onSave,
}) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => DimensionUpdateDialog(
      stock: stock,
      currentDimensions: currentDimensions,
      onSave: onSave,
    ),
  );
}
