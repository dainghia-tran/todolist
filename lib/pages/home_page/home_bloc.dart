import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/models/todo.dart';

class HomeBloc {
  List<Todo> todos = [];
  var todosController = StreamController();

  Stream get todosStream => todosController.stream;

  void createNewTask(Todo todo) {
    todos.add(todo);
    todosController.add(todos);
  }

  void loadTodosFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
  }

  void saveTodosToStorage() async {
    final prefs = await SharedPreferences.getInstance();

    // List<Todo> todos = todosController.stream.
  }

  void loadTodosByFilter(String filter) {
    switch (filter) {
      case 'All':
      case 'Today':
      case 'Upcoming':
    }
  }

  void dispose() {
    todosController.close();
  }
}
