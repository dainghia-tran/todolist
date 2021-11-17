import 'package:flutter/material.dart';
import 'package:todolist/pages/home_page/home_page.dart';

class TodolistApp extends StatelessWidget {
  const TodolistApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
