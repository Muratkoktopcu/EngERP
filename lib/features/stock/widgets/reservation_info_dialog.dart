// lib/features/stock/widgets/reservation_info_dialog.dart

import 'package:flutter/material.dart';
import 'package:eng_erp/features/reservation/data/reservation_model.dart';
import 'package:intl/intl.dart';

/// 📋 Ürün Rezervasyon Bilgisi Dialog
/// Seçilen ürünün rezervasyon detaylarını gösterir
class ReservationInfoDialog extends StatelessWidget {
  final ReservationModel reservation;

  const ReservationInfoDialog({
    super.key,
    required this.reservation,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.bookmark, color: Colors.blue.shade600),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Rezervasyon Bilgisi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
            splashRadius: 20,
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInfoCard(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Kapat'),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Rezervasyon No', reservation.rezervasyonNo),
          const Divider(),
          _buildInfoRow('Rezervasyon Kodu', reservation.rezervasyonKodu),
          const Divider(),
          _buildInfoRow('Alıcı Firma', reservation.aliciFirma),
          const Divider(),
          _buildInfoRow('Durum', reservation.durum, isStatus: true),
          const Divider(),
          _buildInfoRow('Rezervasyon Sorumlusu', reservation.rezervasyonSorumlusu),
          if (reservation.satisSorumlusu != null && reservation.satisSorumlusu!.isNotEmpty) ...[
            const Divider(),
            _buildInfoRow('Satış Sorumlusu', reservation.satisSorumlusu!),
          ],
          const Divider(),
          _buildInfoRow(
            'İşlem Tarihi',
            reservation.islemTarihi != null
                ? DateFormat('dd.MM.yyyy').format(reservation.islemTarihi!)
                : '-',
          ),
          if (reservation.urunCikisTarihi != null) ...[
            const Divider(),
            _buildInfoRow(
              'Çıkış Tarihi',
              DateFormat('dd.MM.yyyy').format(reservation.urunCikisTarihi!),
            ),
          ],
          if (reservation.sevkiyatAdresi != null && reservation.sevkiyatAdresi!.isNotEmpty) ...[
            const Divider(),
            _buildInfoRow('Sevkiyat Adresi', reservation.sevkiyatAdresi!),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isStatus = false}) {
    Color? statusColor;
    if (isStatus) {
      switch (value) {
        case 'Onay Bekliyor':
          statusColor = Colors.orange;
          break;
        case 'Onaylandı':
          statusColor = Colors.green;
          break;
        case 'Sevkiyat Tamamlandı':
          statusColor = Colors.blue;
          break;
        case 'İptal':
          statusColor = Colors.red;
          break;
        default:
          statusColor = Colors.grey;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: isStatus
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor?.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: statusColor ?? Colors.grey),
                    ),
                    child: Text(
                      value,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  )
                : Text(
                    value,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Rezervasyon bilgisi dialog'unu göster
Future<void> showReservationInfoDialog({
  required BuildContext context,
  required ReservationModel reservation,
}) {
  return showDialog(
    context: context,
    builder: (context) => ReservationInfoDialog(reservation: reservation),
  );
}
