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
  bool isEmpty = false;
  bool isBeforeNow = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: Text(
                'Create a new todo task',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Name',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            TextField(
              decoration: InputDecoration(
                  filled: true, errorText: isEmpty ? 'Enter a name' : null),
              onChanged: (value) => setState(() {
                name = value;
              }),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Deadline',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                        filled: true,
                        hintText: utils.formatDate(date),
                        errorText: isBeforeNow
                            ? 'Deadline must be greater present'
                            : null),
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
                    readOnly: true,
                    decoration: InputDecoration(
                        filled: true,
                        hintText: utils.formatTime(time),
                        errorText: isBeforeNow ? '' : null),
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
                    if (name == '') {
                      setState(() {
                        isEmpty = true;
                      });
                      return;
                    } else {
                      setState(() {
                        isEmpty = false;
                      });
                    }

                    DateTime deadline = DateTime(date.year, date.month,
                        date.day, time.hour, time.minute);

                    if (deadline.isBefore(DateTime.now())) {
                      setState(() {
                        isBeforeNow = true;
                      });
                      return;
                    } else {
                      setState(() {
                        isBeforeNow = true;
                      });
                    }

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
