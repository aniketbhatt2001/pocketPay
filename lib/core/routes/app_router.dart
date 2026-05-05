import 'package:flutter/material.dart';
import 'package:pocket_pay_demo/core/services/supabase_auth_service.dart';
import 'package:pocket_pay_demo/features/send_money/presentation/pages/send_money_page.dart';
import 'package:pocket_pay_demo/features/transactions/data/remote_datasource.dart/transaction_datasource.dart';
import 'package:pocket_pay_demo/features/transactions/domain/usecases/get_all_transactions.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/mpin_screen.dart';
import '../../features/home/presentation/pages/home_page.dart';

import '../../features/profile/presentation/screens/profile_setup_screen.dart';
import '../../features/profile/presentation/screens/view_profile_screen.dart';

import '../../features/splash/presentation/screens/splash_screen.dart';

import '../../features/transactions/data/repositories/transaction_repository_impl.dart';

import '../../features/wallet/data/datasources/wallet_remote_datasource.dart';
import '../../features/wallet/data/repositories/wallet_repository_impl.dart';
import '../../features/wallet/domain/usecases/get_wallet_balance.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static const String initialRoute = AppRoutes.splash;

  static Map<String, WidgetBuilder> get routes => {
    AppRoutes.splash: (_) => const SplashScreen(),
    AppRoutes.login: (_) => const LoginScreen(),
    AppRoutes.setMpin: (_) => const MpinScreen(),
    AppRoutes.wallet: (_) {
      final walletRepo = WalletRepositoryImpl(WalletRemoteDatasource());
      final txRepo = TransactionRepositoryImpl(
        TransactionRemoteDataSource(SupabaseService()),
      );
      return HomePage(
        GetWalletBalanceUseCase(walletRepo),
        GetAllTransactions(txRepo),
      );
    },

    AppRoutes.profile: (_) => const ViewProfileScreen(),
    AppRoutes.profileSetup: (_) => const ProfileSetupScreen(),
    // AppRoutes.sendMoney: (_) => const SendMoneyPage(),
  };

  /// Fallback for unknown routes
  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder:
          (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
    );
  }
}
