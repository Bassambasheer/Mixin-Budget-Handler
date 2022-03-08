import 'package:flutter/material.dart';
import 'package:money_management/screens/widgets/home_widgets.dart';
import 'package:money_management/screens/widgets/tab_bar.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heading(head: "Categories.", trail: "Manage your CATAGORIES Here"),
        const Expanded(child: TabBarWidget()),
      ],
    );
  }
}
