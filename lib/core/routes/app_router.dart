import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_pay_demo/core/di/service_locator.dart';
import 'package:pocket_pay_demo/features/home/presentation/cubit/home_cubit.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/mpin_screen.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/screens/profile_setup_screen.dart';
import '../../features/profile/presentation/screens/view_profile_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static const String initialRoute = AppRoutes.splash;

  static Map<String, WidgetBuilder> get routes => {
    AppRoutes.splash: (_) => const SplashScreen(),
    AppRoutes.login: (_) => const LoginScreen(),
    AppRoutes.setMpin: (_) => const MpinScreen(),
    AppRoutes.wallet:
        (_) => BlocProvider<HomeCubit>(
          create: (_) => sl<HomeCubit>()..loadHome(),
          child: const HomePage(),
        ),
    AppRoutes.profile: (_) => const ViewProfileScreen(),
    AppRoutes.profileSetup: (_) => const ProfileSetupScreen(),
  };

  /// Fallback for unknown routes.
  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder:
          (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
    );
  }
}
