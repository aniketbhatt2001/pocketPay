enum TransactionType {
  deposit,
  send,
  receive;

  static TransactionType fromString(String value) {
    return TransactionType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ArgumentError('Unknown transaction type: $value'),
    );
  }

  String get value => name; // 'deposit', 'send', 'receive'
}

enum TransactionStatus {
  pending,
  completed,
  failed;

  static TransactionStatus fromString(String value) {
    return TransactionStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ArgumentError('Unknown transaction status: $value'),
    );
  }

  String get value => name; // 'pending', 'completed', 'failed'
}

class Transaction {
  final String id;
  final String walletId;
  final String userId;
  final TransactionType type;
  final double amount;
  final String? description;
  final TransactionStatus status;
  final String? referenceId;
  final double? balanceBefore;
  final double? balanceAfter;
  // Nullable to match Supabase schema (timestamptz NULL DEFAULT now())
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Transaction({
    required this.id,
    required this.walletId,
    required this.userId,
    required this.type,
    required this.amount,
    this.description,
    required this.status,
    this.referenceId,
    this.balanceBefore,
    this.balanceAfter,
    this.createdAt,
    this.updatedAt,
  });

  // Convenience getters
  bool get isPending => status == TransactionStatus.pending;
  bool get isCompleted => status == TransactionStatus.completed;
  bool get isFailed => status == TransactionStatus.failed;
  bool get isDeposit => type == TransactionType.deposit;
  bool get isSend => type == TransactionType.send;
  bool get isReceive => type == TransactionType.receive;

  /// True for any inbound money movement (deposit or receive).
  bool get isIncoming =>
      type == TransactionType.deposit || type == TransactionType.receive;
}
