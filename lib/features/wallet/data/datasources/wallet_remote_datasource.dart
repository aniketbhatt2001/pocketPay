import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/wallet_model.dart';

/// Remote data source for wallet operations via Supabase.
class WalletRemoteDatasource {
  WalletRemoteDatasource({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  /// Fetches the wallet row for the currently authenticated user.
  Future<WalletModel> getWalletBalance() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated.');

    final data =
        await _client
            .from('wallets')
            .select('id, user_id, balance, currency, updated_at')
            .eq('user_id', userId)
            .single();
    print(data);
    return WalletModel.fromJson(data);
  }

  /// Sends money to a recipient via a Supabase RPC function.
  Future<void> sendMoney({
    required String recipientPhone,
    required double amount,
    String? note,
  }) async {
    final response = await _client.functions.invoke(
      'send-money',
      body: {
        'recipient_phone': recipientPhone,
        'amount': amount,
        if (note != null) 'note': note,
      },
    );

    if (response.status != 200) {
      final message =
          (response.data as Map<String, dynamic>?)?['error'] as String? ??
          'Failed to send money.';
      throw Exception(message);
    }
  }

  /// Adds money to the wallet via a Supabase RPC function.
  Future<void> addMoney({required double amount}) async {
    final response = await _client.functions.invoke(
      'add-money',
      body: {'amount': amount},
    );

    if (response.status != 200) {
      final message =
          (response.data as Map<String, dynamic>?)?['error'] as String? ??
          'Failed to add money.';
      throw Exception(message);
    }
  }
}
