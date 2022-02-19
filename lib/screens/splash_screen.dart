import 'package:flutter/material.dart';
import 'package:money_management/screens/main_screen.dart';
import 'package:money_management/screens/widgets/piedata.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           SizedBox(
            height: MediaQuery.of(context).size.height/ 3.8,
          ),
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
           SizedBox(
            height: MediaQuery.of(context).size.height/ 2.9,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: const Text(
              "Mixin Budget Handler",
              style: TextStyle(
                  fontSize: 18, fontFamily: "Cinzel", color: Colors.white),
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
