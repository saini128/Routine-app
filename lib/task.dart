import 'package:flutter/material.dart';

import '../data.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final onTaskChanged;
  final onDeleteItem;

  const TaskItem({
    Key? key,
    required this.task,
    required this.onTaskChanged,
    required this.onDeleteItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          onTaskChanged(task);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        leading: Icon(
          task.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: Color(0xFF5F52EE),
        ),
        title: Text(
          task.taskText!,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF3A3A3A),
            decoration: task.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.symmetric(vertical: 12),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: Color(0xFFDA4040),
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            color: Colors.white,
            iconSize: 18,
            icon: Icon(Icons.delete),
            onPressed: () {
              // print('Clicked on delete icon');
              onDeleteItem(task.id);
            },
          ),
        ),
      ),
    );
  }
}
