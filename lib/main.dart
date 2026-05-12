import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_pay_demo/core/database/app_database.dart';
import 'package:pocket_pay_demo/core/di/service_locator.dart';
import 'package:pocket_pay_demo/core/services/firebase_service.dart';
import 'package:pocket_pay_demo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/app_config.dart';
import 'core/routes/app_router.dart';
import 'core/theme/theme.dart';

/// Kept for Drift — AppDatabase is also registered in GetIt, but the router
/// still references this symbol. Both point to the same instance via sl.
AppDatabase get appDatabase => sl<AppDatabase>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Load .env — all other config reads depend on it.
  await AppConfig.load();

  // 2. Initialise Firebase and register the background message handler
  //    before any other Firebase usage.
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // 3. Initialise Supabase.
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  // 4. Wire up all dependencies.
  setupServiceLocator();

  // 5. Initialise FCM (permission request + notification channel setup).
  await sl<FirebaseService>().init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // AuthBloc lives at the root so every screen can read it.
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
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
