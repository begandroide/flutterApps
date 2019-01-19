import 'package:flutter/material.dart';
import './homeWidget.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext ctxt) {
    return new MaterialApp(
      title: "Navigation Bottom",
      theme: new ThemeData(
        primaryColor: Colors.orange,
      ),
      home: Home(),
    );
  }
}
