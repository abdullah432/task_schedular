import 'package:task_scheduler/models/note.dart';

class MyTask {
  Note note;
  String title;
  String subtitle;
  List<MyTask> children;

  MyTask(this.title, [this.subtitle, this.note, this.children = const <MyTask>[]]);
}