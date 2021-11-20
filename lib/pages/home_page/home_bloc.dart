import 'dart:async';

import 'package:fuzzy/fuzzy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/notification_utils.dart';

const prefKey = 'todos';

class HomeBloc {
  List<Todo> todos = [];
  var currentFilter = 'All';
  var todosController = StreamController();
  var currentFilterController = StreamController();

  Stream get todosStream => todosController.stream;

  Stream get currentFilterStream => currentFilterController.stream;

  int sortTodos(a, b) => a.deadline.compareTo(b.deadline);

  void initialize() {
    currentFilterController.add(currentFilter);
    loadTodosFromStorage();
    NotificationUtils.initialize();
  }

  void todosManager(String event, {Todo? todo}) async {
    switch (event) {
      case 'add':
        todos.add(todo!);
        NotificationUtils.scheduleNotificationWithDefaultSound(
            todo.name, todo.deadline);
        break;
      case 'remove':
        todos.remove(todo);
        NotificationUtils.cancelNotification(
            (todo!.deadline.millisecondsSinceEpoch / 1000).round());
        break;
      case 'markAsDone':
        final index = todos.indexOf(todo!);
        todo.isCompleted = true;
        todos.remove(todo);
        todos.insert(index, todo);
        NotificationUtils.cancelNotification(
            (todo.deadline.millisecondsSinceEpoch / 1000).round());
        break;
    }
    todos.sort(sortTodos);
    todosController.add(todos);
    loadTodosByFilter(currentFilter);
  }

  void loadTodosFromStorage() async {
    final prefs = await SharedPreferences.getInstance();

    final String? savedData = prefs.getString(prefKey);
    if (savedData != null) {
      todos = Todo.decode(savedData);
    }
    todosController.add(todos);
  }

  void saveTodosToStorage() async {
    final prefs = await SharedPreferences.getInstance();

    final encodedData = Todo.encode(todos);
    prefs.setString(prefKey, encodedData);
  }

  void searchTodos(String keyword) {
    final fuzzyTodos = Fuzzy(todos.map((e) => e.name).toList());
    final result = fuzzyTodos.search(keyword);
    final matchedItems = result.map((e) => e.item).toList();
    final searchResult =
        todos.where((e) => matchedItems.contains(e.name)).toList();
    searchResult.sort(sortTodos);
    todosController.add(searchResult);
  }

  void loadTodosByFilter(String? filter) {
    switch (filter) {
      case 'All':
        todosController.add(todos);
        break;
      case 'Today':
        List<Todo> todayTodos = todos.where(isToday).toList();
        todosController.add(todayTodos);
        break;
      case 'Upcoming':
        List<Todo> upcomingTodos =
            todos.where((e) => e.deadline.isAfter(DateTime.now())).toList();
        todosController.add(upcomingTodos);
        break;
      case 'Done':
        List<Todo> completedTodos = todos.where((e) => e.isCompleted).toList();
        todosController.add(completedTodos);
        break;
    }
    currentFilter = filter!;
    currentFilterController.add(currentFilter);
  }

  bool isToday(Todo todo) {
    DateTime deadline = todo.deadline;
    DateTime now = DateTime.now();
    return (deadline.year == now.year &&
        deadline.month == now.month &&
        deadline.day == now.day);
  }

  void dispose() {
    todosController.close();
    currentFilterController.close();
  }
}
