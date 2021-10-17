import 'package:expenses_app/controllers/categories_controller.dart';
import 'package:expenses_app/widgets/category_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({Key? key}) : super(key: key);

  final categoriesC = Get.put(CategoriesController());

  void confirmAddCategory() {
    categoriesC.nameC.clear();
    Get.dialog(
      AlertDialog(
        title: Text('Create Category'),
        content: Form(
          key: categoriesC.formKey,
          child: TextFormField(
            controller: categoriesC.nameC,
            decoration: InputDecoration(
              labelText: 'Category Name',
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Category Name cannot be blank';
              }
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (!categoriesC.formKey.currentState!.validate()) {
                return;
              }
              categoriesC.addCategory(categoriesC.nameC.text);
              Get.back();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void confirmDeleteCategory(int id) {
    Get.dialog(
      AlertDialog(
        title: Text('Warning'),
        content: Text('Are you sure want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              categoriesC.deleteCategory(id);
              Get.back();
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Obx(
          () => ListView.builder(
            itemCount: categoriesC.catagories.length,
            itemBuilder: (ctx, i) {
              return GestureDetector(
                onTap: () {
                  Get.back(result: categoriesC.catagories[i]);
                },
                child: CategoryItem(
                  name: categoriesC.catagories[i].name,
                  onDelete: () {
                    confirmDeleteCategory(categoriesC.catagories[i].id!);
                  },
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          confirmAddCategory();
        },
      ),
    );
  }
}
