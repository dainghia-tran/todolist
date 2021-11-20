import 'package:flutter/material.dart';

String formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

String formatTime(TimeOfDay time) {
  return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
}

String formatDateTime(DateTime dateTime) {
  return '${dateTime.hour}:${dateTime.minute} - ${dateTime.day}/${dateTime.month}/${dateTime.year}';
}
