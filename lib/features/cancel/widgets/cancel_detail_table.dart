// lib/features/cancel/widgets/cancel_detail_table.dart

import 'package:flutter/material.dart';
import 'package:eng_erp/core/theme/theme.dart';
import 'package:eng_erp/features/sales_management/data/cancel_archive_model.dart';

/// 📋 İptal Detay Tablosu (Ürünler)
class CancelDetailTable extends StatelessWidget {
  final List<RezIptalDetayModel> detayList;
  final bool isLoading;
  final String? rezervasyonNo;

  const CancelDetailTable({
    super.key,
    required this.detayList,
    this.isLoading = false,
    this.rezervasyonNo,
  });

  @override
  Widget build(BuildContext context) {
    if (rezervasyonNo == null) {
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
                  Icons.touch_app_outlined,
                  size: 48,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  'Detayları görmek için bir iptal kaydı seçin',
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

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (detayList.isEmpty) {
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
                  Icons.inventory_2_outlined,
                  size: 48,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  'Bu iptal kaydında ürün detayı bulunmuyor',
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
            color: AppColors.warning.withOpacity(0.1),
            child: Row(
              children: [
                const Icon(Icons.inventory_2, size: 18, color: AppColors.warning),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Ürün Detayları (${detayList.length} ürün)',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.orange.shade800,
                  ),
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
                  headingRowColor: WidgetStateProperty.all(Colors.white),
                  headingRowHeight: 48,
                  dataRowMinHeight: 44,
                  dataRowMaxHeight: 56,
                  columnSpacing: 20,
                  horizontalMargin: 16,
                  dividerThickness: 0,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.grey200, width: 1.5),
                    ),
                  ),
                  columns: [
                    DataColumn(label: _buildHeaderCell('Rez. No')),
                    DataColumn(label: _buildHeaderCell('EPC')),
                    DataColumn(label: _buildHeaderCell('Barkod No')),
                    DataColumn(label: _buildHeaderCell('Bandil No')),
                    DataColumn(label: _buildHeaderCell('Plaka No')),
                    DataColumn(label: _buildHeaderCell('Ürün Tipi')),
                    DataColumn(label: _buildHeaderCell('Ürün Türü')),
                    DataColumn(label: _buildHeaderCell('Yüzey İşlemi')),
                    DataColumn(label: _buildHeaderCell('Seleksiyon')),
                    DataColumn(label: _buildHeaderCell('Kalınlık'), numeric: true),
                    DataColumn(label: _buildHeaderCell('Stok Boyut')),
                    DataColumn(label: _buildHeaderCell('Satış Boyut')),
                    DataColumn(label: _buildHeaderCell('Stok Alan'), numeric: true),
                    DataColumn(label: _buildHeaderCell('Satış Alan'), numeric: true),
                    DataColumn(label: _buildHeaderCell('Durum')),
                  ],
                  rows: detayList.map((detay) {
                    return DataRow(
                      cells: [
                        DataCell(Text(detay.rezervasyonNo, style: const TextStyle(fontSize: 12))),
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 120),
                            child: Text(
                              detay.epc,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        DataCell(Text(detay.barkodNo ?? '-', style: const TextStyle(fontSize: 12))),
                        DataCell(Text(detay.bandilNo ?? '-', style: const TextStyle(fontSize: 12))),
                        DataCell(Text(detay.plakaNo ?? '-', style: const TextStyle(fontSize: 12))),
                        DataCell(Text(detay.urunTipi ?? '-', style: const TextStyle(fontSize: 12))),
                        DataCell(Text(detay.urunTuru ?? '-', style: const TextStyle(fontSize: 12))),
                        DataCell(Text(detay.yuzeyIslemi ?? '-', style: const TextStyle(fontSize: 12))),
                        DataCell(Text(detay.seleksiyon ?? '-', style: const TextStyle(fontSize: 12))),
                        DataCell(Text(_formatNumber(detay.kalinlik), style: const TextStyle(fontSize: 12))),
                        DataCell(Text(
                          '${detay.stokEn?.toStringAsFixed(0) ?? '-'} x ${detay.stokBoy?.toStringAsFixed(0) ?? '-'}',
                          style: const TextStyle(fontSize: 12),
                        )),
                        DataCell(Text(
                          '${detay.satisEn?.toStringAsFixed(0) ?? '-'} x ${detay.satisBoy?.toStringAsFixed(0) ?? '-'}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        )),
                        DataCell(Text(_formatNumber(detay.stokAlan), style: const TextStyle(fontSize: 12))),
                        DataCell(Text(
                          _formatNumber(detay.satisAlan),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        )),
                        DataCell(_buildDurumChip(detay.durum)),
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

  Widget _buildDurumChip(String? durum) {
    Color color = AppColors.textSecondary;
    if (durum == 'İptal') {
      color = AppColors.error;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Text(
        durum ?? 'İptal',
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatNumber(double? value) {
    if (value == null) return '-';
    return value.toStringAsFixed(2);
  }

  /// Modern minimalist header cell builder
  Widget _buildHeaderCell(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.orange.shade600,
            width: 2,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: Colors.grey.shade800,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
