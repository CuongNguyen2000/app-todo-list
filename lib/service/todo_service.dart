import 'package:app_todolist/model/todo.dart';
import 'package:app_todolist/repositories/repository.dart';
import 'package:app_todolist/screens/todo_screen.dart';

class TodoServices{
  Repository? _repository;
  TodoServices(){
    _repository = Repository();
  }
  saveTodo(Todo todo)async{
    return await _repository!.insertData('todos', todo.todoMap());
  }

  //read todo
  readTodos()async{
    return await _repository!.readData('todos');
  }
}