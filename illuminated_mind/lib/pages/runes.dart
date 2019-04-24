import 'package:flutter/material.dart';

class RunesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Text(
            "Spielanleitung",
            textScaleFactor: 2,
          ),
          Text("Mehr Infoos"),
        ]),
      ),
    );
  }
}
