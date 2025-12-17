import 'package:flutter/material.dart';
import 'package:eng_erp/features/stock/data/stock_model.dart';

/// Silme onay dialogunu göster
/// Returns: true eğer kullanıcı onaylarsa, false veya null eğer iptal ederse
Future<bool?> showDeleteConfirmationDialog({
  required BuildContext context,
  required StockModel stock,
}) {
  return showDialog<bool>(
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
                Text('ID: ${stock.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('EPC: ${stock.epc}'),
                Text('Barkod: ${stock.barkodNo}'),
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
}
