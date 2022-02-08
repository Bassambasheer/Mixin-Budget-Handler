import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_management/utility/transaction_db.dart';
import 'package:money_management/db_models/category_model.dart';
import 'package:money_management/db_models/transaction_model.dart';

Widget card({category, amount, boxcolor, borderclr}) {
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
    height: 100,
    width: 165,
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
monthstoint(){
  
}
