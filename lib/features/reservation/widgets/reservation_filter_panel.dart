// lib/features/reservation/widgets/reservation_filter_panel.dart

import 'package:flutter/material.dart';
import 'package:eng_erp/core/theme/theme.dart';
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
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
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
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                                borderSide: const BorderSide(color: AppColors.border),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                                borderSide: const BorderSide(color: AppColors.border),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                                borderSide: const BorderSide(color: AppColors.primary),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildActionButton(
                          label: 'Barkodu Oku',
                          icon: Icons.qr_code_scanner,
                          onPressed: _openBarcodeScanner,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Filtrele butonu
              _buildActionButton(
                label: 'Filtrele',
                icon: Icons.filter_list,
                onPressed: widget.onFilter,
                color: AppColors.success,
              ),

              const SizedBox(width: 8),

              // Filtreleri temizle butonu
              _buildActionButton(
                label: 'Temizle',
                icon: Icons.clear_all,
                onPressed: () {
                  _barkodController.clear();
                  widget.onBarkodChanged('');
                  widget.onClearFilters();
                },
                color: AppColors.error,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          side: BorderSide(color: color.withOpacity(0.3)),
        ),
        disabledBackgroundColor: AppColors.grey200,
        disabledForegroundColor: AppColors.textDisabled,
      ),
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
