import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_login_demo/models/todo.dart';

class Todos {
  String key; 
  List<Todo> todos;
  String userId;
  bool completed; 

  //Constructor
  Todos(this.todos, this.userId, this.completed);

  Todos.fromSnapshot(DataSnapshot snapshot) :
    key = snapshot.key,
    userId = snapshot.value["userId"],
    completed = snapshot.value["completed"],
    todos = snapshot.value["todos"];

  toJson() {
    return {
      "userId": userId,
      "todos": todos,
      "completed": completed,
    };
  }
}