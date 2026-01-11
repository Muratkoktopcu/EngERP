// lib/features/sales_management/data/cancel_archive_model.dart

/// 📋 İptal Edilen Rezervasyon Arşiv Modeli
class RezIptalModel {
  final int? id;
  final String rezervasyonNo;
  final String? rezervasyonKodu;
  final String? aliciFirma;
  final String? rezervasyonSorumlusu;
  final String? satisSorumlusu;
  final DateTime? islemTarihi;
  final String? durum;
  final String? urunCikisTarihi;
  final String? sevkiyatAdresi;
  final String? kaydedenPersonel;
  final String? iptalSebebi;
  final DateTime? iptalTarihi;
  final String? iptalEdenPersonel;

  RezIptalModel({
    this.id,
    required this.rezervasyonNo,
    this.rezervasyonKodu,
    this.aliciFirma,
    this.rezervasyonSorumlusu,
    this.satisSorumlusu,
    this.islemTarihi,
    this.durum,
    this.urunCikisTarihi,
    this.sevkiyatAdresi,
    this.kaydedenPersonel,
    this.iptalSebebi,
    this.iptalTarihi,
    this.iptalEdenPersonel,
  });

  factory RezIptalModel.fromJson(Map<String, dynamic> json) {
    return RezIptalModel(
      id: json['ID'] as int?,
      rezervasyonNo: json['RezervasyonNo'] as String,
      rezervasyonKodu: json['RezervasyonKodu'] as String?,
      aliciFirma: json['AliciFirma'] as String?,
      rezervasyonSorumlusu: json['RezervasyonSorumlusu'] as String?,
      satisSorumlusu: json['SatisSorumlusu'] as String?,
      islemTarihi: json['IslemTarihi'] != null
          ? DateTime.parse(json['IslemTarihi'] as String)
          : null,
      durum: json['Durum'] as String?,
      urunCikisTarihi: json['UrunCikisTarihi'] as String?,
      sevkiyatAdresi: json['SevkiyatAdresi'] as String?,
      kaydedenPersonel: json['KaydedenPersonel'] as String?,
      iptalSebebi: json['IptalSebebi'] as String?,
      iptalTarihi: json['IptalTarihi'] != null
          ? DateTime.parse(json['IptalTarihi'] as String)
          : null,
      iptalEdenPersonel: json['IptalEdenPersonel'] as String?,
    );
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'RezervasyonNo': rezervasyonNo,
      'RezervasyonKodu': rezervasyonKodu,
      'AliciFirma': aliciFirma,
      'RezervasyonSorumlusu': rezervasyonSorumlusu,
      'SatisSorumlusu': satisSorumlusu,
      'IslemTarihi': islemTarihi?.toIso8601String(),
      'Durum': durum,
      'UrunCikisTarihi': urunCikisTarihi,
      'SevkiyatAdresi': sevkiyatAdresi,
      'KaydedenPersonel': kaydedenPersonel,
      'IptalSebebi': iptalSebebi,
      'IptalTarihi': iptalTarihi?.toIso8601String(),
      'IptalEdenPersonel': iptalEdenPersonel,
    };
  }
}

/// 📋 İptal Edilen Ürün Detay Arşiv Modeli
class RezIptalDetayModel {
  final int? id;
  final String rezervasyonNo;
  final String epc;
  final String? barkodNo;
  final String? bandilNo;
  final String? plakaNo;
  final String? urunTipi;
  final String? urunTuru;
  final String? yuzeyIslemi;
  final String? seleksiyon;
  final double? kalinlik;
  final double? stokEn;
  final double? stokBoy;
  final double? stokAlan;
  final double? stokTonaj;
  final double? satisEn;
  final double? satisBoy;
  final double? satisAlan;
  final double? satisTonaj;
  final String? durum;
  final DateTime? iptalTarihi;

  RezIptalDetayModel({
    this.id,
    required this.rezervasyonNo,
    required this.epc,
    this.barkodNo,
    this.bandilNo,
    this.plakaNo,
    this.urunTipi,
    this.urunTuru,
    this.yuzeyIslemi,
    this.seleksiyon,
    this.kalinlik,
    this.stokEn,
    this.stokBoy,
    this.stokAlan,
    this.stokTonaj,
    this.satisEn,
    this.satisBoy,
    this.satisAlan,
    this.satisTonaj,
    this.durum,
    this.iptalTarihi,
  });

  factory RezIptalDetayModel.fromJson(Map<String, dynamic> json) {
    return RezIptalDetayModel(
      id: json['ID'] as int?,
      rezervasyonNo: json['RezervasyonNo'] as String,
      epc: json['EPC'] as String,
      barkodNo: json['BarkodNo'] as String?,
      bandilNo: json['BandilNo'] as String?,
      plakaNo: json['PlakaNo'] as String?,
      urunTipi: json['UrunTipi'] as String?,
      urunTuru: json['UrunTuru'] as String?,
      yuzeyIslemi: json['YuzeyIslemi'] as String?,
      seleksiyon: json['Seleksiyon'] as String?,
      kalinlik: json['Kalinlik'] != null
          ? (json['Kalinlik'] as num).toDouble()
          : null,
      stokEn:
          json['StokEn'] != null ? (json['StokEn'] as num).toDouble() : null,
      stokBoy:
          json['StokBoy'] != null ? (json['StokBoy'] as num).toDouble() : null,
      stokAlan: json['StokAlan'] != null
          ? (json['StokAlan'] as num).toDouble()
          : null,
      stokTonaj: json['StokTonaj'] != null
          ? (json['StokTonaj'] as num).toDouble()
          : null,
      satisEn:
          json['SatisEn'] != null ? (json['SatisEn'] as num).toDouble() : null,
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
      iptalTarihi: json['IptalTarihi'] != null
          ? DateTime.parse(json['IptalTarihi'] as String)
          : null,
    );
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'RezervasyonNo': rezervasyonNo,
      'EPC': epc,
      'BarkodNo': barkodNo,
      'BandilNo': bandilNo,
      'PlakaNo': plakaNo,
      'UrunTipi': urunTipi,
      'UrunTuru': urunTuru,
      'YuzeyIslemi': yuzeyIslemi,
      'Seleksiyon': seleksiyon,
      'Kalinlik': kalinlik,
      'StokEn': stokEn,
      'StokBoy': stokBoy,
      'StokAlan': stokAlan,
      'StokTonaj': stokTonaj,
      'SatisEn': satisEn,
      'SatisBoy': satisBoy,
      'SatisAlan': satisAlan,
      'SatisTonaj': satisTonaj,
      'Durum': durum,
      'IptalTarihi': iptalTarihi?.toIso8601String(),
    };
  }
}
