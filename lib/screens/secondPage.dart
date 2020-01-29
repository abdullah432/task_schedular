import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_scheduler/models/MyTask.dart';
import 'package:task_scheduler/models/SeondTask.dart';
import 'package:task_scheduler/models/note.dart';
import 'package:task_scheduler/screens/note_detail.dart';
import 'package:task_scheduler/screens/second_task_list.dart';
import 'package:task_scheduler/screens/task_items.dart';
import 'package:task_scheduler/utils/database_helper.dart';

class SecondPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SecondPageState();
  }
}

class SecondPageState extends State<SecondPage> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  List<Note> noteList;
  int count = 0;
  //date logic
  final now = DateTime.now();
  DateTime todayDate;
  DateTime tommoroDate;
  DateTime dayAfterTommoro;
  //list of dates
  List<Note> callonsMettingList = List();
  List<Note> conferenceList = List();
  List<Note> visitsList = List();
  int callonsMettingCount = 0;
  int conferenceListCount = 0;
  int visitsListCount = 0;

  @override
  void initState() {
    super.initState();
  }

  // The entire multilevel list displayed by this app.
  List<SecondTask> data = List();

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = new List<Note>();
      updateNoteList();
    }

    return Scaffold(
      floatingActionButton: Container(
        height: 60.0,
        width: 60.0,
        child: FittedBox(
          child: FloatingActionButton(
              tooltip: 'AddNote',
              child: Icon(
                Icons.add,
                size: 30,
              ),
              onPressed: () {
                navigateToDetail(
                    Note('', '', '', '', '', '', '', '','',''), 'Add Task');
              }),
        ),
      ),
      // FloatingActionButton(
      //   tooltip: 'AddNote',
      //   child: Icon(Icons.add,),
      //   onPressed: () {
      //     debugPrint("Add");
      //     navigateToDetail(Note('', '', '', '', '', '', '', ''), 'Add Task');
      //   },
      // ),
      body: getNoteList(),
    );
  }

  ListView getNoteList() {
    TextStyle titleStyle = Theme.of(context).textTheme.subtitle;
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => SecondTaskItem(data[index]),
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
    // if (result) updateNoteList();
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

    for (int i = 0; i < noteList.length; i++) {
      if (noteList[i].title == 'Call Ons' || noteList[i].title == 'Metting')
        callonsMettingList.add(noteList[i]);
      else if (noteList[i].title == 'Conference')
        conferenceList.add(noteList[i]);
      else if (noteList[i].title == 'Visits')
        visitsList.add(noteList[i]);
    }

    // debugPrint('today List: ' + todayList.toString());
    // debugPrint('tommoro List: ' + tommoroList.toString());
    // debugPrint('dayAfterTommoro List: ' + dayAfterTommoroList.toString());
    callonsMettingCount = callonsMettingList.length;
    conferenceListCount = conferenceList.length;
    visitsListCount = visitsList.length;

    // assign data to expandable list
    assignDataToExpandable();
  }

  void assignDataToExpandable() {
    List<SecondTask> callonMettingsubList = List();
    List<SecondTask> conferencesubList = List();
    List<SecondTask> visitssubList = List();

    if (callonsMettingCount == 0) {
      // data.add(new SecondTask('Call Ons + Metting', callonsMettingCount.toString(), null, ''));
    } 
    else {
      for (int i = 0; i < callonsMettingCount; i++) {
        debugPrint('callons: '+callonsMettingList[i].title);
        callonMettingsubList.add(
            SecondTask(callonsMettingList[i].title, callonsMettingList[i].description, callonsMettingList[i], callonsMettingList[i].startdate, callonsMettingList[i].getNote));
      }
      data.add(new SecondTask('Call Ons + Metting', callonsMettingCount.toString(), null, '','', callonMettingsubList));
      // subList.clear();
    }

    if (conferenceListCount == 0) {
      // data.add(new SecondTask('Conference', conferenceListCount.toString(), null, ''));
    } else {
      for (int i = 0; i < conferenceListCount; i++) {
        conferencesubList.add(SecondTask(
            conferenceList[i].title, conferenceList[i].description, conferenceList[i], conferenceList[i].startdate, conferenceList[i].getNote));
      }
      data.add(new SecondTask('Conferences', conferenceListCount.toString(), null, '','', conferencesubList));
      // subList.clear();
    }

    if (visitsListCount == 0) {
      // data.add(new SecondTask('Visit', visitsListCount.toString(), null, ''));
    } else {
      for (int i = 0; i < visitsListCount; i++) {
        visitssubList.add(SecondTask(visitsList[i].title,
            visitsList[i].description, visitsList[i], visitsList[i].startdate, visitsList[i].getNote));
      }
      data.add(new SecondTask('Visits', visitsListCount.toString(), null, '','', visitssubList));
      // subList.clear();
    }
  }
}
