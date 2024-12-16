import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {

  static const TextStyle textGray500_w400_14 = TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 14, height: 1.0);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("404",
                    style: TextStyle(
                        color:Colors.grey,
                        fontSize: 35,
                        fontWeight: FontWeight.w800)),
                Container(
                  margin: EdgeInsets.only(top: 16),
                  child: Text("not found", style: textGray500_w400_14),
                )
              ],
            ),
          ),
        ));
  }
}
