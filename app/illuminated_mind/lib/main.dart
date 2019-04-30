import 'package:flutter/material.dart';

import './pages/bluetooth/bluetooth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: FlutterBlueApp(),
    );
  }
}
