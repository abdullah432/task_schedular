// Displays one Task. If the entry has children then it's displayed
// with an ExpansionTile.
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_scheduler/models/SeondTask.dart';
import 'package:task_scheduler/models/note.dart';
import 'package:task_scheduler/screens/note_detail.dart';

class SecondTaskItem extends StatefulWidget {
  final SecondTask task;
  SecondTaskItem(this.task);

  @override
  State<StatefulWidget> createState() {
    return SecondTaskItemState(task);
  }
}

class SecondTaskItemState extends State<SecondTaskItem> {
  SecondTask task;
  SecondTaskItemState(this.task);

  String date;
  TextEditingController _editingController = TextEditingController();
  FocusNode focusNode;
  String currentNote;

  @override
  void initState() {
    focusNode = new FocusNode();

    // listen to focus changes
    focusNode.addListener(
        () => print('focusNode updated: hasFocus: ${focusNode.hasFocus}'));
    super.initState();
  }

  Widget _buildTiles(SecondTask task) {
    if (task.date != null && task.date != '') {
      DateTime datetime = DateTime.parse(task.date);
      date = formatDate(datetime, [dd, ' ', MM, ' ', yyyy]);
    } else
      date = '';

    if (task.children.isEmpty)
      return ListTile(
        title: Text(task.title),
        subtitle: Text(task.subtitle),
        onTap: () {
          debugPrint(task.note.location);
          debugPrint(task.note.description);
          navigateToDetail(task.note, 'Edit Task');
        },
        trailing: Text(date),
      );
    return ExpansionTile(
      key: PageStorageKey<SecondTask>(task),
      title: Text(task.title),
      subtitle: Text(task.subtitle),
      trailing: GestureDetector(
        child: Icon(Icons.event_note),
        onTap: () {
          showNotePopup();
        },
      ),
      children: task.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(task);
  }

  void navigateToDetail(Note note, String title) async {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            NoteDetail(note, title),
      ),
    );
  }

  void showNotePopup() async{
    var pref = await SharedPreferences.getInstance();
    if (task.title == 'Call Ons + Metting'){
      currentNote = 'Call Ons + Metting';
      _editingController.text = pref.getString('callOns') ?? '';
    }else if (task.title == 'Conference'){
      currentNote = 'Conference';
      _editingController.text = pref.getString('Conference') ?? '';
    }else if (task.title == 'Visit'){
      currentNote = 'Visit';
      _editingController.text = pref.getString('Visit') ?? '';
    }
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Center(child: Text("Note")),
          content: EditableText(
            textAlign: TextAlign.start,
            maxLines: null,
            focusNode: focusNode,
            controller: _editingController,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
            // keyboardType: TextInputType.multiline,
            cursorColor: Colors.blue,
            backgroundCursorColor: Colors.blue,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: new Text("Update"),
              onPressed: () {
                if (currentNote == 'Call Ons + Metting')
                  pref.setString('callOns', _editingController.text);
                else if (currentNote == 'Conference')
                  pref.setString('Conference', _editingController.text);
                else if (currentNote == 'Visit')
                  pref.setString('Visit', _editingController.text);

                // showSnackBar(context, 'Updated Sucessfully');
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: new Text("Delete"),
              onPressed: () {
                if (currentNote == 'Call Ons + Metting')
                  pref.setString('callOns', '');
                else if (currentNote == 'Conference')
                  pref.setString('Conference', '');
                else if (currentNote == 'Visit')
                  pref.setString('Visit', '');
                //show success msg
                // showSnackBar(context, 'Deleted Sucessfully');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void setFocus() {
    FocusScope.of(context).requestFocus(focusNode);
  }

  // void showSnackBar(context, msg) {
  //   SnackBar snackbar = SnackBar(content: Text(msg));
  //   Scaffold.of(context).showSnackBar(snackbar);
  // }
}
