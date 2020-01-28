import 'package:flutter/material.dart';
import 'package:task_scheduler/screens/home.dart';
import 'package:task_scheduler/screens/note_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskSchedular',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: TabBarPage(),
    );
  }
}
