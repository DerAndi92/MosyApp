import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:illuminated_mind/models/BluetoothModel.dart';
import 'package:illuminated_mind/models/AudioModel.dart';
import 'package:illuminated_mind/pages/runesPage/runes.dart';
import 'package:illuminated_mind/pages/startPage/startWidgets.dart';

class StartPage extends StatefulWidget {
  _StartState createState() => _StartState();
}

class _StartState extends State<StartPage> {
  final List<String> bubbleStrings = [
    "Willkommen zu deiner Prüfung, Lehrling",
    "Du bist ein Lehrling der Zauberkünste und möchtest deinen Abschluss erlangen.",
    "Du bestehst die Prüfung, indem du vier Runen in der richtigen Reihenfolge wählst.",
    "Nachdem du vier Runen gewählt hast, erhälst du eine Auswertung deiner Auswahl.",
    "Bleibt das Licht der Kugel an, hast du die richtige Rune für diese Posistion gewählt. ",
    "Blinkt die Kugel, kommt die Rune in der Lösung vor, aber sie ist an der falschen Position. ",
    "Geht das Licht aus, dann ist weder Rune noch Position richtig.",
    "Nun hast du alle wichtigen Informationen. Viel Erfolg bei deiner Prüfung!"
  ];

  //Images
  Image img_start_btn_more;
  Image img_start_btn_go;

  int counter = 0;
  bool buttonText = false;

  void handleBubbleText() {
    ScopedModel.of<AudioModel>(context).play("click.mp3");
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
      ScopedModel.of<AbstractBluetoothModel>(context).writeCharacteristic("s1");
      Navigator.pushReplacementNamed(context, "/runes");
    }
  }

  @override
  void initState() {
    super.initState();

    img_start_btn_more = Image.asset("assets/pages/start/start_btn_more.png");
    img_start_btn_go = Image.asset("assets/pages/start/start_btn_go.png");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(img_start_btn_more.image, context);
    precacheImage(img_start_btn_go.image, context);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AbstractBluetoothModel>(
      builder: (context, child, model) => Scaffold(
              body: Stack(
            children: <Widget>[
              Container(
                  decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("assets/pages/start/background.png"),
                  fit: BoxFit.cover,
                ),
              )),
              Padding(
                padding: EdgeInsets.all(20),
                child: SpeechBubbleWidget(bubbleStrings[counter]),
              ),
              Container(
                  margin: const EdgeInsets.only(
                      top: 550.0, left: 40.0, right: 40.0),
                  child: ConstrainedBox(
                      constraints: BoxConstraints.expand(),
                      child: FlatButton(
                        child: (buttonText)
                            ? img_start_btn_go
                            : img_start_btn_more,
                        onPressed: () => handleBubbleText(),
                      ))),
            ],
          )),
    );
  }
}
