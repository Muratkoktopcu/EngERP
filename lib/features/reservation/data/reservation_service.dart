// lib/features/reservation/data/reservation_service.dart

import 'package:eng_erp/features/reservation/data/reservation_model.dart';
import 'package:eng_erp/features/reservation/data/company_model.dart';
import 'package:eng_erp/features/reservation/data/reservation_repository.dart';
import 'package:eng_erp/features/stock/data/stock_model.dart';

/// 🔧 Reservation Service - Business Logic Layer
class ReservationService {
  final ReservationRepository _repository;

  ReservationService({ReservationRepository? repository})
      : _repository = repository ?? ReservationRepository();

  /// Tüm alıcı firmaları getir
  Future<List<CompanyModel>> getAllCompanies() async {
    try {
      return await _repository.getAllCompanies();
    } catch (e) {
      rethrow;
    }
  }

  /// Ürünün rezervasyona eklenip eklenemeyeceğini kontrol et
  /// Returns: null if valid, error message if invalid
  String? validateProductForReservation(StockModel stock, List<StockModel> cart) {
    // Durum kontrolü
    final invalidStatuses = ['Onay Bekliyor', 'Onaylandı', 'Sevkiyat Tamamlandı'];
    if (stock.durum != null && invalidStatuses.contains(stock.durum)) {
      return "Bu ürün şu anda '${stock.durum}' durumundadır ve rezervasyona eklenemez.";
    }

    // Sepette zaten var mı kontrolü
    final existsInCart = cart.any((item) => item.epc == stock.epc);
    if (existsInCart) {
      return "Bu ürün zaten rezervasyona eklenmiş.";
    }

    return null; // Valid
  }

  /// Form validasyonu
  String? validateReservationForm({
    required String rezervasyonNo,
    required String rezervasyonKodu,
    required String? aliciFirma,
    required DateTime? tarih,
    required List<StockModel> cart,
  }) {
    if (rezervasyonNo.trim().isEmpty) {
      return "Rezervasyon numarası boş olamaz.";
    }

    if (rezervasyonKodu.trim().isEmpty) {
      return "Rezervasyon kodu boş olamaz.";
    }

    if (aliciFirma == null || aliciFirma.trim().isEmpty) {
      return "Alıcı firma seçilmelidir.";
    }

    if (tarih == null) {
      return "İşlem tarihi seçilmelidir.";
    }

    if (cart.isEmpty) {
      return "Sepette en az 1 ürün olmalıdır.";
    }

    return null; // Valid
  }

  /// Rezervasyon numarası benzersizlik kontrolü
  Future<bool> isReservationNoUnique(String reservationNo) async {
    try {
      final exists = await _repository.checkReservationNoExists(reservationNo);
      return !exists;
    } catch (e) {
      rethrow;
    }
  }

  /// EPC çakışma kontrolü
  Future<String?> checkEpcConflicts(List<StockModel> cart) async {
    try {
      for (final item in cart) {
        final hasReservation = await _repository.checkEpcHasReservation(item.epc);
        if (hasReservation) {
          return "EPC: ${item.epc} zaten başka bir rezervasyona atanmış.";
        }
      }
      return null; // No conflicts
    } catch (e) {
      rethrow;
    }
  }

  /// Rezervasyon oluştur (tam iş akışı)
  Future<void> createReservation({
    required String rezervasyonNo,
    required String rezervasyonKodu,
    required String aliciFirma,
    required String rezervasyonSorumlusu,
    required DateTime islemTarihi,
    required List<StockModel> cart,
    required Map<String, Map<String, double>> dimensionUpdates, // epc -> {satisEn, satisBoy, satisAlan, satisTonaj}
  }) async {
    try {
      // 1. Rezervasyon kaydı oluştur
      final reservation = ReservationModel(
        rezervasyonNo: rezervasyonNo,
        rezervasyonKodu: rezervasyonKodu,
        aliciFirma: aliciFirma,
        rezervasyonSorumlusu: rezervasyonSorumlusu,
        islemTarihi: islemTarihi,
        durum: 'Onay Bekliyor',
      );

      await _repository.createReservation(reservation);

      // 2. Stok kayıtlarını güncelle
      for (final item in cart) {
        final dimensions = dimensionUpdates[item.epc] ?? {};
        
        final updateData = <String, dynamic>{
          'SatisEn': dimensions['satisEn'] ?? item.satisEn ?? item.stokEn ?? 0,
          'SatisBoy': dimensions['satisBoy'] ?? item.satisBoy ?? item.stokBoy ?? 0,
          'SatisAlan': dimensions['satisAlan'] ?? item.satisAlan ?? item.stokAlan ?? 0,
          'SatisTonaj': dimensions['satisTonaj'] ?? item.satisTonaj ?? item.stokTonaj ?? 0,
          'RezervasyonNo': rezervasyonNo,
          'Durum': 'Onay Bekliyor',
          'AliciFirma': aliciFirma,
        };

        await _repository.updateStockForReservation(item.epc, updateData);
      }
    } catch (e) {
      rethrow;
    }
  }
}
