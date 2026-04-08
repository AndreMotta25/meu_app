import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../providers/todo_providers.dart';

class TodosScreen extends ConsumerStatefulWidget {
  const TodosScreen({super.key});

  @override
  ConsumerState<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends ConsumerState<TodosScreen> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onAdd() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    ref.read(todoProvider.notifier).addTodo(text);
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final todoState = ref.watch(todoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Nova tarefa...',
                    ),
                    onFieldSubmitted: (_) => _onAdd(),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton.filled(
                  onPressed: _onAdd,
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: todoState.isLoading && todoState.todos.isEmpty
                ? const LoadingWidget()
                : todoState.failure != null &&
                        todoState.todos.isEmpty
                    ? AppErrorWidget(
                        message: todoState.failure!.message,
                        onRetry: () =>
                            ref.read(todoProvider.notifier).loadTodos(),
                      )
                    : todoState.todos.isEmpty
                        ? Center(
                            child: Text(
                              'Nenhuma tarefa ainda.',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.outline,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: todoState.todos.length,
                            itemBuilder: (_, index) {
                              final todo = todoState.todos[index];
                              return ListTile(
                                leading: Checkbox(
                                  value: todo.done,
                                  onChanged: (_) => ref
                                      .read(todoProvider.notifier)
                                      .toggleTodo(todo.id),
                                ),
                                title: Text(
                                  todo.title,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    decoration: todo.done
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: todo.done
                                        ? AppColors.outline
                                        : AppColors.onSurface,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: AppColors.error,
                                  ),
                                  onPressed: () => ref
                                      .read(todoProvider.notifier)
                                      .removeTodo(todo.id),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
