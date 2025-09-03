import 'package:flutter_bloc/flutter_bloc.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoState.initial()) {
    on<AddTodoEvent>(_onAddTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
    on<ToggleTodoEvent>(_onToggleTodo);
  }

  void _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) {
    if (event.todoText.isNotEmpty) {
      final newTodos = List<String>.from(state.todos)..add(event.todoText);
      final newPriorities = List<String>.from(state.priorities)..add(event.priority);
      final newDates = List<DateTime>.from(state.dates)..add(event.date);
      final newCompleted = List<bool>.from(state.completed)..add(false);
      emit(state.copyWith(
        todos: newTodos,
        priorities: newPriorities,
        dates: newDates,
        completed: newCompleted,
      ));
    }
  }

  void _onDeleteTodo(DeleteTodoEvent event, Emitter<TodoState> emit) {
    final newTodos = List<String>.from(state.todos)..removeAt(event.index);
    final newPriorities = List<String>.from(state.priorities)..removeAt(event.index);
    final newDates = List<DateTime>.from(state.dates)..removeAt(event.index);
    final newCompleted = List<bool>.from(state.completed)..removeAt(event.index);
    emit(state.copyWith(
      todos: newTodos,
      priorities: newPriorities,
      dates: newDates,
      completed: newCompleted,
    ));
  }

  void _onToggleTodo(ToggleTodoEvent event, Emitter<TodoState> emit) {
    final newCompleted = List<bool>.from(state.completed);
    newCompleted[event.index] = !newCompleted[event.index];
    emit(state.copyWith(
      completed: newCompleted,
    ));
  }
}
