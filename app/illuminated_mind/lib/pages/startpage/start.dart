import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:illuminated_mind/models/BluetoothModel.dart';
import 'package:illuminated_mind/models/AudioModel.dart';

class StartPage extends StatefulWidget {
  _StartState createState() => _StartState();
}

class _StartState extends State<StartPage> {
  List bubbles;
  List buttons;
  double _opacity = 0;
  int counter = 0;
  bool waitAnimation = false;

  void handleProgress() {
    if (!waitAnimation) {
      ScopedModel.of<AudioModel>(context).play("click.mp3");

      if (counter < bubbles.length - 1) {
        setState(() {
          _opacity = 0;
          waitAnimation = true;
        });
        Future.delayed(const Duration(milliseconds: 600), () {
          setState(() {
            _opacity = 1;
            waitAnimation = false;
            counter++;
          });
        });
      } else {
        ScopedModel.of<AudioModel>(context).play("start.mp3");
        ScopedModel.of<AbstractBluetoothModel>(context).sendData("s1");
        Navigator.pushReplacementNamed(context, "/runes");
      }
    }
  }

  @override
  void initState() {
    super.initState();

    ScopedModel.of<AudioModel>(context).playBackground();

    buttons = [
      Image.asset("assets/pages/start/start_btn_0.png"),
      Image.asset("assets/pages/start/start_btn_1.png"),
      Image.asset("assets/pages/start/start_btn_2.png"),
      Image.asset("assets/pages/start/start_btn_3.png"),
    ];

    bubbles = [
      Image.asset("assets/pages/start/bubble_1.png"),
      Image.asset("assets/pages/start/bubble_1.png"),
      Image.asset("assets/pages/start/bubble_2.png"),
      Image.asset("assets/pages/start/bubble_3.png")
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    buttons.forEach((e) => precacheImage(e.image, context));
    bubbles.forEach((e) => precacheImage(e.image, context));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AbstractBluetoothModel>(
      builder: (context, child, model) => Scaffold(
              body: Stack(
            children: <Widget>[
              _buildBackground(),
              _buildSpeachBubble(),
              _buildButton(),
            ],
          )),
    );
  }

  Container _buildButton() {
    return Container(
        margin: const EdgeInsets.only(top: 550.0, left: 40.0, right: 40.0),
        child: ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: FlatButton(
              child: buttons[counter],
              onPressed: () => handleProgress(),
            )));
  }

  AnimatedOpacity _buildSpeachBubble() {
    return AnimatedOpacity(
        opacity: _opacity,
        duration: Duration(milliseconds: 600),
        child: Container(
            margin: const EdgeInsets.only(
                top: 20.0, left: 30.0, right: 55.0, bottom: 335.0),
            decoration: new BoxDecoration(
                image: new DecorationImage(
              image: bubbles[counter].image,
              fit: BoxFit.fill,
            ))));
  }

  Container _buildBackground() {
    return Container(
        decoration: new BoxDecoration(
      image: new DecorationImage(
        image: new AssetImage("assets/pages/start/background.png"),
        fit: BoxFit.cover,
      ),
    ));
  }
}
