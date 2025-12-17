import 'package:flutter/material.dart';

/// Stok aksiyon butonları widget'ı
class StockActionButtons extends StatelessWidget {
  final VoidCallback onStokRaporu;
  final VoidCallback onUrunGuncelle;
  final VoidCallback onSil;
  final VoidCallback onRezervasyonBilgisi;
  final VoidCallback onYenile;

  const StockActionButtons({
    super.key,
    required this.onStokRaporu,
    required this.onUrunGuncelle,
    required this.onSil,
    required this.onRezervasyonBilgisi,
    required this.onYenile,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            _actionBtn("Stok Raporu", onPressed: onStokRaporu),
            _actionBtn("Ürün Güncelle", onPressed: onUrunGuncelle, isPrimary: true),
            _actionBtn("Sil", onPressed: onSil),
            _actionBtn("Rezervasyon Bilgisi", onPressed: onRezervasyonBilgisi),
            _actionBtn("Yenile", onPressed: onYenile),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn(String text, {required VoidCallback onPressed, bool isPrimary = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.blue.shade700 : Colors.grey.shade200,
          foregroundColor: isPrimary ? Colors.white : Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        ),
        child: Text(text),
      ),
    );
  }
}
