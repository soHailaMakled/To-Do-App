import 'package:equatable/equatable.dart';

class TodoState extends Equatable {
  final List<String> todos;
  final List<bool> completed;
  final List<String> priorities;
  final List<DateTime> dates;

  const TodoState({
    required this.todos,
    required this.completed,
    required this.priorities,
    required this.dates,
  });

  factory TodoState.initial() => const TodoState(
    todos: [],
    completed: [],
    priorities: [],
    dates: [],
  );

  TodoState copyWith({
    List<String>? todos,
    List<bool>? completed,
    List<String>? priorities,
    List<DateTime>? dates,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      completed: completed ?? this.completed,
      priorities: priorities ?? this.priorities,
      dates: dates ?? this.dates,
    );
  }

  int get completedCount => completed.where((c) => c).length;

  @override
  List<Object> get props => [todos, completed, priorities, dates];

  List<DateTime> get dueDates => dates;

}
