import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_pay_demo/core/services/supabase_auth_service.dart';
import 'package:pocket_pay_demo/features/auth/data/repositories/auth_repository_impl.dart';

import 'package:pocket_pay_demo/features/auth/domain/usecases/check_session_usecase.dart';

import 'package:pocket_pay_demo/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:pocket_pay_demo/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:pocket_pay_demo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/app_config.dart';
import 'core/routes/app_router.dart';
import 'core/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env first — all other config reads depend on it.
  await AppConfig.load();

  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final repo = AuthRepositoryImpl(SupabaseAuthService());
            return AuthBloc(
              sendOtpUseCase: SendOtpUseCase(repo),
              verifyOtpUseCase: VerifyOtpUseCase(repo),
              checkSessionUseCase: CheckSessionUseCase(repo),
              // checkMpinUseCase: CheckMpinUseCase(repo),
            );
          },
        ),
      ],
      child: MaterialApp(
        title: 'PocketPay',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRouter.initialRoute,
        routes: AppRouter.routes,
        onUnknownRoute: AppRouter.onUnknownRoute,
      ),
    );
  }
}
