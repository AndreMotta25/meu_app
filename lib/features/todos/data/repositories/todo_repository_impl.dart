import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_datasource.dart';
import '../models/todo_model.dart';

final class TodoRepositoryImpl implements TodoRepository {
  const TodoRepositoryImpl(this._localDatasource);

  final TodoLocalDatasource _localDatasource;

  @override
  Future<Either<Failure, List<Todo>>> getTodos() async {
    try {
      final models = await _localDatasource.getTodos();
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException {
      return const Left(CacheFailure());
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, Todo>> addTodo(Todo todo) async {
    try {
      final model = TodoModel(
        id: todo.id,
        title: todo.title,
        done: todo.done,
        createdAt: todo.createdAt,
      );
      final models = await _localDatasource.addTodo(model);
      final added = models.lastWhere((m) => m.id == todo.id);
      return Right(added.toEntity());
    } on CacheException {
      return const Left(CacheFailure());
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, Todo>> toggleTodo(String id) async {
    try {
      final models = await _localDatasource.toggleTodo(id);
      final toggled = models.firstWhere((m) => m.id == id);
      return Right(toggled.toEntity());
    } on CacheException {
      return const Left(CacheFailure());
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeTodo(String id) async {
    try {
      await _localDatasource.removeTodo(id);
      return const Right(null);
    } on CacheException {
      return const Left(CacheFailure());
    } catch (_) {
      return const Left(UnknownFailure());
    }
  }
}
