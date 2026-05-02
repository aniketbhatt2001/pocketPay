import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/transaction_model.dart';

/// Remote data source for transaction operations via Supabase.
class TransactionRemoteDatasource {
  TransactionRemoteDatasource({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  /// Fetches the most recent [limit] transactions for the current user's wallet.
  Future<List<TransactionModel>> getRecentTransactions({int limit = 3}) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated.');

    // First get the wallet id for this user
    final wallet =
        await _client
            .from('wallets')
            .select('id')
            .eq('user_id', userId)
            .single();

    final walletId = wallet['id'] as String;

    final data = await _client
        .from('transactions')
        .select(
          'id, wallet_id, amount, type, description, created_at, recipient_name, note',
        )
        .eq('wallet_id', walletId)
        .order('created_at', ascending: false)
        .limit(limit);

    return (data as List)
        .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetches all transactions for the current user's wallet.
  Future<List<TransactionModel>> getAllTransactions() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated.');

    final wallet =
        await _client
            .from('wallets')
            .select('id')
            .eq('user_id', userId)
            .single();

    final walletId = wallet['id'] as String;

    final data = await _client
        .from('transactions')
        .select(
          'id, wallet_id, amount, type, description, created_at, recipient_name, note',
        )
        .eq('wallet_id', walletId)
        .order('created_at', ascending: false);

    return (data as List)
        .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
