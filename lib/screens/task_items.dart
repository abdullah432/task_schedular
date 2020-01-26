// Displays one Task. If the entry has children then it's displayed
// with an ExpansionTile.
import 'package:flutter/material.dart';
import 'package:task_scheduler/models/MyTask.dart';
import 'package:task_scheduler/models/note.dart';
import 'package:task_scheduler/screens/note_detail.dart';

class TaskItem extends StatefulWidget {
  final MyTask task;
  TaskItem(this.task);

  @override
  State<StatefulWidget> createState() {
    return TaskItemState(task);
  }

}

class TaskItemState extends State<TaskItem>{
  MyTask task;
  TaskItemState(this.task);
  bool called = false;

  Widget _buildTiles(MyTask task) {
    if (task.children.isEmpty)
      return ListTile(
        title: Text(task.title),
        subtitle: Text(task.subtitle),
        onTap: () {
          debugPrint(task.note.location);
          debugPrint(task.note.description);
          navigateToDetail(task.note, 'Edit Task');
        },
      );
    return ExpansionTile(
      key: PageStorageKey<MyTask>(task),
      title: Text(task.title),
      subtitle: Text(task.subtitle),
      children: task.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(task);
  }

   void navigateToDetail(Note note, String title) async{
    // bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return NoteDetail(note, title);
    // }));

    // if (result)
    //   updateNoteList();

     Navigator.pushReplacement(
      context, 
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => NoteDetail(note,title),
    ),
);
  }
}
