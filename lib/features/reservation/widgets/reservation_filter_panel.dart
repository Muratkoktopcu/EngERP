// lib/features/reservation/widgets/reservation_filter_panel.dart

import 'package:flutter/material.dart';
import 'package:eng_erp/features/stock/pages/barcode_scanner_page.dart';

/// Rezervasyon sayfası için stok filtreleme paneli
class ReservationFilterPanel extends StatefulWidget {
  final String initialBarkod;
  final Function(String) onBarkodChanged;
  final VoidCallback onFilter;
  final VoidCallback onClearFilters;

  const ReservationFilterPanel({
    super.key,
    required this.initialBarkod,
    required this.onBarkodChanged,
    required this.onFilter,
    required this.onClearFilters,
  });

  @override
  State<ReservationFilterPanel> createState() => _ReservationFilterPanelState();
}

class _ReservationFilterPanelState extends State<ReservationFilterPanel> {
  late TextEditingController _barkodController;

  @override
  void initState() {
    super.initState();
    _barkodController = TextEditingController(text: widget.initialBarkod);
  }

  @override
  void dispose() {
    _barkodController.dispose();
    super.dispose();
  }

  Future<void> _openBarcodeScanner() async {
    final String? scannedBarcode = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => const BarcodeScannerPage(),
      ),
    );

    if (scannedBarcode != null && scannedBarcode.isNotEmpty) {
      setState(() {
        _barkodController.text = scannedBarcode;
      });
      widget.onBarkodChanged(scannedBarcode);
      widget.onFilter();
    }
  }

  void _onBarkodTextChanged(String value) {
    widget.onBarkodChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Barkod filtresi
                SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Barkod ile Ara",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _barkodController,
                              onChanged: _onBarkodTextChanged,
                              onSubmitted: (_) => widget.onFilter(),
                              decoration: InputDecoration(
                                hintText: "Barkod numarası girin...",
                                hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                                prefixIcon: const Icon(Icons.search, size: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: _openBarcodeScanner,
                            icon: const Icon(Icons.qr_code_scanner, size: 18),
                            label: const Text("Barkodu Oku"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Filtrele butonu
                ElevatedButton.icon(
                  onPressed: widget.onFilter,
                  icon: const Icon(Icons.filter_list, size: 18),
                  label: const Text("Filtrele"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),

                const SizedBox(width: 8),

                // Filtreleri temizle butonu
                ElevatedButton.icon(
                  onPressed: () {
                    _barkodController.clear();
                    widget.onBarkodChanged('');
                    widget.onClearFilters();
                  },
                  icon: const Icon(Icons.clear_all, size: 18),
                  label: const Text("Temizle"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
