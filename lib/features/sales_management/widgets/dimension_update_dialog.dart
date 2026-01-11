// lib/features/sales_management/widgets/dimension_update_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eng_erp/core/theme/theme.dart';
import 'package:eng_erp/features/stock/data/stock_model.dart';

/// 📐 Boyut Güncelleme Dialog'u
class DimensionUpdateDialog extends StatefulWidget {
  final StockModel product;

  const DimensionUpdateDialog({
    super.key,
    required this.product,
  });

  static Future<Map<String, double>?> show(
    BuildContext context, {
    required StockModel product,
  }) async {
    return showDialog<Map<String, double>>(
      context: context,
      builder: (context) => DimensionUpdateDialog(product: product),
    );
  }

  @override
  State<DimensionUpdateDialog> createState() => _DimensionUpdateDialogState();
}

class _DimensionUpdateDialogState extends State<DimensionUpdateDialog> {
  late final TextEditingController _enController;
  late final TextEditingController _boyController;
  late final TextEditingController _alanController;
  late final TextEditingController _tonajController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _enController = TextEditingController(
      text: widget.product.satisEn?.toStringAsFixed(2) ?? 
            widget.product.stokEn?.toStringAsFixed(2) ?? '',
    );
    _boyController = TextEditingController(
      text: widget.product.satisBoy?.toStringAsFixed(2) ?? 
            widget.product.stokBoy?.toStringAsFixed(2) ?? '',
    );
    _alanController = TextEditingController(
      text: widget.product.satisAlan?.toStringAsFixed(4) ?? 
            widget.product.stokAlan?.toStringAsFixed(4) ?? '',
    );
    _tonajController = TextEditingController(
      text: widget.product.satisTonaj?.toStringAsFixed(4) ?? 
            widget.product.stokTonaj?.toStringAsFixed(4) ?? '',
    );

    // Alan otomatik hesaplama
    _enController.addListener(_calculateArea);
    _boyController.addListener(_calculateArea);
  }

  void _calculateArea() {
    final en = double.tryParse(_enController.text) ?? 0;
    final boy = double.tryParse(_boyController.text) ?? 0;
    if (en > 0 && boy > 0) {
      final alan = (en * boy) / 10000; // cm² -> m²
      _alanController.text = alan.toStringAsFixed(4);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Icon(Icons.straighten, color: AppColors.info, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          const Text(
            'Satış Boyutlarını Güncelle',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ürün bilgisi
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.grey200,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EPC: ${widget.product.epc}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Barkod: ${widget.product.barkodNo}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Stok Boyut: ${widget.product.stokEn?.toStringAsFixed(0) ?? '-'} x ${widget.product.stokBoy?.toStringAsFixed(0) ?? '-'} cm',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Boyut alanları
              Row(
                children: [
                  Expanded(
                    child: _buildNumberField(
                      'Satış En (cm)',
                      _enController,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildNumberField(
                      'Satış Boy (cm)',
                      _boyController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _buildNumberField(
                      'Satış Alan (m²)',
                      _alanController,
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildNumberField(
                      'Satış Tonaj',
                      _tonajController,
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
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final result = {
                'satisEn': double.tryParse(_enController.text) ?? 0,
                'satisBoy': double.tryParse(_boyController.text) ?? 0,
                'satisAlan': double.tryParse(_alanController.text) ?? 0,
                'satisTonaj': double.tryParse(_tonajController.text) ?? 0,
              };
              Navigator.of(context).pop(result);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
          ),
          child: const Text('Güncelle'),
        ),
      ],
    );
  }

  Widget _buildNumberField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
          ],
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            filled: readOnly,
            fillColor: readOnly ? AppColors.grey200 : null,
          ),
          style: TextStyle(
            fontSize: 14,
            color: readOnly ? AppColors.textSecondary : AppColors.textPrimary,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Zorunlu';
            }
            if (double.tryParse(value) == null) {
              return 'Geçersiz';
            }
            return null;
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _enController.dispose();
    _boyController.dispose();
    _alanController.dispose();
    _tonajController.dispose();
    super.dispose();
  }
}
