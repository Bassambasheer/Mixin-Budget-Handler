import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_management/screens/widgets/expense_transactions.dart';
import 'package:money_management/screens/widgets/income_transaction.dart';
import 'package:money_management/utility/transaction_db.dart';
import 'package:money_management/screens/widgets/home_widgets.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:money_management/screens/widgets/piedata.dart';
import 'package:pie_chart/pie_chart.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>
    with SingleTickerProviderStateMixin {
  final _list = ['All', 'Today', 'Yesterday', 'Custom', 'Monthly'];

/*.........Date Pickers........*/
  static DateTime date = DateTime.now();
  static final _date = DateTime(date.year, date.month, date.day);
  static DateTime yesterday = DateTime.now();
  static final _yesterday =
      DateTime(yesterday.year, yesterday.month, (yesterday.day) - 1);
  String formattedDate = DateFormat('MMM-dd').format(_date);
  String formattedDateyester = DateFormat('MMM-dd').format(_yesterday);

  Future _datepicker(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    final newDate = await showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: initialDate,
      initialDate: month,
    );
    if (newDate == null) return month = initialDate;
    setState(() {
      month = newDate;
      formattedMonth = DateFormat('MMMM').format(month);
      monthfunction();
      totalbymonth(month: eachmonth);
      incomepiedatabyMonth(monthly: eachmonth);
    });
  }

  /*.........Date Range Pickers........*/
  static DateTimeRange? range;
  static DateTime startDate = DateTime.now().add(const Duration(days: -5));
  static DateTime endDate = DateTime.now();
  String formattedStartDate = DateFormat('MMM-dd').format(startDate);
  String formattedEndDate = DateFormat('MMM-dd').format(endDate);

  Future dateRangePicker() async {
    final _initialDateRange = DateTimeRange(
        start: DateTime.now().add(const Duration(days: -2)),
        end: DateTime.now());
    final newdateRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 10),
        lastDate: DateTime.now(),
        initialDateRange: range ?? _initialDateRange);
    if (newdateRange == null) return;
    setState(() {
      range = newdateRange;
      startDate = range!.start;
      endDate = range!.end;
      TransactionDB.instance
          .refreshCustomTransactions(startdate: startDate, enddate: endDate);
      totalcustom(range!.start, range!.end);
      incomepiedatabycustom(range!.start, range!.end);
    });
  }

  Widget getFrom() {
    if (range == null) {
      return const Text("From",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ));
    } else {
      return Text(
          DateFormat('MMM-dd').format(
            range!.start,
          ),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ));
    }
  }

  Widget toFrom() {
    if (range == null) {
      return const Text("Untill",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ));
    } else {
      return Text(
        DateFormat('MMM-dd').format(range!.end),
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      );
    }
  }

  late TabController _tabController;

  @override
  void initState() {
    All = true;
    reload();
    reloadtotal();
    _tabController = TabController(length: 3, vsync: this);
  }

  var _dateToday = DateTime.now();
  var _dateYesterday = DateTime.now().subtract(Duration(days: 1));
  @override
  Widget build(BuildContext context) {
    Map<String, double> datamap = {
      "Income": income.value,
      "Expense": expense.value,
    };
    monthfunction();

    if (All == true) {
      TransactionDB.instance.refreshAllTransactions();
    } else if (Today == true) {
      TransactionDB.instance.refreshTransactions(dat: parseDate(_dateToday));
    } else if (Yesterday == true) {
      TransactionDB.instance
          .refreshTransactions(dat: parseDate(_dateYesterday));
    } else if (Monthly == true) {
      TransactionDB.instance.refreshMonthlyTransactions(monthly: eachmonth);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heading(head: "STATS.", trail: "Know you STATISTICS here"),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: SizedBox(
            width: 100,
            child: DropdownButtonFormField(
              hint: Text(_list[0]),
              items: _list.map((e) {
                return DropdownMenuItem(
                  onTap: () {
                    if (e == _list[0]) {
                      All = true;
                      Today = false;
                      Yesterday = false;
                      Monthly = false;
                      Custom = false;
                      reload();
                      reloadtotal();
                      setState(() {});
                    } else if (e == _list[1]) {
                      Today = true;
                      All = false;
                      Yesterday = false;
                      Monthly = false;
                      Custom = false;
                      reload();
                      reloadtotal();
                      setState(() {});
                    }
                    if (e == _list[2]) {
                      Yesterday = true;
                      All = false;
                      Today = false;
                      Monthly = false;
                      Custom = false;
                      reload();
                      reloadtotal();
                      setState(() {});
                    }
                    if (e == _list[4]) {
                      Monthly = true;
                      Custom = false;
                      All = false;
                      Today = false;
                      Yesterday = false;
                      monthfunction();
                      totalbymonth(month: eachmonth);
                      incomepiedatabyMonth(monthly: eachmonth);
                      setState(() {});
                    } else if (e == _list[3]) {
                      Custom = true;
                      Monthly = false;
                      All = false;
                      Today = false;
                      Yesterday = false;
                      setState(() {});
                    }
                  },
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (value) {},
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Custom == false && Monthly == false 
                ? SizedBox(
                    width: MediaQuery.of(context).size.width / 1,
                  )
                : Monthly == true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: GestureDetector(
                                onTap: () => _datepicker(context),
                                child: Container(
                                  width: 150,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      borderRadius:
                                          BorderRadiusDirectional.circular(3)),
                                  child: Center(
                                    child: Text(("Month :${formattedMonth}"),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18)),
                                  ),
                                )),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 14.0),
                            child: TextButton(
                              onPressed: () {
                                dateRangePicker();
                              },
                              child: getFrom(),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.arrow_right_alt_rounded,
                              size: 40,
                              color: Colors.red,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 14.0),
                            child: TextButton(
                              onPressed: () {
                                dateRangePicker();
                              },
                              child: toFrom(),
                            ),
                          ),
                        ],
                      )),
        SizedBox(height: 10),
        TabBar(
            labelColor: Colors.blueGrey[900],
            unselectedLabelColor: Colors.grey,
            controller: _tabController,
            tabs: const [
              Tab(text: "OVERALL"),
              Tab(text: "INCOME"),
              Tab(
                text: "EXPENSE",
              )
            ]),
        Expanded(
          child: TabBarView(controller: _tabController, children: [
            Center(
              child: PieChart(
                emptyColor: Colors.blue.shade300,
                dataMap: datamap,
                chartRadius: MediaQuery.of(context).size.width / 2.0,
                legendOptions: const LegendOptions(
                  legendPosition: LegendPosition.right,
                ),
                chartValuesOptions: const ChartValuesOptions(
                    showChartValuesInPercentage: false),
              ),
            ),
            IncomeTransactions(),
            ExpenseTransactions(),
          ]),
        )
      ],
    );
  }
}
