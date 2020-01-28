import 'package:flutter/material.dart';
import 'package:task_scheduler/screens/about.dart';
import 'package:task_scheduler/screens/note_list.dart';
import 'package:task_scheduler/screens/secondPage.dart';

class TabBarPage extends StatefulWidget {
    @override
  State<StatefulWidget> createState() {
    return TabBarPageState();
  }
}

class TabBarPageState extends State<TabBarPage> {
  var choices = ['About'];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.receipt),),
                Tab(icon: Icon(Icons.note),),
              ],
            ),
            title: Center(child: Text('Task Scheduler')),
            actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value){navigateToAbout();},
            itemBuilder: (BuildContext context){
              return choices.map((String choice){
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],

          ),
          body: TabBarView(
            children: [
              NoteList(),
              SecondPage(),
            ],
          ),
        ),
      ),
    );
  }

    void navigateToAbout() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AboutPage();
    }));
  }
}