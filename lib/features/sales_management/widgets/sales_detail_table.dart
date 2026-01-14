// lib/features/sales_management/widgets/sales_detail_table.dart

import 'package:flutter/material.dart';
import 'package:eng_erp/core/theme/theme.dart';
import 'package:eng_erp/features/stock/data/stock_model.dart';

/// 📦 Rezervasyon Detay Tablosu (Ürünler)
class SalesDetailTable extends StatelessWidget {
  final List<StockModel> products;
  final String? selectedEpc;
  final ValueChanged<StockModel> onRowTap;
  final bool isLoading;
  final String? rezervasyonNo;

  const SalesDetailTable({
    super.key,
    required this.products,
    required this.selectedEpc,
    required this.onRowTap,
    this.isLoading = false,
    this.rezervasyonNo,
  });

  Color _getDurumColor(String? durum) {
    switch (durum) {
      case 'Onay Bekliyor':
        return AppColors.warning;
      case 'Onaylandı':
        return AppColors.success;
      case 'Sevkiyat Tamamlandı':
        return AppColors.info;
      case 'Stokta':
        return AppColors.textSecondary;
      default:
        return AppColors.textSecondary;
    }
  }

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
                  'Detayları görmek için bir rezervasyon seçin',
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
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (products.isEmpty) {
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
                  'Bu rezervasyonda ürün bulunmuyor',
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
            color: AppColors.success.withOpacity(0.1),
            child: Row(
              children: [
                const Icon(Icons.inventory_2, size: 18, color: AppColors.success),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Ürün Detayları (${products.length} ürün)',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.success,
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
                  headingRowColor: WidgetStateProperty.all(AppColors.grey200),
                  dataRowMinHeight: 44,
                  dataRowMaxHeight: 56,
                  columnSpacing: 20,
                  horizontalMargin: 16,
                  columns: const [
                    DataColumn(label: Text('Rez. No', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('EPC', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Barkod No', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Ürün Türü', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Stok Boyut', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Satış Boyut', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Stok Alan', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                    DataColumn(label: Text('Satış Alan', style: TextStyle(fontWeight: FontWeight.bold)), numeric: true),
                    DataColumn(label: Text('Durum', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: products.map((product) {
                    final isSelected = product.epc == selectedEpc;
                    return DataRow(
                      selected: isSelected,
                      color: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColors.success.withOpacity(0.15);
                        }
                        return null;
                      }),
                      onSelectChanged: (_) => onRowTap(product),
                      cells: [
                        DataCell(Text(
                          product.rezervasyonNo ?? '-',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        )),
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 120),
                            child: Text(
                              product.epc,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        DataCell(Text(product.barkodNo, style: const TextStyle(fontSize: 12))),
                        DataCell(Text(product.urunTuru ?? '-', style: const TextStyle(fontSize: 12))),
                        DataCell(Text(
                          '${product.stokEn?.toStringAsFixed(0) ?? '-'} x ${product.stokBoy?.toStringAsFixed(0) ?? '-'}',
                          style: const TextStyle(fontSize: 12),
                        )),
                        DataCell(Text(
                          '${product.satisEn?.toStringAsFixed(0) ?? '-'} x ${product.satisBoy?.toStringAsFixed(0) ?? '-'}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        )),
                        DataCell(Text(
                          product.stokAlan?.toStringAsFixed(2) ?? '-',
                          style: const TextStyle(fontSize: 12),
                        )),
                        DataCell(Text(
                          product.satisAlan?.toStringAsFixed(2) ?? '-',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        )),
                        DataCell(_buildDurumChip(product.durum)),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _getDurumColor(durum).withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _getDurumColor(durum).withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Text(
        durum ?? '-',
        style: TextStyle(
          color: _getDurumColor(durum),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
