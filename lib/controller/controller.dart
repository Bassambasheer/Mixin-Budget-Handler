 import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:money_management/db_models/category_model.dart';
import 'package:money_management/db_models/transaction_model.dart';


// Controller For Transaction DataBase Values//

RxList<TransactionModel> transactionListNotifier =
<TransactionModel>[].obs;
RxList<TransactionModel> incomeTransactionListNotifier =
<TransactionModel>[].obs;
RxList<TransactionModel> expenseTransactionListNotifier =
<TransactionModel>[].obs;
RxList<CategoryModel> incomeCategoryListNotifier =
<CategoryModel>[].obs;
RxList<CategoryModel> expenseCategoryListNotifier =
<CategoryModel>[].obs;