import 'dart:developer';

import 'package:pocket_pay_demo/core/error/exceptions.dart';
import 'package:pocket_pay_demo/features/wallet/data/models/transfer_response_model.dart';
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
  Future<TransferResponseModel> sendMoney({
    required String recipientPhone,
    required double amount,
    required String senderUserId, // ✅ fixed type
    String? note,
  }) async {
    try {
      if (recipientPhone.isEmpty) {
        throw InvalidResponseException('Recipient phone is required');
      }

      if (amount <= 0) {
        throw InvalidResponseException('Amount must be greater than zero');
      }
      print({
        'recipient_phone_number': recipientPhone,
        'amount': amount,
        'sender_user_id': senderUserId,
        if (note != null && note.isNotEmpty) 'note': note,
      });
      final response = await _client.functions.invoke(
        'transfer-money',
        body: {
          'recipient_phone_number': recipientPhone,
          'amount': amount,
          'sender_user_id': senderUserId,
          if (note != null && note.isNotEmpty) 'note': note,
        },
      );
      log("response ${response.data}");
      if (response.status != 200) {
        final message =
            (response.data as Map<String, dynamic>?)?['error'] as String? ??
            'Failed to send money';

        throw ServerException(message);
      }

      final data = response.data;

      if (data != null && data is! Map<String, dynamic>) {
        throw InvalidResponseException('Invalid response format');
      }
      log("data $data");
      return TransferResponseModel.fromJson(data);
    } on FunctionException catch (e) {
      throw ServerException(e.details["error"]);
    } catch (e) {
      print(e);
      throw ServerException("Something went wrong");
    } // ✅ No return → success = no exception
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
