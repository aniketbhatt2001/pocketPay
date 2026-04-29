import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/wallet/presentation/screens/wallet_screen.dart';
import '../../features/payment/presentation/screens/payment_screen.dart';
import '../../features/transaction/presentation/screens/transaction_screen.dart';
import '../../features/qr_scanner/presentation/screens/qr_scanner_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

class AppRouter {
  AppRouter._();

  static const String initialRoute = AppRoutes.login;

  static Map<String, WidgetBuilder> get routes => {
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.wallet: (_) => const WalletScreen(),
        AppRoutes.payment: (_) => const PaymentScreen(),
        AppRoutes.transaction: (_) => const TransactionScreen(),
        AppRoutes.qrScanner: (_) => const QrScannerScreen(),
        AppRoutes.profile: (_) => const ProfileScreen(),
      };

  /// Fallback for unknown routes
  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('No route defined for ${settings.name}'),
        ),
      ),
    );
  }
}
