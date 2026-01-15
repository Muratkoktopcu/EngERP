// lib/features/sales_management/widgets/sales_reservation_table.dart

import 'package:flutter/material.dart';
import 'package:eng_erp/core/theme/theme.dart';
import 'package:eng_erp/features/reservation/data/reservation_model.dart';

/// 📋 Rezervasyon Listesi Tablosu
class SalesReservationTable extends StatelessWidget {
  final List<ReservationModel> reservations;
  final String? selectedRezervasyonNo;
  final ValueChanged<ReservationModel> onRowTap;
  final bool isLoading;
  final VoidCallback? onRefresh;

  const SalesReservationTable({
    super.key,
    required this.reservations,
    required this.selectedRezervasyonNo,
    required this.onRowTap,
    this.isLoading = false,
    this.onRefresh,
  });

  Color _getDurumColor(String? durum) {
    switch (durum) {
      case 'Onay Bekliyor':
        return AppColors.warning;
      case 'Onaylandı':
        return AppColors.success;
      case 'Sevkiyat Tamamlandı':
        return AppColors.info;
      case 'İptal':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (reservations.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 48,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  'Rezervasyon bulunamadı',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Başlık
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            color: AppColors.primaryLighter.withOpacity(0.3),
            child: Row(
              children: [
                const Icon(Icons.list_alt, size: 18, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Rezervasyonlar (${reservations.length})',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                if (onRefresh != null)
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 20),
                    onPressed: onRefresh,
                    tooltip: 'Yenile',
                    color: AppColors.primary,
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
          ),
          // Tablo
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(Colors.white),
                  headingRowHeight: 48,
                  dataRowMinHeight: 44,
                  dataRowMaxHeight: 56,
                  columnSpacing: 24,
                  horizontalMargin: 16,
                  dividerThickness: 0,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.grey200, width: 1.5),
                    ),
                  ),
                  columns: [
                    DataColumn(label: _buildHeaderCell('Rez. No')),
                    DataColumn(label: _buildHeaderCell('Rez. Kodu')),
                    DataColumn(label: _buildHeaderCell('Alıcı Firma')),
                    DataColumn(label: _buildHeaderCell('Rez. Sorumlusu')),
                    DataColumn(label: _buildHeaderCell('Satış Sorumlusu')),
                    DataColumn(label: _buildHeaderCell('İşlem Tarihi')),
                    DataColumn(label: _buildHeaderCell('Durum')),
                  ],
                  rows: reservations.map((reservation) {
                    final isSelected = reservation.rezervasyonNo == selectedRezervasyonNo;
                    return DataRow(
                      selected: isSelected,
                      color: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColors.primaryLighter.withOpacity(0.5);
                        }
                        return null;
                      }),
                      onSelectChanged: (_) => onRowTap(reservation),
                      cells: [
                        DataCell(Text(reservation.rezervasyonNo)),
                        DataCell(Text(reservation.rezervasyonKodu)),
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 150),
                            child: Text(
                              reservation.aliciFirma,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(Text(reservation.rezervasyonSorumlusu)),
                        DataCell(Text(reservation.satisSorumlusu ?? '-')),
                        DataCell(Text(_formatDate(reservation.islemTarihi))),
                        DataCell(_buildDurumChip(reservation.durum)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurumChip(String durum) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _getDurumColor(durum).withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getDurumColor(durum).withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Text(
        durum,
        style: TextStyle(
          color: _getDurumColor(durum),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  /// Modern minimalist header cell builder
  Widget _buildHeaderCell(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: Colors.grey.shade800,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
