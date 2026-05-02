import '../../domain/entities/transaction.dart';

/// Data model for deserialising transaction rows from Supabase.
class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.walletId,
    required super.amount,
    required super.type,
    required super.description,
    required super.createdAt,
    super.recipientName,
    super.note,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final typeStr = (json['type'] as String?)?.toLowerCase() ?? 'debit';
    return TransactionModel(
      id: json['id'] as String,
      walletId: json['wallet_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      type:
          typeStr == 'credit' ? TransactionType.credit : TransactionType.debit,
      description: (json['description'] as String?) ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      recipientName: json['recipient_name'] as String?,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'wallet_id': walletId,
    'amount': amount,
    'type': type.name,
    'description': description,
    'created_at': createdAt.toIso8601String(),
    'recipient_name': recipientName,
    'note': note,
  };
}
