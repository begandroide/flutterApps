import 'package:flutter/material.dart';
import 'package:flutter_login_demo/services/authentication.dart';
import 'package:flutter_login_demo/models/todos.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_login_demo/models/todo.dart';
import 'package:flutter_login_demo/pages/draw_page.dart';
import 'dart:async';
import 'dart:ui';
import 'dart:typed_data';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> _todoList;
  List<Todos> _todosList;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _textEditingController = TextEditingController();
  final _textEditingControllerTwo = TextEditingController();
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;

  Query _todoQuery;

  @override
  void initState() {
    super.initState();
    _todoList = new List();
    _todoQuery = _database
        .reference()
        .child("todo")
        .orderByChild("userId")
        .equalTo(widget.userId);
    _onTodoAddedSubscription = _todoQuery.onChildAdded.listen(_onEntryAdded);
    _onTodoChangedSubscription = _todoQuery.onChildChanged.listen(_onEntryChanged);
  }

  @override
  void dispose() {
    _onTodoAddedSubscription.cancel();
    _onTodoChangedSubscription.cancel();
    super.dispose();
  }

  _onEntryChanged(Event event) {
    var oldEntry = _todoList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _todoList[_todoList.indexOf(oldEntry)] = Todo.fromSnapshot(event.snapshot);
    });
  }

  _onEntryAdded(Event event) {
    setState(() {
      _todoList.add(Todo.fromSnapshot(event.snapshot));
    });
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  _addNewTodo(String todoItem) {
    if (todoItem.length > 0) {

      Todo todo = new Todo(todoItem.toString(), widget.userId, false);
      _database.reference().child("todo").push().set(todo.toJson());
    }
  }

  _updateTodo(Todo todo){
    //Toggle completed
    todo.completed = !todo.completed;
    if (todo != null) {
      _database.reference().child("todo").child(todo.key).set(todo.toJson());
    }
  }

  _deleteTodo(String todoId, int index) {
    _database.reference().child("todo").child(todoId).remove().then((_) {
      print("Delete $todoId successful");
      setState(() {
        _todoList.removeAt(index);
      });
    });
  }

  _editTodo( String todoId,int index, String newSubject) {
    Map<String,String> insert = new Map<String,String>();
    insert.putIfAbsent("subject",()=>newSubject);
    _database.reference().child("todo").child(todoId).update(insert).then( (_) {
      print("edit $todoId successful");
      setState(() {
        _todoList.elementAt(index).subject = newSubject;
        //_todoList. updateAt(todoId);
      });
    });
  }



  _showDialogAdd(BuildContext context) async {
    _textEditingController.clear();
    await showDialog(
    // )
    // await showDialog<String>(
        context: context,
      builder: (BuildContext context) {
          return Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: new AppBar(title: new Center( child: Text("Add new todo"))),
            body: new Padding(
              padding: const EdgeInsets.all(16.0),
              child: new Column(
              children: <Widget>[
                // title todo
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new TextField(
                      controller: _textEditingController,
                      autofocus: true,
                      decoration: new InputDecoration(
                        labelText: 'Add Title Note',
                      ),),),
                      ],),
                // description todo
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new TextField(
                        maxLines: 3,
                    controller: _textEditingControllerTwo,
                    autofocus: true,
                    decoration: new InputDecoration(
                      labelText: 'Description',
                    ),),),],),
                new ButtonBar(
                    children: <Widget>[
                      MaterialButton( 
                        height: 10,
                        minWidth: 13,
                        padding: EdgeInsets.all(10.0),
                        child:  Icon( Icons.add_a_photo ),
                        onPressed: (){}, ),
                      MaterialButton(  
                        height: 10,
                        minWidth: 13,
                        padding: EdgeInsets.all(10.0),
                        child:  Icon( Icons.add_alarm ),
                        onPressed: (){}, ),
                      MaterialButton( 
                        height: 10,
                        minWidth: 13, 
                        padding: EdgeInsets.all(10.0),
                        child:  Icon( Icons.keyboard_voice ),
                        onPressed: (){}, ),
                      MaterialButton( 
                        height: 10,
                        minWidth: 13, 
                        padding: EdgeInsets.all(10.0),
                        child:  Icon( Icons.gesture ),
                        onPressed: (){
                          //build a new view 
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>DrawPage()),
                            );
                          // return new DrawPage();
                        }, ),
                    ],
                ), 
             //   new Divider(height: 240.0, color: Colors.blue,),
                new Row(
                  children: <Widget>[
                    new FlatButton(
                      textColor: Colors.white,
                      color: Colors.green,
                      child: const Text('Save'),
                      onPressed: () {
                        _addNewTodo(_textEditingController.text.toString());
                        Navigator.pop(context);
                      }
                    ),
                    new VerticalDivider(),
                    new FlatButton(
                      textColor: Colors.white,
                      color: Colors.red,
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                )
              ],
            ),
          ),
        );
      } 
    );
  }

  _showDialogEdit(BuildContext context, int index,Todo todo) async {
    _textEditingController.clear();
    _textEditingController.text = todo.subject;
    await showDialog<String>(
        context: context,
      builder: (BuildContext context) {
          return AlertDialog(
            content: new Row(
              children: <Widget>[
                new Expanded(child: new TextField(
                  controller: _textEditingController,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: 'Edit Todo -- Change the name',
                  ),
                ))
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('Save'),
                  onPressed: () {
                    _editTodo(todo.key, index, _textEditingController.text.toString());// _addNewTodo(_textEditingController.text.toString());
                    Navigator.pop(context);
                  })
            ],
          );
      }
    );
  }

  Widget _showTodoList() {
    if (_todoList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _todoList.length,
          itemBuilder: (BuildContext context, int index) {
            String todoId = _todoList[index].key;
            String subject = _todoList[index].subject;
            bool completed = _todoList[index].completed;
            String userId = _todoList[index].userId;
            return Dismissible(
              key: Key(todoId),
              background: Container(color: Colors.red),
              onDismissed: (direction) async {
                 _deleteTodo(todoId, index);
              },
              child: ListTile(
                onLongPress: (){
                  _showDialogEdit(context,index, _todoList[index]);
                    },
                  title: Text(
                  subject,
                  style: TextStyle(fontSize: 20.0),
                ),
                trailing: IconButton(
                    icon: (completed)
                        ? Icon(
                      Icons.done_outline,
                      color: Colors.purple,
                      size: 20.0,
                    )
                        : Icon(Icons.done, color: Colors.grey, size: 20.0),
                    onPressed: () {
                      _updateTodo(_todoList[index]);
                    }),
              ),
            );
          });
    } else {
      return Center(child: Text("Welcome. Your list is empty",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30.0),));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Center(
            child: new Text('Androides Notes')
            ),
          actions: <Widget>[
            new FlatButton(
                child: new Icon(
                  Icons.exit_to_app,
                  color:  Colors.white),
                onPressed: _signOut)
          ],
        ),
        body: _showTodoList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showDialogAdd(context);
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        )
    );
  }
}