import '../../domain/entities/wallet.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_remote_datasource.dart';

class WalletRepositoryImpl implements WalletRepository {
  WalletRepositoryImpl(this._datasource);

  final WalletRemoteDatasource _datasource;

  @override
  Future<Wallet> getWalletBalance() => _datasource.getWalletBalance();

  @override
  Future<void> sendMoney({
    required String recipientPhone,
    required double amount,
    String? note,
  }) => _datasource.sendMoney(
    recipientPhone: recipientPhone,
    amount: amount,
    note: note,
  );

  @override
  Future<void> addMoney({required double amount}) =>
      _datasource.addMoney(amount: amount);
}
