import 'package:expenses_app/controllers/transaction_controller.dart';
import 'package:expenses_app/utils/common_util.dart';
import 'package:expenses_app/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionScreen extends StatelessWidget {
  final TransactionController transactionC = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Manager'),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Obx(
          () => Column(
            children: [
              Container(
                color: Colors.white,
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(4),
                child: Text(
                  'Balance: ${CommonUtil.toCurrencyFormat(transactionC.totalAmount)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: transactionC.transactions.length,
                  itemBuilder: (ctx, i) {
                    return TransactionItem(
                      date: transactionC.transactions[i].date,
                      category: transactionC.transactions[i].category!.name,
                      amount: transactionC.transactions[i].amount,
                      description: transactionC.transactions[i].description,
                      type: transactionC.transactions[i].type,
                      onEdit: () {
                        transactionC.goToEditScreen(
                            id: transactionC.transactions[i].id);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          transactionC.goToEditScreen();
        },
      ),
    );
  }
}
