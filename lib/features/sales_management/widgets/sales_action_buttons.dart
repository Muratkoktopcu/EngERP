// lib/features/sales_management/widgets/sales_action_buttons.dart

import 'package:flutter/material.dart';
import 'package:eng_erp/core/theme/theme.dart';

/// 🎯 Satış Yönetimi Aksiyon Butonları
class SalesActionButtons extends StatelessWidget {
  final VoidCallback? onApprove;
  final VoidCallback? onRevokeApproval;
  final VoidCallback? onAddProduct;
  final VoidCallback? onRemoveProduct;
  final VoidCallback? onUpdateDimensions;
  final VoidCallback? onCancel;
  final VoidCallback? onPackingList;
  final VoidCallback? onPdfReport;
  final bool isLoading;

  const SalesActionButtons({
    super.key,
    this.onApprove,
    this.onRevokeApproval,
    this.onAddProduct,
    this.onRemoveProduct,
    this.onUpdateDimensions,
    this.onCancel,
    this.onPackingList,
    this.onPdfReport,
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
              label: 'Onayla',
              icon: Icons.check_circle_outline,
              onPressed: onApprove,
              color: AppColors.success,
              isLoading: isLoading,
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildActionButton(
              label: 'Onayı Geri Al',
              icon: Icons.undo,
              onPressed: onRevokeApproval,
              color: AppColors.warning,
              isLoading: isLoading,
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildActionButton(
              label: 'Ürün Ekle',
              icon: Icons.add_circle_outline,
              onPressed: onAddProduct,
              color: AppColors.primary,
              isLoading: isLoading,
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildActionButton(
              label: 'Ürün Çıkar',
              icon: Icons.remove_circle_outline,
              onPressed: onRemoveProduct,
              color: AppColors.error,
              isLoading: isLoading,
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildActionButton(
              label: 'Boyut Güncelle',
              icon: Icons.straighten,
              onPressed: onUpdateDimensions,
              color: AppColors.info,
              isLoading: isLoading,
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildActionButton(
              label: 'İptal Et',
              icon: Icons.cancel_outlined,
              onPressed: onCancel,
              color: AppColors.error,
              isLoading: isLoading,
            ),
            const SizedBox(width: AppSpacing.md),
            Container(
              width: 1,
              height: 32,
              color: AppColors.border,
            ),
            const SizedBox(width: AppSpacing.md),
            _buildActionButton(
              label: 'Packing List',
              icon: Icons.inventory_2_outlined,
              onPressed: onPackingList,
              color: AppColors.blueGrey900,
              isLoading: isLoading,
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildActionButton(
              label: 'PDF Rapor',
              icon: Icons.picture_as_pdf,
              onPressed: onPdfReport,
              color: AppColors.error,
              isLoading: isLoading,
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
    bool isLoading = false,
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
