import 'package:get_it/get_it.dart';
import 'package:pocket_pay_demo/core/config/app_config.dart';
import 'package:pocket_pay_demo/core/database/app_database.dart';
import 'package:pocket_pay_demo/core/services/supabase_auth_service.dart';

// ── Auth ──────────────────────────────────────────────────────────────────
import 'package:pocket_pay_demo/features/auth/data/local/auth_local_datasource.dart';
import 'package:pocket_pay_demo/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:pocket_pay_demo/features/auth/domain/repositories/auth_repository.dart';
import 'package:pocket_pay_demo/features/auth/domain/usecases/check_session_usecase.dart';
import 'package:pocket_pay_demo/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:pocket_pay_demo/features/auth/domain/usecases/set_mpin_usecase.dart';
import 'package:pocket_pay_demo/features/auth/domain/usecases/set_user_profile_usecase.dart';
import 'package:pocket_pay_demo/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:pocket_pay_demo/features/auth/domain/usecases/verify_mpin_usecase.dart';
import 'package:pocket_pay_demo/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:pocket_pay_demo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pocket_pay_demo/features/auth/presentation/bloc/mpin_cubit.dart';

// ── Wallet ────────────────────────────────────────────────────────────────
import 'package:pocket_pay_demo/features/wallet/data/datasources/wallet_local_datasource.dart';
import 'package:pocket_pay_demo/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:pocket_pay_demo/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:pocket_pay_demo/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:pocket_pay_demo/features/wallet/domain/usecases/add_money.dart';
import 'package:pocket_pay_demo/features/wallet/domain/usecases/get_wallet_balance.dart';
import 'package:pocket_pay_demo/features/wallet/domain/usecases/send_money.dart';

// ── Transactions ──────────────────────────────────────────────────────────
import 'package:pocket_pay_demo/features/transactions/data/local_datasource/transaction_local_datasource.dart';
import 'package:pocket_pay_demo/features/transactions/data/remote_datasource.dart/transaction_datasource.dart';
import 'package:pocket_pay_demo/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:pocket_pay_demo/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:pocket_pay_demo/features/transactions/domain/usecases/get_all_transactions.dart';

// ── Feature cubits ────────────────────────────────────────────────────────
import 'package:pocket_pay_demo/features/home/presentation/cubit/home_cubit.dart';
import 'package:pocket_pay_demo/features/send_money/presentation/cubit/send_money_cubit.dart';
import 'package:pocket_pay_demo/features/add_money/presentation/cubit/add_money_cubit.dart';
import 'package:pocket_pay_demo/features/profile/presentation/cubit/profile_setup_cubit.dart';
import 'package:pocket_pay_demo/features/transactions/presentation/cubit/transactions_cubit.dart';

/// Global GetIt instance — import this wherever you need `sl<T>()`.
final GetIt sl = GetIt.instance;

/// Call once in [main] before [runApp].
void setupServiceLocator() {
  // ── Core ────────────────────────────────────────────────────────────────

  // Supabase wrapper — singleton (one auth session for the whole app)
  sl.registerLazySingleton<SupabaseService>(() => SupabaseService());

  // Drift SQLite database — singleton (one connection for the whole app)
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // ── Auth ─────────────────────────────────────────────────────────────────

  sl.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasource(sl<AppDatabase>()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<SupabaseService>(), sl<AuthLocalDatasource>()),
  );

  sl.registerLazySingleton<SendOtpUseCase>(
    () => SendOtpUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<CheckSessionUseCase>(
    () => CheckSessionUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SetMpinUseCase>(
    () => SetMpinUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<VerifyMpinUseCase>(
    () => VerifyMpinUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SetUserProfileUseCase>(
    () => SetUserProfileUseCase(sl<AuthRepository>()),
  );

  // AuthBloc — factory so each registration gives a fresh instance,
  // but we keep one alive at the top of the widget tree via MultiBlocProvider.
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      sendOtpUseCase: sl<SendOtpUseCase>(),
      verifyOtpUseCase: sl<VerifyOtpUseCase>(),
      checkSessionUseCase: sl<CheckSessionUseCase>(),
      signOutUseCase: sl<SignOutUseCase>(),
    ),
  );

  // MpinCubit — factory (created fresh per screen)
  sl.registerFactory<MpinCubit>(
    () => MpinCubit(
      setMpinUseCase: sl<SetMpinUseCase>(),
      verifyMpinUseCase: sl<VerifyMpinUseCase>(),
    ),
  );

  // ── Wallet ────────────────────────────────────────────────────────────────

  sl.registerLazySingleton<WalletRemoteDatasource>(
    () => WalletRemoteDatasource(client: sl<SupabaseService>()),
  );
  sl.registerLazySingleton<WalletLocalDatasource>(
    () => WalletLocalDatasource(sl<AppDatabase>()),
  );
  sl.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(
      sl<WalletRemoteDatasource>(),
      sl<WalletLocalDatasource>(),
    ),
  );

  sl.registerLazySingleton<GetWalletBalanceUseCase>(
    () => GetWalletBalanceUseCase(sl<WalletRepository>()),
  );
  sl.registerLazySingleton<SendMoneyUseCase>(
    () => SendMoneyUseCase(sl<WalletRepository>()),
  );
  sl.registerLazySingleton<AddMoneyUseCase>(
    () => AddMoneyUseCase(sl<WalletRepository>()),
  );

  // ── Transactions ──────────────────────────────────────────────────────────

  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSource(sl<SupabaseService>()),
  );
  sl.registerLazySingleton<TransactionLocalDatasource>(
    () => TransactionLocalDatasource(sl<AppDatabase>()),
  );

  // TransactionRepository is a factory because it captures the current userId
  // at creation time (userId can change after sign-out / sign-in).
  sl.registerFactory<TransactionRepository>(
    () => TransactionRepositoryImpl(
      sl<TransactionRemoteDataSource>(),
      sl<TransactionLocalDatasource>(),
      sl<SupabaseService>().currentUser?.id ?? '',
    ),
  );

  sl.registerFactory<GetCachedTransactions>(
    () => GetCachedTransactions(sl<TransactionRepository>()),
  );
  sl.registerFactory<SyncTransactions>(
    () => SyncTransactions(sl<TransactionRepository>()),
  );

  // ── Feature cubits ────────────────────────────────────────────────────────

  sl.registerFactory<HomeCubit>(
    () => HomeCubit(
      getWalletBalance: sl<GetWalletBalanceUseCase>(),
      getCachedTransactions: sl<GetCachedTransactions>(),
      syncTransactions: sl<SyncTransactions>(),
    ),
  );

  sl.registerFactory<SendMoneyCubit>(
    () => SendMoneyCubit(sendMoney: sl<SendMoneyUseCase>()),
  );

  sl.registerFactory<AddMoneyCubit>(
    () => AddMoneyCubit(
      addMoney: sl<AddMoneyUseCase>(),
      razorpayKeyId: AppConfig.razorpayKeyId,
    ),
  );

  sl.registerFactory<ProfileSetupCubit>(
    () => ProfileSetupCubit(updateProfileUseCase: sl<SetUserProfileUseCase>()),
  );

  sl.registerFactory<TransactionsCubit>(
    () => TransactionsCubit(syncTransactions: sl<SyncTransactions>()),
  );
}
