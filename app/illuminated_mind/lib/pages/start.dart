import 'package:flutter/material.dart';
import 'runes.dart';
import 'speechBubble.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          SpeechBubbleWidget(bubbleStrings[counter]),
          RaisedButton(
            child: Text(buttonText ? "Los gehts" : "Weiter"),
            onPressed: () => handleBubbleText(),
          )
        ]),
      ),
    );
  }
}
