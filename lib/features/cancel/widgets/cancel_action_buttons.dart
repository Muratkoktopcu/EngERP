// lib/features/cancel/widgets/cancel_action_buttons.dart

import 'package:flutter/material.dart';
import 'package:eng_erp/core/theme/theme.dart';

/// 🔘 İptal Yönetimi Aksiyon Butonları
class CancelActionButtons extends StatelessWidget {
  final bool hasSelectedIptal;
  final VoidCallback onPdfRapor;
  final VoidCallback onIptalSebebiGoster;
  final VoidCallback onSil;
  final bool isLoading;

  const CancelActionButtons({
    super.key,
    required this.hasSelectedIptal,
    required this.onPdfRapor,
    required this.onIptalSebebiGoster,
    required this.onSil,
    this.isLoading = false,
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
              label: 'PDF Rapor',
              icon: Icons.picture_as_pdf,
              onPressed: onPdfRapor,
              color: AppColors.info,
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildActionButton(
              label: 'İptal Sebebi',
              icon: Icons.info_outline,
              onPressed: hasSelectedIptal ? onIptalSebebiGoster : null,
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
              label: 'Kaydı Sil',
              icon: Icons.delete_forever,
              onPressed: hasSelectedIptal ? onSil : null,
              color: AppColors.error,
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
      onPressed: isLoading ? null : onPressed,
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
      icon: isLoading
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: color,
              ),
            )
          : Icon(icon, size: 18),
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
