// lib/features/reservation/data/company_model.dart

/// 🏢 Firma Modeli - Supabase AliciFirmalar tablosunu temsil eder
class CompanyModel {
  final int id;
  final String firmaAdi;

  CompanyModel({
    required this.id,
    required this.firmaAdi,
  });

  /// Supabase JSON → CompanyModel
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['ID'] as int,
      firmaAdi: json['FirmaAdi'] as String,
    );
  }

  /// CompanyModel → JSON
  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'FirmaAdi': firmaAdi,
    };
  }

  @override
  String toString() => firmaAdi;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CompanyModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
