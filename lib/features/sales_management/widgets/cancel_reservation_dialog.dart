// lib/features/sales_management/widgets/cancel_reservation_dialog.dart

import 'package:flutter/material.dart';
import 'package:eng_erp/core/theme/theme.dart';

/// ❌ Rezervasyon İptal Dialog'u
class CancelReservationDialog extends StatefulWidget {
  final String rezervasyonNo;
  final String aliciFirma;

  const CancelReservationDialog({
    super.key,
    required this.rezervasyonNo,
    required this.aliciFirma,
  });

  static Future<String?> show(
    BuildContext context, {
    required String rezervasyonNo,
    required String aliciFirma,
  }) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => CancelReservationDialog(
        rezervasyonNo: rezervasyonNo,
        aliciFirma: aliciFirma,
      ),
    );
  }

  @override
  State<CancelReservationDialog> createState() => _CancelReservationDialogState();
}

class _CancelReservationDialogState extends State<CancelReservationDialog> {
  final TextEditingController _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Icon(Icons.cancel, color: AppColors.error, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          const Text(
            'Rezervasyon İptal',
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
              // Uyarı mesajı
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber, color: AppColors.warning, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Bu işlem geri alınamaz! Rezervasyon ve tüm ürünler stoğa geri alınacak.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.warning.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Rezervasyon bilgileri
              Text(
                'Rezervasyon No: ${widget.rezervasyonNo}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Alıcı Firma: ${widget.aliciFirma}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // İptal sebebi
              const Text(
                'İptal Sebebi *',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'İptal sebebini yazınız...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'İptal sebebi zorunludur';
                  }
                  if (value.trim().length < 5) {
                    return 'İptal sebebi en az 5 karakter olmalıdır';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Vazgeç'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(_reasonController.text.trim());
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.white,
          ),
          child: const Text('İptal Et'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}
