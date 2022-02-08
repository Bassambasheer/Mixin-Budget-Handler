
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_management/utility/transaction_db.dart';
import 'package:money_management/db_models/category_model.dart';
import 'package:money_management/db_models/transaction_model.dart';
  bool All = true;
  bool Today = false;
  bool Yesterday = false;
  bool Custom = false;
  bool Monthly = false;
    String parseDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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
    expallMap.addAll({expensecatname[i]: expenseamt[i]});
  }
}
