import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/theme.dart';
import 'core/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL',defaultValue: 'https://udwgnkivfvqmfarwcakn.supabase.co'),//https://udwgnkivfvqmfarwcakn.supabase.co/rest/v1/
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY',defaultValue: 'sb_publishable_qA4HoxE4bAZTpdnADf-5ow_OvF8aIzU'),//sb_publishable_qA4HoxE4bAZTpdnADf-5ow_OvF8aIzU
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PocketPay',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRouter.initialRoute,
      routes: AppRouter.routes,
      onUnknownRoute: AppRouter.onUnknownRoute,
    );
  }
}
