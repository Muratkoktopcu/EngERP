import 'package:flutter/material.dart';
import 'package:eng_erp/core/theme/theme.dart';

/// Stok aksiyon butonları widget'ı - Modern tasarım
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
            _buildActionButton(
              label: 'Stok Raporu',
              icon: Icons.picture_as_pdf,
              onPressed: onStokRaporu,
              color: AppColors.info,
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildActionButton(
              label: 'Ürün Güncelle',
              icon: Icons.edit,
              onPressed: onUrunGuncelle,
              color: AppColors.primary,
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildActionButton(
              label: 'Sil',
              icon: Icons.delete,
              onPressed: onSil,
              color: AppColors.error,
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildActionButton(
              label: 'Rezervasyon Bilgisi',
              icon: Icons.info_outline,
              onPressed: onRezervasyonBilgisi,
              color: AppColors.warning,
            ),
            const SizedBox(width: AppSpacing.md),
            Container(
              width: 1,
              height: 32,
              color: AppColors.border,
            ),
            const SizedBox(width: AppSpacing.md),
            _buildActionButton(
              label: 'Yenile',
              icon: Icons.refresh,
              onPressed: onYenile,
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
    required VoidCallback onPressed,
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
}
