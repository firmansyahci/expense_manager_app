import 'package:expenses_app/controllers/transaction_controller.dart';
import 'package:expenses_app/models/category.dart';
import 'package:expenses_app/models/transaction.dart';
import 'package:expenses_app/utils/common_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionAddScreen extends StatefulWidget {
  @override
  _TransactionAddScreenState createState() => _TransactionAddScreenState();
}

class _TransactionAddScreenState extends State<TransactionAddScreen> {
  final TransactionController _transactionC = Get.put(TransactionController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateC = TextEditingController();
  final TextEditingController _categoryC = TextEditingController();
  final TextEditingController _amountC = TextEditingController();
  final TextEditingController _descriptionC = TextEditingController();

  var _selectedCategory;

  var _transactionId;

  @override
  void initState() {
    super.initState();
    _transactionC.currentTransactionType.value = TransactionType.Expense;
    _transactionId = Get.arguments[0];
    if (_transactionId != null) {
      final transaction = _transactionC.getTransactionById(_transactionId);
      _transactionC.currentTransactionType.value = transaction.type!;
      _transactionC.selectedDate(transaction.date!);
      _selectedCategory = transaction.category;
      _dateC.text = CommonUtil.toDateFormat(transaction.date!);
      _categoryC.text = transaction.category!.name!;
      _amountC.text = transaction.amount!.toInt().toString();
      _descriptionC.text = transaction.description!;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _categoryC.dispose();
    _amountC.dispose();
    _descriptionC.dispose();
    _transactionC.selectedDate(DateTime.now());
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _transactionC.pickedDate.value,
      firstDate: DateTime(2015, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _transactionC.pickedDate.value) {
      _transactionC.selectedDate(picked);
      _dateC.text = CommonUtil.toDateFormat(picked);
    }
  }

  Future<void> _selectCategory() async {
    final Category category = await Get.toNamed('/categories');
    _selectedCategory = category;
    _categoryC.text = category.name!;
  }

  void _submitTransaction() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_transactionId != null) {
      _transactionC.editTransaction(
        id: _transactionId,
        category: _selectedCategory,
        amount: double.parse(_amountC.text),
        description: _descriptionC.text,
      );
    } else {
      _transactionC.addTransaction(
        category: _selectedCategory,
        amount: double.parse(_amountC.text),
        description: _descriptionC.text,
      );
    }
    Get.back();
  }

  void _confirmDeleteTransaction(int id) {
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
              _transactionC.deleteTransaction(id);
              Get.back();
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
        title: _transactionId != null
            ? Text('Update Transaction')
            : Text('Create Transaction'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _transactionC
                              .changeTransactionType(TransactionType.Expense);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _transactionC.currentTransactionType.value ==
                                    TransactionType.Expense
                                ? Colors.blue
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.blue,
                            ),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'EXPENSE',
                            style: TextStyle(
                              color: _transactionC.isTransactionTypeActive(
                                      TransactionType.Expense)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _transactionC
                              .changeTransactionType(TransactionType.Income);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _transactionC.isTransactionTypeActive(
                                    TransactionType.Income)
                                ? Colors.blue
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.blue,
                            ),
                          ),
                          child: Text(
                            'INCOME',
                            style: TextStyle(
                              color: _transactionC.isTransactionTypeActive(
                                      TransactionType.Income)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _dateC,
                        readOnly: true,
                        onTap: () {
                          _selectDate(context);
                        },
                        decoration: InputDecoration(
                          labelText: 'Transaction Date',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Transaction Date cannot be blank';
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _categoryC,
                        readOnly: true,
                        onTap: () {
                          _selectCategory();
                        },
                        decoration: InputDecoration(
                          labelText: 'Select Category',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Category cannot be blank';
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _amountC,
                        decoration: InputDecoration(
                          labelText: 'Amount',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Amount cannot be blank';
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _descriptionC,
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Description cannot be blank';
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.done,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          if (_transactionId != null) ...[
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  _confirmDeleteTransaction(_transactionId);
                                },
                                child: Text('Delete'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                          ],
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _submitTransaction();
                              },
                              child: Text('Save'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
