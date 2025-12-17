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
}
