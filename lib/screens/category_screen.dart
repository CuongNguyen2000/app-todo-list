import 'package:app_todolist/model/category.dart';
import 'package:app_todolist/screens/home_screen.dart';
import 'package:app_todolist/service/category_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();

  // var _cateoryIdController = TextEditingController();
  var _category = Category();
  var _categoryService = CategoryService();

  List<Category> _categoryList = <Category>[];

  var category;
  var _editcategoryNameController = TextEditingController();
  var _editcategoryDescriptionController = TextEditingController();

  void initState() {
    super.initState();
    getAllCategories();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllCategories() async {
    _categoryList = <Category>[];
    var categories = await _categoryService.readCategory();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category['name'];
        categoryModel.description = category['description'];
        categoryModel.id = category['id'];
        _categoryList.add(categoryModel);
      });
    });
  }

  _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              TextButton(
                onPressed: () async {
                  _category.name = _categoryNameController.text;
                  _category.description = _categoryDescriptionController.text;
                  //   _category.id = int.parse(_cateoryIdController.text);
                  var result = await _categoryService.saveCategory(_category);
                  if (result > 0) {
                    print(result);
                    getAllCategories();
                    _categoryDescriptionController.clear();
                    _categoryNameController.clear();
                    Navigator.pop(context);
                  }
                },
                child: Text('Save'),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'))
            ],
            title: Text('Categories Forms'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  // TextField(
                  //   controller: _cateoryIdController,
                  //   decoration: InputDecoration(
                  //       hintText: 'Write a category',
                  //       labelText: 'Category'
                  //   ),
                  // ),
                  TextField(
                    controller: _categoryNameController,
                    decoration: InputDecoration(
                        hintText: 'Write a category', labelText: 'Category'),
                  ),
                  TextField(
                    controller: _categoryDescriptionController,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              _categoryDescriptionController.clear();
                            },
                            icon: Icon(Icons.clear)),
                        hintText: 'Write a decription',
                        labelText: 'Description'),
                  )
                ],
              ),
            ),
          );
        });
  }

  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    //   _globalKey.currentState!.showSnackBar(_snackBar);
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ElevatedButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomeScreen())),
          child: Icon(Icons.arrow_back),
        ),
        title: Text('Categories'),
      ),
      body: ListView.builder(
        itemCount: _categoryList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 16.0, right: 16.0),
            child: Card(
              elevation: 10.0,
              child: ListTile(
                leading: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    //   _editCategory(context, _categoryList[index].id);
                  },
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_categoryList[index].name!),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                    )
                  ],
                ),
                subtitle: Text(_categoryList[index].description!),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
