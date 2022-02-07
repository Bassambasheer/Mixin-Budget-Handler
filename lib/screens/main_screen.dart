import 'package:flutter/material.dart';
import 'package:money_management/screens/add_transactions_screen.dart';
import 'package:money_management/screens/catergory_screen.dart';
import 'package:money_management/screens/home_screen.dart';
import 'package:money_management/screens/settings_screen.dart';
import 'package:money_management/screens/stats_screen.dart';
import 'package:money_management/screens/widgets/add_category.dart';
import 'package:money_management/screens/widgets/bottom_navigation.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);
  static ValueNotifier<int> selectedIndexNOtifier = ValueNotifier(0);
  final _pages = [
    const HomeScreen(),
    const StatsScreen(),
    const CategoryScreen(),
    SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.lightBlue, Colors.blue, Colors.white])),
    child:
    Scaffold(
      backgroundColor: Colors.grey.withOpacity(0),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedIndexNOtifier.value == 2) {
            showCategoryAddPopup(context);
          } else {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const AddTransactions()));
          }
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomBar(),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: selectedIndexNOtifier,
          builder: (BuildContext context, int updatedIndex, _) {
            return _pages[updatedIndex];
          },
        ),
      ),
    )
    );
  }
}
