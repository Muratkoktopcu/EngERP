// lib/features/stock/data/stock_model.dart

/// 📦 Stok Modeli - Supabase UrunStok tablosunu temsil eder
class StockModel {
  final int id;
  final String epc;
  final String barkodNo;
  final String? bandilNo;
  final String? plakaNo;
  final String? urunTipi;
  final String? urunTuru;
  final String? yuzeyIslemi;
  final String? seleksiyon;
  final DateTime? uretimTarihi;
  final double? kalinlik;
  final int? plakaAdedi;
  final double? stokEn;
  final double? stokBoy;
  final double? stokAlan;
  final double? stokTonaj;
  final double? satisEn;
  final double? satisBoy;
  final double? satisAlan;
  final double? satisTonaj;
  final String? durum;
  final String? rezervasyonNo;
  final String? kaydedenPersonel;
  final DateTime? urunCikisTarihi;
  final String? aliciFirma;

  StockModel({
    required this.id,
    required this.epc,
    required this.barkodNo,
    this.bandilNo,
    this.plakaNo,
    this.urunTipi,
    this.urunTuru,
    this.yuzeyIslemi,
    this.seleksiyon,
    this.uretimTarihi,
    this.kalinlik,
    this.plakaAdedi,
    this.stokEn,
    this.stokBoy,
    this.stokAlan,
    this.stokTonaj,
    this.satisEn,
    this.satisBoy,
    this.satisAlan,
    this.satisTonaj,
    this.durum,
    this.rezervasyonNo,
    this.kaydedenPersonel,
    this.urunCikisTarihi,
    this.aliciFirma,
  });

  /// Supabase JSON → StockModel
  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      id: json['ID'] as int,
      epc: json['EPC'] as String,
      barkodNo: json['BarkodNo'] as String,
      bandilNo: json['BandilNo'] as String?,
      plakaNo: json['PlakaNo'] as String?,
      urunTipi: json['UrunTipi'] as String?,
      urunTuru: json['UrunTuru'] as String?,
      yuzeyIslemi: json['YuzeyIslemi'] as String?,
      seleksiyon: json['Seleksiyon'] as String?,
      uretimTarihi: json['UretimTarihi'] != null
          ? DateTime.parse(json['UretimTarihi'] as String)
          : null,
      kalinlik: json['Kalinlik'] != null
          ? (json['Kalinlik'] as num).toDouble()
          : null,
      plakaAdedi: json['PlakaAdedi'] as int?,
      stokEn: json['StokEn'] != null
          ? (json['StokEn'] as num).toDouble()
          : null,
      stokBoy: json['StokBoy'] != null
          ? (json['StokBoy'] as num).toDouble()
          : null,
      stokAlan: json['StokAlan'] != null
          ? (json['StokAlan'] as num).toDouble()
          : null,
      stokTonaj: json['StokTonaj'] != null
          ? (json['StokTonaj'] as num).toDouble()
          : null,
      satisEn: json['SatisEn'] != null
          ? (json['SatisEn'] as num).toDouble()
          : null,
      satisBoy: json['SatisBoy'] != null
          ? (json['SatisBoy'] as num).toDouble()
          : null,
      satisAlan: json['SatisAlan'] != null
          ? (json['SatisAlan'] as num).toDouble()
          : null,
      satisTonaj: json['SatisTonaj'] != null
          ? (json['SatisTonaj'] as num).toDouble()
          : null,
      durum: json['Durum'] as String?,
      rezervasyonNo: json['RezervasyonNo'] as String?,
      kaydedenPersonel: json['KaydedenPersonel'] as String?,
      urunCikisTarihi: json['UrunCikisTarihi'] != null
          ? DateTime.parse(json['UrunCikisTarihi'] as String)
          : null,
      aliciFirma: json['AliciFirma'] as String?,
    );
  }

  /// StockModel → JSON (Update için)
  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'EPC': epc,
      'BarkodNo': barkodNo,
      'BandilNo': bandilNo,
      'PlakaNo': plakaNo,
      'UrunTipi': urunTipi,
      'UrunTuru': urunTuru,
      'YuzeyIslemi': yuzeyIslemi,
      'Seleksiyon': seleksiyon,
      'UretimTarihi': uretimTarihi?.toIso8601String(),
      'Kalinlik': kalinlik,
      'PlakaAdedi': plakaAdedi,
      'StokEn': stokEn,
      'StokBoy': stokBoy,
      'StokAlan': stokAlan,
      'StokTonaj': stokTonaj,
      'SatisEn': satisEn,
      'SatisBoy': satisBoy,
      'SatisAlan': satisAlan,
      'SatisTonaj': satisTonaj,
      'Durum': durum,
      'RezervasyonNo': rezervasyonNo,
      'KaydedenPersonel': kaydedenPersonel,
      'UrunCikisTarihi': urunCikisTarihi?.toIso8601String(),
      'AliciFirma': aliciFirma,
    };
  }
}
