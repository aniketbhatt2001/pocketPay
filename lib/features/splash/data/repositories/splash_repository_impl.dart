import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_auth_service.dart';
import '../../domain/repositories/splash_repository.dart';

class SplashRepositoryImpl implements SplashRepository {
  SplashRepositoryImpl(this._authService) : _db = Supabase.instance.client;

  final SupabaseAuthService _authService;
  final SupabaseClient _db;

  @override
  Future<bool> hasActiveSession() => _authService.hasActiveSession();

  @override
  Future<bool> isMpinSet() async {
    final uid = _authService.currentUser?.id;
    if (uid == null) return false;

    final row =
        await _db.from('users').select('mpin_hash').eq('id', uid).maybeSingle();

    return row != null && row['mpin_hash'] != null;
  }
}
