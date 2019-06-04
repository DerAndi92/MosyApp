import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:illuminated_mind/pages/bluetoothPage/bluetooth.dart';
import 'package:illuminated_mind/pages/finalPage/final.dart';
import 'package:illuminated_mind/pages/interimResultPage/interimResult.dart';
import 'package:illuminated_mind/pages/startPage/start.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:illuminated_mind/pages/runesPage/runes.dart';
import 'package:illuminated_mind/models/BluetoothModel.dart';
import 'package:illuminated_mind/models/QuestModel.dart';
import 'package:illuminated_mind/models/AudioModel.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(IlluminatedMind(
        bluetoothModel: BluetoothModel(),
        questModel: QuestModel(),
        audioModel: AudioModel()));
  });
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
  final AudioModel audioModel;

  const IlluminatedMind(
      {Key key,
      @required this.bluetoothModel,
      @required this.questModel,
      @required this.audioModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return ScopedModel<QuestModel>(
      model: questModel,
      child: ScopedModel<AbstractBluetoothModel>(
        model: bluetoothModel,
        child: ScopedModel<AudioModel>(
          model: audioModel,
          child: MaterialApp(
            theme: _themeData,
            home: RunesPage(),
            routes: {
              '/bluetooth': (BuildContext context) => BluetoothPage(),
              '/start': (BuildContext context) => StartPage(),
              '/runes': (BuildContext context) => RunesPage(),
              '/interimResult': (BuildContext context) => InterimResultPage(),
              '/finalResult': (BuildContext context) => FinalPage(),
            },
          ),
        ),
      ),
    );
  }
}
