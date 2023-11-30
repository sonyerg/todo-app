import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/nav_drawer.dart';

import 'todo.dart';
import 'todo_item.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 236, 236, 236),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 236, 236, 236),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ToDo> todosList = [];

  @override
  void initState() {
    super.initState();
    _loadToDos();
  }

  Future<void> _saveToDos() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> encodedTodos = todosList.map((todo) => todo.toJson()).toList();
    prefs.setStringList('todosList', encodedTodos);
  }

  Future<void> _loadToDos() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? encodedTodos = prefs.getStringList('todosList');

    if (encodedTodos != null) {
      setState(() {
        todosList = encodedTodos.map((e) => ToDo.fromJson(e)).toList();
      });
    } else {
      todosList =
          ToDo.todoList(); // Load the initial list if no saved list is found
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return Scaffold(
      drawer: const Drawer(
        child: NavDrawer(),
      ),
      appBar: AppBar(),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            // Search bar
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search',
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    'Todo\'s',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                for (ToDo todoo in todosList)
                  TodoItem(
                    todo: todoo,
                    onToDoChanged: _handleToDoChange,
                    onDeleteItem: _deleteToDoItem,
                    onEditItem: _editToDoItem,
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskModal(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskModal(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add ToDo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'ToDo title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ElevatedButton(
                  onPressed: () {
                    // Add task to the list
                    _addToDo(controller.text);
                    Navigator.pop(context);
                  },
                  child: const Text('Add ToDo'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addToDo(String todoTitle) {
    setState(() {
      todosList.add(
        ToDo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          todoText: todoTitle,
          completed: false,
        ),
      );
    });
    _saveToDos(); // Save updated list
  }

  void _deleteToDoItem(ToDo todo) {
    setState(() {
      todosList.remove(todo);
    });

    _saveToDos(); // Save updated list

    final snackBar = SnackBar(
      content: const Text('Item deleted'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() {
            todosList.add(todo);
          });
          _saveToDos(); // Save updated list
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.completed = !todo.completed;
    });
    _saveToDos(); // Save updated list
  }

  void _editToDoItem(ToDo todo) {
    final TextEditingController controller =
        TextEditingController(text: todo.todoText);

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Edit ToDo',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  // labelText: 'ToDo title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ElevatedButton(
                  onPressed: () {
                    // Update task title
                    setState(() {
                      todo.todoText = controller.text;
                    });
                    _saveToDos(); // Save updated list
                    Navigator.pop(context);
                  },
                  child: const Text('Edit ToDo'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
