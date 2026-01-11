// lib/features/cancel/widgets/cancel_main_table.dart

import 'package:flutter/material.dart';
import 'package:eng_erp/core/theme/theme.dart';
import 'package:eng_erp/features/sales_management/data/cancel_archive_model.dart';

/// 📋 İptal Ana Tablosu
class CancelMainTable extends StatelessWidget {
  final List<RezIptalModel> iptalList;
  final RezIptalModel? selectedIptal;
  final ValueChanged<RezIptalModel> onIptalSelected;
  final bool isLoading;
  final VoidCallback? onRefresh;

  const CancelMainTable({
    super.key,
    required this.iptalList,
    required this.selectedIptal,
    required this.onIptalSelected,
    this.isLoading = false,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (iptalList.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 48,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  'İptal kaydı bulunamadı',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Başlık
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            color: AppColors.error.withOpacity(0.1),
            child: Row(
              children: [
                const Icon(Icons.cancel, size: 18, color: AppColors.error),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'İptal Edilen Rezervasyonlar (${iptalList.length} kayıt)',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.error,
                  ),
                ),
                const Spacer(),
                if (onRefresh != null)
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 20),
                    onPressed: onRefresh,
                    tooltip: 'Yenile',
                    color: AppColors.error,
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
          ),
          // Tablo
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(AppColors.grey200),
                  dataRowMinHeight: 44,
                  dataRowMaxHeight: 56,
                  columnSpacing: 24,
                  horizontalMargin: 16,
                  columns: const [
                    DataColumn(label: Text('Rez. No', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Rez. Kodu', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Alıcı Firma', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Satış Sorumlusu', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('İşlem Tarihi', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('İptal Tarihi', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('İptal Eden', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('İptal Sebebi', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: iptalList.map((iptal) {
                    final isSelected = selectedIptal?.rezervasyonNo == iptal.rezervasyonNo;
                    return DataRow(
                      selected: isSelected,
                      color: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColors.error.withOpacity(0.1);
                        }
                        return null;
                      }),
                      onSelectChanged: (_) => onIptalSelected(iptal),
                      cells: [
                        DataCell(Text(iptal.rezervasyonNo)),
                        DataCell(Text(iptal.rezervasyonKodu ?? '')),
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 150),
                            child: Text(
                              iptal.aliciFirma ?? '',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(Text(iptal.satisSorumlusu ?? '-')),
                        DataCell(Text(_formatDate(iptal.islemTarihi))),
                        DataCell(Text(_formatDate(iptal.iptalTarihi))),
                        DataCell(Text(iptal.iptalEdenPersonel ?? '-')),
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 200),
                            child: Text(
                              iptal.iptalSebebi ?? '',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
