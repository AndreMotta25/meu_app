import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

final class GetCurrentUserUsecase {
  const GetCurrentUserUsecase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, User?>> call() {
    return _repository.getCurrentUser();
  }
}
