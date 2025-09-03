import 'package:equatable/equatable.dart';

abstract class TodoEvent {}

class LoadTodosEvent extends TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final String task;
  final String priority;
  final DateTime? dueDate;

  AddTodoEvent({
    required this.task,
    required this.priority,
    this.dueDate,
  });
}

class ToggleTodoEvent extends TodoEvent {
  final int index;

  ToggleTodoEvent(this.index);
}

class DeleteTodoEvent extends TodoEvent {
  final int index;

  DeleteTodoEvent(this.index);
}
