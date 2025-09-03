import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import 'add_task_bottom_sheet.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formatter = DateFormat('MMMM d, yyyy');
    final formattedDate = formatter.format(now);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          formattedDate,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            final incompleteTodos = <Map<String, dynamic>>[];
            final completedTodos = <Map<String, dynamic>>[];

            for (int i = 0; i < state.todos.length; i++) {
              final todoData = {
                'text': state.todos[i],
                'index': i,
                'priority': state.priorities[i], // إضافة الأولوية
                'date': state.dates[i], // إضافة التاريخ
              };
              if (state.completed[i]) {
                completedTodos.add(todoData);
              } else {
                incompleteTodos.add(todoData);
              }
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${incompleteTodos.length} incomplete, ${completedTodos.length} completed',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Incomplete',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: incompleteTodos.length,
                    itemBuilder: (context, index) {
                      final todo = incompleteTodos[index];
                      return ListTile(
                        leading: Checkbox(
                          value: false,
                          onChanged: (_) {
                            context.read<TodoBloc>().add(ToggleTodoEvent(todo['index']));
                          },
                          activeColor: Colors.black,
                        ),
                        title: Text(todo['text']),
                        subtitle: Row(
                          children: [
                            // عرض الأولوية
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getPriorityColor(todo['priority']).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                todo['priority'],
                                style: TextStyle(color: _getPriorityColor(todo['priority']), fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // عرض التاريخ
                            Text(
                              DateFormat('MMM d, yyyy').format(todo['date']),
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context.read<TodoBloc>().add(DeleteTodoEvent(todo['index']));
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Completed',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: completedTodos.length,
                    itemBuilder: (context, index) {
                      final todo = completedTodos[index];
                      return ListTile(
                        leading: Checkbox(
                          value: true,
                          onChanged: (_) {
                            context.read<TodoBloc>().add(ToggleTodoEvent(todo['index']));
                          },
                          activeColor: Colors.black,
                        ),
                        title: Text(
                          todo['text'],
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            // عرض الأولوية
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getPriorityColor(todo['priority']).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                todo['priority'],
                                style: TextStyle(color: _getPriorityColor(todo['priority']), fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // عرض التاريخ
                            Text(
                              DateFormat('MMM d, yyyy').format(todo['date']),
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context.read<TodoBloc>().add(DeleteTodoEvent(todo['index']));
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const AddTaskBottomSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Low':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'High':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}