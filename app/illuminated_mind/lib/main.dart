import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:illuminated_mind/pages/bluetoothPage/bluetooth.dart';
//import 'package:illuminated_mind/pages/runesPage/runes.dart';

import 'package:illuminated_mind/models/BluetoothModel.dart';
import 'package:illuminated_mind/models/QuestModel.dart';

void main() {
  runApp(IlluminatedMind(
      bluetoothModel: BluetoothModel(), questModel: QuestModel()));
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
  final AbstractBluetoothModel bluetoothModel;

  final QuestModel questModel;
  const IlluminatedMind(
      {Key key, @required this.bluetoothModel, @required this.questModel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return ScopedModel<QuestModel>(
      model: questModel,
      child: ScopedModel<AbstractBluetoothModel>(
        model: bluetoothModel,
        child: MaterialApp(
          theme: _themeData,
          home: BluetoothPage(),
        ),
      ),
    );
  }
}
