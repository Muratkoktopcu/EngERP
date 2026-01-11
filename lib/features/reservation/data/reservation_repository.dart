// lib/features/reservation/data/reservation_repository.dart

import 'package:eng_erp/core/services/supabase_client.dart';
import 'package:eng_erp/features/reservation/data/reservation_model.dart';
import 'package:eng_erp/features/reservation/data/company_model.dart';

/// 📊 Reservation Repository - Supabase ile iletişim
class ReservationRepository {
  final _supabase = SupabaseClientManager().db;
  static const String _reservationTable = 'UrunRezervasyon';
  static const String _stockTable = 'UrunStok';
  static const String _companyTable = 'AliciFirmalar';

  /// Tüm alıcı firmaları getir
  Future<List<CompanyModel>> getAllCompanies() async {
    try {
      final response = await _supabase
          .from(_companyTable)
          .select()
          .order('FirmaAdi', ascending: true);

      return (response as List)
          .map((json) => CompanyModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Firma listesi yüklenirken hata oluştu: $e');
    }
  }

  /// Rezervasyon numarası benzersizlik kontrolü
  Future<bool> checkReservationNoExists(String reservationNo) async {
    try {
      final response = await _supabase
          .from(_reservationTable)
          .select('ID')
          .eq('RezervasyonNo', reservationNo)
          .maybeSingle();

      return response != null;
    } catch (e) {
      throw Exception('Rezervasyon kontrolü sırasında hata: $e');
    }
  }

  /// EPC'nin başka bir rezervasyona atanıp atanmadığını kontrol et
  Future<bool> checkEpcHasReservation(String epc) async {
    try {
      final response = await _supabase
          .from(_stockTable)
          .select('RezervasyonNo')
          .eq('EPC', epc)
          .maybeSingle();

      if (response == null) return false;
      
      final rezervasyonNo = response['RezervasyonNo'] as String?;
      return rezervasyonNo != null && rezervasyonNo.isNotEmpty;
    } catch (e) {
      throw Exception('EPC kontrolü sırasında hata: $e');
    }
  }

  /// Yeni rezervasyon kaydı oluştur
  Future<ReservationModel> createReservation(ReservationModel reservation) async {
    try {
      final response = await _supabase
          .from(_reservationTable)
          .insert(reservation.toInsertJson())
          .select()
          .single();

      return ReservationModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Rezervasyon oluşturulurken hata: $e');
    }
  }

  /// Stok kaydını rezervasyon için güncelle
  Future<void> updateStockForReservation(String epc, Map<String, dynamic> data) async {
    try {
      await _supabase
          .from(_stockTable)
          .update(data)
          .eq('EPC', epc);
    } catch (e) {
      throw Exception('Stok güncellenirken hata: $e');
    }
  }

  /// Birden fazla stok kaydını güncelle (batch update)
  Future<void> updateMultipleStocksForReservation(
    List<String> epcList,
    String rezervasyonNo,
    String aliciFirma,
    String durum,
  ) async {
    try {
      for (final epc in epcList) {
        await _supabase
            .from(_stockTable)
            .update({
              'RezervasyonNo': rezervasyonNo,
              'AliciFirma': aliciFirma,
              'Durum': durum,
            })
            .eq('EPC', epc);
      }
    } catch (e) {
      throw Exception('Stoklar güncellenirken hata: $e');
    }
  }

  /// Rezervasyon numarasına göre rezervasyon getir
  Future<ReservationModel?> getReservationByNo(String rezervasyonNo) async {
    try {
      final response = await _supabase
          .from(_reservationTable)
          .select()
          .eq('RezervasyonNo', rezervasyonNo)
          .maybeSingle();

      if (response == null) return null;
      return ReservationModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Rezervasyon bilgisi alınırken hata: $e');
    }
  }

  /// Tüm rezervasyonları getir
  Future<List<ReservationModel>> getAllReservations() async {
    try {
      final response = await _supabase
          .from(_reservationTable)
          .select()
          .order('IslemTarihi', ascending: false);

      return (response as List)
          .map((json) => ReservationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Rezervasyonlar yüklenirken hata: $e');
    }
  }
}
