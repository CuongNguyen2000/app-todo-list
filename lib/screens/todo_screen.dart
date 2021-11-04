import 'package:app_todolist/model/todo.dart';
import 'package:app_todolist/screens/home_screen.dart';
import 'package:app_todolist/service/category_service.dart';
import 'package:app_todolist/service/todo_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var _todoTitleController = TextEditingController();
  var _todoDescriptionController = TextEditingController();
  var _todoDateController = TextEditingController();
  var _selectedValue;
  var _categories = <DropdownMenuItem>[];
  _loadCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategory();
    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(category['name']),
          value: category['name'],
        ));
      });
    });
  }

  DateTime _datetime = DateTime.now();
  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _datetime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2200));
    if (_pickedDate != null) {
      setState(() {
        _datetime = _pickedDate;
        _todoDateController.text = DateFormat('yyyy-mm-dd').format(_pickedDate);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
    //  getAllTodos();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _todoTitleController,
              decoration: InputDecoration(
                  labelText: 'Title', hintText: 'Write Todo Title'),
            ),
            TextField(
              controller: _todoDescriptionController,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        _todoDescriptionController.clear();
                      },
                      icon: Icon(Icons.clear)),
                  labelText: 'Description',
                  hintText: 'Write Todo Description'),
            ),
            TextField(
              controller: _todoDateController,
              decoration: InputDecoration(
                  labelText: 'Date',
                  hintText: 'Pick a date',
                  prefix: InkWell(
                    onTap: () {
                      _selectedTodoDate(context);
                    },
                    child: Icon(Icons.calendar_today),
                  )),
            ),
            DropdownButtonFormField<dynamic>(
              value: _selectedValue,
              items: _categories,
              hint: Text('Categories'),
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
                onPressed: () async {
                  var todoObject = Todo();
                  todoObject.title = _todoTitleController.text;
                  todoObject.description = _todoDescriptionController.text;
                  todoObject.isFinished = 0;
                  todoObject.category = _selectedValue;
                  todoObject.todoDate = _todoDateController.text;

                  var _todoService = TodoServices();
                  var result = await _todoService.saveTodo(todoObject);
                  if (result > 0) {
                    Navigator.pop(context);
                    //  var getAllTodos();
                    // _loadCategories();
                    print(result);
                  }
                },
                child: Text('Submit'))
          ],
        ),
      ),
    );
  }
}
