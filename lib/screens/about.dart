import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About'),leading: IconButton(icon:Icon(Icons.arrow_back),
          onPressed:() => Navigator.pop(context, false),
        )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
Text('AM Consultants &', style: TextStyle(fontWeight: FontWeight.bold),),
Text('Warsi Computer Technology', style: TextStyle(fontWeight: FontWeight.bold)),
          ],),
      ) 
    );
  }
}
