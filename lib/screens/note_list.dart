import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_scheduler/models/note.dart';
import 'package:task_scheduler/screens/note_detail.dart';
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
  DateTime tommoro;
  DateTime dayAfterTommoro;

  @override
  void initState() {
    tommoro = DateTime(now.year, now.month, now.day + 1);
    dayAfterTommoro = DateTime(now.year, now.month, now.day + 2);
    debugPrint('tommoro: ' + tommoro.toString());
    debugPrint('dayAfterTommoro: ' + dayAfterTommoro.toString());
    super.initState();
  }

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
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('Today'),
          trailing: Text('$count Tasks'),
        ),
        ListTile(
          title: Text('Tomorrow'),
          trailing: Text('0 Tasks'),
        ),
        ListTile(
          title: Text('Next days'),
          trailing: Text('0 Tasks'),
        ),
      ],
    );
  }

  void navigateToDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));

    if (result) updateNoteList();
  }

  // Color getPriorityColor(int priority) {
  //   switch (priority) {
  //     case 1:
  //       return Colors.red;
  //       break;
  //     case 2:
  //       return Colors.yellow;
  //       break;
  //     default:
  //       return Colors.yellow;
  //   }
  // }

  // Icon getPriorityIcon(int priority) {
  //   switch (priority) {
  //     case 1:
  //       return Icon(Icons.play_arrow);
  //       break;
  //     case 2:
  //       return Icon(Icons.keyboard_arrow_right);
  //       break;

  //     default:
  //       return Icon(Icons.keyboard_arrow_right);
  //   }
  // }

  // void deleteNote(BuildContext context, int id) async {
  //   int result = await databaseHelper.deleteTask(id);
  //   if (result != 0) {
  //     showSnackBar(context, 'Note is successfully Deleted');
  //   }
  // }

  // void showSnackBar(context, msg) {
  //   SnackBar snackbar = SnackBar(content: Text(msg));
  //   Scaffold.of(context).showSnackBar(snackbar);
  // }

  void updateNoteList() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getTaskList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
          arrangeDates();
        });
      });
    });
  }

  void arrangeDates() {
    for (int i = 0; i < noteList.length; i++) {
      debugPrint('start of dates $i: '+(noteList[i].startdate).toString());
      debugPrint('end of dates $i: '+(noteList[i].enddate).toString());
    }
  }
}
