import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  //atributes
  int _currentIndex = 0;
  final List<Widget> _children = [
    Card(child:Center(child: Text("Page 1"),)),
    Card(child:Center(child: Text("Page 2"),)),
    Card(child:Center(child: Text("Page 3"),)),
    Card(child:Center(child: Text("Page 4"),)),
 ];

//methods
void onTabTapped(int index) {
   setState(() {
     _currentIndex = index; 
   });
 }

@override
 Widget build(BuildContext context) {
  
    return Scaffold(
      body: new DefaultTabController(
      length: 4,
      child: new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Center(child: new Text("begandroide"),),
        ),
        body: new Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(40),
          child: _children[_currentIndex],
        ) 
        ),
      ),
     bottomNavigationBar: BottomNavigationBar(
       type: BottomNavigationBarType.fixed,
       onTap: onTabTapped, // new
       currentIndex: _currentIndex, // new
       items: [
         new BottomNavigationBarItem(
           icon: Icon(Icons.home),
           title: Text('Home'),
         ),
         new BottomNavigationBarItem(
           icon: Icon(Icons.mail),
           title: Text('Notificaciones'),
         ),
         new BottomNavigationBarItem(
           icon: Icon(Icons.monetization_on),
           title: Text('Promociones')
         ),
         new BottomNavigationBarItem(
           icon: Icon(Icons.person),
           title: Text('Usuario')
         ),
         
       ],
     ),
   );
 }
}