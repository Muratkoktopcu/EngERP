// lib/features/reservation/widgets/reservation_action_buttons.dart

import 'package:flutter/material.dart';

/// Rezervasyon sayfası alt aksiyon butonları
class ReservationActionButtons extends StatelessWidget {
  final VoidCallback onAddToCart;
  final VoidCallback onRemoveFromCart;
  final VoidCallback onUpdateDimensions;
  final VoidCallback onCreateReservation;
  final bool isCreating;

  const ReservationActionButtons({
    super.key,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.onUpdateDimensions,
    required this.onCreateReservation,
    this.isCreating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Rezervasyona Ekle
              ElevatedButton.icon(
                onPressed: onAddToCart,
                icon: const Icon(Icons.add_shopping_cart, size: 18),
                label: const Text("Rezervasyona Ekle"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),

              const SizedBox(width: 12),

              // Rezervasyondan Çıkar
              ElevatedButton.icon(
                onPressed: onRemoveFromCart,
                icon: const Icon(Icons.remove_shopping_cart, size: 18),
                label: const Text("Rezervasyondan Çıkar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade500,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),

              const SizedBox(width: 12),

              // Boyutları Güncelle
              ElevatedButton.icon(
                onPressed: onUpdateDimensions,
                icon: const Icon(Icons.straighten, size: 18),
                label: const Text("Boyutları Güncelle"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),

              const SizedBox(width: 24),

              // Divider
              Container(
                width: 1,
                height: 36,
                color: Colors.grey.shade300,
              ),

              const SizedBox(width: 24),

              // Rezervasyon Oluştur
              ElevatedButton.icon(
                onPressed: isCreating ? null : onCreateReservation,
                icon: isCreating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save, size: 18),
                label: Text(isCreating ? "Oluşturuluyor..." : "Rezervasyon Oluştur"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
