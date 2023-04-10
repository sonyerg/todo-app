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
        completed: true,
      ),
      ToDo(
        id: '2',
        todoText: 'long press on a todo item to edit it',
        completed: false,
      ),
      ToDo(
        id: '3',
        todoText: 'Buy bread',
        completed: false,
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
}
