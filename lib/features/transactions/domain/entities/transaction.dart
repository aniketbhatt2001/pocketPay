/// Domain entity representing a single financial transaction.
class Transaction {
  const Transaction({
    required this.id,
    required this.walletId,
    required this.amount,
    required this.type,
    required this.description,
    required this.createdAt,
    this.recipientName,
    this.note,
  });

  final String id;
  final String walletId;
  final double amount;
  final TransactionType type;
  final String description;
  final DateTime createdAt;
  final String? recipientName;
  final String? note;

  bool get isCredit => type == TransactionType.credit;

  @override
  String toString() =>
      'Transaction(id: $id, amount: $amount, type: $type, description: $description)';
}

enum TransactionType { credit, debit }
