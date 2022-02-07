import 'dart:math';

import 'package:flutter/material.dart';
import 'package:money_management/screens/main_screen.dart';
import 'package:money_management/screens/widgets/home_widgets.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    total();
    toHome();
     incomepiedata();
    inc();
    piemap();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 200,),
          Center(
              child: Image.asset(
            r"assets\images\splash icon.jpg",
            scale: 11,
          )),
          const Text(
            "Manage it\n in your way",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontFamily: "Roboto"),
          ),
          const SizedBox(height: 270,),
           Container(
             alignment: Alignment.bottomCenter,
             child: const Text(
                   "Mixin Budget Handler",
                   style: TextStyle(fontSize: 18, fontFamily: "Cinzel",
                   color: Colors.white),
                   textAlign: TextAlign.center,
                 ),
           ),
        ],
      ),
    );
  }

  toHome() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => MainScreen()));
  }
}
