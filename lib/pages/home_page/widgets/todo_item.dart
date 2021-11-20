import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/utils.dart' as utils;

class TodoItem extends StatefulWidget {
  const TodoItem({
    Key? key,
    required this.todo,
    required this.onMarkAsDone,
    required this.onRemove,
  }) : super(key: key);
  final Todo todo;
  final onMarkAsDone;
  final onRemove;

  @override
  _TodoItemState createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  Timer? timer;

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final isComing =
        (widget.todo.deadline.difference(DateTime.now()).inSeconds) < 900;
    final isPassed = widget.todo.deadline.isBefore(DateTime.now());
    final color = widget.todo.isCompleted
        ? Colors.lightGreen
        : (isPassed
            ? Colors.grey
            : (isComing ? Colors.amber : Colors.cyan.shade100));

    final contentColor = widget.todo.isCompleted ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Slidable(
        child: Container(
          decoration: BoxDecoration(
            color: color,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 5,
                  offset: const Offset(0, 5)),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  widget.todo.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: contentColor),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Icon(
                    Icons.event_outlined,
                    color: contentColor,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    utils.formatDateTime(widget.todo.deadline),
                    style: TextStyle(color: contentColor),
                  )
                ],
              ),
            ],
          ),
        ),
        key: ValueKey<String>(widget.todo.deadline.toString()),
        startActionPane: ActionPane(
          extentRatio: 0.2,
          dismissible: DismissiblePane(
            onDismissed: widget.onRemove,
          ),
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => widget.onRemove(),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
            ),
          ],
        ),
        endActionPane: widget.todo.isCompleted
            ? null
            : ActionPane(
                extentRatio: 0.2,
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) => widget.onMarkAsDone(),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    icon: Icons.check,
                  ),
                ],
              ),
      ),
    );
  }
}
