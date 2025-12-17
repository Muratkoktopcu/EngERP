import 'package:flutter/material.dart';
import 'package:eng_erp/features/stock/data/stock_model.dart';

/// Stok verileri tablosu widget'ı
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

    // Hata durumunu göster
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
              'Henüz stok verisi bulunmamaktadır.',
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          showCheckboxColumn: false,
          columns: const [
            DataColumn(label: Text("ID")),
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
            DataColumn(label: Text("SatisEn")),
            DataColumn(label: Text("SatisBoy")),
            DataColumn(label: Text("SatisAlan")),
            DataColumn(label: Text("SatisTonaj")),
            DataColumn(label: Text("Durum")),
            DataColumn(label: Text("RezervasyonNo")),
            DataColumn(label: Text("KaydedenPersonel")),
            DataColumn(label: Text("ÜrünCikisTarihi")),
            DataColumn(label: Text("AliciFirma")),
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
                DataCell(Text(stock.durum ?? '-')),
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
    );
  }
}
