// lib/features/cancel/widgets/cancel_filter_panel.dart

import 'package:flutter/material.dart';
import 'package:eng_erp/core/theme/theme.dart';

/// 🔍 İptal Yönetimi Filtre Paneli
class CancelFilterPanel extends StatelessWidget {
  final TextEditingController rezervasyonNoController;
  final TextEditingController rezervasyonKoduController;
  final TextEditingController satisSorumlusuController;
  final TextEditingController epcController;
  final DateTime? rezervasyonTarihi;
  final DateTime? iptalTarihi;
  final String tarihPeriyodu;
  final List<String> firmaListesi;
  final String? selectedFirma;
  final VoidCallback onRezervasyonTarihiTap;
  final VoidCallback onIptalTarihiTap;
  final ValueChanged<String?> onPeriyotChanged;
  final ValueChanged<String?> onFirmaChanged;
  final VoidCallback onClear;

  const CancelFilterPanel({
    super.key,
    required this.rezervasyonNoController,
    required this.rezervasyonKoduController,
    required this.satisSorumlusuController,
    required this.epcController,
    required this.rezervasyonTarihi,
    required this.iptalTarihi,
    required this.tarihPeriyodu,
    required this.firmaListesi,
    required this.selectedFirma,
    required this.onRezervasyonTarihiTap,
    required this.onIptalTarihiTap,
    required this.onPeriyotChanged,
    required this.onFirmaChanged,
    required this.onClear,
  });

  static const List<String> periyotList = ['Günlük', 'Haftalık', 'Aylık', 'Yıllık'];

  @override
  Widget build(BuildContext context) {
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
                _buildTextField(
                  'Rez. No',
                  rezervasyonNoController,
                  inputBorder,
                  contentPadding,
                  width: 130,
                ),
                const SizedBox(width: 10),
                _buildTextField(
                  'Rez. Kodu',
                  rezervasyonKoduController,
                  inputBorder,
                  contentPadding,
                  width: 130,
                ),
                const SizedBox(width: 10),
                _buildSearchableDropdown(
                  'Alıcı Firma',
                  selectedFirma,
                  firmaListesi,
                  onFirmaChanged,
                  inputBorder,
                  contentPadding,
                  width: 200,
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
                _buildDatePicker(
                  'Rez. Tarihi',
                  rezervasyonTarihi,
                  onRezervasyonTarihiTap,
                  inputBorder,
                  contentPadding,
                ),
                const SizedBox(width: 10),
                _buildDatePicker(
                  'İptal Tarihi',
                  iptalTarihi,
                  onIptalTarihiTap,
                  inputBorder,
                  contentPadding,
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
                _buildTextField(
                  'EPC',
                  epcController,
                  inputBorder,
                  contentPadding,
                  width: 140,
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

  Widget _buildSearchableDropdown(
    String label,
    String? value,
    List<String> items,
    ValueChanged<String?> onChanged,
    OutlineInputBorder border,
    EdgeInsets padding, {
    double width = 200,
  }) {
    // Tüm seçenekler: boş seçenek + firmalar
    final allItems = ['', ...items];
    
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
          DropdownButtonFormField<String>(
            value: (value == null || value.isEmpty) ? '' : value,
            isExpanded: true,
            menuMaxHeight: 300,
            items: allItems
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.isEmpty ? 'Tümü' : e,
                        style: TextStyle(
                          fontSize: 13,
                          color: e.isEmpty ? AppColors.textSecondary : null,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            onChanged: (val) => onChanged(val == '' ? null : val),
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

  Widget _buildDatePicker(
    String label,
    DateTime? selectedDate,
    VoidCallback onTap,
    OutlineInputBorder border,
    EdgeInsets padding,
  ) {
    final dateText = selectedDate != null
        ? '${selectedDate.day.toString().padLeft(2, '0')}.${selectedDate.month.toString().padLeft(2, '0')}.${selectedDate.year}'
        : 'Tarih Seç';

    return SizedBox(
      width: 140,
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
          InkWell(
            onTap: onTap,
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
      width: 150,
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
