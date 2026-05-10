import 'package:pocket_pay_demo/core/result/result.dart';

import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

/// Returns transactions from the local database immediately — no network call.
///
/// Use this to render the UI on first paint.
class GetCachedTransactions {
  const GetCachedTransactions(this._repository);

  final TransactionRepository _repository;

  Future<Result<List<Transaction>>> call() =>
      _repository.getCachedTransactions();
}

/// Fetches fresh transactions from Supabase, persists them locally, and
/// returns the merged local snapshot.
///
/// Call this after [GetCachedTransactions] to sync in the background.
class SyncTransactions {
  const SyncTransactions(this._repository);

  final TransactionRepository _repository;

  Future<Result<List<Transaction>>> call() => _repository.syncTransactions();
}

/// Convenience alias kept for any code that still references [GetAllTransactions].
/// Internally delegates to [SyncTransactions] (remote fetch + local save).
@Deprecated('Use GetCachedTransactions + SyncTransactions instead.')
class GetAllTransactions {
  const GetAllTransactions(this._repository);

  final TransactionRepository _repository;

  Future<Result<List<Transaction>>> call() => _repository.syncTransactions();
}
