import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';

final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._localDatasource);

  final AuthLocalDatasource _localDatasource;

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Simulated sign-in: creates a UserModel and saves locally.
      // Replace with actual API call via a remote datasource when available.
      const userModel = UserModel(
        id: '1',
        name: 'Usuário Teste',
        email: 'teste@email.com',
      );

      await _localDatasource.saveUser(userModel);
      return Right(userModel.toEntity());
    } on CacheException {
      return const Left(CacheFailure());
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _localDatasource.clearUser();
      return const Right(null);
    } on CacheException {
      return const Left(CacheFailure());
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final userModel = await _localDatasource.getUser();
      return Right(userModel.toEntity());
    } on CacheException {
      return const Right(null);
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }
}
