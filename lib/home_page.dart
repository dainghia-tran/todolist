import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
                onPressed: () {})
          ],
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
              child: AppBar(
                bottom: const TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(Icons.date_range),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.today,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.upcoming,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Container(
                    color: Colors.red,
                    child: const Center(
                      child: Text(
                        'All',
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.pink,
                    child: const Center(
                      child: Text(
                        'Tody',
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.pink,
                    child: const Center(
                      child: Text(
                        'Upcoming',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
