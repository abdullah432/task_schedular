import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_scheduler/models/MyTask.dart';
import 'package:task_scheduler/models/note.dart';
import 'package:task_scheduler/screens/note_detail.dart';
import 'package:task_scheduler/screens/task_items.dart';
import 'package:task_scheduler/utils/database_helper.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  List<Note> noteList;
  int count = 0;
  //date logic
  final now = DateTime.now();
  DateTime todayDate;
  DateTime tommoroDate;
  DateTime dayAfterTommoro;
  //list of dates
  List<Note> todayList = List();
  List<Note> tommoroList = List();
  List<Note> dayAfterTommoroList = List();
  int todayCount = 0;
  int tommoroCount = 0;
  int dayAfterTommoroCount = 0;

  @override
  void initState() {
    todayDate = DateTime(now.year, now.month, now.day);
    tommoroDate = DateTime(now.year, now.month, now.day + 1);
    dayAfterTommoro = DateTime(now.year, now.month, now.day + 2);
    debugPrint('todayDate: ' + todayDate.toString());
    debugPrint('tommoroDate: ' + tommoroDate.toString());
    debugPrint('dayAfterTommoro: ' + dayAfterTommoro.toString());
    super.initState();
  }

  // The entire multilevel list displayed by this app.
  List<MyTask> data = List();

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = new List<Note>();
      updateNoteList();
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'AddNote',
        child: Icon(Icons.add),
        onPressed: () {
          debugPrint("Add");
          navigateToDetail(Note('', '', '', '', '', ''), 'Add Task');
        },
      ),
      appBar: AppBar(title: Text('Task Scheduler')),
      body: getNoteList(),
    );
  }

  ListView getNoteList() {
    TextStyle titleStyle = Theme.of(context).textTheme.subtitle;
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => TaskItem(data[index]),
      itemCount: data.length,
    );
  }

  void navigateToDetail(Note note, String title) async {
    // bool result =
    //     await Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return NoteDetail(note, title);
    // }));

    // if (result) updateNoteList();
    bool result = await Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            NoteDetail(note, title),
      ),
    );
    if (result) updateNoteList();
  }

  void updateNoteList() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getTaskList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
          debugPrint('updateNoteList');
          if (noteList.isNotEmpty) arrangeDates();
        });
      });
    });
  }

  void arrangeDates() {
    data.clear();
    debugPrint('Length: ' + noteList.length.toString());
    List<DateTime> between = List();

    for (int i = 0; i < noteList.length; i++) {
      // debugPrint('start of dates $i: '+(noteList[i].startdate).toString());
      // debugPrint('end of dates $i: '+(noteList[i].enddate).toString());
      // if (now.compareTo())
      DateTime startDate = DateTime.parse(noteList[i].startdate);
      DateTime endDate = DateTime.parse(noteList[i].enddate);
      debugPrint('start dates $i: ' + (noteList[i].startdate).toString());
      debugPrint('end dates $i: ' + (noteList[i].enddate).toString());
      // for (DateTime start=startDate; start <= endDate; start.day+1){

      // }
      //get number of days between each task
      final days = endDate.difference(startDate).inDays;
      // debugPrint('Days: '+(days + 1).toString());
      debugPrint('days'+days.toString());
      //all dates between startDate and endDate
      for (int i = 0; i <= days; i++) {
        between
            .add(DateTime(startDate.year, startDate.month, startDate.day + i));
      }

      for (var b in between) {
        if (todayDate.compareTo(b) == 0) {
          todayList.add(noteList[i]);
        } else if (tommoroDate.compareTo(b) == 0) {
          tommoroList.add(noteList[i]);
          debugPrint('tommorodate: '+tommoroDate.toString());
          debugPrint('bdate: '+tommoroDate.toString());
        } else if (dayAfterTommoro.compareTo(b) == 0) {
          dayAfterTommoroList.add(noteList[i]);
        }
      }
      between.clear();
    }

    // debugPrint('today List: ' + todayList.toString());
    // debugPrint('tommoro List: ' + tommoroList.toString());
    // debugPrint('dayAfterTommoro List: ' + dayAfterTommoroList.toString());
    todayCount = todayList.length;
    tommoroCount = tommoroList.length;
    dayAfterTommoroCount = dayAfterTommoroList.length;

    // assign data to expandable list
    assignDataToExpandable();
  }

  void assignDataToExpandable() {
    List<MyTask> todaysubList = List();
    List<MyTask> tommorowsubList = List();
    List<MyTask> nextDaysubList = List();

    if (todayCount == 0) {
      data.add(new MyTask('Today', todayCount.toString()));
    } else {
      for (int i = 0; i < todayCount; i++) {
        todaysubList.add(
            MyTask(todayList[i].title, todayList[i].description, todayList[i]));
      }
      data.add(new MyTask('Today', todayCount.toString(), null, todaysubList));
      // subList.clear();
    }

    if (tommoroCount == 0) {
      data.add(new MyTask('Tommorow', tommoroCount.toString()));
    } else {
      for (int i = 0; i < tommoroCount; i++) {
        tommorowsubList.add(MyTask(
            tommoroList[i].title, tommoroList[i].description, tommoroList[i]));
      }
      data.add(new MyTask(
          'Tomorrow', tommoroCount.toString(), null, tommorowsubList));
      // subList.clear();
    }

    if (dayAfterTommoroCount == 0) {
      data.add(new MyTask('Next Day', dayAfterTommoroCount.toString()));
    } else {
      for (int i = 0; i < dayAfterTommoroCount; i++) {
        nextDaysubList.add(MyTask(dayAfterTommoroList[i].title,
            dayAfterTommoroList[i].description, dayAfterTommoroList[i]));
      }
      data.add(new MyTask(
          'Next Day', dayAfterTommoroCount.toString(), null, nextDaysubList));
      // subList.clear();
    }

    // data = <MyTask>[
    //   // for (int i=0; i<todayCount; i++) {

    //   // },
    //   MyTask('Today', [ MyTask('Section A0'), MyTask('Section A1'), MyTask('Section A2'),  ],),
    //   MyTask('Tomorrow', ),
    //   MyTask('Next Day',
    //     <MyTask>[
    //       MyTask('Section C0'),
    //       MyTask('Section C1'),
    //       MyTask('Section C2'),
    //     ],
    //   ),
    // ];
  }
}
