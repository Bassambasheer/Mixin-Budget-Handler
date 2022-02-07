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

ValueNotifier<double> income = ValueNotifier(0);
ValueNotifier<double> expense = ValueNotifier(0);
total() async {
  final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
  // Box<TransactionModel> _db = Hive.box<TransactionModel>(TRANSACTION_DB_NAME);
  double incomeamounts = 0;
  double expenseamounts = 0;

  List<int> incomecategorykey = _db.keys
      .cast<int>()
      .where((Key) => _db.get(Key)!.type == CategoryType.income)
      .toList();
  for (var i = 0; i < incomecategorykey.length; i++) {
    final TransactionModel? incomeTransaction = _db.get(incomecategorykey[i]);
    incomeamounts = incomeamounts + incomeTransaction!.amount;
  }
  income.value = 0;
  income.value = incomeamounts;
  income.notifyListeners();

  List<int> expensecategorykey = _db.keys
      .cast<int>()
      .where((Key) => _db.get(Key)!.type == CategoryType.expense)
      .toList();
  for (var i = 0; i < expensecategorykey.length; i++) {
    final TransactionModel? expenseTransaction = _db.get(expensecategorykey[i]);
    expenseamounts = expenseamounts + expenseTransaction!.amount;
  }
  expense.value = 0;
  expense.value = expenseamounts;
  expense.notifyListeners();
}

/*piechart*/

Map<String, double> incallMap = {};
List<dynamic> incomecategories = [];
List expensecategories = [];
Map<String, double> expallMap = {};

incomepiedata() async {
  final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
  incomecategories.clear();
  expensecategories.clear();
  List<int> incomecategorykey = _db.keys
      .cast<int>()
      .where((Key) => _db.get(Key)!.type == CategoryType.income)
      .toList();
  for (int i = 0; i < incomecategorykey.length; i++) {
    final TransactionModel? incomecatgry = _db.get(incomecategorykey[i]);
    incomecategories.add(incomecatgry!.category.name);
    incomecategories.add(incomecatgry.amount);
  }
  List<int> expensecategorykey = _db.keys
      .cast<int>()
      .where((Key) => _db.get(Key)!.type == CategoryType.expense)
      .toList();
  for (int i = 0; i < expensecategorykey.length; i++) {
    final TransactionModel? expensecatgry = _db.get(expensecategorykey[i]);
    expensecategories.add(expensecatgry!.category.name);
    expensecategories.add(expensecatgry.amount);
  }
}

List incomecatname = [];
List incomeamt = [];
List expensecatname = [];
List expenseamt = [];
inc() {
  incomecatname.clear();
  incomeamt.clear();
  expensecatname.clear();
  expenseamt.clear();
  for (int i = 0; i < incomecategories.length; i++) {
    if (i % 2 == 0 || i == 0) {
      incomecatname.add(incomecategories[i]);
    } else {
      incomeamt.add(incomecategories[i]);
    }
  }
  for (int i = 0; i < expensecategories.length; i++) {
    if (i % 2 == 0 || i == 0) {
      expensecatname.add(expensecategories[i]);
    } else {
      expenseamt.add(expensecategories[i]);
    }
  }
}

double expsum = 0;
piemap() {
  incallMap.clear();
  expallMap.clear();
  if (incallMap == null) {
    incallMap = {"income category": 1};
  }
    if (expallMap == null) {
    expallMap = {"expense category": 1};
  }
  for (int i = 0; i < incomecatname.length; i++) {
    for (var j = i + 1; j < incomeamt.length; j++) {
      if (incomecatname[i] == incomecatname[j]) {
        incomeamt[i] = incomeamt[i] + incomeamt[j];
        incomeamt[j] = 0.0;
        incomecatname[j] = "";
      }
    }
    incomeamt.removeWhere((item) => item == 0.0);
    incomecatname.removeWhere((item) => item == "");
    incallMap.addAll({incomecatname[i]: incomeamt[i]});
  }
  for (int i = 0; i < expensecatname.length; i++) {
    for (var j = i + 1; j < expenseamt.length; j++) {
      if (expensecatname[i] == expensecatname[j]) {
        expenseamt[i] = expenseamt[i] + expenseamt[j];
        expenseamt[j] = 0.0;
        expensecatname[j] = "";
      }
    }
    expenseamt.removeWhere((item) => item == 0.0);
    expensecatname.removeWhere((item) => item == "");
    print(expenseamt);
    expallMap.addAll({expensecatname[i]: expenseamt[i]});
  }
  // print(expallMap);
  // print(incallMap);
}
