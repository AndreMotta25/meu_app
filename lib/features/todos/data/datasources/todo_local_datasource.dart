import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo_model.dart';

final class TodoLocalDatasource {
  const TodoLocalDatasource(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  static const String todosKey = 'todos';

  Future<List<TodoModel>> getTodos() async {
    final jsonString = _sharedPreferences.getString(todosKey);
    if (jsonString == null) {
      return [];
    }
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((item) => TodoModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<TodoModel>> addTodo(TodoModel todo) async {
    final currentTodos = await getTodos();
    final updatedTodos = [...currentTodos, todo];
    await _saveTodos(updatedTodos);
    return updatedTodos;
  }

  Future<List<TodoModel>> toggleTodo(String id) async {
    final currentTodos = await getTodos();
    final updatedTodos = currentTodos.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(done: !todo.done);
      }
      return todo;
    }).toList();
    await _saveTodos(updatedTodos);
    return updatedTodos;
  }

  Future<List<TodoModel>> removeTodo(String id) async {
    final currentTodos = await getTodos();
    final updatedTodos = currentTodos.where((todo) => todo.id != id).toList();
    await _saveTodos(updatedTodos);
    return updatedTodos;
  }

  Future<void> _saveTodos(List<TodoModel> todos) async {
    final jsonList = todos.map((todo) => todo.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await _sharedPreferences.setString(todosKey, jsonString);
  }
}
