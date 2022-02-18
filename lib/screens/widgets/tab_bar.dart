import 'package:flutter/material.dart';
import 'package:money_management/utility/category_db.dart';
import 'package:money_management/screens/widgets/expense_categorylists.dart';
import 'package:money_management/screens/widgets/income_categorylists.dart';

class TabBarWidget extends StatefulWidget {
  const TabBarWidget({Key? key}) : super(key: key);

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    CategoryDB().refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.blueGrey.shade600,
            controller: _tabController,
            tabs: const [
              Tab(text: "INCOME"),
              Tab(
                text: "EXPENSE",
              )
            ]),
        Expanded(
          child: TabBarView(
              controller: _tabController,
              children: const [IncomeCategory(),
               ExpenseCategory()]),
        )
      ],
    );
  }
}
