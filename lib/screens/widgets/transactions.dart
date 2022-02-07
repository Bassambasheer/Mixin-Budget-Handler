import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_management/utility/transaction_db.dart';
import 'package:money_management/db_models/category_model.dart';
import 'package:money_management/db_models/transaction_model.dart';
import 'package:money_management/screens/widgets/delete_popup.dart';
import 'package:money_management/screens/widgets/home_widgets.dart';

class Transactions extends StatelessWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionListNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newlist, Widget? _) {
        return ListView.separated(
            padding: const EdgeInsets.only(left: 10, right: 10),
            itemBuilder: (ctx, index) {
              final _value = newlist[index];
              return Dismissible(
                direction: DismissDirection.endToStart,
                key: Key("${_value.key}"),
                background: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 300),
                    child: Icon(
                      Icons.delete,
                    ),
                  ),
                ),
                confirmDismiss: (direction) async {
                  deletePopup(
                      context: context,
                      title: "Confirm",
                      message: "Are sure to delete",
                      btn1: "Delete",
                      btn2: "Cancel",
                      onpressdel: () {
                        TransactionDB.instance.deleteTransaction(_value.key!);
                        total();
                       incomepiedata();
                       
                       inc();
    piemap();
                        Navigator.of(context).pop();
                      },
                      onpresscancel: () {
                        Navigator.of(context).pop();
                      });
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.blue[100],
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(
                        backgroundColor: Colors.blueGrey,
                        radius: 25,
                        child: Text(
                          parseDate(_value.date),
                          textAlign: TextAlign.center,
                        )),
                    title: Text(
                      "\u20B9 ${_value.amount}",
                      style: TextStyle(
                          color: _value.type == CategoryType.income
                              ? Colors.green
                              : Colors.red),
                    ),
                    subtitle: Text("${_value.category.name.toUpperCase()}"),
                  ),
                ),
              );
            },
            separatorBuilder: (ctx, index) {
              return const SizedBox(height: 2);
            },
            itemCount: newlist.length);
      },
    );
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splittedDate = _date.split(' ');
    return "${_splittedDate.last}\n${_splittedDate.first}";
    // return '${date.day}\n${date.month}';
  }
}
