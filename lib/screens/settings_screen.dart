import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:money_management/utility/category_db.dart';
import 'package:money_management/utility/transaction_db.dart';
import 'package:money_management/screens/widgets/delete_popup.dart';
import 'package:money_management/screens/widgets/home_widgets.dart';
import 'package:money_management/screens/widgets/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:money_management/screens/widgets/piedata.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const isswitched = 'buttonClicked';
  static const isAlarmOn = 'alarmon';
  TimeOfDay? shardAlarm;

  bool isSwitched = false;
  bool tileShow = false;

  Future<void> checkButtonSwitched() async {
    final sharedPreference = await SharedPreferences.getInstance();
    final buttonOn = sharedPreference.getBool(isswitched);
    if (buttonOn == false) {
      setState(() {
        isSwitched = false;
      });
    } else {
      setState(() {
        isSwitched = true;
        tileShow = true;
      });
    }
  }

  sharedtimeGetting() async {
    final sharedPreference = await SharedPreferences.getInstance();
    sharedTime = sharedPreference.getString(isAlarmOn);
  }

  var sharedTime;
  static TimeOfDay time = TimeOfDay.now();

  static final now =  DateTime.now();
  var dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  var format = DateFormat.jm();

  String formatTimeOfDay(TimeOfDay tod) {
    return format.format(dt);
  }

  var formatted;
  TimeOfDay timee = TimeOfDay.now();
  Future timepicker(BuildContext context) async {
    // const initialTime = const TimeOfDay(hour: 09, minute: 0);
    final newTime = await showTimePicker(context: context, initialTime: time);
    if (newTime == null) return;
    setState(() {
      time = newTime.replacing(hour: newTime.hourOfPeriod);
      timee = newTime;
      dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
      format = DateFormat().add_jm();
      formatted = format.format(dt);
      var _formated = timee.format(context);
      alarmTimeSaver(_formated);
      sharedtimeGetting();

      NotificationApi2.showScheduledNotification(
          scheduledTime: Time(timee.hour, timee.minute, 0),
          title: "Mixin Budget Handler",
          body: "Dont forget to add your transactions : )");
    });
  }

  @override
  void initState() {
    super.initState();
    checkButtonSwitched();
    NotificationApi2.init(initScheduled: true);
    listenNotifications();
    sharedtimeGetting();
  }

  listenNotifications() {
    NotificationApi2.onNotifications.stream.listen(onClickedNotification);
  }

  void onClickedNotification(String? payload) => null;

  trueFunction() async {
    final shared = await SharedPreferences.getInstance();
    shared.setBool(isswitched, true);
    setState(() {});
  }

  falseFunction() async {
    final shared = await SharedPreferences.getInstance();
    shared.setBool(isswitched, false);
    setState(() {});
    NotificationApi2.cancelNotification();
  }

  alarmTimeSaver(
    var tym,
  ) async {
    final shared = await SharedPreferences.getInstance();
    shared.setString(isAlarmOn, tym);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget Settings({required String txt, Widget? trail}) {
      return Padding(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Card(
          elevation: 3,
          child: ListTile(
              tileColor: Colors.cyan[100],
              title: Center(
                child: Text(
                  txt,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              trailing: trail),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
               begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0XFF18A5A8),Color(0XFFBFFFC8)])),
      child: Scaffold(
          backgroundColor: Colors.white.withOpacity(0),
          body: SingleChildScrollView(
            child: Column(
              children: [
                heading(head: "Settings.", trail: ""),
                settingsbutton(
                    text: "Reset App",
                    ontap: () {
                      deletePopup(
                          context: context,
                          title: "Confirm",
                          message: "Are you sure to clear all data",
                          btn1: "Clear",
                          btn2: "CANCEL",
                          onpressdel: () async {
                            CategoryDB.instance.categoryClear();
                            TransactionDB.instance.transactionsClear();
                            incallMap.clear();
                            expallMap.clear();
                            await total();
                            Navigator.of(context).pop();
                          },
                          onpresscancel: () {
                            Navigator.of(context).pop();
                          });
                    }),
                Settings(
                  txt: 'Notification',
                  trail: IconButton(
                    onPressed: () {
                      if (isSwitched == false) {
                        setState(() {
                          tileShow = true;
                          isSwitched = true;
                          trueFunction();
                        });
                      } else if (isSwitched == true) {
                        setState(() {
                          tileShow = false;
                          isSwitched = false;
                          falseFunction();
                          NotificationApi2.cancelNotification();
                        });
                      }
                      setState(() {});
                    },
                    padding: const EdgeInsets.only(right: 20),
                    icon: isSwitched == true
                        ? const Icon(
                            Icons.toggle_on,
                            color: Colors.black,
                            size: 50,
                          )
                        : const Icon(
                            Icons.toggle_off_outlined,
                            color: Colors.blueGrey,
                            size: 50,
                          ),
                  ),
                ),
                tileShow
                    ? Padding(
                        padding: const EdgeInsets.only(left: 50.0, right: 50),
                        child: Container(
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            tileColor: Colors.cyan[100],
                            title: Center(
                              child: RichText(
                                  text: TextSpan(
                                      text: sharedTime != null
                                          ? "Remainder Time: "
                                          : "Select time ",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                      children: [
                                    TextSpan(
                                      text: sharedTime == null
                                          ? ""
                                          : "$sharedTime",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    )
                                  ])),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                timepicker(context);
                              },
                              icon: const Icon(
                                Icons.timer,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                settingsbutton(
                    text: "About",
                    ontap: () {
                      deletePopup(
                          context: context,
                          title: "About",
                          message: "Devoloper : Bassam Basheer N ",
                          btn1: "",
                          btn2: "Close",
                          onpressdel: () {},
                          onpresscancel: () {
                            Navigator.of(context).pop();
                          });
                    }),
                settingsbutton(text: "Version 1.0")
              ],
            ),
          )),
    );
  }
}
