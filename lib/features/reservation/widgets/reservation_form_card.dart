// lib/features/reservation/widgets/reservation_form_card.dart

import 'package:flutter/material.dart';
import 'package:eng_erp/features/reservation/data/company_model.dart';
import 'package:eng_erp/core/theme/theme.dart';

/// Rezervasyon form alanlarını içeren kart widget'ı
class ReservationFormCard extends StatelessWidget {
  final DateTime selectedDate;
  final TextEditingController rezervasyonNoController;
  final TextEditingController rezervasyonKoduController;
  final List<CompanyModel> companies;
  final CompanyModel? selectedCompany;
  final String rezervasyonSorumlusu;
  final Function(DateTime) onDateChanged;
  final Function(CompanyModel?) onCompanyChanged;
  final VoidCallback onClear;

  const ReservationFormCard({
    super.key,
    required this.selectedDate,
    required this.rezervasyonNoController,
    required this.rezervasyonKoduController,
    required this.companies,
    required this.selectedCompany,
    required this.rezervasyonSorumlusu,
    required this.onDateChanged,
    required this.onCompanyChanged,
    required this.onClear,
  });

  Future<void> _showDatePicker(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: "İŞLEM TARİHİ SEÇİN",
      cancelText: "İPTAL",
      confirmText: "SEÇ",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryDark,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      onDateChanged(date);
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return "$day.$month.${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -------- İşlem Tarihi --------
                _buildFormField(
                  label: "İşlem Tarihi",
                  width: 150,
                  child: TextField(
                    readOnly: true,
                    controller: TextEditingController(text: _formatDate(selectedDate)),
                    decoration: InputDecoration(
                      hintText: "Tarih seçin",
                      suffixIcon: const Icon(Icons.calendar_month),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                    ),
                    onTap: () => _showDatePicker(context),
                  ),
                ),

                const SizedBox(width: 20),

                // -------- Rezervasyon No --------
                _buildFormField(
                  label: "Rezervasyon No *",
                  width: 150,
                  child: TextField(
                    controller: rezervasyonNoController,
                    decoration: InputDecoration(
                      hintText: "Örn: RZV-001",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                // -------- Rezervasyon Kodu --------
                _buildFormField(
                  label: "Rezervasyon Kodu *",
                  width: 150,
                  child: TextField(
                    controller: rezervasyonKoduController,
                    decoration: InputDecoration(
                      hintText: "Örn: ABC123",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                // -------- Alıcı Firma --------
                _buildFormField(
                  label: "Alıcı Firma *",
                  width: 200,
                  child: DropdownButtonFormField<CompanyModel>(
                    value: selectedCompany,
                    hint: const Text("Firma seçin...", style: TextStyle(fontSize: 13)),
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                    ),
                    items: companies.map((company) {
                      return DropdownMenuItem<CompanyModel>(
                        value: company,
                        child: Text(
                          company.firmaAdi,
                          style: const TextStyle(fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: onCompanyChanged,
                    menuMaxHeight: 300,
                  ),
                ),

                const SizedBox(width: 20),

                // -------- Rezervasyon Sorumlusu --------
                _buildFormField(
                  label: "Rezervasyon Sorumlusu",
                  width: 170,
                  child: TextField(
                    readOnly: true,
                    controller: TextEditingController(text: rezervasyonSorumlusu),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                // -------- Temizle Butonu --------
                SizedBox(
                  width: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24), // Label height offset
                      ElevatedButton.icon(
                        onPressed: onClear,
                        icon: const Icon(Icons.clear_all, size: 18),
                        label: const Text("Temizle"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required double width,
    required Widget child,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 5),
          child,
        ],
      ),
    );
  }
}
