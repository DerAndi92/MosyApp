import 'package:flutter/material.dart';

import './pages/bluetoothPage/bluetooth.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(IlluminatedMind());
}

final ThemeData _themeData = new ThemeData(
    scaffoldBackgroundColor: Colors.blueGrey[900],
    backgroundColor: Colors.blueGrey[900],
    brightness: Brightness.dark,
    accentColor: Colors.blueGrey,
    primaryColor: Colors.teal[700],
    buttonColor: Colors.pink[900],
    textTheme: TextTheme(
      headline: TextStyle(
          color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
      title: TextStyle(color: Colors.white, fontSize: 24.0),
      body1: TextStyle(color: Colors.white, fontSize: 14.0),
    ));

class IlluminatedMind extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      theme: _themeData,
      home: BluetoothPage(),
    );
  }
}
