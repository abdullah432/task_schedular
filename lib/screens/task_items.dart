// Displays one Task. If the entry has children then it's displayed
// with an ExpansionTile.
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:printing/printing.dart';
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

class TaskItemState extends State<TaskItem> {
  MyTask task;
  TaskItemState(this.task);
  bool called = false;
  List<Note> dataList;
  //Date
  final now = DateTime.now();
  DateTime todayDate;
  DateTime tommoroDate;
  DateTime nextDay;
  DateTime selectedDate;

  DateTime currentTime;

  @override
  void initState() {
    currentTime = DateTime(now.hour,now.minute);
    super.initState();
  }

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
      trailing: GestureDetector(
          onTap: () {
            printDocument(task.title);
          },
          child: Icon(Icons.print)),
      children: task.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(task);
  }

  void navigateToDetail(Note note, String title) async {
    // bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return NoteDetail(note, title);
    // }));

    // if (result)
    //   updateNoteList();

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            NoteDetail(note, title),
      ),
    );
  }

  void printDocument(String choice) {
    switch (choice) {
      case 'Today':
        dataList = task.todayData;
        selectedDate = DateTime(now.year, now.month, now.day);
        break;
      case 'Tomorrow':
        dataList = task.tommorowData;
        selectedDate = DateTime(now.year, now.month, now.day + 1);
        break;
      case 'Next Day':
        dataList = task.nexdayData;
        selectedDate = DateTime(now.year, now.month, now.day + 2);
        break;
    }
    setState(() {
      buildPdfDoument();
    });
  }

  void buildPdfDoument() {
    setState(() {
      debugPrint('clicked');
      // debugPrint(task.tommorowList.length.toString());

      Printing.layoutPdf(
        onLayout: buildPdf,
      );
    });
  }

    // PdfPageFormat pdformat = new PdfPageFormat(288.0, 432.0);
  List<int> buildPdf(PdfPageFormat format) {
    final pdf.Document doc = pdf.Document();
    debugPrint('format: '+format.toString());
    doc.addPage(pdf.Page(
        pageFormat: format,
        build: (pdf.Context context) {
          return pdf.Column(children: <pdf.Widget>[
            pdf.Padding(
                padding: pdf.EdgeInsets.all(15),
                child: pdf.Align(
                    alignment: pdf.Alignment.topLeft,
                    child: pdf.Container(
                        child: pdf.Row(
                            mainAxisAlignment:
                                pdf.MainAxisAlignment.spaceBetween,
                            children: <pdf.Widget>[
                          pdf.Flexible(
                              flex: 1,
                              child: pdf.FittedBox(
                                  fit: pdf.BoxFit.fitWidth,
                                  child: pdf.Padding(
                                    padding: pdf.EdgeInsets.only(right: 40),
                                    child: pdf.Text(
                                        formatDate(selectedDate,
                                            [dd, ' ', MM, ' ', yyyy]),
                                        style: pdf.TextStyle(fontSize: 18)),
                                  ))),
                          pdf.Flexible(
                              flex: 1,
                              child: pdf.FittedBox(
                                  fit: pdf.BoxFit.fitWidth,
                                  child: pdf.Padding(
                                      padding: pdf.EdgeInsets.only(left: 30),
                                      child: pdf.Text(
                                        'Updated: ' +
                                           formatDate(now, [HH,':',nn]),
                                      ))))
                        ])))),
            pdf.Expanded(
                child: pdf.Container(
              padding: pdf.EdgeInsets.all(10),
              margin: pdf.EdgeInsets.all(10),
              decoration: pdf.BoxDecoration(
                  border: pdf.BoxBorder(
                      top: true,
                      bottom: true,
                      left: true,
                      right: true,
                      color: PdfColors.black,
                      width: 1.5)),
              child: dataCoulumnBody(),
            ))
          ]);
        }));
    return doc.save();
  }

  pdf.Widget dataCoulumnBody() {
    return pdf.Column(children: <pdf.Widget>[
      pdf.Table(border: pdf.TableBorder(), children: [
        pdf.TableRow(children: [
          pdf.Expanded(
              flex: 6,
              child: pdf.Padding(
                  child: pdf.Flexible(
                      // flex: 1,
                      child: pdf.Container(
                          child: pdf.FittedBox(
                                fit: pdf.BoxFit.scaleDown,
                              child: pdf.Text('Name and Appt',
                                  style: pdf.TextStyle(
                                      fontSize: 22,
                                      fontWeight: pdf.FontWeight.bold))))),
                  padding: pdf.EdgeInsets.only(left: 20, right: 20,top: 10))),
          pdf.Expanded(
              flex: 2,
              child: pdf.Padding(
                  child: pdf.Flexible(
                      // flex: 1,
                      child: pdf.Container(
                          child: pdf.FittedBox(
                            fit: pdf.BoxFit.scaleDown,
                              child: pdf.Align(alignment: pdf.Alignment.centerLeft ,child: pdf.Text('Timing',
                                  style: pdf.TextStyle(
                                      fontSize: 22,
                                      fontWeight: pdf.FontWeight.bold)))))),
                  padding: pdf.EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 5))),
          pdf.Expanded(
              flex: 2,
              child: pdf.Padding(
                  child: pdf.Flexible(
                      // flex: 1,
                      child: pdf.Container(
                          child: pdf.FittedBox(
                            fit: pdf.BoxFit.scaleDown,
                              child: pdf.Text('RV',
                                  style: pdf.TextStyle(
                                      fontSize: 22,
                                      fontWeight: pdf.FontWeight.bold))))),
                  padding: pdf.EdgeInsets.only(left: 15, right: 15,top: 15, bottom: 15))),
        ]),
      ]),
      pdf.Table(border: pdf.TableBorder(), children: [
        for (var i in dataList)
          pdf.TableRow(children: [
            pdf.Expanded(
                flex: 6,
                child: pdf.Padding(
                    padding: pdf.EdgeInsets.all(5),
                    child: pdf.RichText(
                      text: new pdf.TextSpan(
                        text: i.title + ' ' + i.description + ': ',
                        style: pdf.TextStyle(
                            decoration: pdf.TextDecoration.underline,
                            fontWeight: pdf.FontWeight.bold),
                        children: <pdf.TextSpan>[
                          new pdf.TextSpan(
                              text: i.attendence,
                              style: new pdf.TextStyle(
                                  decoration: pdf.TextDecoration.none,
                                  fontWeight: pdf.FontWeight.normal)),
                        ],
                      ),
                    ))),
            pdf.Expanded(
                flex: 2,
                child: pdf.Padding(
                    padding: pdf.EdgeInsets.all(5),
                    child: pdf.Text(i.starttime + ' - ' + i.duetime))),
            pdf.Expanded(
                flex: 2,
                child: pdf.Padding(
                    padding: pdf.EdgeInsets.all(5), child:
                    pdf.FittedBox(fit:pdf.BoxFit.fitWidth, child: pdf.Text(i.location)))),
          ])
      ]),
    ]);
  }
}
