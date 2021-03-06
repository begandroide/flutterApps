import 'package:flutter/material.dart';
import 'package:template_flutter/screens/root_page.dart';
import 'package:template_flutter/screens/home_page.dart';
import 'package:template_flutter/services/authentication.dart';

class Routes {
  final routes = <String, WidgetBuilder>{
    '/Auth': (BuildContext context) => new RootPage(auth: new Auth()),
    '/Home': (BuildContext context) => new HomePage()
  };

  Routes () {
    runApp(new MaterialApp(
      title: 'Flutter Template',
      routes: routes,
      home: new RootPage(auth: new Auth()),
    ));
  }
}