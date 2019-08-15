//Import Materialapp and other widgets
import 'package:flutter/material.dart';

//runApp requires app's container?
void main() => runApp(new TodoApp());


class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Todo List',
      home: new TodoList(),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent,
        fontFamily: 'Montserrat',
      )
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  List<String> _todoItems = [];

  //function called every time button is pressed
  void _addTodoItem(String task) {
    //setState tells app that state has changed, will re-render the list
    if (task.length > 0) {
      setState(() => _todoItems.add(task));
    }
  }

  Widget _buildTodoList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        //itemBuilder is called as many times for the list to fill up,
        //so we need to double check if the index is ok.
        if (index < _todoItems.length) {
          return _buildTodoItem(_todoItems[index], index);
        }
      },
    );
  }

  Widget _buildTodoItem(String todoText, int index) {
    return new ListTile(
        title: new Text(todoText),
      onTap: () => _promptRemoveTodoItem(index),
    );
  }

  //Appbar at the top
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text('Todo List')
      ),
      body: _buildTodoList(),
      floatingActionButton: new FloatingActionButton(
          onPressed: _pushAddTodoScreen,
          tooltip: 'Add task',
          child: new Icon(Icons.add)
      ),
    );
  }

  void _pushAddTodoScreen() {
    Navigator.of(context).push(
      //MaterialPageRoute automatically adds animation and back button
        new MaterialPageRoute(
          builder: (context){
            return new Scaffold(
              appBar: new AppBar(
                title: new Text('Add a new task')
              ),
              body: new TextField(
                autofocus: true,
                onSubmitted: (val){
                  _addTodoItem(val);
                  Navigator.pop(context); //close the add screen
                },
                decoration: new InputDecoration(
                  hintText: 'What do you need to get done?',
                  contentPadding: const EdgeInsets.all(16.0)
                )
              )
            );
          }
        )
    );
  }

  void _removeTodoItem(int index) {
    setState(() => _todoItems.removeAt(index));
  }

  //show an alert, confirming the done task
  void _promptRemoveTodoItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Mark "${_todoItems[index]}" as done?'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
            ),
            new FlatButton(
              child: new Text('Mark as Done'),
              onPressed: (){
                _removeTodoItem(index);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }
}