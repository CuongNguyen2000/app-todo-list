import 'package:app_todolist/helpers/drawer_navigation.dart';
import 'package:app_todolist/model/todo.dart';
import 'package:app_todolist/screens/todo_screen.dart';
import 'package:app_todolist/service/todo_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TodoServices? _todoServices;
  List<Todo>? _todoList;

  getAllTodos() async {
    _todoServices = TodoServices();
    _todoList = <Todo>[];
    var todos = await _todoServices!.readTodos();
    todos.forEach((todo) {
      setState(() {
        var model = Todo();
        model.id = todo['id'];
        model.title = todo['title'];
        model.description = todo['description'];
        model.todoDate = todo['todoDate'];
        model.isFinished = todo['isFinished'];
        _todoList!.add(model);
      });
    });
  }

  List<Todo>? _findItem;
  @override
  initState() {
    super.initState();
    getAllTodos();
    _findItem = _todoList;
  }

  Widget build(BuildContext context) {
    var _textEditingController;
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
              color: Colors.blue.shade300,
              borderRadius: BorderRadius.circular(30)),
          child: Center(
            child: TextFormField(
              onChanged: (value) => onSearchTextChanged(value),
              controller: _textEditingController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                  hintText: 'Search'),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _findItem?.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 10.0,
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(_findItem?[index].title ?? 'No title')],
              ),
              subtitle: Text(_findItem?[index].category ?? 'No category'),
              trailing: Text(_findItem?[index].todoDate ?? 'No date'),
            ),
          );
        },
      ),
      drawer: DrawerNavigation(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TodoScreen())),
        child: Icon(Icons.add),
      ),
    );
  }

  void onSearchTextChanged(String text) {
    List<Todo> results = [];
    if (text.isEmpty) {
      results = _todoList!;
    } else {
      results = _todoList!
          .where(
              (item) => item.title!.toLowerCase().contains(text.toLowerCase()))
          .toList();
    }
    setState(() {
      _findItem = results;
    });
  }
}
