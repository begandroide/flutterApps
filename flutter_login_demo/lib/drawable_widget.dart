import 'package:flutter/material.dart';

class Episode3 extends StatelessWidget {
  var accpeptedData = 0;

  
  _showDialogAdd(BuildContext context) async {
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
                    labelText: 'Add new todo',
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
                    _addNewTodo(_textEditingController.text.toString());
                    Navigator.pop(context);
                  })
            ],
          );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
       floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showDialogAdd(context);
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 50.0,
            left: 20.0,
            child: DragTarget(
              builder: (BuildContext context, List<dynamic> accepted,
                      List<dynamic> rejected) =>
                  Container(
                    height: 200.0,
                    width: 200.0,
                    decoration: BoxDecoration(color: Colors.cyan),
                    child: Dismissible(
                        key: Key("1"),
                        background: Container(color: Colors.red),
                        onDismissed: (direction) async {
                          //_deleteTodo(todoId, index);
                        },
                        child: ListTile(
                          onLongPress: (){
                            //_showDialogEdit(context,index, _todoList[index]);
                              },
                            title: Text(
                            "eso",
                            style: TextStyle(fontSize: 20.0),
                          ),
                          trailing: IconButton(
                              icon: (true) ? Icon(
                                Icons.done_outline,
                                color: Colors.purple,
                                size: 20.0,
                              )
                                  : Icon(Icons.done, color: Colors.grey, size: 20.0),
                              onPressed: () {
                                //_updateTodo(_todoList[index]);
                              }),
                        ),
                      ),
                    ),
                  onAccept: (int data) {
                    accpeptedData = data;
                },
            ),
          )
        ],
      ),
    );
  }
}

class DraggableWidget extends StatefulWidget {
  final Offset offset;

  DraggableWidget({Key key, this.offset}) : super(key: key);

  @override
  _DraggableWidgetState createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> {
  Offset offset = Offset(0.0, 0.0);
 

  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    offset = widget.offset;
  }

  @override
  Widget build(BuildContext context) {
    _textEditingController.clear();
    return Positioned(
      bottom: offset.dy,
      left: offset.dx,
      child: Draggable(
        data: 20,
        child: Container(
          width: 200.0,
          height: 80.0,
          color: Colors.grey,
          child: Center(
            child:   new TextField(
                  controller: _textEditingController,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: 'Add new todo',
                  ),
            ),
          ),
        ),
        
        //TODO onDragStarted: ,
        
        feedback: Container(
          width: 200.0,
          height: 200.0,
          color: Colors.blue.withOpacity(0.9),
          child: Center(
            child: Text(
              "Hi CTM",
              style: TextStyle(
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
        onDraggableCanceled: (v, o) {
          setState(() {
            offset = o;
          });
        },
      ),
    );
  }
}