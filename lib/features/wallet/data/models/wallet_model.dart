import '../../domain/entities/wallet.dart';

/// Data model for deserialising wallet rows from Supabase.
class WalletModel extends Wallet {
  const WalletModel({
    required super.id,
    required super.userId,
    required super.balance,
    required super.currency,
    super.updatedAt,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      balance: (json['balance'] as num).toDouble(),
      currency: (json['currency'] as String?) ?? 'USD',
      updatedAt:
          json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'balance': balance,
    'currency': currency,
    'updated_at': updatedAt?.toIso8601String(),
  };
}
