import 'dart:convert';

class Todo {
  String name;
  DateTime deadline;
  bool isCompleted;

  Todo(this.name, this.deadline, this.isCompleted);

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
        json['name'], DateTime.parse(json['deadline']), json['isCompleted']);
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'deadline': deadline.toString(),
        'isCompleted': isCompleted
      };

  static String encode(List<Todo> todos) =>
      json.encode(todos.map((e) => e.toMap()).toList());

  static List<Todo> decode(String todos) =>
      (json.decode(todos) as List<dynamic>)
          .map((e) => Todo.fromJson(e))
          .toList();
}
