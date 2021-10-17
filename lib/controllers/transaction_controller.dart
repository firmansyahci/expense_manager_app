import 'package:expenses_app/helpers/db_helper.dart';
import 'package:expenses_app/models/category.dart';
import 'package:expenses_app/models/transaction.dart';
import 'package:get/get.dart';

class TransactionController extends GetxController {
  final transactions = <Transaction>[].obs;

  var currentTransactionType = TransactionType.Expense.obs;

  var pickedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    fetchAndSetTransactions();
  }

  @override
  void dispose() {
    super.dispose();
  }

  double get totalAmount {
    var result = 0.0;
    transactions.forEach((transaction) {
      if (transaction.type == TransactionType.Income) {
        result += transaction.amount!;
      } else {
        result -= transaction.amount!;
      }
    });
    return result;
  }

  void goToEditScreen({int? id}) {
    Get.toNamed(
      '/transaction-add',
      arguments: [id],
    );
  }

  void selectedDate(DateTime date) {
    pickedDate.value = date;
  }

  void changeTransactionType(TransactionType type) {
    currentTransactionType.value = type;
  }

  bool isTransactionTypeActive(TransactionType type) {
    return currentTransactionType.value == type;
  }

  Transaction getTransactionById(int id) {
    return transactions.firstWhere((transaction) => transaction.id == id);
  }

  Future<void> fetchAndSetTransactions() async {
    final dataList = await DBHelper.getData('transactions');
    transactions.addAll(dataList
        .map(
          (item) => Transaction(
            id: item['id'],
            date: DateTime.parse(item['date']),
            category: Category(
              id: item['categoryId'],
              name: item['categoryName'],
            ),
            amount: item['amount'].toDouble(),
            description: item['description'],
            type: TransactionType.values[item['type']],
          ),
        )
        .toList());
  }

  Future<void> addTransaction({
    Category? category,
    double? amount,
    String? description,
  }) async {
    final id = await DBHelper.insert(
      'transactions',
      {
        'date': pickedDate.value.toIso8601String(),
        'categoryId': category!.id!,
        'categoryName': category.name!,
        'amount': amount!,
        'description': description!,
        'type': currentTransactionType.value.index
      },
    );
    final newTransaction = Transaction(
      id: id,
      date: pickedDate.value,
      category: category,
      amount: amount,
      description: description,
      type: currentTransactionType.value,
    );

    transactions.add(newTransaction);
  }

  Future<void> editTransaction({
    int? id,
    Category? category,
    double? amount,
    String? description,
  }) async {
    await DBHelper.update(
      'transactions',
      {
        'date': pickedDate.value.toIso8601String(),
        'categoryId': category!.id!,
        'categoryName': category.name!,
        'amount': amount!,
        'description': description!,
        'type': currentTransactionType.value.index
      },
      id!,
    );
    final newTransaction = Transaction(
      id: id,
      date: pickedDate.value,
      category: category,
      amount: amount,
      description: description,
      type: currentTransactionType.value,
    );
    final transactionIndex =
        transactions.indexWhere((transaction) => transaction.id == id);

    transactions[transactionIndex] = newTransaction;
  }

  Future<void> deleteTransaction(int id) async {
    await DBHelper.delete('transactions', id);
    transactions.removeWhere((transaction) => transaction.id == id);
  }
}
