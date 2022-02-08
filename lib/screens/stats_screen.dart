import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_management/utility/transaction_db.dart';
import 'package:money_management/screens/widgets/home_widgets.dart';
import 'package:money_management/screens/widgets/tab_bar_Stats.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:money_management/screens/widgets/piedata.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  void initState() {
incomepiedata();
    inc();
    piemap();
    incomepiedatabydate(dat:DateTime.now().day);
    incomepiedatabyMonth();
  }

  final _list = ['All', 'Today', 'Yesterday', 'Custom', 'Monthly'];

/*.........Date Pickers........*/
  static DateTime date = DateTime.now();
  static final _date = DateTime(date.year, date.month, date.day);
  static DateTime yesterday = DateTime.now();
  static final _yesterday =
      DateTime(yesterday.year, yesterday.month, (yesterday.day) - 1);
  String formattedDate = DateFormat('MMM-dd').format(_date);
  String formattedDateyester = DateFormat('MMM-dd').format(_yesterday);

  String formattedMonth = DateFormat('MMMM').format(month);
  static DateTime month = DateTime.now();
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

      // formattedMonth = month.toString();
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

  final _dateToday = DateTime.now();
  final _dateYesterday = DateTime.now().subtract(Duration(days: 1));
  late final _dateYear = DateFormat('yyyy').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    int? eachmonth;
    if (formattedMonth == "January") {
      eachmonth = 1;
    }
    if (formattedMonth == "February") {
      eachmonth = 2;
    }
    if (formattedMonth == "March") {
      eachmonth = 3;
    }
    if (formattedMonth == "April") {
      eachmonth = 4;
    }
    if (formattedMonth == "May") {
      eachmonth = 5;
    }
    if (formattedMonth == "June") {
      eachmonth = 6;
    }
    if (formattedMonth == "July") {
      eachmonth = 7;
    }
    if (formattedMonth == "August") {
      eachmonth = 8;
    }
    if (formattedMonth == "September") {
      eachmonth = 9;
    }
    if (formattedMonth == "October") {
      eachmonth = 10;
    }
    if (formattedMonth == "November") {
      eachmonth = 11;
    }
    if (formattedMonth == "December") {
      eachmonth = 12;
    }

    if (All == true) {
   incomepiedata();
    inc();
    piemap();
      TransactionDB.instance.refreshAllTransactions();
    } else if (Today == true) {
      incomepiedatabydate(dat:DateTime.now().day);
      inc();
    piemap();
      TransactionDB.instance.refreshTransactions(dat: parseDate(_dateToday));
    } else if (Yesterday == true) {
       incomepiedatabydate(dat:_dateYesterday.day);
      inc();
    piemap();
      TransactionDB.instance
          .refreshTransactions(dat: parseDate(_dateYesterday));
    } else if (Monthly == true) {
      incomepiedatabyMonth(monthly:eachmonth);
      inc();
    piemap();
      TransactionDB.instance.refreshMonthlyTransactions(monthly: eachmonth);
    }
  
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heading(head: "STATS.", trail: "Know you STATISTICS here"),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 270),
          child: DropdownButtonFormField(
            hint: Text(_list[0]),
            items: _list.map((e) {
              return DropdownMenuItem(
                onTap: () {
                  if (e == _list[0]) {
                    setState(() {
                      All = true;
                      Monthly = false;
                      Custom = false;
                    });
                  } else if (e == _list[1]) {
                    setState(() {
                      Today = true;
                      All = false;
                      Yesterday = false;
                      Monthly = false;
                      Custom = false;
                    });
                  }
                  if (e == _list[2]) {
                    setState(() {
                      Yesterday = true;
                      All = false;
                      Today = false;
                      Monthly = false;
                      Custom = false;
                    });
                  }
                  if (e == _list[4]) {
                    setState(() {
                      Monthly = true;
                      Custom = false;
                      All = false;
                      Today = false;
                      Yesterday = false;
                    });
                  } else if (e == _list[3]) {
                    setState(() {
                      Custom = true;
                      Monthly = false;
                      All = false;
                      Today = false;
                      Yesterday = false;
                    });
                  }
                },
                value: e,
                child: Text(e),
              );
            }).toList(),
            onChanged: (value) {
              
            },
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Monthly == false && Custom == false
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
        const Expanded(child: TabBarStats()),
      ],
    );
  }
}
