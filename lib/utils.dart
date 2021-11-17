import 'package:flutter/material.dart';

String formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

String formatTime(TimeOfDay time) {
  return '${time.hour}:${time.minute}';
}
