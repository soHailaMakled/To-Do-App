import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_state.dart';
import '../bloc/todo_event.dart';
import 'add_task_bottom_sheet.dart';
import 'dart:math';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String formatTaskDate(DateTime date) {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return "Today";
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return "Tomorrow";
    } else {
      return DateFormat('MMM d').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, MMM d').format(now);

    return Scaffold(
      body: Stack(
        children: [
          // 🌊 Wave Background
          WaveWidget(
            config: CustomConfig(
              colors: [
                Color(0xFF3B82F6).withOpacity(0.25), // أزرق هادي
                Color(0xFFB3E5FC).withOpacity(0.20), // أزرق سماوي فاتح جداً
                Color(0xFFE6E6FA).withOpacity(0.30), // Lavender بنفسجي باهت
              ],
              durations: [35000, 19440, 10800],
              heightPercentages: [0.20, 0.23, 0.27],
            ),
            backgroundColor: Colors.deepPurpleAccent,
            size: const Size(double.infinity, double.infinity),
            waveAmplitude: 0,
          ),

          // 📄 Page Content
          SafeArea(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                final completedCount = state.completedCount;
                final totalCount = state.todos.length;
                final progress =
                totalCount > 0 ? completedCount / totalCount : 0.0;

                // ✅ Show motivational popup if all tasks are completed
                if (completedCount == totalCount && totalCount > 0) {
                  Future.microtask(() {
                    final messages = [
                      "Well done! You nailed it 🎉",
                      "Awesome job! All tasks completed ✅",
                      "You're unstoppable 🚀 Keep going!",
                      "Fantastic! You did it 💪",
                      "Great work! Time to relax 🌟",
                    ];
                    final random = Random();
                    final message = messages[random.nextInt(messages.length)];

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: const Text(
                          "Congratulations 🎉",
                          textAlign: TextAlign.center,
                        ),
                        content: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Continue"),
                          ),
                        ],
                      ),
                    );
                  });
                }

                final easyTasks = state.todos
                    .asMap()
                    .entries
                    .where((e) => state.priorities[e.key] == 'Low')
                    .toList();
                final mediumTasks = state.todos
                    .asMap()
                    .entries
                    .where((e) => state.priorities[e.key] == 'Medium')
                    .toList();
                final hardTasks = state.todos
                    .asMap()
                    .entries
                    .where((e) => state.priorities[e.key] == 'High')
                    .toList();

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ⏰ Date + Profile
                      SizedBox(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                formattedDate,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person,
                                  color: Color(0xFF3B82F6)),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 📊 Summary Card
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Tasks Completed",
                                      style: TextStyle(color: Colors.black)),
                                  const SizedBox(height: 8),
                                  Text(
                                    "$completedCount / $totalCount",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: CircularProgressIndicator(
                                  value: progress,
                                  strokeWidth: 6,
                                  color: const Color(0xFF3B50F6),
                                  backgroundColor: Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 🟢 Easy Section
                      _buildTaskSection(context, 'Easy Tasks', Colors.green,
                          easyTasks, state),
                      const Divider(thickness: 1, height: 40),

                      // 🟠 Medium Section
                      _buildTaskSection(context, 'Medium Tasks', Colors.orange,
                          mediumTasks, state),
                      const Divider(thickness: 1, height: 40),

                      // 🔴 Hard Section
                      _buildTaskSection(
                          context, 'Hard Tasks', Colors.red, hardTasks, state),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // ➕ Add Task Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const AddTaskBottomSheet(),
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Color(0xFF3B82F6), size: 28),
      ),
    );
  }
}

Widget _buildTaskSection(
    BuildContext context,
    String label,
    Color color,
    List<MapEntry<int, String>> tasks,
    TodoState state,
    ) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 3,
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 10),
          if (tasks.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'No tasks in this category.',
                style: TextStyle(color: Colors.grey[600]),
              ),
            )
          else
            ...tasks.map((taskEntry) {
              final isCompleted = state.completed[taskEntry.key];
              final dueDate = state.dueDates[taskEntry.key];
              final formattedDate = dueDate != null
                  ? HomeScreen().formatTaskDate(dueDate)
                  : "No date";

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 1,
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: Checkbox(
                    value: isCompleted,
                    onChanged: (_) {
                      context
                          .read<TodoBloc>()
                          .add(ToggleTodoEvent(taskEntry.key));
                    },
                    activeColor: color,
                  ),
                  title: Text(
                    taskEntry.value,
                    style: TextStyle(
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: isCompleted ? Colors.grey : Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context
                          .read<TodoBloc>()
                          .add(DeleteTodoEvent(taskEntry.key));
                    },
                  ),
                ),
              );
            }),
        ],
      ),
    ),
  );
}
