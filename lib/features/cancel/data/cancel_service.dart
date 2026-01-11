// lib/features/cancel/data/cancel_service.dart

import 'package:eng_erp/features/cancel/data/cancel_repository.dart';
import 'package:eng_erp/features/sales_management/data/cancel_archive_model.dart';
import 'package:eng_erp/features/reservation/data/company_model.dart';

/// 📊 Cancel Service - İş mantığı katmanı
class CancelService {
  final CancelRepository _repository = CancelRepository();

  /// Filtrelenmiş iptal kayıtlarını getir
  Future<List<RezIptalModel>> getFilteredIptalRecords({
    String? rezervasyonNo,
    String? rezervasyonKodu,
    String? aliciFirma,
    String? satisSorumlusu,
    DateTime? rezervasyonTarihi,
    DateTime? iptalTarihi,
    String? tarihPeriyodu,
    String? epc,
  }) async {
    return await _repository.getFilteredIptalRecords(
      rezervasyonNo: rezervasyonNo,
      rezervasyonKodu: rezervasyonKodu,
      aliciFirma: aliciFirma,
      satisSorumlusu: satisSorumlusu,
      rezervasyonTarihi: rezervasyonTarihi,
      iptalTarihi: iptalTarihi,
      tarihPeriyodu: tarihPeriyodu,
      epc: epc,
    );
  }

  /// İptal kaydının detaylarını getir
  Future<List<RezIptalDetayModel>> getIptalDetails(String rezervasyonNo) async {
    return await _repository.getIptalDetails(rezervasyonNo);
  }

  /// İptal kaydını sil
  Future<void> deleteIptalKaydi(String rezervasyonNo) async {
    await _repository.deleteIptalKaydi(rezervasyonNo);
  }

  /// Tüm firmaları getir (dropdown için)
  Future<List<CompanyModel>> getAllCompanies() async {
    return await _repository.getAllCompanies();
  }

  /// Firma ara
  Future<List<CompanyModel>> searchCompanies(String term) async {
    return await _repository.searchCompanies(term);
  }

  /// Tarih formatla (yyyy-MM-dd)
  String formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Sayı formatla (2 ondalık)
  String formatNumber(double? value) {
    if (value == null) return '';
    return value.toStringAsFixed(2);
  }
}
