import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_management/controller/controller.dart';
import 'package:money_management/utility/category_db.dart';
import 'package:money_management/screens/widgets/delete_popup.dart';

class IncomeCategory extends StatelessWidget {
  const IncomeCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return ListView.separated(
            itemBuilder: (ctx, index) {
              final category = incomeCategoryListNotifier[index];
              return Padding(
                padding: const EdgeInsets.only(left: 8,right: 8),
                child: Card(
                   shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.cyan[100],
            elevation: 4,
                  child: ListTile(
                      onLongPress: () {
                        deletePopup(
                            context: context,
                            title: "Confirm",
                            message: "Are sure you want to delete?",
                            btn1: "Delete",
                            btn2: "CANCEL",
                            onpressdel: () {
                              CategoryDB.instance.deleteCategory(category.id);
                              Navigator.of(context).pop();
                            },
                            onpresscancel: () {
                              Navigator.of(context).pop();
                            });
                      },
                      leading: Text(category.name.toUpperCase())),
                ),
              );
            },
            separatorBuilder: (ctx, index) {
              return const SizedBox(height: 1);
            },
            itemCount: incomeCategoryListNotifier.length);
      },
    );
  }
}
