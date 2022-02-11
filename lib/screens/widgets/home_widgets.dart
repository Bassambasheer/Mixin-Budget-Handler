import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_management/screens/widgets/piedata.dart';
DateTime month = DateTime.now();
String formattedMonth = DateFormat('MMMM').format(month);
 int? eachmonth;
Widget card({category, amount, boxcolor, borderclr,context}) {
  return Container(
    decoration: BoxDecoration(
      color: boxcolor,
      borderRadius: BorderRadiusDirectional.circular(10),
      boxShadow: [
        BoxShadow(
          color: borderclr,
          spreadRadius: 1,
          blurRadius: 2,
          offset: const Offset(7, 5), // changes position of shadow
        ),
      ],
    ),
    margin: const EdgeInsets.all(15),
    height: MediaQuery.of(context).size.height/ 8,
     width: MediaQuery.of(context).size.width / 2.5,
    child: Padding(
      padding: const EdgeInsets.all(9.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                amount,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget heading({head, trail}) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          head,
          style: const TextStyle(fontSize: 25, fontFamily: "Roboto"),
        ),
        const SizedBox(height: 20),
        Text(trail),
        const SizedBox(height: 20),
      ],
    ),
  );
}

Widget settingsbutton({text, ontap}) {
  return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: Card(
        elevation: 3,
        child: ListTile(
          tileColor: Colors.blue[100],
          onTap: ontap,
          title: Text(
            text,
            textAlign: TextAlign.center,
          ),
        ),
      ));
}

Widget new_text({required String txt1, required String txt2}) {
  return RichText(
    text: TextSpan(
      text: '$txt1.\n',
      style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black),
      children: <TextSpan>[
        TextSpan(
            text: txt2,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black)),
      ],
    ),
  );
}
 
monthfunction(){
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
}

reload() {
  var _dateToday = DateTime.now();
  var _dateYesterday = DateTime.now().subtract(Duration(days: 1));
  if (All == true) {
    incomepiedata();
  } else if (Today == true) {
    incomepiedatabydate(dat: _dateToday.day);
  } else if (Yesterday == true) {
    incomepiedatabydate(dat: _dateYesterday.day);
  }
}

reloadtotal() async {
  var _dateToday = DateTime.now();
  var _dateYesterday = DateTime.now().subtract(Duration(days: 1));
  if (All == true) {
    await total();
  } else if (Today == true) {
    await totalbydate(date: _dateToday.day);
  } else if (Yesterday == true) {
    await totalbydate(date: _dateYesterday.day);
  }

}
