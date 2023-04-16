import 'dart:convert';

class ToDo {
  String id;
  String todoText;
  bool completed;

  ToDo({
    required this.id,
    required this.todoText,
    this.completed = false,
  });

  static List<ToDo> todoList() {
    return [
      ToDo(
        id: '1',
        todoText: 'Press on a todo item to check it off and vice versa',
        completed: false,
      ),
      ToDo(
        id: '2',
        todoText: 'Tap on the three dots to edit or delete a todo item',
        completed: false,
      ),
      ToDo(
        id: '3',
        todoText: 'Tap on a todo item to check it off',
        completed: true,
      ),
      ToDo(
        id: '4',
        todoText: 'Buy butter',
        completed: false,
      ),
      ToDo(
        id: '5',
        todoText: 'Buy cheese',
        completed: false,
      ),
    ];
  }

  String toJson() {
    Map<String, dynamic> data = {
      'id': id,
      'todoText': todoText,
      'completed': completed,
    };
    return json.encode(data);
  }

  factory ToDo.fromJson(String jsonString) {
    Map<String, dynamic> data = json.decode(jsonString);
    return ToDo(
      id: data['id'],
      todoText: data['todoText'],
      completed: data['completed'],
    );
  }
}
