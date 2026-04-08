import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

final class AddTodoUsecase {
  const AddTodoUsecase(this._repository);

  final TodoRepository _repository;

  Future<Either<Failure, Todo>> call({required String title}) {
    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      done: false,
      createdAt: DateTime.now(),
    );
    return _repository.addTodo(todo);
  }
}
