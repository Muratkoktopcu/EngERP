// lib/features/reservation/widgets/reservation_action_buttons.dart

import 'package:flutter/material.dart';
import 'package:eng_erp/core/theme/theme.dart';

/// Rezervasyon sayfası alt aksiyon butonları - Modern tasarım
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
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.md,
      ),
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
          children: [
            // Rezervasyona Ekle
            _buildActionButton(
              label: 'Rezervasyona Ekle',
              icon: Icons.add_shopping_cart,
              onPressed: onAddToCart,
              color: AppColors.primary,
            ),
            const SizedBox(width: AppSpacing.sm),

            // Rezervasyondan Çıkar
            _buildActionButton(
              label: 'Rezervasyondan Çıkar',
              icon: Icons.remove_shopping_cart,
              onPressed: onRemoveFromCart,
              color: AppColors.error,
            ),
            const SizedBox(width: AppSpacing.sm),

            // Boyutları Güncelle
            _buildActionButton(
              label: 'Boyutları Güncelle',
              icon: Icons.straighten,
              onPressed: onUpdateDimensions,
              color: AppColors.warning,
            ),

            const SizedBox(width: AppSpacing.md),

            // Divider
            Container(
              width: 1,
              height: 32,
              color: AppColors.border,
            ),

            const SizedBox(width: AppSpacing.md),

            // Rezervasyon Oluştur - Yeşil (Success)
            _buildPrimaryButton(
              label: isCreating ? 'Oluşturuluyor...' : 'Rezervasyon Oluştur',
              icon: Icons.check_circle,
              onPressed: isCreating ? null : onCreateReservation,
              isLoading: isCreating,
              color: AppColors.success,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

  Widget _buildPrimaryButton({
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
    bool isLoading = false,
    Color color = AppColors.primary,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          side: BorderSide(color: color.withOpacity(0.3)),
        ),
        disabledBackgroundColor: AppColors.grey200,
        disabledForegroundColor: AppColors.textDisabled,
      ),
      icon: isLoading
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: color,
              ),
            )
          : Icon(icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
