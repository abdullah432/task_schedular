import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:task_scheduler/models/note.dart';
import 'package:task_scheduler/screens/note_list.dart';
import 'package:task_scheduler/utils/database_helper.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  NoteDetail(this.note, this.appBarTitle);
  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(note, appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  String appBarTitle;
  Note note;
  NoteDetailState(this.note, this.appBarTitle);
  //title dropdown
  var titleDropDown = [
    'Metting',
    'Call Ons',
    'Conference',
    'Private Meetings',
    'Visits',
    'Presentation',
    'Briefs',
    'Discussion'
  ];
  String selectedTitle = 'Metting';
  //privacy dropdown
  var privacyDropDown = ['Public', 'Private', 'Confidential'];
  String selectedPrivacy = 'Public';

  var minimumPadding = 5.0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  //today date
  final now = DateTime.now();
  DateTime startDate = DateTime.now();
  DateTime endDate;

  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    endDate = new DateTime(now.year, now.month, now.day + 1, 0, 0, 0);
    debugPrint('tommoro' + endDate.toString());
    setPreviousValues();
    super.initState();
    // selectedValue = dropDown[0];
  }

  @override
  void dispose() {
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    locationController.text = this.note.location;
    descriptionController.text = this.note.description;

    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                moveToLastScreen();
              },
            ),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15, left: 10, right: 10),
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Title',
                    style: textStyle,
                  ),
                  subtitle: getTitleDropDown(),
                ),
                ListTile(
                  title: Text(
                    'START',
                    style: textStyle,
                  ),
                  subtitle: Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            formatDate(startDate, [dd, ' ', MM, ' ', yyyy]),
                            style:
                                TextStyle(fontSize: 17, color: Colors.black45),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          )
                        ],
                      )),
                  onTap: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(2018, 1, 1),
                        maxTime: DateTime(2199, 12, 31), onConfirm: (date) {
                      setState(() {
                        this.note.startDate = date.toString();
                        startDate = date;
                        debugPrint(
                            'startdate' + date.toString().substring(0, 10));
                        debugPrint('todaydate' +
                            DateTime.now().toString().substring(0, 10));
                      });
                    }, currentTime: startDate, locale: LocaleType.en);
                  },
                ),
                ListTile(
                  title: Text(
                    'DUE',
                    style: textStyle,
                  ),
                  subtitle: Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            formatDate(endDate, [dd, ' ', MM, ' ', yyyy]),
                            style:
                                TextStyle(fontSize: 17, color: Colors.black45),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          )
                        ],
                      )),
                  onTap: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(2019, 1, 1),
                        maxTime: DateTime(2199, 12, 31), onConfirm: (date) {
                      setState(() {
                        this.note.endDate = date.toString();
                        endDate = date;
                        debugPrint('startdate' + date.toString());
                        debugPrint('todaydate' + DateTime.now().toString());
                      });
                    }, currentTime: endDate, locale: LocaleType.en);
                  },
                ),
                ListTile(
                  title: Text(
                    'Privacy',
                    style: textStyle,
                  ),
                  subtitle: getPrivacyDropDown(),
                ),
                Padding(
                    padding: EdgeInsets.only(
                            top: minimumPadding * 3, bottom: minimumPadding) *
                        2,
                    child: TextField(
                      controller: locationController,
                      onChanged: (value) {
                        updateLocation();
                      },
                      decoration: InputDecoration(
                          labelText: 'RV',
                          labelStyle: textStyle,
                          hintText: 'Enter Location',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
                      style: textStyle,
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        top: minimumPadding * 3, bottom: minimumPadding * 5),
                    child: TextField(
                      controller: descriptionController,
                      onChanged: (value) {
                        updateDescription();
                      },
                      decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: textStyle,
                          hintText: 'Enter Description',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
                      style: textStyle,
                    )),
 
                Padding(
                  padding: EdgeInsets.only(top: minimumPadding * 2),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text('SAVE', style: TextStyle(fontSize: 16)),
                          onPressed: () {
                            saveButton();
                          },
                        ),
                      ),
                      Container(width: 5.0),
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text('DELETE', style: TextStyle(fontSize: 16)),
                          onPressed: () {
                            deleteButton();
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void updateLocation() {
    this.note.location = locationController.text;
  }

  void updateDescription() {
    this.note.description = descriptionController.text;
  }

  void saveButton() async {
    //assign dropdown and date values because may be user leave it default
    assignDefaultValues();

    int result;
    //   note.date = DateFormat.yMMMd().format(DateTime.now());

    if (note.id == null) {
      //insert operation
      result = await databaseHelper.insertTask(note);
      debugPrint('insert operation');
    } else {
      //update operation
      debugPrint('update operation');
      result = await databaseHelper.updateTask(note);
    }

    moveToLastScreen();

    if (result != 0) {
      showAlertDialog('Status', 'Task Saved Successfully');
    } else {
      showAlertDialog('Status', 'Fail to Saved');
    }
  }

  void deleteButton() async {
    moveToLastScreen();

    if (note.id == null) {
      showAlertDialog('Status', 'No task is deleted');
      return;
    } else {
      databaseHelper.deleteTask(note.id);
    }
  }

  void showAlertDialog(String title, String msg) {
    AlertDialog alertDialog =
        AlertDialog(title: Text(title), content: Text(msg));
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void moveToLastScreen() {
    // Navigator.pop(context, true);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return NoteList();
    }));
  }

  getTitleDropDown() {
    return DropdownButton<String>(
      items: titleDropDown.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      value: selectedTitle,
      onChanged: (String newValueSelected) {
        setState(() {
          this.note.title = newValueSelected;
          selectedTitle = newValueSelected;
        });
      },
    );
  }

  getPrivacyDropDown() {
    return DropdownButton<String>(
      items: privacyDropDown.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      value: selectedPrivacy,
      onChanged: (String newValueSelected) {
        setState(() {
          this.note.privacy = newValueSelected;
          selectedPrivacy = newValueSelected;
        });
      },
    );
  }

  //assign dropdown and date values because may be user leave it default
  void assignDefaultValues() {
    debugPrint('title: ' + selectedTitle);
    debugPrint('start: ' + startDate.toString());
    debugPrint('end: ' + endDate.toString());
    this.note.title = selectedTitle;
    this.note.startDate = startDate.toString();
    this.note.endDate = endDate.toString();
    this.note.privacy = selectedPrivacy;
  }

  void setPreviousValues() {
    if (note.startdate.isNotEmpty) {
      startDate = DateTime.parse(note.startdate);
      endDate = DateTime.parse(note.enddate);
      selectedTitle = note.title;
      selectedPrivacy = note.privacy;
    }
  }
}
