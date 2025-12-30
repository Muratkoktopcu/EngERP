// lib/features/reservation/widgets/reservation_stock_table.dart

import 'package:flutter/material.dart';
import 'package:eng_erp/features/stock/data/stock_model.dart';

/// Stok listesi tablosu - Rezervasyona eklenecek ürünler
class ReservationStockTable extends StatelessWidget {
  final List<StockModel> stockList;
  final bool isLoading;
  final String? errorMessage;
  final StockModel? selectedStock;
  final VoidCallback onRetry;
  final Function(StockModel?) onSelectionChanged;

  const ReservationStockTable({
    super.key,
    required this.stockList,
    required this.isLoading,
    required this.errorMessage,
    required this.selectedStock,
    required this.onRetry,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Loading durumu
    if (isLoading) {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(50.0),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    // Hata durumu
    if (errorMessage != null) {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Hata: $errorMessage',
                  style: const TextStyle(color: Colors.red),
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
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(50.0),
            child: Text(
              'Stok verisi bulunmamaktadır.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ),
      );
    }

    // Veri varsa tabloyu göster
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.inventory_2, color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Stok Listesi (${stockList.length} ürün)",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
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
                  showCheckboxColumn: false,
                  columns: const [
                    DataColumn(label: Text("EPC")),
                    DataColumn(label: Text("BarkodNo")),
                    DataColumn(label: Text("BandılNo")),
                    DataColumn(label: Text("PlakaNo")),
                    DataColumn(label: Text("ÜrünTipi")),
                    DataColumn(label: Text("ÜrünTürü")),
                    DataColumn(label: Text("Yüzeyİşlemi")),
                    DataColumn(label: Text("Seleksiyon")),
                    DataColumn(label: Text("ÜretimTarihi")),
                    DataColumn(label: Text("Kalinlik")),
                    DataColumn(label: Text("PlakaAdedi")),
                    DataColumn(label: Text("StokEn")),
                    DataColumn(label: Text("StokBoy")),
                    DataColumn(label: Text("StokAlan")),
                    DataColumn(label: Text("StokTonaj")),
                    DataColumn(label: Text("Durum")),
                  ],
                  rows: stockList.map((stock) {
                    final isSelected = selectedStock?.id == stock.id;
                    return DataRow(
                      selected: isSelected,
                      color: WidgetStateProperty.resolveWith<Color?>((states) {
                        if (isSelected) return Colors.blue.shade100;
                        return null;
                      }),
                      onSelectChanged: (selected) {
                        onSelectionChanged(selected == true ? stock : null);
                      },
                      cells: [
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
                        DataCell(_buildStatusChip(stock.durum)),
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

  Widget _buildStatusChip(String? durum) {
    Color backgroundColor;
    Color textColor;

    switch (durum) {
      case 'Stokta':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case 'Onay Bekliyor':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        break;
      case 'Onaylandı':
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        break;
      case 'Sevkiyat Tamamlandı':
        backgroundColor = Colors.purple.shade100;
        textColor = Colors.purple.shade800;
        break;
      default:
        backgroundColor = Colors.grey.shade200;
        textColor = Colors.grey.shade700;
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
