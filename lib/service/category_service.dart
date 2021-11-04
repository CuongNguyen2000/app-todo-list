import 'package:app_todolist/model/category.dart';
import 'package:app_todolist/repositories/repository.dart';

class CategoryService{
  Repository? _repository;
  CategoryService(){
    _repository = Repository();
  }
  // Create date 
  saveCategory(Category category) async {
    return await _repository!.insertData('categories', category.categoryMap());
  }
  
  readCategory() async{
    return await _repository!.readData('categories');
  }
  // Read category by id
  readCategoryById(categoryId) async {
    return await _repository!.readDataById('categories',categoryId);
  }
  // Update data from table


}