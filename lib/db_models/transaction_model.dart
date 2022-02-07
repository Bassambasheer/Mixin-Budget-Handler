import 'package:hive_flutter/adapters.dart';
import 'package:money_management/db_models/category_model.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 3)
class TransactionModel {
  @HiveField(0)
  DateTime date;
  @HiveField(1)
  final CategoryType type;
  @HiveField(2)
  final CategoryModel category;
  @HiveField(3)
  final double amount;
  @HiveField(4)
  final String note;
  @HiveField(5)
  int? key;
  TransactionModel(
      {required this.date,
      required this.type,
      required this.category,
      required this.amount,
      required this.note,
      this.key});
}
