import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class AddTodoEvent extends TodoEvent {
  final String todoText;
  final String priority;
  final DateTime date;

  const AddTodoEvent(this.todoText, {required this.priority, required this.date});

  @override
  List<Object> get props => [todoText, priority, date];
}

class DeleteTodoEvent extends TodoEvent {
  final int index;

  const DeleteTodoEvent(this.index);

  @override
  List<Object> get props => [index];
}

class ToggleTodoEvent extends TodoEvent {
  final int index;

  const ToggleTodoEvent(this.index);

  @override
  List<Object> get props => [index];
}
