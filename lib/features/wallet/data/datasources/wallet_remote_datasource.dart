import 'dart:developer';

import 'package:pocket_pay_demo/core/error/exceptions.dart';
import 'package:pocket_pay_demo/core/services/supabase_auth_service.dart';
import 'package:pocket_pay_demo/features/wallet/data/models/transfer_response_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show FunctionException;

import '../models/wallet_model.dart';

/// Remote data source for wallet operations via Supabase.
class WalletRemoteDatasource {
  WalletRemoteDatasource({SupabaseService? client})
    : _client = client ?? SupabaseService();

  final SupabaseService _client;

  /// Fetches the wallet balance for the currently authenticated user via edge function.
  Future<WalletModel> getWalletBalance() async {
    try {
      final userId = _client.currentUser?.id;
      if (userId == null) {
        throw UnauthorizedException('User not authenticated.');
      }

      final response = await _client.invokeFn(
        'get-wallet-balance',
        body: {'user_id': userId},
      );

      log('getWalletBalance response: ${response.data}');
      return WalletModel.fromJson(response.data);
    } on FunctionException catch (e) {
      throw mapFunctionExceptionToCustom(e);
    } catch (e) {
      log('getWalletBalance error: $e');
      throw ServerException('Something went wrong');
    }
  }

  /// Sends money to a recipient via a Supabase RPC function.
  Future<TransferResponseModel> sendMoney({
    required String recipientPhone,
    required double amount,
    required String senderUserId, // ✅ fixed type
    String? note,
  }) async {
    try {
      log(
        'sendMoney payload: ${{'recipient_phone_number': recipientPhone, 'amount': amount, 'sender_user_id': senderUserId, if (note != null && note.isNotEmpty) 'note': note}}',
      );
      if (_client.currentUser == null) {
        throw UnauthorizedException('User not authenticated.');
      }

      final response = await _client.invokeFn(
        'transfer-money',

        body: {
          'recipient_phone_number': recipientPhone,
          'amount': amount,
          'sender_user_id': senderUserId,
          if (note != null && note.isNotEmpty) 'note': note,
        },
      );
      log("response ${response.data}");

      final data = response.data;

      log("data $data");
      return TransferResponseModel.fromJson(data);
    } on FunctionException catch (e) {
      throw mapFunctionExceptionToCustom(e);
    } catch (e) {
      log('sendMoney error: $e');
      throw ServerException("Something went wrong");
    } // ✅ No return → success = no exception
  }

  /// Adds money to the wallet via the add-money-to-wallet edge function.
  Future<void> addMoney({required double amount}) async {
    try {
      if (_client.currentUser == null) {
        throw UnauthorizedException('User not authenticated.');
      }

      await _client.invokeFn('add-money-to-wallet', body: {'amount': amount});
    } on FunctionException catch (e) {
      throw mapFunctionExceptionToCustom(e);
    } catch (e) {
      throw ServerException('Something went wrong');
    }
  }
}
