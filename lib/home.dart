import 'package:flutter/material.dart';

import '../data.dart';
import '../task.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final taskList = Task.taskList();
  List<Task> _foundTask = [];
  final _taskInput = TextEditingController();

  @override
  void initState() {
    _foundTask = taskList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEFF5),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 50,
                          bottom: 20,
                        ),
                        child: Text(
                          'Tasks',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      for (Task taskk in _foundTask.reversed)
                        TaskItem(
                          task: taskk,
                          onTaskChanged: _handleTaskChange,
                          onDeleteItem: _deleteTaskItem,
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                    left: 20,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _taskInput,
                    decoration: InputDecoration(
                        hintText: 'Add a new routine task',
                        border: InputBorder.none),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: 20,
                  right: 20,
                ),
                child: ElevatedButton(
                  child: Text(
                    '+',
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                  onPressed: () {
                    _addTaskItem(_taskInput.text);
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF5F52EE),
                    minimumSize: Size(60, 60),
                    elevation: 10,
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void _handleTaskChange(Task task) {
    setState(() {
      task.isDone = !task.isDone;
    });
  }

  void _deleteTaskItem(String id) {
    setState(() {
      taskList.removeWhere((item) => item.id == id);
    });
  }

  void _addTaskItem(String inputTask) {
    setState(() {
      taskList.add(Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        taskText: inputTask,
      ));
    });
    _taskInput.clear();
  }

  void _runFilter(String enteredKeyword) {
    List<Task> results = [];
    if (enteredKeyword.isEmpty) {
      results = taskList;
    } else {
      results = taskList
          .where((item) => item.taskText! //change
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundTask = results;
    });
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: Color(0xFF3A3A3A),
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: Color(0xFF717171)),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xFFEEEFF5),
      elevation: 0,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Icon(
          Icons.menu,
          color: Color(0xFF3A3A3A),
          size: 30,
        ),
        Container(
          height: 40,
          width: 40,
          // child: ClipRRect(
          //   borderRadius: BorderRadius.circular(20),
          //   child: Image.asset('assets/images/avatar.jpeg'),
          // ),
        ),
      ]),
    );
  }
}
