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

  /// Adds money to the wallet by incrementing the balance via RPC.
  Future<void> addMoney({required double amount}) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated.');
    if (amount <= 0) throw Exception('Amount must be greater than zero.');

    // Use a Postgres RPC to atomically increment the balance.
    // The function runs as SECURITY DEFINER so it bypasses RLS for the update.
    await _client.rpc(
      'increment_wallet_balance',
      params: {'p_user_id': userId, 'p_amount': amount},
    );
  }
}
