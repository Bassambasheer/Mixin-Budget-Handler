import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management/controller/controller.dart';
import 'package:money_management/screens/widgets/add_category.dart';
import 'package:money_management/utility/category_db.dart';
import 'package:money_management/utility/transaction_db.dart';
import 'package:money_management/db_models/category_model.dart';
import 'package:money_management/db_models/transaction_model.dart';
import 'package:money_management/screens/widgets/home_widgets.dart';
import 'package:money_management/screens/widgets/piedata.dart';

class AddTransactions extends StatefulWidget {
  const AddTransactions({Key? key}) : super(key: key);

  @override
  State<AddTransactions> createState() => _AddTransactionsState();
}

class _AddTransactionsState extends State<AddTransactions> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategorytype;
  CategoryModel? _selectedCategoryModel;
  String? _categoryId;

  final _amountTextEditingController = TextEditingController();
  final _noteTextEditingController = TextEditingController();
  @override
  void initState() {
    _selectedCategorytype = CategoryType.income;
    _selectedDate = DateTime.now();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0XFF18A5A8), Color(0XFFBFFFC8)])),
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              heading(head: "Add Transactions.", trail: ""),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Radio(
                            value: CategoryType.income,
                            groupValue: _selectedCategorytype,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCategorytype = CategoryType.income;
                                _categoryId = null;
                              });
                            }),
                        const Text("Income")
                      ],
                    ),
                  ),
                  Container(
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Radio(
                            value: CategoryType.expense,
                            groupValue: _selectedCategorytype,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCategorytype = CategoryType.expense;
                                _categoryId = null;
                              });
                            }),
                        const Text("Expense")
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextButton.icon(
                        onPressed: () async {
                          final _selectedDateTemp = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 365 * 1)),
                              lastDate: DateTime.now());
                          if (_selectedDateTemp == null) {
                            return;
                          } else {
                            setState(() {
                              _selectedDate = _selectedDateTemp;
                            });
                          }
                        },
                        icon: const Icon(Icons.calendar_today),
                        label: Text(
                          _selectedDate == null
                              ? "Select Date"
                              : parseDate(_selectedDate!),
                          style: const TextStyle(fontSize: 18),
                        )),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      showCategoryAddPopup(context);
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                    label: const Text(
                      "Add a category",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  setState(() {});
                },
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Obx(
                      () {
                        return DropdownButton<String>(
                          isExpanded: true,
                          hint: const Text("Select Category"),
                          value: _categoryId,
                          items: (_selectedCategorytype == CategoryType.income
                                  ? incomeCategoryListNotifier
                                  : expenseCategoryListNotifier)
                              .map((e) {
                            return DropdownMenuItem(
                              value: e.id,
                              child: Text(e.name),
                              onTap: () {
                                _selectedCategoryModel = e;
                              },
                            );
                          }).toList(),
                          onChanged: (selectedValue) {
                            setState(() {
                              _categoryId = selectedValue;
                            });
                          },
                          underline: const SizedBox(),
                        );
                      }
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '*This Field is required';
                        }
                      },
                      textInputAction: TextInputAction.next,
                      controller: _amountTextEditingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "Amount",
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)))),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '*This Field is required';
                        }
                      },
                      textInputAction: TextInputAction.done,
                      controller: _noteTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Note",
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 70, vertical: 6),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        addTransaction();
                      }
                    },
                    child: const Text("Add")),
              )
            ],
          ),
        )),
      ),
    );
  }

  Future<void> addTransaction() async {
    final _amountText = _amountTextEditingController.text.trim();
    final _noteText = _noteTextEditingController.text.trim();
    if (_selectedCategoryModel == null) {
      Get.snackbar("Add a Category", "", snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (_amountText.isEmpty) {
      return;
    }
    if (_noteText.isEmpty) {
      return;
    }
    final _parsedamount = double.tryParse(_amountText);
    if (_parsedamount == null) {
      return;
    }
    final _model = TransactionModel(
      date: _selectedDate!,
      type: _selectedCategorytype!,
      category: _selectedCategoryModel!,
      amount: _parsedamount,
      note: _noteText,
    );
    await TransactionDB.instance.addTransaction(_model);
    await total();
    await incomepiedata();
    Get.back();
    TransactionDB.instance.refresh();
  }

  String parseDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
