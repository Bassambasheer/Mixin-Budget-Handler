import 'package:flutter/material.dart';
import 'package:money_management/screens/widgets/expense_transactions.dart';
import 'package:money_management/screens/widgets/income_transaction.dart';
import 'package:money_management/screens/widgets/piedata.dart';
import 'package:pie_chart/pie_chart.dart';

class TabBarStats extends StatefulWidget {
  const TabBarStats({Key? key}) : super(key: key);

  @override
  State<TabBarStats> createState() => _TabBarStatsState();
}

class _TabBarStatsState extends State<TabBarStats>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> datamap = {
      "Income": income.value,
      "Expense": expense.value,
    };
    return Column(
      children: [
        TabBar(
            labelColor: Colors.blueGrey[900],
            unselectedLabelColor: Colors.grey,
            controller: _tabController,
            tabs: const [
              Tab(text: "INCOME"),
              Tab(text: "EXPENSE"),
              Tab(
                text: "OVERALL",
              )
            ]),
        Expanded(
          child: TabBarView(controller: _tabController, children: [

            IncomeTransactions(),
            ExpenseTransactions(),
                        Container(
              child: Center(
                child: PieChart(
                  dataMap: datamap,
                  chartRadius: MediaQuery.of(context).size.width / 2.0,
                  legendOptions: const LegendOptions(
                    legendPosition: LegendPosition.right,
                  ),
                  chartValuesOptions: const ChartValuesOptions(
                      showChartValuesInPercentage: true),
                ),
              ),
            ),
          ]),
        )
      ],
    );
  }
}
