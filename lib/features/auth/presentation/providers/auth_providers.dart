import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/auth_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/entities/user.dart';
import '../../../../core/errors/failures.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden before use.');
});

final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return AuthLocalDatasource(sharedPreferences);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final localDatasource = ref.watch(authLocalDatasourceProvider);
  return AuthRepositoryImpl(localDatasource);
});

final signInUsecaseProvider = Provider<SignInUsecase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignInUsecase(repository);
});

final signOutUsecaseProvider = Provider<SignOutUsecase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignOutUsecase(repository);
});

final getCurrentUserUsecaseProvider = Provider<GetCurrentUserUsecase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUsecase(repository);
});

final class AuthState {
  const AuthState({
    this.user,
    this.isLoading = false,
    this.failure,
  });

  final User? user;
  final bool isLoading;
  final Failure? failure;

  AuthState copyWith({
    User? user,
    bool? isLoading,
    Failure? failure,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      failure: failure,
    );
  }
}

final class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _loadCurrentUser();
    return const AuthState();
  }

  Future<void> _loadCurrentUser() async {
    state = state.copyWith(isLoading: true);
    final usecase = ref.read(getCurrentUserUsecaseProvider);
    final result = await usecase();

    result.fold(
      (failure) => state = state.copyWith(isLoading: false, failure: failure),
      (user) => state = state.copyWith(isLoading: false, user: user),
    );
  }

  Future<bool> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, failure: null);
    final usecase = ref.read(signInUsecaseProvider);
    final result = await usecase(email: email, password: password);

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, failure: failure);
        return false;
      },
      (user) {
        state = state.copyWith(isLoading: false, user: user);
        return true;
      },
    );
  }

  Future<bool> signOut() async {
    state = state.copyWith(isLoading: true, failure: null);
    final usecase = ref.read(signOutUsecaseProvider);
    final result = await usecase();

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, failure: failure);
        return false;
      },
      (_) {
        state = const AuthState();
        return true;
      },
    );
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
