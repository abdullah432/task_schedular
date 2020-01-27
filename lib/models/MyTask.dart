import 'package:task_scheduler/models/note.dart';

class MyTask {
  Note note;
  String title;
  String subtitle;
  List<MyTask> children;
  //list of data
  List<Note> todayData;
  List<Note> tommorowData;
  List<Note> nexdayData;

  MyTask(this.title, [this.subtitle, this.note, this.todayData,this.tommorowData, this.nexdayData, this.children = const <MyTask>[]]);
  // MyTask.fromMyTask(this.title, [this.subtitle, this.todayList, this.tommorowList, this.nextDayList, this.children = const <MyTask>[]]);
}