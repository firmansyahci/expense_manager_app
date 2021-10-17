import 'package:expenses_app/models/category.dart';

enum TransactionType { Income, Expense }

class Transaction {
  final int? id;
  final DateTime? date;
  final Category? category;
  final double? amount;
  final String? description;
  final TransactionType? type;

  Transaction({
    this.id,
    this.date,
    this.category,
    this.amount,
    this.description,
    this.type,
  });
}
