import 'package:flutter/material.dart';

Future<void> deletePopup({context,onpressdel,onpresscancel,title,message,btn1,btn2}) async {
  showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: Text(title),
          children: [
            const SizedBox(height: 20),
             Center(child: Text(message)),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,                children: [
                TextButton(onPressed: onpressdel, child:  Text(btn1,
                style: TextStyle(
                  color: Colors.red
                ),)),
                 TextButton(onPressed: onpresscancel, child: Text(btn2))
              ],
            )
          ],
        );
      });
}
