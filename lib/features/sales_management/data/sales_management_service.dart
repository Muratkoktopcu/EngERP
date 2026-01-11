// lib/features/sales_management/data/sales_management_service.dart

import 'package:eng_erp/features/reservation/data/reservation_model.dart';
import 'package:eng_erp/features/reservation/data/company_model.dart';
import 'package:eng_erp/features/stock/data/stock_model.dart';
import 'package:eng_erp/features/sales_management/data/sales_management_repository.dart';

/// 🔧 Sales Management Service - İş Mantığı Katmanı
class SalesManagementService {
  final SalesManagementRepository _repository;

  SalesManagementService({SalesManagementRepository? repository})
      : _repository = repository ?? SalesManagementRepository();

  /// Tarih periyoduna göre başlangıç ve bitiş tarihlerini hesapla
  Map<String, DateTime> calculateDateRange(DateTime date, String period) {
    DateTime startDate;
    DateTime endDate;

    switch (period) {
      case 'Günlük':
        startDate = DateTime(date.year, date.month, date.day);
        endDate = startDate.add(const Duration(days: 1));
        break;
      case 'Haftalık':
        // Haftanın pazartesi başlangıcı
        final weekday = date.weekday;
        startDate = DateTime(date.year, date.month, date.day - weekday + 1);
        endDate = startDate.add(const Duration(days: 7));
        break;
      case 'Aylık':
        startDate = DateTime(date.year, date.month, 1);
        endDate = DateTime(date.year, date.month + 1, 1);
        break;
      case 'Yıllık':
        startDate = DateTime(date.year, 1, 1);
        endDate = DateTime(date.year + 1, 1, 1);
        break;
      default:
        startDate = DateTime(date.year, date.month, date.day);
        endDate = startDate.add(const Duration(days: 1));
    }

    return {'start': startDate, 'end': endDate};
  }

  /// Filtreleme ile rezervasyonları getir
  Future<List<ReservationModel>> getFilteredReservations({
    String? rezervasyonNo,
    String? rezervasyonKodu,
    String? aliciFirma,
    String? rezervasyonSorumlusu,
    String? satisSorumlusu,
    String? durum,
    DateTime? tarih,
    String? tarihPeriyodu,
    String? epc,
  }) async {
    try {
      DateTime? startDate;
      DateTime? endDate;

      if (tarih != null && tarihPeriyodu != null) {
        final range = calculateDateRange(tarih, tarihPeriyodu);
        startDate = range['start'];
        endDate = range['end'];
      }

      return await _repository.getFilteredReservations(
        rezervasyonNo: rezervasyonNo,
        rezervasyonKodu: rezervasyonKodu,
        aliciFirma: aliciFirma,
        rezervasyonSorumlusu: rezervasyonSorumlusu,
        satisSorumlusu: satisSorumlusu,
        durum: durum,
        startDate: startDate,
        endDate: endDate,
        epc: epc,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Rezervasyona ait ürünleri getir
  Future<List<StockModel>> getReservationProducts(String rezervasyonNo) async {
    try {
      return await _repository.getReservationProducts(rezervasyonNo);
    } catch (e) {
      rethrow;
    }
  }

  /// Rezervasyon onaylama validasyonu
  String? validateApproval(ReservationModel reservation) {
    if (reservation.durum == 'Onaylandı') {
      return 'Bu rezervasyon zaten onaylanmış durumda.';
    }
    if (reservation.durum == 'Sevkiyat Tamamlandı') {
      return 'Sevkiyatı tamamlanmış rezervasyon onaylanamaz.';
    }
    if (reservation.durum == 'İptal') {
      return 'İptal edilmiş rezervasyon onaylanamaz.';
    }
    return null;
  }

  /// Rezervasyonu onayla
  Future<void> approveReservation(
    ReservationModel reservation,
    String satisSorumlusu,
  ) async {
    final error = validateApproval(reservation);
    if (error != null) {
      throw Exception(error);
    }

    try {
      await _repository.approveReservation(
        reservation.rezervasyonNo,
        satisSorumlusu,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Onay geri alma validasyonu
  String? validateRevokeApproval(ReservationModel reservation) {
    if (reservation.durum != 'Onaylandı') {
      return 'Sadece onaylanmış rezervasyonların onayı geri alınabilir.';
    }
    return null;
  }

  /// Onayı geri al
  Future<void> revokeApproval(ReservationModel reservation) async {
    final error = validateRevokeApproval(reservation);
    if (error != null) {
      throw Exception(error);
    }

    try {
      await _repository.revokeApproval(reservation.rezervasyonNo);
    } catch (e) {
      rethrow;
    }
  }

  /// İptal validasyonu
  Future<String?> validateCancellation(ReservationModel reservation) async {
    if (reservation.durum == 'İptal') {
      return 'Bu rezervasyon zaten iptal edilmiş.';
    }
    if (reservation.durum == 'Sevkiyat Tamamlandı') {
      return 'Sevkiyatı tamamlanmış rezervasyon iptal edilemez.';
    }

    // Sevkiyat tamamlanmış ürün var mı kontrol et
    final hasShipped = await _repository.hasShippedProducts(reservation.rezervasyonNo);
    if (hasShipped) {
      return 'Bu rezervasyonda sevkiyatı tamamlanmış ürünler bulunuyor. İptal edilemez.';
    }

    return null;
  }

  /// Rezervasyonu iptal et
  Future<void> cancelReservation({
    required ReservationModel reservation,
    required String iptalSebebi,
    required String iptalEdenPersonel,
  }) async {
    final error = await validateCancellation(reservation);
    if (error != null) {
      throw Exception(error);
    }

    try {
      final products = await _repository.getReservationProducts(reservation.rezervasyonNo);

      await _repository.cancelReservation(
        reservation: reservation,
        products: products,
        iptalSebebi: iptalSebebi,
        iptalEdenPersonel: iptalEdenPersonel,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Ürün ekleme validasyonu
  String? validateAddProduct(ReservationModel? reservation) {
    if (reservation == null) {
      return 'Bir rezervasyon seçmelisiniz.';
    }
    if (reservation.durum != 'Onay Bekliyor') {
      return 'Sadece "Onay Bekliyor" durumundaki rezervasyonlara ürün eklenebilir.';
    }
    return null;
  }

  /// Rezervasyona ürün ekle
  Future<void> addProductToReservation({
    required String epc,
    required ReservationModel reservation,
  }) async {
    final error = validateAddProduct(reservation);
    if (error != null) {
      throw Exception(error);
    }

    try {
      await _repository.addProductToReservation(
        epc: epc,
        rezervasyonNo: reservation.rezervasyonNo,
        aliciFirma: reservation.aliciFirma,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Ürün çıkarma validasyonu
  String? validateRemoveProduct(StockModel? product) {
    if (product == null) {
      return 'Bir ürün seçmelisiniz.';
    }
    if (product.durum != 'Onay Bekliyor') {
      return 'Sadece "Onay Bekliyor" durumundaki ürünler çıkarılabilir.';
    }
    return null;
  }

  /// Rezervasyondan ürün çıkar
  Future<bool> removeProductFromReservation({
    required StockModel product,
    required String rezervasyonNo,
  }) async {
    final error = validateRemoveProduct(product);
    if (error != null) {
      throw Exception(error);
    }

    try {
      // Rezervasyondaki toplam ürün sayısını kontrol et
      final products = await _repository.getReservationProducts(rezervasyonNo);
      final isLastProduct = products.length <= 1;

      // Ürünü çıkar
      await _repository.removeProductFromReservation(product.epc);

      // Son ürünse rezervasyonu da sil
      if (isLastProduct) {
        await _repository.deleteReservation(rezervasyonNo);
      }

      return isLastProduct; // Rezervasyon da silindi mi?
    } catch (e) {
      rethrow;
    }
  }

  /// Boyut güncelleme
  Future<void> updateProductDimensions({
    required String epc,
    required double satisEn,
    required double satisBoy,
    double? satisAlan,
    double? satisTonaj,
  }) async {
    try {
      // Alan otomatik hesaplanabilir
      final calculatedAlan = satisAlan ?? (satisEn * satisBoy / 10000); // m²
      final calculatedTonaj = satisTonaj ?? 0;

      await _repository.updateProductDimensions(
        epc: epc,
        satisEn: satisEn,
        satisBoy: satisBoy,
        satisAlan: calculatedAlan,
        satisTonaj: calculatedTonaj,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Stokta olan ürünleri getir (ürün ekleme için)
  Future<List<StockModel>> getAvailableProducts({String? searchTerm}) async {
    try {
      return await _repository.getAvailableProducts(searchTerm: searchTerm);
    } catch (e) {
      rethrow;
    }
  }

  /// Firma ara (autocomplete için)
  Future<List<CompanyModel>> searchCompanies(String term) async {
    try {
      return await _repository.searchCompanies(term);
    } catch (e) {
      rethrow;
    }
  }

  /// Packing List görüntüleme validasyonu
  String? validatePackingList(ReservationModel? reservation) {
    if (reservation == null) {
      return 'Bir rezervasyon seçmelisiniz.';
    }
    if (reservation.durum != 'Onaylandı' && reservation.durum != 'Sevkiyat Tamamlandı') {
      return 'Packing List sadece onaylanmış veya sevkiyatı tamamlanmış rezervasyonlar için görüntülenebilir.';
    }
    return null;
  }

  /// PDF Rapor validasyonu
  String? validatePdfReport(List<ReservationModel> reservations) {
    if (reservations.isEmpty) {
      return 'Rapor oluşturmak için listede en az 1 rezervasyon olmalıdır.';
    }
    return null;
  }
}
