import '../../domain/entities/todo.dart';

final class TodoModel {
  const TodoModel({
    required this.id,
    required this.title,
    required this.done,
    required this.createdAt,
  });

  final String id;
  final String title;
  final bool done;
  final DateTime createdAt;

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      done: json['done'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'done': done,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Todo toEntity() {
    return Todo(id: id, title: title, done: done, createdAt: createdAt);
  }

  TodoModel copyWith({
    String? id,
    String? title,
    bool? done,
    DateTime? createdAt,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      done: done ?? this.done,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
