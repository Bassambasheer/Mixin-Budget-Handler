import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_management/utility/transaction_db.dart';
import 'package:money_management/db_models/transaction_model.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:money_management/screens/widgets/piedata.dart';

class IncomeTransactions extends StatelessWidget {
  const IncomeTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TransactionModel? incomecategories;
    // incomecategorylist() async {
    //   final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    //   List<int> incomecategorykey = _db.keys
    //       .cast<int>()
    //       .where((Key) => _db.get(Key)!.type == CategoryType.income)
    //       .toList();
    //   final TransactionModel? incomeTransaction = _db.get(incomecategorykey);
    //   incomecategories = incomeTransaction;
    // }
    Map<String, double> datamap = incallMap;
    if (datamap.isEmpty) {
      return SizedBox();
    }
    return Column(
      children: [
        Container(
          child: Center(
            child: PieChart(
              dataMap: datamap,
              chartRadius: MediaQuery.of(context).size.width / 2.3,
              legendOptions: const LegendOptions(
                legendPosition: LegendPosition.right,
              ),
              chartValuesOptions:
                  const ChartValuesOptions(showChartValuesInPercentage: false),
            ),
          ),
        ),
        const Divider(),
        Expanded(
          child: ValueListenableBuilder(
              valueListenable:
                  TransactionDB.instance.incomeTransactionListNotifier,
              builder: (BuildContext ctx, List<TransactionModel> newlist,
                  Widget? _) {
                return ListView.separated(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    itemBuilder: (ctx, index) {
                      final _value = newlist[index];
                      return Card(
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
                            style: const TextStyle(color: Colors.green),
                          ),
                          subtitle: Text(
                              "${_value.category.name.toUpperCase()}\n${_value.note}"),
                        ),
                      );
                    },
                    separatorBuilder: (ctx, index) {
                      return const SizedBox(height: 2);
                    },
                    itemCount: newlist.length);
              }),
        ),
      ],
    );
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splittedDate = _date.split(' ');
    return "${_splittedDate.last}\n${_splittedDate.first}";
  }
}
