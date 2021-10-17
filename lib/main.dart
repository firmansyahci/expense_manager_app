import 'package:expenses_app/screens/categories_screen.dart';
import 'package:expenses_app/screens/transaction_add_screen.dart';
import 'package:expenses_app/screens/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Expenses App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/transaction',
      getPages: [
        GetPage(
          name: '/transaction',
          page: () => TransactionScreen(),
        ),
        GetPage(
          name: '/transaction-add',
          page: () => TransactionAddScreen(),
        ),
        GetPage(
          name: '/categories',
          page: () => CategoriesScreen(),
        ),
      ],
    );
  }
}
