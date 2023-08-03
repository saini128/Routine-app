import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../task.dart';
import '../taskdata.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DataBase db = DataBase();
  final _myBox = Hive.box('mybox');
  final _reset = Hive.box('mybox');
  final _taskInput = TextEditingController();
  DateTime now = DateTime.now();
  @override
  void initState() {
    if (_myBox.get("TASKLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    if (_reset.get("TIME") != null) {
      DateTime prev = _reset.get("TIME");
      DateTime next = DateTime(prev.year, prev.month, prev.day + 1);
      if (now.isAfter(next)) {
        db.resetall();
        _reset.put("TIME", now);
      }
    } else {
      _reset.put("TIME", now);
    }
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
              vertical: 5,
            ),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 30,
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
                      for (int i = 0; i < db.dbList.length; i++)
                        TaskItem(
                          taskName: db.dbList[i][0],
                          taskCompleted: db.dbList[i][1],
                          onTaskChanged: () {
                            setState(() {
                              db.dbList[i][1] = !db.dbList[i][1];
                            });
                            db.updateDataBase();
                          },
                          onDeleteItem: () {
                            setState(() {
                              db.dbList.removeAt(i);
                            });
                            db.updateDataBase();
                          },
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

  void _addTaskItem(String inputTask) {
    if (inputTask.isNotEmpty) {
      setState(() {
        db.dbList.add([inputTask, false]);
      });
    }

    db.updateDataBase();
    _taskInput.clear();
  }

  void _runFilter(String enteredKeyword) {
    List results = [];
    if (enteredKeyword.isEmpty) {
      results = _myBox.get("TASKLIST");
    } else {
      for (int i = 0; i < db.dbList.length; i++) {
        if (db.dbList[i][0]
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase())) {
          results.add(db.dbList[i]);
        }
      }
    }

    setState(() {
      db.dbList = results;
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
        IconButton(
          color: Colors.black,
          iconSize: 28,
          icon: Icon(Icons.info),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("App Dev Workshop by Frosh x CCS"),
              duration: Duration(seconds: 2),
            ));
          },
        ),
      ]),
    );
  }
}
