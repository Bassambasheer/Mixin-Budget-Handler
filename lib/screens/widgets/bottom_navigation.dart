import 'package:flutter/material.dart';
import 'package:money_management/screens/main_screen.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: MainScreen.selectedIndexNOtifier,
      builder: (BuildContext ctx, int updatedIndex, Widget? _) {
        return BottomNavigationBar(
          backgroundColor: Colors.grey,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          currentIndex: updatedIndex,
          onTap: (newIndex) {
            MainScreen.selectedIndexNOtifier.value = newIndex;
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.insert_chart_outlined_rounded,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.category,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                ),
                label: "")
          ],
        );
      },
    );
  }
}
