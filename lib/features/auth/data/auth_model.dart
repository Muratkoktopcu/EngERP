// lib/features/auth/data/auth_model.dart

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthModel {
  final String userId;
  final String? email;
  final String accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;

  /// ERP sistemi için ek metadata alanları:
  final String? role;           // Örneğin: "admin", "manager", "worker"
  final int? departmentId;      // Veya backend hangi field’ı tutuyorsa
  final Map<String, dynamic>? metadata;

  AuthModel({
    required this.userId,
    this.email,
    required this.accessToken,
    this.refreshToken,
    this.expiresAt,
    this.role,
    this.departmentId,
    this.metadata,
  });

  /// Supabase User + Session → AuthModel
  factory AuthModel.fromSupabase(User user, Session session) {
    final metadata = user.userMetadata ?? {};

    // --- BU SATIRI EKLE (DEBUG İÇİN) ---
    print("🔍 GELEN METADATA: $metadata");
    // -----------------------------------

    return AuthModel(
      userId: user.id,
      email: user.email,
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      expiresAt: session.expiresAt != null
          ? DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000)
          : null,
      role: metadata["role"],
      departmentId: metadata["departmentId"],
      metadata: metadata,
    );
  }
}
