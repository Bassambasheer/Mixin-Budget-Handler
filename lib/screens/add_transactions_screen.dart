import 'package:flutter/material.dart';
import 'package:money_management/utility/category_db.dart';
import 'package:money_management/utility/transaction_db.dart';
import 'package:money_management/db_models/category_model.dart';
import 'package:money_management/db_models/transaction_model.dart';
import 'package:money_management/screens/widgets/home_widgets.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.lightBlue, Colors.blue, Colors.white])),
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
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
                      borderRadius: BorderRadius.circular(10),
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
                      borderRadius: BorderRadius.circular(10),
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
                      borderRadius: BorderRadius.circular(10),
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
              const SizedBox(height: 20),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text("Select Category"),
                    value: _categoryId,
                    items: (_selectedCategorytype == CategoryType.income
                            ? CategoryDB().incomeCategoryListNotifier
                            : CategoryDB().expenseCategoryListNotifier)
                        .value
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
                    onTap: () {},
                    underline: const SizedBox(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: _amountTextEditingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "Amount",
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
              const SizedBox(height: 20),
              TextFormField(
                textInputAction: TextInputAction.done,
                controller: _noteTextEditingController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Note",
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                maxLines: 5,
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
                      addTransaction();
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
    final _amountText = _amountTextEditingController.text;
    final _noteText = _noteTextEditingController.text;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Select a Date")));
      return;
    }
    // if (_categoryId == null) {
    //   return;
    // }
    if (_selectedCategoryModel == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Choose a category")));
      return;
    }
    if (_amountText.isEmpty) {                 
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Enter the amount")));
      return;
    }
    if (_noteText.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Enter your note")));
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

    inc();
    piemap();
    Navigator.of(context).pop();
    TransactionDB.instance.refresh();
  }

  String parseDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
