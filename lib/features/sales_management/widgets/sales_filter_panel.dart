// lib/features/sales_management/widgets/sales_filter_panel.dart

import 'package:flutter/material.dart';
import 'package:eng_erp/core/theme/theme.dart';

/// 🔍 Satış Yönetimi Filtre Paneli
class SalesFilterPanel extends StatelessWidget {
  final bool isExpanded;
  final TextEditingController rezervasyonNoController;
  final TextEditingController rezervasyonKoduController;
  final TextEditingController aliciFirmaController;
  final TextEditingController rezervasyonSorumlusuController;
  final TextEditingController satisSorumlusuController;
  final TextEditingController epcController;
  final DateTime? selectedDate;
  final String tarihPeriyodu;
  final String durum;
  final List<String> firmaOnerileri;
  final VoidCallback onDateTap;
  final ValueChanged<String?> onPeriyotChanged;
  final ValueChanged<String?> onDurumChanged;
  final VoidCallback onClear;
  final VoidCallback onFilter;
  final ValueChanged<String> onFirmaSearch;

  const SalesFilterPanel({
    super.key,
    required this.isExpanded,
    required this.rezervasyonNoController,
    required this.rezervasyonKoduController,
    required this.aliciFirmaController,
    required this.rezervasyonSorumlusuController,
    required this.satisSorumlusuController,
    required this.epcController,
    required this.selectedDate,
    required this.tarihPeriyodu,
    required this.durum,
    required this.firmaOnerileri,
    required this.onDateTap,
    required this.onPeriyotChanged,
    required this.onDurumChanged,
    required this.onClear,
    required this.onFilter,
    required this.onFirmaSearch,
  });

  static const List<String> periyotList = ['Günlük', 'Haftalık', 'Aylık', 'Yıllık'];
  static const List<String> durumList = [
    'Hepsi',
    'Onay Bekliyor',
    'Onaylandı',
    'Sevkiyat Tamamlandı',
  ];

  @override
  Widget build(BuildContext context) {
    if (!isExpanded) return const SizedBox.shrink();

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      borderSide: const BorderSide(color: AppColors.border),
    );
    const contentPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 10);

    return Align(
      alignment: Alignment.centerLeft,
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildDatePicker(inputBorder, contentPadding),
                const SizedBox(width: 10),
                _buildTextField(
                  'Rez. Kodu',
                  rezervasyonKoduController,
                  inputBorder,
                  contentPadding,
                  width: 130,
                ),
                const SizedBox(width: 10),
                _buildTextField(
                  'Rez. No',
                  rezervasyonNoController,
                  inputBorder,
                  contentPadding,
                  width: 130,
                ),
                const SizedBox(width: 10),
                _buildAutocomplete(
                  'Alıcı Firma',
                  aliciFirmaController,
                  inputBorder,
                  contentPadding,
                  width: 160,
                ),
                const SizedBox(width: 10),
                _buildTextField(
                  'Rez. Sorumlusu',
                  rezervasyonSorumlusuController,
                  inputBorder,
                  contentPadding,
                  width: 140,
                ),
                const SizedBox(width: 10),
                _buildTextField(
                  'Satış Sorumlusu',
                  satisSorumlusuController,
                  inputBorder,
                  contentPadding,
                  width: 140,
                ),
                const SizedBox(width: 10),
                _buildTextField(
                  'EPC',
                  epcController,
                  inputBorder,
                  contentPadding,
                  width: 140,
                ),
                const SizedBox(width: 10),
                _buildDropdown(
                  'Tarih Periyodu',
                  tarihPeriyodu,
                  periyotList,
                  onPeriyotChanged,
                  inputBorder,
                  contentPadding,
                ),
                const SizedBox(width: 10),
                _buildDropdown(
                  'Durum',
                  durum,
                  durumList,
                  onDurumChanged,
                  inputBorder,
                  contentPadding,
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: onClear,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.grey200,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                  ),
                  icon: const Icon(Icons.clear_all, size: 20),
                  label: const Text('Temizle'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    OutlineInputBorder border,
    EdgeInsets padding, {
    double width = 140,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: border,
              contentPadding: padding,
              isDense: true,
            ),
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildAutocomplete(
    String label,
    TextEditingController controller,
    OutlineInputBorder border,
    EdgeInsets padding, {
    double width = 180,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Autocomplete<String>(
            optionsBuilder: (textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty();
              }
              onFirmaSearch(textEditingValue.text);
              return firmaOnerileri.where((option) =>
                  option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
            },
            onSelected: (String selection) {
              controller.text = selection;
            },
            fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
              // Sync controllers
              textController.text = controller.text;
              textController.addListener(() {
                controller.text = textController.text;
              });
              return TextField(
                controller: textController,
                focusNode: focusNode,
                decoration: InputDecoration(
                  border: border,
                  contentPadding: padding,
                  isDense: true,
                ),
                style: const TextStyle(fontSize: 13),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(OutlineInputBorder border, EdgeInsets padding) {
    final dateText = selectedDate != null
        ? '${selectedDate!.day.toString().padLeft(2, '0')}.${selectedDate!.month.toString().padLeft(2, '0')}.${selectedDate!.year}'
        : 'Tarih Seç';

    return SizedBox(
      width: 140,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tarih',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: onDateTap,
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateText,
                    style: const TextStyle(fontSize: 13),
                  ),
                  const Icon(Icons.calendar_month, size: 18, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
    OutlineInputBorder border,
    EdgeInsets padding,
  ) {
    return SizedBox(
      width: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            items: items
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: const TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              border: border,
              contentPadding: padding,
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}
