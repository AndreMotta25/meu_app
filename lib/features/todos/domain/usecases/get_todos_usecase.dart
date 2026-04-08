import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

final class GetTodosUsecase {
  const GetTodosUsecase(this._repository);

  final TodoRepository _repository;

  Future<Either<Failure, List<Todo>>> call() {
    return _repository.getTodos();
  }
}
