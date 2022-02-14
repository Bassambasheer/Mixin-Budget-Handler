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
ValueNotifier<double> grandtotal = ValueNotifier(0);

/* total amount*/
total() async {
  final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
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

  grandtotal.value = 0;
  grandtotal.value = incomeamounts - expenseamounts;
  grandtotal.notifyListeners();
}

/* total amount by date*/
totalbydate({date}) async {
  final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
  double incomeamounts = 0;
  double expenseamounts = 0;

  List<int> incomecategorykey = _db.keys
      .cast<int>()
      .where((Key) =>
          _db.get(Key)!.type == CategoryType.income &&
          _db.get(Key)!.date.day == date)
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
      .where((Key) =>
          _db.get(Key)!.type == CategoryType.expense &&
          _db.get(Key)!.date.day == date)
      .toList();
  for (var i = 0; i < expensecategorykey.length; i++) {
    final TransactionModel? expenseTransaction = _db.get(expensecategorykey[i]);
    expenseamounts = expenseamounts + expenseTransaction!.amount;
  }
  expense.value = 0;
  expense.value = expenseamounts;
  expense.notifyListeners();
}

/* total amount by month*/
totalbymonth({month}) async {
  final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
  double incomeamounts = 0;
  double expenseamounts = 0;

  List<int> incomecategorykey = _db.keys
      .cast<int>()
      .where((Key) =>
          _db.get(Key)!.type == CategoryType.income &&
          _db.get(Key)!.date.month == month)
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
      .where((Key) =>
          _db.get(Key)!.type == CategoryType.expense &&
          _db.get(Key)!.date.month == month)
      .toList();
  for (var i = 0; i < expensecategorykey.length; i++) {
    final TransactionModel? expenseTransaction = _db.get(expensecategorykey[i]);
    expenseamounts = expenseamounts + expenseTransaction!.amount;
  }
  expense.value = 0;
  expense.value = expenseamounts;
  expense.notifyListeners();
}

totalcustom(DateTime startdate, DateTime enddate) async {
  final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
  double incomeamounts = 0;
  double expenseamounts = 0;
  int difference = enddate.difference(startdate).inDays;

  List<int> rangeKeyincome = [];
  List<int> rangeKeyexpense = [];
  for (int i = 0; i <= difference; i++) {
    rangeKeyincome.addAll(_db.keys
        .cast<int>()
        .where((Key) =>
            _db.get(Key)!.date == startdate.add(Duration(days: i)) &&
            _db.get(Key)!.type == CategoryType.income)
        .toList());
  }
  for (var i = 0; i < rangeKeyincome.length; i++) {
    final TransactionModel? incomeTransaction = _db.get(rangeKeyincome[i]);
    incomeamounts = incomeamounts + incomeTransaction!.amount;
  }
  income.value = 0;
  income.value = incomeamounts;
  income.notifyListeners();

  for (int i = 0; i <= difference; i++) {
    rangeKeyexpense.addAll(_db.keys
        .cast<int>()
        .where((Key) =>
            _db.get(Key)!.date == startdate.add(Duration(days: i)) &&
            _db.get(Key)!.type == CategoryType.expense)
        .toList());
  }

  for (var i = 0; i < rangeKeyexpense.length; i++) {
    final TransactionModel? expenseTransaction = _db.get(rangeKeyexpense[i]);
    expenseamounts = expenseamounts + expenseTransaction!.amount;
  }
  expense.value = 0;
  expense.value = expenseamounts;
  expense.notifyListeners();
}

/*piechart*/
List<dynamic> incomecategories = [];
List expensecategories = [];
List incomecatname = [];
List incomeamt = [];
List expensecatname = [];
List expenseamt = [];
Map<String, double> incallMap = {};
Map<String, double> expallMap = {};

/*all */
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

/* by date */
incomepiedatabydate({dat}) async {
  final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
  incomecategories.clear();
  expensecategories.clear();
  List<int> incomecategorykey = _db.keys
      .cast<int>()
      .where((Key) =>
          _db.get(Key)!.type == CategoryType.income &&
          _db.get(Key)!.date.day == dat)
      .toList();
  for (int i = 0; i < incomecategorykey.length; i++) {
    final TransactionModel? incomecatgry = _db.get(incomecategorykey[i]);
    incomecategories.add(incomecatgry!.category.name);
    incomecategories.add(incomecatgry.amount);
  }
  List<int> expensecategorykey = _db.keys
      .cast<int>()
      .where((Key) =>
          _db.get(Key)!.type == CategoryType.expense &&
          _db.get(Key)!.date.day == dat)
      .toList();
  for (int i = 0; i < expensecategorykey.length; i++) {
    final TransactionModel? expensecatgry = _db.get(expensecategorykey[i]);
    expensecategories.add(expensecatgry!.category.name);
    expensecategories.add(expensecatgry.amount);
  }
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

/* monthly */
incomepiedatabyMonth({monthly}) async {
  final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
  incomecategories.clear();
  expensecategories.clear();
  List<int> incomecategorykey = _db.keys
      .cast<int>()
      .where((Key) =>
          _db.get(Key)!.date.month == monthly &&
          _db.get(Key)!.type == CategoryType.income)
      .toList();
  for (int i = 0; i < incomecategorykey.length; i++) {
    final TransactionModel? incomecatgry = _db.get(incomecategorykey[i]);
    incomecategories.add(incomecatgry!.category.name);
    incomecategories.add(incomecatgry.amount);
  }
  List<int> expensecategorykey = _db.keys
      .cast<int>()
      .where((Key) =>
          _db.get(Key)!.date.month == monthly &&
          _db.get(Key)!.type == CategoryType.expense)
      .toList();
  for (int i = 0; i < expensecategorykey.length; i++) {
    final TransactionModel? expensecatgry = _db.get(expensecategorykey[i]);
    expensecategories.add(expensecatgry!.category.name);
    expensecategories.add(expensecatgry.amount);
  }
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

incomepiedatabycustom(DateTime startdate, DateTime enddate) async {
  final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
  incomecategories.clear();
  expensecategories.clear();
  int difference = enddate.difference(startdate).inDays;

  List<int> rangeKeyincome = [];
  List<int> rangeKeyexpense = [];

  for (int i = 0; i <= difference; i++) {
    rangeKeyincome.addAll(_db.keys
        .cast<int>()
        .where((Key) =>
            _db.get(Key)!.date == startdate.add(Duration(days: i)) &&
            _db.get(Key)!.type == CategoryType.income)
        .toList());
  }
  for (int i = 0; i < rangeKeyincome.length; i++) {
    final TransactionModel? incomecatgry = _db.get(rangeKeyincome[i]);
    incomecategories.add(incomecatgry!.category.name);
    incomecategories.add(incomecatgry.amount);
  }
  for (int i = 0; i <= difference; i++) {
    rangeKeyexpense.addAll(_db.keys
        .cast<int>()
        .where((Key) =>
            _db.get(Key)!.date == startdate.add(Duration(days: i)) &&
            _db.get(Key)!.type == CategoryType.expense)
        .toList());
  }
  for (int i = 0; i < rangeKeyexpense.length; i++) {
    final TransactionModel? expensecatgry = _db.get(rangeKeyexpense[i]);
    expensecategories.add(expensecatgry!.category.name);
    expensecategories.add(expensecatgry.amount);
  }
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
