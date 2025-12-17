// lib/features/stock/data/stock_repository.dart

import 'package:eng_erp/core/services/supabase_client.dart';
import 'package:eng_erp/features/stock/data/stock_model.dart';

/// 📊 Stock Repository - Supabase UrunStok tablosu ile iletişim
class StockRepository {
  final _supabase = SupabaseClientManager().db;
  static const String _tableName = 'UrunStok';

  /// Tüm stok verilerini getir
  Future<List<StockModel>> getAllStock() async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .order('ID', ascending: true);

      return (response as List)
          .map((json) => StockModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Stok verileri yüklenirken hata oluştu: $e');
    }
  }

  /// Filtrelere göre stok verilerini getir
  Future<List<StockModel>> getFilteredStock({
    String? epc,
    String? barkod,
    String? bandilNo,
    String? plakaNo,
    String? urunTipi,
    String? urunTuru,
    String? yuzeyIslemi,
    String? durum,
    DateTime? uretimTarihiBaslangic,
    DateTime? uretimTarihiBitis,
  }) async {
    try {
      var query = _supabase.from(_tableName).select();

      // Filtreler ekleniyor - Baştan eşleşme (prefix match)
      if (epc != null && epc.isNotEmpty) {
        query = query.ilike('EPC', '$epc%');
      }

      if (barkod != null && barkod.isNotEmpty) {
        query = query.ilike('BarkodNo', '$barkod%');
      }

      if (bandilNo != null && bandilNo.isNotEmpty) {
        query = query.ilike('BandilNo', '$bandilNo%');
      }

      if (plakaNo != null && plakaNo.isNotEmpty) {
        query = query.ilike('PlakaNo', '$plakaNo%');
      }

      if (urunTipi != null && urunTipi != 'Seçiniz' && urunTipi != 'Hepsi') {
        query = query.ilike('UrunTipi', urunTipi);
      }

      if (urunTuru != null && urunTuru != 'Seçiniz' && urunTuru != 'Hepsi') {
        query = query.ilike('UrunTuru', urunTuru);
      }

      if (yuzeyIslemi != null && yuzeyIslemi != 'Seçiniz' && yuzeyIslemi != 'Hepsi') {
        query = query.ilike('YuzeyIslemi', yuzeyIslemi);
      }

      if (durum != null && durum != 'Hepsi') {
        query = query.ilike('Durum', durum);
      }

      // Tarih aralığı filtresi
      if (uretimTarihiBaslangic != null) {
        query = query.gte('UretimTarihi', uretimTarihiBaslangic.toIso8601String());
      }

      if (uretimTarihiBitis != null) {
        query = query.lte('UretimTarihi', uretimTarihiBitis.toIso8601String());
      }

      final response = await query.order('ID', ascending: true);

      return (response as List)
          .map((json) => StockModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Filtreleme sırasında hata oluştu: $e');
    }
  }

  /// ID'ye göre tek bir ürün getir
  Future<StockModel?> getStockById(int id) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('ID', id)
          .single();

      return StockModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Ürün bulunamadı: $e');
    }
  }

  /// EPC'ye göre tek bir ürün getir
  Future<StockModel?> getStockByEPC(String epc) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('EPC', epc)
          .single();

      return StockModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('EPC ile ürün bulunamadı: $e');
    }
  }

  /// Barkod No'ya göre tek bir ürün getir
  Future<StockModel?> getStockByBarkod(String barkodNo) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('BarkodNo', barkodNo)
          .single();

      return StockModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Barkod ile ürün bulunamadı: $e');
    }
  }

  /// Ürün bilgilerini güncelle
  Future<StockModel> updateStock(int id, Map<String, dynamic> data) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .update(data)
          .eq('ID', id)
          .select()
          .single();

      return StockModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Ürün güncellenirken hata oluştu: $e');
    }
  }
}
