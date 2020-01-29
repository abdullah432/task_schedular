import 'package:task_scheduler/models/note.dart';

class SecondTask {
  Note note;
  String title;
  String subtitle;
  String date;
  String taskNote;
  List<SecondTask> children;
  //list of data
  // List<Note> callOnsData;
  // List<Note> conferenceData;
  // List<Note> visitsData;

  SecondTask(this.title, [this.subtitle, this.note, this.date, this.taskNote, this.children = const <SecondTask>[]]);
  // MyTask.fromMyTask(this.title, [this.subtitle, this.todayList, this.tommorowList, this.nextDayList, this.children = const <MyTask>[]]);
}