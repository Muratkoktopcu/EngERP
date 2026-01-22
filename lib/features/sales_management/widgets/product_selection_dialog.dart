// lib/features/sales_management/widgets/product_selection_dialog.dart

import 'package:flutter/material.dart';
import 'package:eng_erp/core/theme/theme.dart';
import 'package:eng_erp/features/stock/data/stock_model.dart';

/// 📦 Ürün Seçim Dialog'u
class ProductSelectionDialog extends StatefulWidget {
  final List<StockModel> availableProducts;
  final Future<void> Function(String) onSearch;
  final bool isLoading;

  const ProductSelectionDialog({
    super.key,
    required this.availableProducts,
    required this.onSearch,
    this.isLoading = false,
  });

  static Future<StockModel?> show(
    BuildContext context, {
    required List<StockModel> availableProducts,
    required Future<void> Function(String) onSearch,
    bool isLoading = false,
  }) async {
    return showDialog<StockModel>(
      context: context,
      builder: (context) => ProductSelectionDialog(
        availableProducts: availableProducts,
        onSearch: onSearch,
        isLoading: isLoading,
      ),
    );
  }

  @override
  State<ProductSelectionDialog> createState() => _ProductSelectionDialogState();
}

class _ProductSelectionDialogState extends State<ProductSelectionDialog> {
  final TextEditingController _searchController = TextEditingController();
  StockModel? _selectedProduct;
  bool _isSearching = false;
  List<StockModel> _products = [];

  @override
  void initState() {
    super.initState();
    _products = widget.availableProducts;
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isSearching = true);
    try {
      await widget.onSearch('');
    } finally {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _products = widget.availableProducts;
        });
      }
    }
  }

  Future<void> _search() async {
    setState(() => _isSearching = true);
    try {
      await widget.onSearch(_searchController.text);
    } finally {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _products = widget.availableProducts;
        });
      }
    }
  }

  @override
  void didUpdateWidget(ProductSelectionDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.availableProducts != oldWidget.availableProducts) {
      setState(() {
        _products = widget.availableProducts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Container(
        width: 700,
        height: 500,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık
            Row(
              children: [
                const Icon(Icons.add_circle, color: AppColors.primary, size: 24),
                const SizedBox(width: AppSpacing.sm),
                const Text(
                  'Rezervasyona Ürün Ekle',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // Arama
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'EPC veya Barkod ile ara...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                ElevatedButton(
                  onPressed: _search,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                  child: const Text('Ara'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // Ürün Listesi
            Expanded(
              child: _isSearching
                  ? const Center(child: CircularProgressIndicator())
                  : _products.isEmpty
                      ? const Center(
                          child: Text(
                            'Stokta ürün bulunamadı',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            final product = _products[index];
                            final isSelected = _selectedProduct?.epc == product.epc;
                            return Card(
                              elevation: isSelected ? 2 : 0,
                              color: isSelected ? AppColors.primaryLighter.withOpacity(0.5) : null,
                              margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.primary.withOpacity(0.1),
                                  child: const Icon(Icons.inventory_2, color: AppColors.primary, size: 20),
                                ),
                                title: Text(
                                  product.barkodNo,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  'EPC: ${product.epc}\n${product.urunTuru ?? ''} - ${product.stokEn?.toStringAsFixed(0) ?? '-'} x ${product.stokBoy?.toStringAsFixed(0) ?? '-'}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                isThreeLine: true,
                                trailing: isSelected
                                    ? const Icon(Icons.check_circle, color: AppColors.success)
                                    : null,
                                selected: isSelected,
                                onTap: () {
                                  setState(() {
                                    _selectedProduct = product;
                                  });
                                },
                              ),
                            );
                          },
                        ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Butonlar
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('İptal'),
                ),
                const SizedBox(width: AppSpacing.sm),
                ElevatedButton(
                  onPressed: _selectedProduct != null
                      ? () => Navigator.of(context).pop(_selectedProduct)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: AppColors.white,
                  ),
                  child: const Text('Ekle'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
