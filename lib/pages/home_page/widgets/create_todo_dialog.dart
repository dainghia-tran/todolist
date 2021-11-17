import 'package:flutter/material.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/utils.dart' as utils;

class CreateTodoDialog extends StatefulWidget {
  const CreateTodoDialog({Key? key, required this.onPressConfirm})
      : super(key: key);
  final Function(Todo todo) onPressConfirm;

  @override
  State<CreateTodoDialog> createState() => _CreateTodoDialogState();
}

class _CreateTodoDialogState extends State<CreateTodoDialog> {
  String name = '';
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Create a new todo task',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              decoration: const InputDecoration(
                filled: true,
                labelText: 'Name',
              ),
              onChanged: (value) => setState(() {
                name = value;
              }),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: utils.formatDate(date),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.event))
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: utils.formatTime(time),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () => _selectTime(context),
                    icon: const Icon(Icons.schedule))
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel')),
                MaterialButton(
                  onPressed: () {
                    DateTime deadline = DateTime(date.year, date.month,
                        date.day, time.hour, time.minute);

                    Todo todo = Todo(name, deadline, false);
                    widget.onPressConfirm(todo);
                    Navigator.of(context).pop();
                  },
                  elevation: 0,
                  color: Color(Colors.blue.value),
                  child: const Text('Confirm'),
                  textColor: Color(Colors.white.value),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        date = picked;
      });
    }
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        time = picked;
      });
    }
  }
}
