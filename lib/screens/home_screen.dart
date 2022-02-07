import 'package:flutter/material.dart';
import 'package:money_management/utility/category_db.dart';
import 'package:money_management/utility/transaction_db.dart';
import 'package:money_management/screens/widgets/home_widgets.dart';
import 'package:money_management/screens/widgets/transactions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refresh();
    CategoryDB.instance.refreshUI();
    total();
       incomepiedata();
    inc();
    piemap();
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          "Mixin\nBudget Handler",
          style: TextStyle(fontSize: 25, fontFamily: "Cinzel"),
          textAlign: TextAlign.center,
        ),
        Row(
          children: [
            ValueListenableBuilder(
              valueListenable: income,
              builder: (context, double value, child) {
                return card(
                    category: "Total Earned",
                    amount: ("\u20B9${income.value}"),
                    boxcolor: Colors.greenAccent.shade400.withOpacity(0.9),
                    borderclr: Colors.greenAccent.shade700.withOpacity(0.5));
              },
            ),
            ValueListenableBuilder(
              valueListenable: expense,
              builder: (context, double value, child) {
                return card(
                    category: "Total Spent",
                    amount: ("\u20B9${expense.value}"),
                    boxcolor: Colors.redAccent.shade200.withOpacity(0.9),
                    borderclr: Colors.redAccent.shade400.withOpacity(0.5));
              },
            )
          ],
        ),
        const Text(
          "Transactions",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
        const Expanded(
          child: Transactions(),
        )
      ],
    );
  }
}