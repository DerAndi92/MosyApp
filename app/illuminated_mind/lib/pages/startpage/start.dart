import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:illuminated_mind/models/BluetoothModel.dart';

import 'package:illuminated_mind/pages/runesPage/runes.dart';
import 'package:illuminated_mind/pages/startPage/startWidgets.dart';

class StartPage extends StatefulWidget {
  _StartState createState() => _StartState();
}

class _StartState extends State<StartPage> {
  final List<String> bubbleStrings = [
    "Willkommen zu deiner Prüfung",
    "Du bist ein Lehrling der Zauberkünste und möchtest deinen Abschluss erlangen.",
    "bla bla bla... Du kannst jetzt starten"
  ];

  int counter = 0;
  bool buttonText = false;

  void handleBubbleText() {
    if (counter == (bubbleStrings.length - 2)) {
      setState(() {
        buttonText = true;
        counter++;
      });
    } else if (counter < (bubbleStrings.length - 1)) {
      setState(() {
        counter++;
      });
    } else {
      Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (BuildContext context) => RunesPage()),
      );
    }
  }

  void _writeToBlue(AbstractBluetoothModel model) {
    model.writeCharacteristic("Hallo");
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AbstractBluetoothModel>(
      builder: (context, child, model) => Scaffold(
            body: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                SpeechBubbleWidget(bubbleStrings[counter]),
                RaisedButton(
                  child: Text(buttonText ? "Los gehts" : "Weiter"),
                  onPressed: () => handleBubbleText(),
                ),
                RaisedButton(
                  child: Text(model.device.name.toString()),
                  onPressed: () => _writeToBlue(model),
                )
              ]),
            ),
          ),
    );
  }
}
