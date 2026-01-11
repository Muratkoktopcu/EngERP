// lib/features/cancel/data/cancel_repository.dart

import 'package:eng_erp/core/services/supabase_client.dart';
import 'package:eng_erp/features/sales_management/data/cancel_archive_model.dart';
import 'package:eng_erp/features/reservation/data/company_model.dart';

/// 📊 Cancel Repository - Supabase ile iletişim
class CancelRepository {
  final _supabase = SupabaseClientManager().db;
  static const String _cancelTable = 'RezIptal';
  static const String _cancelDetailTable = 'RezIptalDetay';
  static const String _companyTable = 'AliciFirmalar';

  /// Filtreleme ile iptal kayıtlarını getir
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
    try {
      // EPC filtresi varsa önce ilgili rezervasyon numaralarını bul
      List<String>? epcReservationNos;
      if (epc != null && epc.isNotEmpty) {
        final epcResponse = await _supabase
            .from(_cancelDetailTable)
            .select('RezervasyonNo')
            .ilike('EPC', '%$epc%');

        epcReservationNos = (epcResponse as List)
            .map((e) => e['RezervasyonNo'] as String?)
            .where((e) => e != null && e.isNotEmpty)
            .cast<String>()
            .toSet()
            .toList();

        if (epcReservationNos.isEmpty) {
          return [];
        }
      }

      var query = _supabase.from(_cancelTable).select();

      // Filtreler
      if (rezervasyonNo != null && rezervasyonNo.isNotEmpty) {
        query = query.ilike('RezervasyonNo', '$rezervasyonNo%');
      }
      if (rezervasyonKodu != null && rezervasyonKodu.isNotEmpty) {
        query = query.ilike('RezervasyonKodu', '$rezervasyonKodu%');
      }
      if (aliciFirma != null && aliciFirma.isNotEmpty) {
        query = query.ilike('AliciFirma', '$aliciFirma%');
      }
      if (satisSorumlusu != null && satisSorumlusu.isNotEmpty) {
        query = query.ilike('SatisSorumlusu', '$satisSorumlusu%');
      }

      // Tarih periyoduna göre tarih aralığı hesapla
      if (tarihPeriyodu != null && rezervasyonTarihi != null) {
        final dateRange = _calculateDateRange(rezervasyonTarihi, tarihPeriyodu);
        query = query.gte('IslemTarihi', dateRange['start']!.toIso8601String());
        query = query.lt('IslemTarihi', dateRange['end']!.toIso8601String());
      } else if (rezervasyonTarihi != null) {
        final startOfDay = DateTime(rezervasyonTarihi.year, rezervasyonTarihi.month, rezervasyonTarihi.day);
        final endOfDay = startOfDay.add(const Duration(days: 1));
        query = query.gte('IslemTarihi', startOfDay.toIso8601String());
        query = query.lt('IslemTarihi', endOfDay.toIso8601String());
      }

      if (iptalTarihi != null) {
        final startOfDay = DateTime(iptalTarihi.year, iptalTarihi.month, iptalTarihi.day);
        final endOfDay = startOfDay.add(const Duration(days: 1));
        query = query.gte('IptalTarihi', startOfDay.toIso8601String());
        query = query.lt('IptalTarihi', endOfDay.toIso8601String());
      }

      if (epcReservationNos != null && epcReservationNos.isNotEmpty) {
        query = query.in_('RezervasyonNo', epcReservationNos);
      }

      final response = await query.order('IptalTarihi', ascending: false);

      return (response as List)
          .map((json) => RezIptalModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('İptal kayıtları yüklenirken hata oluştu: $e');
    }
  }

  /// Seçilen iptal kaydının ürün detaylarını getir
  Future<List<RezIptalDetayModel>> getIptalDetails(String rezervasyonNo) async {
    try {
      final response = await _supabase
          .from(_cancelDetailTable)
          .select()
          .eq('RezervasyonNo', rezervasyonNo);

      return (response as List)
          .map((json) => RezIptalDetayModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('İptal detayları yüklenirken hata oluştu: $e');
    }
  }

  /// İptal kaydını sil
  Future<void> deleteIptalKaydi(String rezervasyonNo) async {
    try {
      // 1. Önce detayları sil
      await _supabase
          .from(_cancelDetailTable)
          .delete()
          .eq('RezervasyonNo', rezervasyonNo);

      // 2. Ana kaydı sil
      await _supabase
          .from(_cancelTable)
          .delete()
          .eq('RezervasyonNo', rezervasyonNo);
    } catch (e) {
      throw Exception('İptal kaydı silinirken hata oluştu: $e');
    }
  }

  /// Tüm firmaları getir (dropdown için)
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
      throw Exception('Firmalar yüklenirken hata oluştu: $e');
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

  /// Tarih periyoduna göre başlangıç ve bitiş tarihlerini hesapla
  Map<String, DateTime> _calculateDateRange(DateTime baseDate, String periyot) {
    DateTime start;
    DateTime end;

    switch (periyot) {
      case 'Günlük':
        start = DateTime(baseDate.year, baseDate.month, baseDate.day);
        end = start.add(const Duration(days: 1));
        break;
      case 'Haftalık':
        // Haftanın başlangıcı (Pazartesi)
        final weekday = baseDate.weekday;
        start = DateTime(baseDate.year, baseDate.month, baseDate.day - weekday + 1);
        end = start.add(const Duration(days: 7));
        break;
      case 'Aylık':
        start = DateTime(baseDate.year, baseDate.month, 1);
        end = DateTime(baseDate.year, baseDate.month + 1, 1);
        break;
      case 'Yıllık':
        start = DateTime(baseDate.year, 1, 1);
        end = DateTime(baseDate.year + 1, 1, 1);
        break;
      default:
        start = DateTime(baseDate.year, baseDate.month, baseDate.day);
        end = start.add(const Duration(days: 1));
    }

    return {'start': start, 'end': end};
  }
}
