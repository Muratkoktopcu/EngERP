// lib/features/sales_management/data/sales_management_repository.dart

import 'package:eng_erp/core/services/supabase_client.dart';
import 'package:eng_erp/features/reservation/data/reservation_model.dart';
import 'package:eng_erp/features/reservation/data/company_model.dart';
import 'package:eng_erp/features/stock/data/stock_model.dart';
import 'package:eng_erp/features/sales_management/data/cancel_archive_model.dart';

/// 📊 Sales Management Repository - Supabase ile iletişim
class SalesManagementRepository {
  final _supabase = SupabaseClientManager().db;
  static const String _reservationTable = 'UrunRezervasyon';
  static const String _stockTable = 'UrunStok';
  static const String _companyTable = 'AliciFirmalar';
  static const String _cancelTable = 'RezIptal';
  static const String _cancelDetailTable = 'RezIptalDetay';

  /// Filtreleme ile rezervasyonları getir
  Future<List<ReservationModel>> getFilteredReservations({
    String? rezervasyonNo,
    String? rezervasyonKodu,
    String? aliciFirma,
    String? rezervasyonSorumlusu,
    String? satisSorumlusu,
    String? durum,
    DateTime? startDate,
    DateTime? endDate,
    String? epc,
  }) async {
    try {
      // EPC filtresi varsa önce ilgili rezervasyon numaralarını bul
      List<String>? epcReservationNos;
      if (epc != null && epc.isNotEmpty) {
        final epcResponse = await _supabase
            .from(_stockTable)
            .select('RezervasyonNo')
            .ilike('EPC', '%$epc%')
            .not('RezervasyonNo', 'is', null);

        epcReservationNos = (epcResponse as List)
            .map((e) => e['RezervasyonNo'] as String?)
            .where((e) => e != null && e.isNotEmpty)
            .cast<String>()
            .toList();

        if (epcReservationNos.isEmpty) {
          return []; // EPC eşleşmesi yoksa boş liste döndür
        }
      }

      var query = _supabase.from(_reservationTable).select();

      // Filtreler
      if (rezervasyonNo != null && rezervasyonNo.isNotEmpty) {
        query = query.ilike('RezervasyonNo', '%$rezervasyonNo%');
      }
      if (rezervasyonKodu != null && rezervasyonKodu.isNotEmpty) {
        query = query.ilike('RezervasyonKodu', '%$rezervasyonKodu%');
      }
      if (aliciFirma != null && aliciFirma.isNotEmpty) {
        query = query.ilike('AliciFirma', '%$aliciFirma%');
      }
      if (rezervasyonSorumlusu != null && rezervasyonSorumlusu.isNotEmpty) {
        query = query.ilike('RezervasyonSorumlusu', '%$rezervasyonSorumlusu%');
      }
      if (satisSorumlusu != null && satisSorumlusu.isNotEmpty) {
        query = query.ilike('SatisSorumlusu', '%$satisSorumlusu%');
      }
      if (durum != null && durum.isNotEmpty && durum != 'Hepsi') {
        query = query.eq('Durum', durum);
      }
      if (startDate != null) {
        query = query.gte('IslemTarihi', startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.lt('IslemTarihi', endDate.toIso8601String());
      }
      if (epcReservationNos != null && epcReservationNos.isNotEmpty) {
        query = query.in_('RezervasyonNo', epcReservationNos);
      }

      final response = await query.order('IslemTarihi', ascending: false);

      return (response as List)
          .map((json) => ReservationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Rezervasyonlar yüklenirken hata oluştu: $e');
    }
  }

  /// Rezervasyona ait ürünleri getir
  Future<List<StockModel>> getReservationProducts(String rezervasyonNo) async {
    try {
      final response = await _supabase
          .from(_stockTable)
          .select()
          .eq('RezervasyonNo', rezervasyonNo);

      return (response as List)
          .map((json) => StockModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Rezervasyon ürünleri yüklenirken hata oluştu: $e');
    }
  }

  /// Rezervasyonu onayla
  Future<void> approveReservation(String rezervasyonNo, String satisSorumlusu) async {
    try {
      // Rezervasyon durumunu güncelle
      await _supabase.from(_reservationTable).update({
        'Durum': 'Onaylandı',
        'SatisSorumlusu': satisSorumlusu,
      }).eq('RezervasyonNo', rezervasyonNo);

      // İlgili ürünlerin durumunu güncelle
      await _supabase.from(_stockTable).update({
        'Durum': 'Onaylandı',
      }).eq('RezervasyonNo', rezervasyonNo);
    } catch (e) {
      throw Exception('Rezervasyon onaylanırken hata oluştu: $e');
    }
  }

  /// Onayı geri al
  Future<void> revokeApproval(String rezervasyonNo) async {
    try {
      await _supabase.from(_reservationTable).update({
        'Durum': 'Onay Bekliyor',
      }).eq('RezervasyonNo', rezervasyonNo);

      await _supabase.from(_stockTable).update({
        'Durum': 'Onay Bekliyor',
      }).eq('RezervasyonNo', rezervasyonNo);
    } catch (e) {
      throw Exception('Onay geri alınırken hata oluştu: $e');
    }
  }

  /// Rezervasyonu iptal et ve arşivle
  Future<void> cancelReservation({
    required ReservationModel reservation,
    required List<StockModel> products,
    required String iptalSebebi,
    required String iptalEdenPersonel,
  }) async {
    try {
      // 1. RezIptal tablosuna arşivle
      final iptalModel = RezIptalModel(
        rezervasyonNo: reservation.rezervasyonNo,
        rezervasyonKodu: reservation.rezervasyonKodu,
        aliciFirma: reservation.aliciFirma,
        rezervasyonSorumlusu: reservation.rezervasyonSorumlusu,
        satisSorumlusu: reservation.satisSorumlusu,
        islemTarihi: reservation.islemTarihi,
        durum: reservation.durum,
        urunCikisTarihi: reservation.urunCikisTarihi?.toIso8601String(),
        sevkiyatAdresi: reservation.sevkiyatAdresi,
        kaydedenPersonel: reservation.kaydedenPersonel,
        iptalSebebi: iptalSebebi,
        iptalTarihi: DateTime.now(),
        iptalEdenPersonel: iptalEdenPersonel,
      );

      await _supabase.from(_cancelTable).insert(iptalModel.toInsertJson());

      // 2. RezIptalDetay tablosuna ürün detaylarını arşivle
      for (final product in products) {
        final detayModel = RezIptalDetayModel(
          rezervasyonNo: reservation.rezervasyonNo,
          epc: product.epc,
          barkodNo: product.barkodNo,
          bandilNo: product.bandilNo,
          plakaNo: product.plakaNo,
          urunTipi: product.urunTipi,
          urunTuru: product.urunTuru,
          yuzeyIslemi: product.yuzeyIslemi,
          seleksiyon: product.seleksiyon,
          kalinlik: product.kalinlik,
          stokEn: product.stokEn,
          stokBoy: product.stokBoy,
          stokAlan: product.stokAlan,
          stokTonaj: product.stokTonaj,
          satisEn: product.satisEn,
          satisBoy: product.satisBoy,
          satisAlan: product.satisAlan,
          satisTonaj: product.satisTonaj,
          durum: product.durum,
          iptalTarihi: DateTime.now(),
        );

        await _supabase.from(_cancelDetailTable).insert(detayModel.toInsertJson());
      }

      // 3. Ürünleri stoğa geri al
      for (final product in products) {
        await _supabase.from(_stockTable).update({
          'Durum': 'Stokta',
          'RezervasyonNo': null,
          'AliciFirma': null,
          'SatisEn': 0,
          'SatisBoy': 0,
          'SatisAlan': 0,
          'SatisTonaj': 0,
        }).eq('EPC', product.epc);
      }

      // 4. Rezervasyonu sil
      await _supabase
          .from(_reservationTable)
          .delete()
          .eq('RezervasyonNo', reservation.rezervasyonNo);
    } catch (e) {
      throw Exception('Rezervasyon iptal edilirken hata oluştu: $e');
    }
  }

  /// Rezervasyona ürün ekle
  Future<void> addProductToReservation({
    required String epc,
    required String rezervasyonNo,
    required String aliciFirma,
  }) async {
    try {
      await _supabase.from(_stockTable).update({
        'RezervasyonNo': rezervasyonNo,
        'Durum': 'Onay Bekliyor',
        'AliciFirma': aliciFirma,
      }).eq('EPC', epc);
    } catch (e) {
      throw Exception('Ürün eklenirken hata oluştu: $e');
    }
  }

  /// Rezervasyondan ürün çıkar
  Future<void> removeProductFromReservation(String epc) async {
    try {
      await _supabase.from(_stockTable).update({
        'Durum': 'Stokta',
        'RezervasyonNo': null,
        'AliciFirma': null,
      }).eq('EPC', epc);
    } catch (e) {
      throw Exception('Ürün çıkarılırken hata oluştu: $e');
    }
  }

  /// Ürün boyutlarını güncelle
  Future<void> updateProductDimensions({
    required String epc,
    required double satisEn,
    required double satisBoy,
    required double satisAlan,
    required double satisTonaj,
  }) async {
    try {
      await _supabase.from(_stockTable).update({
        'SatisEn': satisEn,
        'SatisBoy': satisBoy,
        'SatisAlan': satisAlan,
        'SatisTonaj': satisTonaj,
      }).eq('EPC', epc);
    } catch (e) {
      throw Exception('Boyutlar güncellenirken hata oluştu: $e');
    }
  }

  /// Rezervasyonu sil (ürün olmadan)
  Future<void> deleteReservation(String rezervasyonNo) async {
    try {
      await _supabase
          .from(_reservationTable)
          .delete()
          .eq('RezervasyonNo', rezervasyonNo);
    } catch (e) {
      throw Exception('Rezervasyon silinirken hata oluştu: $e');
    }
  }

  /// Stokta olan ürünleri getir (ürün ekleme için)
  Future<List<StockModel>> getAvailableProducts({String? searchTerm}) async {
    try {
      var query = _supabase.from(_stockTable).select().eq('Durum', 'Stokta');

      if (searchTerm != null && searchTerm.isNotEmpty) {
        query = query.or('EPC.ilike.%$searchTerm%,BarkodNo.ilike.%$searchTerm%');
      }

      final response = await query.limit(100);

      return (response as List)
          .map((json) => StockModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Stok ürünleri yüklenirken hata oluştu: $e');
    }
  }

  /// Firma ara (autocomplete için)
  Future<List<CompanyModel>> searchCompanies(String term) async {
    try {
      final response = await _supabase
          .from(_companyTable)
          .select()
          .ilike('FirmaAdi', '%$term%')
          .limit(20);

      return (response as List)
          .map((json) => CompanyModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Firma araması sırasında hata oluştu: $e');
    }
  }

  /// Rezervasyon kontrolleri
  Future<bool> hasShippedProducts(String rezervasyonNo) async {
    try {
      final response = await _supabase
          .from(_stockTable)
          .select('EPC')
          .eq('RezervasyonNo', rezervasyonNo)
          .eq('Durum', 'Sevkiyat Tamamlandı')
          .limit(1);

      return (response as List).isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
