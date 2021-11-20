import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todolist/pages/home_page/home_bloc.dart';
import 'package:todolist/pages/home_page/widgets/create_todo_dialog.dart';
import 'package:todolist/pages/home_page/widgets/search_bar.dart';
import 'package:todolist/pages/home_page/widgets/todo_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final HomeBloc bloc = HomeBloc();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      //Save to SharedPreferences
      bloc.saveTodosToStorage();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    bloc.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                // _showNotificationWithDefaultSound('name', DateTime.now());
                showDialog(
                    context: context,
                    builder: (_) => CreateTodoDialog(
                          onPressConfirm: (todo) =>
                              bloc.todosManager('add', todo: todo),
                        ));
              })
        ],
      ),
      body: Column(
        children: [
          Column(
            children: [
              SearchBar(
                onChange: bloc.searchTodos,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Filter',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    StreamBuilder(
                      stream: bloc.currentFilterStream,
                      builder: (context, snapshot) => DropdownButton(
                        value: snapshot.data,
                        icon: const Icon(Icons.arrow_drop_down_sharp),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (value) =>
                            bloc.loadTodosByFilter((value as String)),
                        items: <String>['All', 'Today', 'Upcoming', 'Done']
                            .map<DropdownMenuItem<String>>(
                              (e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: StreamBuilder(
                stream: bloc.todosStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && (snapshot.data as List).isNotEmpty) {
                    return Column(
                      children: (snapshot.data as List)
                          .map((e) => TodoItem(
                                todo: e,
                                onMarkAsDone: () =>
                                    bloc.todosManager('markAsDone', todo: e),
                                onRemove: () =>
                                    bloc.todosManager('remove', todo: e),
                              ))
                          .toList(),
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
              ),
            ),
          )
        ],
      ),
    );
  }
}
