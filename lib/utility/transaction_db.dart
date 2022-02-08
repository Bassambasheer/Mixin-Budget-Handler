import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_management/db_models/category_model.dart';
import 'package:money_management/db_models/transaction_model.dart';
import 'package:money_management/screens/widgets/piedata.dart';

const TRANSACTION_DB_NAME = 'transaction_db';

abstract class TransactionDbFunctions {
  Future<void> addTransaction(TransactionModel obj);
  Future<List<TransactionModel>> getAllTransactions();
  Future<void> deleteTransaction(int transactionID);
}

class TransactionDB implements TransactionDbFunctions {
  TransactionDB._internal();
  static TransactionDB instance = TransactionDB._internal();
  factory TransactionDB() {
    return instance;
  }
  ValueNotifier<List<TransactionModel>> incomeTransactionListNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> expenseTransactionListNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> transactionListNotifier =
      ValueNotifier([]);

  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    final _key = await _db.add(obj);
    obj.key = _key;
    await _db.put(obj.key, obj);
  }
  Future<void> refreshTransactions({dat}) async {
    final _allTransactions = await getAllTransactions();
    _allTransactions.sort((first, second) => second.date.compareTo(first.date));
    incomeTransactionListNotifier.value.clear();
    expenseTransactionListNotifier.value.clear();
    await Future.forEach(
      _allTransactions,
      (TransactionModel category) {
        if (category.type == CategoryType.income && parseDate(category.date) == dat) {
          incomeTransactionListNotifier.value.add(category);
        } else  if (category.type == CategoryType.expense && parseDate(category.date) == dat) {
          expenseTransactionListNotifier.value.add(category);
        }
      },
    );
    incomeTransactionListNotifier.notifyListeners();
    expenseTransactionListNotifier.notifyListeners();
  }

   Future<void> refreshMonthlyTransactions({monthly}) async {
    final _allTransactions = await getAllTransactions();
    _allTransactions.sort((first, second) => second.date.compareTo(first.date));
    incomeTransactionListNotifier.value.clear();
    expenseTransactionListNotifier.value.clear();
    await Future.forEach(
      _allTransactions,
      (TransactionModel category) {
        if (category.type == CategoryType.income && category.date.month == monthly) {
          incomeTransactionListNotifier.value.add(category);
        } else  if (category.type == CategoryType.expense && category.date.month == monthly) {
          expenseTransactionListNotifier.value.add(category);
        }
      },
    );
    incomeTransactionListNotifier.notifyListeners();
    expenseTransactionListNotifier.notifyListeners();
  }

  // Future<void> refreshCustomTransactions({monthly}) async {
  //   final _allTransactions = await getAllTransactions();
  //   _allTransactions.sort((first, second) => second.date.compareTo(first.date));
  //   incomeTransactionListNotifier.value.clear();
  //   expenseTransactionListNotifier.value.clear();
  //   await Future.forEach(
  //     _allTransactions,
  //     (TransactionModel category) {
  //       if (category.type == CategoryType.income && category.date.month == monthly) {
  //         incomeTransactionListNotifier.value.add(category);
  //       } else  if (category.type == CategoryType.expense && category.date.month == monthly) {
  //         expenseTransactionListNotifier.value.add(category);
  //       }
  //     },
  //   );
  //   incomeTransactionListNotifier.notifyListeners();
  //   expenseTransactionListNotifier.notifyListeners();
  // }
   Future<void> refreshAllTransactions() async {
    final _allTransactions = await getAllTransactions();
    _allTransactions.sort((first, second) => second.date.compareTo(first.date));
    incomeTransactionListNotifier.value.clear();
    expenseTransactionListNotifier.value.clear();
    await Future.forEach(
      _allTransactions,
      (TransactionModel category) {
        if (category.type == CategoryType.income) {
            incomeTransactionListNotifier.value.add(category);
        } else {
          expenseTransactionListNotifier.value.add(category);
        }
      },
    );
    incomeTransactionListNotifier.notifyListeners();
    expenseTransactionListNotifier.notifyListeners();
  }
  

  Future<void> refresh() async {
    final _list = await getAllTransactions();
    _list.sort((first, second) => second.date.compareTo(first.date));
    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(_list);
    transactionListNotifier.notifyListeners();
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return _db.values.toList();
  }

  transactionsClear() async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.clear();
    refresh();
    refreshTransactions();
  }

  @override
  Future<void> deleteTransaction(int transactionID) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.delete(transactionID);
    refresh();
  }

}
