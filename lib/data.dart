class Task {
  String? id;
  String? taskText;
  bool isDone;

  Task({
    required this.id,
    required this.taskText,
    this.isDone = false,
  });

  static List<Task> taskList() {
    return [
      Task(id: '01', taskText: 'Morning Excercise', isDone: true),
      Task(id: '02', taskText: 'Buy Groceries', isDone: true),
      Task(
        id: '03',
        taskText: 'Check Emails',
      ),
      Task(
        id: '04',
        taskText: 'Team Meeting',
      ),
      Task(
        id: '05',
        taskText: 'Work on mobile apps for 2 hour',
      ),
      Task(
        id: '06',
        taskText: 'Dinner with Jenny',
      ),
    ];
  }
}
