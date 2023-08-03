import 'package:hive_flutter/hive_flutter.dart';

class DataBase {
  List dbList = [];

  // reference our box
  final _myBox = Hive.box('mybox');

  // run this method if this is the 1st time ever opening this app
  void createInitialData() {
    dbList = [
      ["DSA practice", false],
      ["Athletics Practise", false],
      ["Drink 1.5 Litre Water", false],
      ["Read Book 30 min", false],
    ];
  }

  // load the data from database
  void loadData() {
    dbList = _myBox.get("TASKLIST");
  }

  // update the database
  void updateDataBase() {
    _myBox.put("TASKLIST", dbList);
  }

  void resetall() {
    for (int i = 0; i < dbList.length; i++) {
      dbList[i][1] = false;
    }
  }
}
