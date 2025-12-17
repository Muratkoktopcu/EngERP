// lib/features/stock/data/stock_service.dart

import 'package:eng_erp/features/stock/data/stock_model.dart';
import 'package:eng_erp/features/stock/data/stock_repository.dart';

/// 🔧 Stock Service - Business Logic Layer
class StockService {
  final StockRepository _repository;

  StockService({StockRepository? repository})
      : _repository = repository ?? StockRepository();

  /// Tüm stok verilerini getir
  Future<List<StockModel>> getAllStock() async {
    try {
      return await _repository.getAllStock();
    } catch (e) {
      rethrow;
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
      return await _repository.getFilteredStock(
        epc: epc?.trim(),
        barkod: barkod?.trim(),
        bandilNo: bandilNo?.trim(),
        plakaNo: plakaNo?.trim(),
        urunTipi: urunTipi,
        urunTuru: urunTuru,
        yuzeyIslemi: yuzeyIslemi,
        durum: durum,
        uretimTarihiBaslangic: uretimTarihiBaslangic,
        uretimTarihiBitis: uretimTarihiBitis,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// ID'ye göre ürün getir
  Future<StockModel?> getStockById(int id) async {
    if (id <= 0) {
      throw Exception('Geçersiz ID değeri');
    }
    
    try {
      return await _repository.getStockById(id);
    } catch (e) {
      rethrow;
    }
  }

  /// EPC'ye göre ürün getir
  Future<StockModel?> getStockByEPC(String epc) async {
    if (epc.trim().isEmpty) {
      throw Exception('EPC boş olamaz');
    }
    
    try {
      return await _repository.getStockByEPC(epc.trim());
    } catch (e) {
      rethrow;
    }
  }

  /// Barkod'a göre ürün getir
  Future<StockModel?> getStockByBarkod(String barkodNo) async {
    if (barkodNo.trim().isEmpty) {
      throw Exception('Barkod No boş olamaz');
    }
    
    try {
      return await _repository.getStockByBarkod(barkodNo.trim());
    } catch (e) {
      rethrow;
    }
  }

  /// Ürün bilgilerini güncelle
  Future<StockModel> updateStock({
    required int id,
    String? barkodNo,
    String? bandilNo,
    String? plakaNo,
    String? urunTipi,
    String? urunTuru,
    String? yuzeyIslemi,
    String? seleksiyon,
    DateTime? uretimTarihi,
    double? kalinlik,
    double? stokEn,
    double? stokBoy,
    double? stokTonaj,
    int? plakaAdedi,
    DateTime? urunCikisTarihi,
  }) async {
    if (id <= 0) {
      throw Exception('Geçersiz ID değeri');
    }

    try {
      // Sadece güncellenen alanları Map'e ekle
      final Map<String, dynamic> updateData = {};

      if (barkodNo != null && barkodNo.trim().isNotEmpty) {
        updateData['BarkodNo'] = barkodNo.trim();
      }
      if (bandilNo != null) {
        updateData['BandilNo'] = bandilNo.trim().isEmpty ? null : bandilNo.trim();
      }
      if (plakaNo != null) {
        updateData['PlakaNo'] = plakaNo.trim().isEmpty ? null : plakaNo.trim();
      }
      if (urunTipi != null) {
        updateData['UrunTipi'] = urunTipi;
      }
      if (urunTuru != null) {
        updateData['UrunTuru'] = urunTuru;
      }
      if (yuzeyIslemi != null) {
        updateData['YuzeyIslemi'] = yuzeyIslemi;
      }
      if (seleksiyon != null) {
        updateData['Seleksiyon'] = seleksiyon.trim().isEmpty ? null : seleksiyon.trim();
      }
      if (uretimTarihi != null) {
        updateData['UretimTarihi'] = uretimTarihi.toIso8601String();
      }
      if (kalinlik != null) {
        updateData['Kalinlik'] = kalinlik;
      }
      if (stokEn != null) {
        updateData['StokEn'] = stokEn;
      }
      if (stokBoy != null) {
        updateData['StokBoy'] = stokBoy;
      }
      if (stokTonaj != null) {
        updateData['StokTonaj'] = stokTonaj;
      }
      if (plakaAdedi != null) {
        updateData['PlakaAdedi'] = plakaAdedi;
      }
      if (urunCikisTarihi != null) {
        updateData['UrunCikisTarihi'] = urunCikisTarihi.toIso8601String();
      }

      if (updateData.isEmpty) {
        throw Exception('Güncellenecek alan bulunamadı');
      }

      return await _repository.updateStock(id, updateData);
    } catch (e) {
      rethrow;
    }
  }
}
