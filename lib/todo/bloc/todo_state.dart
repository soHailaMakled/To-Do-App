import 'package:equatable/equatable.dart';

class TodoState {
  final List<String> todos;
  final List<bool> completed;
  final List<String> priorities;
  final Map<int, DateTime?> dueDates;

  TodoState({
    required this.todos,
    required this.completed,
    required this.priorities,
    required this.dueDates,
  });

  factory TodoState.initial() {
    return TodoState(
      todos: [],
      completed: [],
      priorities: [],
      dueDates: {},
    );
  }

  TodoState copyWith({
    List<String>? todos,
    List<bool>? completed,
    List<String>? priorities,
    Map<int, DateTime?>? dueDates,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      completed: completed ?? this.completed,
      priorities: priorities ?? this.priorities,
      dueDates: dueDates ?? this.dueDates,
    );
  }

  int get completedCount => completed.where((c) => c).length;
}
