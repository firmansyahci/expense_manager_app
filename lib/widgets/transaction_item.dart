import 'package:expenses_app/models/transaction.dart';
import 'package:expenses_app/utils/common_util.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final DateTime? date;
  final String? category;
  final double? amount;
  final String? description;
  final TransactionType? type;
  final Function? onEdit;

  TransactionItem({
    this.date,
    this.category,
    this.amount,
    this.description,
    this.type,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onEdit!();
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            type == TransactionType.Expense
                ? Icon(
                    Icons.arrow_upward,
                    color: Colors.red,
                  )
                : Icon(
                    Icons.arrow_downward,
                    color: Colors.green,
                  ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CommonUtil.toCurrencyFormat(amount!),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    category!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    description!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              CommonUtil.toDateFormat(date!),
            ),
          ],
        ),
      ),
    );
  }
}
