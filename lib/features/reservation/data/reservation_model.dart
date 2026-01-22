// lib/features/reservation/data/reservation_model.dart

/// 📋 Rezervasyon Modeli - Supabase UrunRezervasyon tablosunu temsil eder
class ReservationModel {
  final int? id;
  final String rezervasyonNo;
  final DateTime? islemTarihi;
  final String rezervasyonKodu;
  final String aliciFirma;
  final String? satisSorumlusu;
  final String rezervasyonSorumlusu;
  final String durum;
  final String? kaydedenPersonel;
  final DateTime? urunCikisTarihi;
  final String? sevkiyatAdresi;

  ReservationModel({
    this.id,
    required this.rezervasyonNo,
    this.islemTarihi,
    required this.rezervasyonKodu,
    required this.aliciFirma,
    this.satisSorumlusu,
    required this.rezervasyonSorumlusu,
    required this.durum,
    this.kaydedenPersonel,
    this.urunCikisTarihi,
    this.sevkiyatAdresi,
  });

  /// Supabase JSON → ReservationModel
  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['ID'] as int?,
      rezervasyonNo: json['RezervasyonNo'] as String,
      islemTarihi: json['IslemTarihi'] != null
          ? DateTime.parse(json['IslemTarihi'] as String)
          : null,
      rezervasyonKodu: json['RezervasyonKodu'] as String,
      aliciFirma: json['AliciFirma'] as String,
      satisSorumlusu: json['SatisSorumlusu'] as String?,
      rezervasyonSorumlusu: json['RezervasyonSorumlusu'] as String,
      durum: json['Durum'] as String,
      kaydedenPersonel: json['KaydedenPersonel'] as String?,
      urunCikisTarihi: json['UrunCikisTarihi'] != null
          ? DateTime.parse(json['UrunCikisTarihi'] as String)
          : null,
      sevkiyatAdresi: json['SevkiyatAdresi'] as String?,
    );
  }

  /// ReservationModel → JSON (Insert için)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'ID': id,
      'RezervasyonNo': rezervasyonNo,
      'IslemTarihi': islemTarihi?.toIso8601String(),
      'RezervasyonKodu': rezervasyonKodu,
      'AliciFirma': aliciFirma,
      'SatisSorumlusu': satisSorumlusu,
      'RezervasyonSorumlusu': rezervasyonSorumlusu,
      'Durum': durum,
      'KaydedenPersonel': kaydedenPersonel,
      'UrunCikisTarihi': urunCikisTarihi?.toIso8601String(),
      'SevkiyatAdresi': sevkiyatAdresi,
    };
  }

  /// Insert için ID'siz JSON
  Map<String, dynamic> toInsertJson() {
    return {
      'RezervasyonNo': rezervasyonNo,
      'IslemTarihi': islemTarihi?.toIso8601String(),
      'RezervasyonKodu': rezervasyonKodu,
      'AliciFirma': aliciFirma,
      'SatisSorumlusu': satisSorumlusu,
      'RezervasyonSorumlusu': rezervasyonSorumlusu,
      'Durum': durum,
      'KaydedenPersonel': kaydedenPersonel,
      'UrunCikisTarihi': urunCikisTarihi?.toIso8601String(),
      'SevkiyatAdresi': sevkiyatAdresi,
    };
  }
}
