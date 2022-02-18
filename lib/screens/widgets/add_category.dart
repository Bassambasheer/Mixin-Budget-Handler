import 'package:flutter/material.dart';
import 'package:money_management/utility/category_db.dart';
import 'package:money_management/db_models/category_model.dart';

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);
final _formKey = GlobalKey<FormState>();

Future<void> showCategoryAddPopup(BuildContext context) async {
  final _nameEditingController = TextEditingController();
  showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text("Add Category"),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '*This field is required';
                    }
                  },
                  controller: _nameEditingController,
                  decoration: const InputDecoration(
                      hintText: "Category Name", border: OutlineInputBorder()),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  RadioButton(title: "Income", type: CategoryType.income),
                  RadioButton(title: "Expense", type: CategoryType.expense)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  final _name = _nameEditingController.text.trim();
                  if (_formKey.currentState!.validate()) {
                    final _type = selectedCategoryNotifier.value;
                    final _category = CategoryModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        type: _type,
                        name: _name);
                    CategoryDB.instance.insertCategory(_category);
                    Navigator.of(ctx).pop();
                  }
                },
                child: const Text("Add"),
              ),
            )
          ],
        );
      });
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;
  // final CategoryType selectedCategorytype;
  const RadioButton({Key? key, required this.title, required this.type})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
            valueListenable: selectedCategoryNotifier,
            builder: (BuildContext ctx, CategoryType newCategory, Widget? _) {
              return Radio<CategoryType>(
                  value: type,
                  groupValue: newCategory,
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    selectedCategoryNotifier.value = value;
                    selectedCategoryNotifier.notifyListeners();
                  });
            }),
        Text(title),
      ],
    );
  }
}
