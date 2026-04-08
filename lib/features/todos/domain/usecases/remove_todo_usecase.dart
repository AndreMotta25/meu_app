import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/todo_repository.dart';

final class RemoveTodoUsecase {
  const RemoveTodoUsecase(this._repository);

  final TodoRepository _repository;

  Future<Either<Failure, void>> call({required String id}) {
    return _repository.removeTodo(id);
  }
}
