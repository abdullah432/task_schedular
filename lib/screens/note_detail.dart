import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:task_scheduler/models/note.dart';
import 'package:task_scheduler/screens/home.dart';
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
  String attendence = '';
  String location = '';
  String description = '';

  var minimumPadding = 5.0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  //today date
  final now = DateTime.now();
  DateTime startDate = DateTime.now();
  DateTime endDate;
  //time
  String starttime = 'Not Set';
  String duetime = 'Not Set';

  TextStyle textStyle;

  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController attendenceController = TextEditingController();

  //dynamic textfield
  List<TextEditingController> _highlightControllers;
  TextEditingController _highlightController;
  List<int> highlights;
  int highlightCount = 1;

  @override
  void initState() {
    endDate = new DateTime(now.year, now.month, now.day, 0, 0, 0);
    starttime = '${now.hour}:${now.minute}';
    duetime = '${now.hour}:${now.minute}';
    setPreviousValues();
    super.initState();
    highlights = new List<int>();
    highlights.add(highlightCount);
    _highlightControllers = new List<TextEditingController>();
    _highlightController = new TextEditingController();
  }

  @override
  void dispose() {
    locationController.dispose();
    descriptionController.dispose();
    attendenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    textStyle = Theme.of(context).textTheme.subtitle;

    locationController.text = this.note.location;
    descriptionController.text = this.note.description;
    attendenceController.text = this.note.attendence;

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
                Padding(
                    padding: EdgeInsets.only(
                            top: minimumPadding, bottom: minimumPadding) *
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
                        top: minimumPadding * 2, bottom: minimumPadding * 5),
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
                    padding: EdgeInsets.only(bottom: minimumPadding * 5),
                    child: TextField(
                      controller: attendenceController,
                      onChanged: (value) {
                        updateAttendence();
                      },
                      decoration: InputDecoration(
                          labelText: 'Attendance',
                          labelStyle: textStyle,
                          hintText: 'Enter Names',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
                      style: textStyle,
                    )),

                Row(
                  children: <Widget>[
                    Expanded(
                        child: ListTile(
                      title: Text(
                        'START',
                        style: textStyle,
                      ),
                      subtitle: Padding(
                          padding: const EdgeInsets.only(top: 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                  child: Text(
                                formatDate(startDate, [dd, ' ', MM, ' ', yyyy]),
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black45),
                              )),
                              Expanded(
                                  child: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black45,
                              ))
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
                            endDate = date;
                            debugPrint(
                                'startdate' + date.toString().substring(0, 10));
                            debugPrint('todaydate' +
                                DateTime.now().toString().substring(0, 10));
                          });
                        }, currentTime: startDate, locale: LocaleType.en);
                      },
                    )),
                    Expanded(
                        child: ListTile(
                      title: Text(
                        'START TIME',
                        style: textStyle,
                      ),
                      subtitle: Padding(
                          padding: const EdgeInsets.only(top: 7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                  child: Text(
                                starttime,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black45),
                              )),
                              Expanded(
                                  child: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black45,
                              ))
                            ],
                          )),
                      onTap: () {
                        DatePicker.showTimePicker(
                          context,
                            // theme: DatePickerTheme(
                            //   containerHeight: 210.0,
                            // ),
                            showTitleActions: true, onConfirm: (time) {
                          print('confirm $time');
                          starttime =
                              '${time.hour}:${time.minute}';
                          duetime =
                              '${time.hour}:${time.minute}';
                          setState(() {
                            this.note.setStartTime = starttime;
                            this.note.setDueTime = duetime;
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                    )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 13),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: Text(
                            'DUE DATE',
                            style: textStyle,
                          ),
                          subtitle: Padding(
                              padding: const EdgeInsets.only(top: 7),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                      child: Text(
                                    formatDate(
                                        endDate, [dd, ' ', MM, ' ', yyyy]),
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.black45),
                                  )),
                                  Expanded(
                                      child: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black45,
                                  ))
                                ],
                              )),
                          onTap: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2019, 1, 1),
                                maxTime: DateTime(2199, 12, 31),
                                onConfirm: (date) {
                              setState(() {
                                this.note.endDate = date.toString();
                                endDate = date;
                                debugPrint('startdate' + date.toString());
                                debugPrint(
                                    'todaydate' + DateTime.now().toString());
                              });
                            }, currentTime: endDate, locale: LocaleType.en);
                          },
                        ),
                      ),
                      Expanded(
                          child: ListTile(
                        title: Text(
                          'DUE TIME',
                          style: textStyle,
                        ),
                        subtitle: Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                  duetime,
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black45),
                                )),
                                Expanded(
                                    child: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black45,
                                ))
                              ],
                            )),
                        onTap: () {
                          DatePicker.showTimePicker(context,
                              showTitleActions: true, onConfirm: (time) {
                            print('confirm $time');
                            duetime =
                                '${time.hour}:${time.minute}';
                            setState(() {
                              this.note.setDueTime = duetime;
                            });
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                          // selectTime(context);
                          
                        },
                      )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ListTile(
                    title: Text(
                      'Privacy',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                    subtitle: getPrivacyDropDown(),
                  ),
                ),
                // ListView.builder(
                //     shrinkWrap: true,
                //     physics: ClampingScrollPhysics(),
                //     itemCount: highlights.length,
                //     itemBuilder: (context, index) {
                //       return _getHighlightItem(index);
                //     }),
                // Container(
                //   child: new RaisedButton(
                //     onPressed: () {
                //       setState(() {
                //         highlightCount++;
                //         highlights.add(highlightCount);
                //       });
                //     },
                //     color: Colors.blue,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       mainAxisSize: MainAxisSize.min,
                //       children: <Widget>[
                //         new Text(
                //           'ADD',
                //           style: new TextStyle(
                //               color: Colors.white, fontSize: 16.0),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                //     Container(
                //       child: new RaisedButton(
                //         onPressed: () {
                //           setState(() {
                //             // debugPrint('clicked');
                //             Printing.layoutPdf(
                //   onLayout: buildPdf,
                // );
                //           });
                //         },
                //         color: Colors.blue,
                //         child: new Text(
                //               'PRINT',
                //               style: new TextStyle(
                //                   color: Colors.white, fontSize: 16.0),
                //             ),
                //         ),
                //       ),

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

  void updateAttendence() {
    this.note.setAttendence = attendenceController.text;
  }

  void saveButton() async {

    //assign dropdown and date values because may be user leave it default
    assignDefaultValues();
    //check if textfield is null then assign at null
    // if (attendenceController.text == ''){
    //   this.note.setAttendence = 'null';
    // }
    // if (descriptionController.text == ''){
    //   this.note.description = 'null';
    // }
    if (locationController.text == ''){
      this.note.location = '.......';
    }

    debugPrint('save');
    debugPrint(note.title);
    debugPrint(note.description);
    debugPrint(note.attendence);
    debugPrint(note.startdate);
    debugPrint(note.enddate);
    debugPrint(note.starttime);
    debugPrint(note.duetime);
    debugPrint(note.privacy);
    debugPrint(note.getNote);
    debugPrint('after save');

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
      return TabBarPage();
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
    // debugPrint('title: ' + selectedTitle);
    // debugPrint('start: ' + startDate.toString());
    // debugPrint('end: ' + endDate.toString());
    this.note.title = selectedTitle;
    this.note.startDate = startDate.toString();
    this.note.endDate = endDate.toString();
    this.note.privacy = selectedPrivacy;
    this.note.setStartTime = starttime;
    this.note.setDueTime = duetime;
    this.note.setNote = '';
  }

  void setPreviousValues() {
    if (note.startdate.isNotEmpty) {
      startDate = DateTime.parse(note.startdate);
      endDate = DateTime.parse(note.enddate);
      selectedTitle = note.title;
      selectedPrivacy = note.privacy;
      starttime = note.starttime;
      duetime = note.duetime;
    }
  }

  _getHighlightItem(int index) {
    highlightCount = highlights.elementAt(index);

    return new Stack(
      children: <Widget>[
        Padding(
            padding:
                EdgeInsets.only(top: minimumPadding, bottom: minimumPadding),
            child: TextField(
              controller: _highlightController,
              onChanged: (value) {
                updateDescription();
              },
              decoration: InputDecoration(
                  labelText: 'Attendance',
                  labelStyle: textStyle,
                  hintText: 'Enter Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
              style: textStyle,
            )),
        highlights.length > 1
            ? new Positioned(
                top: 10.0,
                right: 0.0,
                child: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      if (highlightCount > 0) {
                        highlightCount--;
                        highlights.removeAt(index);
                      }
                    });
                  },
                ),
              )
            : new Container(),
      ],
    );
  }

  // TimeOfDay time = TimeOfDay.now();
  // TimeOfDay picked;
  // Future<Null> selectTime(BuildContext context) async{
  //   picked = await showTimePicker(context: context, initialTime:  time);

  //   setState(() {
  //     time = picked;
  //     // debugPrint('time: '+formatDate(time, [dd,]);
  //   });
  // }

  }
