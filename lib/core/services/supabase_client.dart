// lib/core/services/supabase_client.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eng_erp/core/constant/app_constants.dart';

class SupabaseClientManager {
  static final SupabaseClientManager _instance = SupabaseClientManager._internal();
  factory SupabaseClientManager() => _instance;

  SupabaseClientManager._internal();

  late final SupabaseClient client;

  Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );

    client = Supabase.instance.client;
  }

  /// Quick access
  SupabaseClient get db => client;

  /// Auth short-hands
  GoTrueClient get auth => client.auth;

  /// For reading tables
  SupabaseQueryBuilder table(String name) => client.from(name);

  /// For calling RPC functions
  Function get rpc => client.rpc;
}
