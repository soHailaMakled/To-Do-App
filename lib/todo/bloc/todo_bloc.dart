import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoState.initial()) {
    on<LoadTodosEvent>(_onLoadTodos);
    on<AddTodoEvent>(_onAddTodo);
    on<ToggleTodoEvent>(_onToggleTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);

    // تحميل البيانات عند بداية التطبيق
    add(LoadTodosEvent());
  }

  Future<void> _saveToPrefs(TodoState state) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode({
      "todos": state.todos,
      "completed": state.completed,
      "priorities": state.priorities,
      "dueDates": state.dueDates.map((k, v) => MapEntry(k.toString(), v?.toIso8601String())),
    });
    await prefs.setString("todo_data", data);
  }

  Future<void> _onLoadTodos(LoadTodosEvent event, Emitter<TodoState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("todo_data");
    if (data != null) {
      final map = jsonDecode(data);
      emit(state.copyWith(
        todos: List<String>.from(map["todos"]),
        completed: List<bool>.from(map["completed"]),
        priorities: List<String>.from(map["priorities"]),
        dueDates: Map<int, DateTime?>.from(
          (map["dueDates"] as Map).map(
                (k, v) => MapEntry(int.parse(k), v != null ? DateTime.parse(v) : null),
          ),
        ),
      ));
    }
  }

  Future<void> _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    final newTodos = List<String>.from(state.todos)..add(event.task);
    final newCompleted = List<bool>.from(state.completed)..add(false);
    final newPriorities = List<String>.from(state.priorities)..add(event.priority);
    final newDueDates = Map<int, DateTime?>.from(state.dueDates)
      ..[newTodos.length - 1] = event.dueDate;

    final newState = state.copyWith(
      todos: newTodos,
      completed: newCompleted,
      priorities: newPriorities,
      dueDates: newDueDates,
    );
    emit(newState);
    await _saveToPrefs(newState);
  }

  Future<void> _onToggleTodo(ToggleTodoEvent event, Emitter<TodoState> emit) async {
    final newCompleted = List<bool>.from(state.completed);
    newCompleted[event.index] = !newCompleted[event.index];

    final newState = state.copyWith(completed: newCompleted);
    emit(newState);
    await _saveToPrefs(newState);
  }

  Future<void> _onDeleteTodo(DeleteTodoEvent event, Emitter<TodoState> emit) async {
    final newTodos = List<String>.from(state.todos)..removeAt(event.index);
    final newCompleted = List<bool>.from(state.completed)..removeAt(event.index);
    final newPriorities = List<String>.from(state.priorities)..removeAt(event.index);
    final newDueDates = Map<int, DateTime?>.from(state.dueDates)..remove(event.index);

    final newState = state.copyWith(
      todos: newTodos,
      completed: newCompleted,
      priorities: newPriorities,
      dueDates: newDueDates,
    );
    emit(newState);
    await _saveToPrefs(newState);
  }
}
