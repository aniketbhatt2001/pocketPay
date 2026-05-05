/// Domain entity representing a user's wallet.
class Wallet {
  const Wallet({
    this.id = '',
    this.userId = '',
    this.balance = 0,
    this.currency = '',
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
