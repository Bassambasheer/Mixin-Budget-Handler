import 'package:flutter/material.dart';
import 'package:money_management/utility/category_db.dart';
import 'package:money_management/utility/transaction_db.dart';
import 'package:money_management/screens/widgets/home_widgets.dart';
import 'package:money_management/screens/widgets/transactions.dart';
import 'package:money_management/screens/widgets/piedata.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refresh();
    CategoryDB.instance.refreshUI();
    total();
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          "Mixin\nBudget Handler",
          style: TextStyle(fontSize: 25, fontFamily: "Cinzel"),
          textAlign: TextAlign.center,
        ),
        ValueListenableBuilder(
          valueListenable: grandtotal,
          builder: (BuildContext context, double value, Widget?_) {
            return card(
              context: context,
              category: "Total Balance",
              amount: (" \u20B9${grandtotal.value}"),
               boxcolor: Colors.blue.shade700.withOpacity(0.5),
              borderclr:  Colors.blue.withOpacity(0.5)
            );
          }
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ValueListenableBuilder(
              valueListenable: income,
              builder: (context, double value, child) {
                return card(
                  context: context,
                    category: "Total Earned",
                    amount: ("\u20B9${income.value}"),
                    boxcolor: Colors.greenAccent.shade400.withOpacity(0.9),
                    borderclr: Colors.green.withOpacity(0.5));
                    
              },
            ),
            ValueListenableBuilder(
              valueListenable: expense,
              builder: (context, double value, child) {
                return card(
                   context: context,
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
