import 'package:flutter/material.dart';
import 'runes.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Text(
            "StartScreen",
            textScaleFactor: 2,
          ),
          Text("Meister heißt Lehrling willkommen"),
          RaisedButton(
            child: Text("Los gehts"),
            onPressed: () => Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => RunesPage()),
                ),
          )
        ]),
      ),
    );
  }
}
