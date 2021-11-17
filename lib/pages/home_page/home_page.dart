import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/pages/home_page/home_bloc.dart';
import 'package:todolist/pages/home_page/widgets/create_todo_dialog.dart';
import 'package:todolist/pages/home_page/widgets/search_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeBloc bloc = HomeBloc();

  @override
  void initState() {
    super.initState();
    bloc.loadTodosFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: const Icon(
          Icons.event_note,
          color: Colors.black,
        ),
        title: const Text(
          'Todolist',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => CreateTodoDialog(
                      onPressConfirm: (todo) => bloc.createNewTask(todo)),
                );
              })
        ],
      ),
      body: Column(
        children: [
          Column(
            children: [
              SearchBar(
                onClick: () {},
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Filter',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    DropdownButton(
                        value: 'All',
                        icon: const Icon(Icons.arrow_drop_down_sharp),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (value) => {},
                        items: <String>['All', 'Today', 'Upcoming']
                            .map<DropdownMenuItem<String>>((e) =>
                                DropdownMenuItem<String>(
                                    value: e, child: Text(e)))
                            .toList())
                  ],
                ),
              )
            ],
          ),
          StreamBuilder(
            stream: bloc.todosStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    children: (snapshot.data as List)
                        .map((e) => Text((e as Todo).name))
                        .toList(),
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    children: [
                      LottieBuilder.asset('assets/empty_state.json'),
                      const Text(
                        'No tasks in your list',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      )
                    ],
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
