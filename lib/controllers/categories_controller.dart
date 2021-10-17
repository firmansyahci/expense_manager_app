import 'package:expenses_app/helpers/db_helper.dart';
import 'package:expenses_app/models/category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesController extends GetxController {
  final catagories = <Category>[].obs;

  final TextEditingController nameC = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchAndSetCategories();
  }

  @override
  void dispose() {
    super.dispose();
    nameC.dispose();
  }

  Future<void> fetchAndSetCategories() async {
    final dataList = await DBHelper.getData('categories');
    catagories.addAll(dataList
        .map(
          (item) => Category(
            id: item['id'],
            name: item['name'],
          ),
        )
        .toList());
  }

  Future<void> addCategory(String name) async {
    final id = await DBHelper.insert('categories', {'name': name});
    catagories.add(Category(
      id: id,
      name: name,
    ));
  }

  Future<void> deleteCategory(int id) async {
    await DBHelper.delete('categories', id);
    catagories.removeWhere((category) => category.id == id);
  }
}
