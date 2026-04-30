import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/services/supabase_auth_service.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/mpin_screen.dart';
import '../../features/payment/presentation/screens/payment_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/qr_scanner/presentation/screens/qr_scanner_screen.dart';
import '../../features/splash/data/repositories/splash_repository_impl.dart';
import '../../features/splash/domain/usecases/check_mpin_usecase.dart';
import '../../features/splash/domain/usecases/check_session_usecase.dart';
import '../../features/splash/presentation/cubit/splash_cubit.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/transaction/presentation/screens/transaction_screen.dart';
import '../../features/wallet/presentation/screens/wallet_screen.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static const String initialRoute = AppRoutes.splash;

  static Map<String, WidgetBuilder> get routes => {
    AppRoutes.splash: (_) {
      final repo = SplashRepositoryImpl(SupabaseAuthService());
      return BlocProvider(
        create:
            (_) => SplashCubit(
              checkSession: CheckSessionUseCase(repo),
              checkMpin: CheckMpinUseCase(repo),
            ),
        child: const SplashScreen(),
      );
    },
    AppRoutes.login: (_) => const LoginScreen(),
    AppRoutes.mpin: (_) => const MpinScreen(),
    AppRoutes.wallet: (_) => const WalletScreen(),
    AppRoutes.payment: (_) => const PaymentScreen(),
    AppRoutes.transaction: (_) => const TransactionScreen(),
    AppRoutes.qrScanner: (_) => const QrScannerScreen(),
    AppRoutes.profile: (_) => const ProfileScreen(),
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
