/// Domain entity representing a user's wallet.
class Wallet {
  const Wallet({
    required this.id,
    required this.userId,
    required this.balance,
    required this.currency,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final double balance;
  final String currency;
  final DateTime? updatedAt;

  @override
  String toString() =>
      'Wallet(id: $id, userId: $userId, balance: $balance, currency: $currency)';
}
