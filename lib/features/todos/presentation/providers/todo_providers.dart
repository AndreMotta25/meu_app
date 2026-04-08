import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../../auth/presentation/providers/auth_providers.dart'
    show sharedPreferencesProvider;
import '../../data/datasources/todo_local_datasource.dart';
import '../../data/repositories/todo_repository_impl.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../domain/usecases/add_todo_usecase.dart';
import '../../domain/usecases/get_todos_usecase.dart';
import '../../domain/usecases/remove_todo_usecase.dart';
import '../../domain/usecases/toggle_todo_usecase.dart';

final todoLocalDatasourceProvider = Provider<TodoLocalDatasource>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return TodoLocalDatasource(sharedPreferences);
});

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  final localDatasource = ref.watch(todoLocalDatasourceProvider);
  return TodoRepositoryImpl(localDatasource);
});

final addTodoUsecaseProvider = Provider<AddTodoUsecase>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return AddTodoUsecase(repository);
});

final getTodosUsecaseProvider = Provider<GetTodosUsecase>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return GetTodosUsecase(repository);
});

final toggleTodoUsecaseProvider = Provider<ToggleTodoUsecase>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return ToggleTodoUsecase(repository);
});

final removeTodoUsecaseProvider = Provider<RemoveTodoUsecase>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return RemoveTodoUsecase(repository);
});

final class TodoState {
  const TodoState({
    this.todos = const [],
    this.isLoading = false,
    this.failure,
  });

  final List<Todo> todos;
  final bool isLoading;
  final Failure? failure;

  TodoState copyWith({
    List<Todo>? todos,
    bool? isLoading,
    Failure? failure,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
      failure: failure,
    );
  }
}

final class TodoNotifier extends Notifier<TodoState> {
  @override
  TodoState build() {
    loadTodos();
    return const TodoState();
  }

  Future<void> loadTodos() async {
    state = state.copyWith(isLoading: true);
    final usecase = ref.read(getTodosUsecaseProvider);
    final result = await usecase();

    result.fold(
      (failure) => state = state.copyWith(isLoading: false, failure: failure),
      (todos) => state = state.copyWith(isLoading: false, todos: todos),
    );
  }

  Future<void> addTodo(String title) async {
    state = state.copyWith(isLoading: true, failure: null);
    final usecase = ref.read(addTodoUsecaseProvider);
    final result = await usecase(title: title);

    result.fold(
      (failure) => state = state.copyWith(isLoading: false, failure: failure),
      (todo) {
        state = state.copyWith(
          isLoading: false,
          todos: [...state.todos, todo],
        );
      },
    );
  }

  Future<void> toggleTodo(String id) async {
    final usecase = ref.read(toggleTodoUsecaseProvider);
    final result = await usecase(id: id);

    result.fold(
      (failure) => state = state.copyWith(failure: failure),
      (todo) {
        state = state.copyWith(
          todos: state.todos.map((t) => t.id == id ? todo : t).toList(),
        );
      },
    );
  }

  Future<void> removeTodo(String id) async {
    final usecase = ref.read(removeTodoUsecaseProvider);
    final result = await usecase(id: id);

    result.fold(
      (failure) => state = state.copyWith(failure: failure),
      (_) {
        state = state.copyWith(
          todos: state.todos.where((t) => t.id != id).toList(),
        );
      },
    );
  }
}

final todoProvider = NotifierProvider<TodoNotifier, TodoState>(
  TodoNotifier.new,
);
