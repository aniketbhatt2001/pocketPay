import '../../domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.walletId,
    required super.userId,
    required super.type,
    required super.amount,
    super.description,
    required super.status,
    super.referenceId,
    super.balanceBefore,
    super.balanceAfter,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Creates a [TransactionModel] from a JSON map (e.g., from Supabase).
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      walletId: json['wallet_id'] as String,
      userId: json['user_id'] as String,
      type: TransactionType.fromString(json['type'] as String),
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String?,
      status: TransactionStatus.fromString(
        json['status'] as String? ?? 'pending',
      ),
      referenceId: json['reference_id'] as String?,
      balanceBefore:
          json['balance_before'] != null
              ? (json['balance_before'] as num).toDouble()
              : null,
      balanceAfter:
          json['balance_after'] != null
              ? (json['balance_after'] as num).toDouble()
              : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Converts this model to a JSON map for persistence.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wallet_id': walletId,
      'user_id': userId,
      'type': type.value,
      'amount': amount,
      'description': description,
      'status': status.value,
      'reference_id': referenceId,
      'balance_before': balanceBefore,
      'balance_after': balanceAfter,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Creates a [TransactionModel] from a domain [Transaction] entity.
  factory TransactionModel.fromEntity(Transaction entity) {
    return TransactionModel(
      id: entity.id,
      walletId: entity.walletId,
      userId: entity.userId,
      type: entity.type,
      amount: entity.amount,
      description: entity.description,
      status: entity.status,
      referenceId: entity.referenceId,
      balanceBefore: entity.balanceBefore,
      balanceAfter: entity.balanceAfter,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Converts to domain entity.
  Transaction toEntity() {
    return Transaction(
      id: id,
      walletId: walletId,
      userId: userId,
      type: type,
      amount: amount,
      description: description,
      status: status,
      referenceId: referenceId,
      balanceBefore: balanceBefore,
      balanceAfter: balanceAfter,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
