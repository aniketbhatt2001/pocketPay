import 'dart:developer';

import 'package:pocket_pay_demo/core/error/failures.dart';
import 'package:pocket_pay_demo/core/result/result.dart';
import 'package:pocket_pay_demo/features/transactions/data/local_datasource/transaction_local_datasource.dart';
import 'package:pocket_pay_demo/features/transactions/data/remote_datasource.dart/transaction_datasource.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._remote, this._local, this._userId);

  final TransactionRemoteDataSource _remote;
  final TransactionLocalDatasource _local;

  /// The currently authenticated user's ID — used as the local DB key.
  final String _userId;

  /// Returns whatever is already in the local database — no network call.
  ///
  /// Returns an empty list (not a failure) when the cache is cold.
  @override
  Future<Result<List<Transaction>>> getCachedTransactions() async {
    try {
      final rows = await _local.getTransactions(_userId);
      return Result.success(rows.map((e) => e.toEntity()).toList());
    } catch (e) {
      log('TransactionRepository.getCachedTransactions error: $e');
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  /// Fetches fresh transactions from Supabase, upserts them into the local
  /// database, then returns the full merged local snapshot.
  ///
  /// - New records from the server are inserted.
  /// - Existing records (same PK) are updated in place.
  /// - Old records not returned by the server are **kept** — history is never
  ///   deleted from the local store.
  @override
  Future<Result<List<Transaction>>> syncTransactions() async {
    try {
      // 1. Hit the remote.
      final fresh = await _remote.getTransactions();

      // 2. Upsert into local DB — history accumulates, nothing is deleted.
      await _local.saveTransactions(fresh);

      // 3. Re-read the full local snapshot (old + newly synced records).
      final merged = await _local.getTransactions(_userId);
      return Result.success(merged.map((e) => e.toEntity()).toList());
    } catch (e) {
      log('TransactionRepository.syncTransactions error: $e');
      return Result.failure(ServerFailure(e.toString()));
    }
  }
}
