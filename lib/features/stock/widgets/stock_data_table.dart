import 'package:flutter/material.dart';
import 'package:eng_erp/features/stock/data/stock_model.dart';
import 'package:eng_erp/core/theme/theme.dart';

/// Stok verileri tablosu widget'ı - Modern tasarım
class StockDataTable extends StatelessWidget {
  final List<StockModel> stockList;
  final bool isLoading;
  final String? errorMessage;
  final StockModel? selectedStock;
  final VoidCallback onRetry;
  final Function(StockModel?) onSelectionChanged;

  const StockDataTable({
    super.key,
    required this.stockList,
    required this.isLoading,
    this.errorMessage,
    this.selectedStock,
    required this.onRetry,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Loading durumunu göster
    if (isLoading) {
      return Container(
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
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(50.0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    // Hata durumunu göster
    if (errorMessage != null) {
      return Container(
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Hata: $errorMessage',
                  style: const TextStyle(color: AppColors.error),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Tekrar Dene'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Veri yoksa mesaj göster
    if (stockList.isEmpty) {
      return Container(
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
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(50.0),
            child: Text(
              'Henüz stok verisi bulunmamaktadır.',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ),
        ),
      );
    }

    // Veri varsa tabloyu göster
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.md),
                topRight: Radius.circular(AppRadius.md),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.inventory_2, color: Colors.blue.shade800, size: 18),
                const SizedBox(width: 8),
                Text(
                  "Ürünler (${stockList.length} kayıt)",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.blue.shade900,
                  ),
                ),
              ],
            ),
          ),
          // Tablo
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  showCheckboxColumn: true,
                  headingRowColor: WidgetStateProperty.all(Colors.white),
                  headingRowHeight: 48,
                  dividerThickness: 0,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.grey200, width: 1.5),
                    ),
                  ),
                  columns: [
                    DataColumn(label: _buildHeaderCell('ID')),
            DataColumn(label: _buildHeaderCell('EPC')),
            DataColumn(label: _buildHeaderCell('Barkod No')),
            DataColumn(label: _buildHeaderCell('Bandıl No')),
            DataColumn(label: _buildHeaderCell('Plaka No')),
            DataColumn(label: _buildHeaderCell('Ürün Tipi')),
            DataColumn(label: _buildHeaderCell('Ürün Türü')),
            DataColumn(label: _buildHeaderCell('Yüzey İşlemi')),
            DataColumn(label: _buildHeaderCell('Seleksiyon')),
            DataColumn(label: _buildHeaderCell('Üretim Tarihi')),
            DataColumn(label: _buildHeaderCell('Kalınlık')),
            DataColumn(label: _buildHeaderCell('Plaka Adedi')),
            DataColumn(label: _buildHeaderCell('Stok En')),
            DataColumn(label: _buildHeaderCell('Stok Boy')),
            DataColumn(label: _buildHeaderCell('Stok Alan')),
            DataColumn(label: _buildHeaderCell('Stok Tonaj')),
            DataColumn(label: _buildHeaderCell('Satış En', isHighlight: true)),
            DataColumn(label: _buildHeaderCell('Satış Boy', isHighlight: true)),
            DataColumn(label: _buildHeaderCell('Satış Alan', isHighlight: true)),
            DataColumn(label: _buildHeaderCell('Satış Tonaj', isHighlight: true)),
            DataColumn(label: _buildHeaderCell('Durum')),
            DataColumn(label: _buildHeaderCell('Rezervasyon No')),
            DataColumn(label: _buildHeaderCell('Kaydeden Personel')),
            DataColumn(label: _buildHeaderCell('Ürün Çıkış Tarihi')),
            DataColumn(label: _buildHeaderCell('Alıcı Firma')),
          ],
          rows: stockList.map((stock) {
            final isSelected = selectedStock?.id == stock.id;
            return DataRow(
              selected: isSelected,
              color: WidgetStateProperty.resolveWith<Color?>((states) {
                if (isSelected) return AppColors.primary.withOpacity(0.1);
                return null;
              }),
              onSelectChanged: (selected) {
                // Toggle: Aynı satıra tıklanırsa seçimi kaldır
                if (isSelected) {
                  onSelectionChanged(null);
                } else {
                  onSelectionChanged(selected == true ? stock : null);
                }
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
                DataCell(_buildStatusChip(stock.durum)),
                DataCell(Text(stock.rezervasyonNo ?? '-')),
                DataCell(Text(stock.kaydedenPersonel ?? '-')),
                DataCell(Text(stock.urunCikisTarihi != null
                    ? '${stock.urunCikisTarihi!.day}.${stock.urunCikisTarihi!.month}.${stock.urunCikisTarihi!.year}'
                    : '-')),
                DataCell(Text(stock.aliciFirma ?? '-')),
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

  /// Modern minimalist header cell builder
  Widget _buildHeaderCell(String text, {bool isHighlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isHighlight ? AppColors.success : AppColors.primary,
            width: 2,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: isHighlight ? AppColors.success : Colors.grey.shade800,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildStatusChip(String? durum) {
    Color backgroundColor;
    Color textColor;

    switch (durum) {
      case 'Stokta':
        backgroundColor = AppColors.success.withOpacity(0.1);
        textColor = AppColors.success;
        break;
      case 'Onay Bekliyor':
        backgroundColor = AppColors.warning.withOpacity(0.1);
        textColor = AppColors.warning;
        break;
      case 'Onaylandı':
        backgroundColor = AppColors.primary.withOpacity(0.1);
        textColor = AppColors.primary;
        break;
      case 'Sevkiyat Tamamlandı':
        backgroundColor = AppColors.info.withOpacity(0.1);
        textColor = AppColors.info;
        break;
      default:
        backgroundColor = AppColors.grey200;
        textColor = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        durum ?? '-',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
