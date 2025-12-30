// lib/features/reservation/widgets/reservation_cart_table.dart

import 'package:flutter/material.dart';
import 'package:eng_erp/features/stock/data/stock_model.dart';

/// Rezervasyon sepeti tablosu - Eklenen ürünler
class ReservationCartTable extends StatelessWidget {
  final List<StockModel> cartItems;
  final StockModel? selectedCartItem;
  final Function(StockModel?) onSelectionChanged;
  final Map<String, Map<String, double>> dimensionUpdates;

  const ReservationCartTable({
    super.key,
    required this.cartItems,
    required this.selectedCartItem,
    required this.onSelectionChanged,
    required this.dimensionUpdates,
  });

  @override
  Widget build(BuildContext context) {
    // Veri yoksa mesaj göster
    if (cartItems.isEmpty) {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            // Başlık
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.shopping_cart, color: Colors.green.shade700, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Rezervasyon Sepeti (0 ürün)",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.green.shade900,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart_outlined, color: Colors.grey.shade400, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      "Sepet boş",
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Stok listesinden ürün ekleyin",
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
              color: Colors.green.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.shopping_cart, color: Colors.green.shade700, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Rezervasyon Sepeti (${cartItems.length} ürün)",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.green.shade900,
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
                    DataColumn(label: Text("ÜrünTipi")),
                    DataColumn(label: Text("ÜrünTürü")),
                    DataColumn(label: Text("StokEn")),
                    DataColumn(label: Text("StokBoy")),
                    DataColumn(label: Text("SatışEn", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("SatışBoy", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("SatışAlan", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("SatışTonaj", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
                  ],
                  rows: cartItems.map((stock) {
                    final isSelected = selectedCartItem?.epc == stock.epc;
                    final dimensions = dimensionUpdates[stock.epc] ?? {};
                    
                    // Satış değerlerini al (önce güncellenen, sonra mevcut, sonra stok)
                    final satisEn = dimensions['satisEn'] ?? stock.satisEn ?? stock.stokEn ?? 0;
                    final satisBoy = dimensions['satisBoy'] ?? stock.satisBoy ?? stock.stokBoy ?? 0;
                    final satisAlan = dimensions['satisAlan'] ?? stock.satisAlan ?? stock.stokAlan ?? 0;
                    final satisTonaj = dimensions['satisTonaj'] ?? stock.satisTonaj ?? stock.stokTonaj ?? 0;

                    return DataRow(
                      selected: isSelected,
                      color: WidgetStateProperty.resolveWith<Color?>((states) {
                        if (isSelected) return Colors.green.shade100;
                        return null;
                      }),
                      onSelectChanged: (selected) {
                        onSelectionChanged(selected == true ? stock : null);
                      },
                      cells: [
                        DataCell(Text(stock.epc)),
                        DataCell(Text(stock.barkodNo)),
                        DataCell(Text(stock.bandilNo ?? '-')),
                        DataCell(Text(stock.urunTipi ?? '-')),
                        DataCell(Text(stock.urunTuru ?? '-')),
                        DataCell(Text(stock.stokEn?.toStringAsFixed(2) ?? '-')),
                        DataCell(Text(stock.stokBoy?.toStringAsFixed(2) ?? '-')),
                        DataCell(Text(
                          satisEn.toStringAsFixed(2),
                          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.blue.shade700),
                        )),
                        DataCell(Text(
                          satisBoy.toStringAsFixed(2),
                          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.blue.shade700),
                        )),
                        DataCell(Text(
                          satisAlan.toStringAsFixed(2),
                          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.blue.shade700),
                        )),
                        DataCell(Text(
                          satisTonaj.toStringAsFixed(2),
                          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.blue.shade700),
                        )),
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
}
