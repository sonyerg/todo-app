import 'package:flutter/material.dart';
import 'package:todo_app/todo.dart';

class TodoItem extends StatelessWidget {
  final ToDo todo;
  final onToDoChanged;
  final onDeleteItem;
  final onEditItem;
  final addToDo;

  const TodoItem({
    super.key,
    required this.todo,
    this.onToDoChanged,
    this.onDeleteItem,
    this.onEditItem,
    this.addToDo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      child: ListTile(
        onTap: () {
          onToDoChanged(todo);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        tileColor: Colors.white,
        leading: Icon(
          todo.completed
              ? (Icons.check_box_outlined)
              : (Icons.check_box_outline_blank),
        ),
        title: Text(
          todo.todoText,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
            decoration: todo.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
          onSelected: (String value) {
            if (value == 'delete') {
              onDeleteItem(todo);
            } else if (value == 'edit') {
              onEditItem(todo);
            }
          },
        ),
      ),
    );
  }
}
