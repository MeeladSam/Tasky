import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'tasks_list_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _pages = <Widget>[
    const HomeScreen(),
    TasksListScreen(
      title: 'To Do Tasks',
      filter: (t) => !t.isCompleted,
      showBack: false,
    ),
    TasksListScreen(
      title: 'Completed Tasks',
      filter: (t) => t.isCompleted,
      showBack: false,
    ),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.description_outlined), label: 'To Do'),
          BottomNavigationBarItem(
              icon: Icon(Icons.task_outlined), label: 'Completed'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
