import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

final class ToggleTodoUsecase {
  const ToggleTodoUsecase(this._repository);

  final TodoRepository _repository;

  Future<Either<Failure, Todo>> call({required String id}) {
    return _repository.toggleTodo(id);
  }
}
