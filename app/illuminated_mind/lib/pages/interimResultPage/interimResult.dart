import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:illuminated_mind/models/QuestModel.dart';
import 'package:illuminated_mind/models/BluetoothModel.dart';
import 'package:illuminated_mind/models/AudioModel.dart';
import 'dart:io';


class InterimResultPage extends StatefulWidget {
  _InterimResultState createState() => _InterimResultState();
}

class _InterimResultState extends State<InterimResultPage> {

  double _opacityBubble = 1;
  double _opacityButton = 0;

  _goToRunes(BuildContext context, QuestModel model) {
    model.generateInterimResult();
    model.setNextLayer();
    Navigator.pushReplacementNamed(context, "/runes");
    ScopedModel.of<AbstractBluetoothModel>(context)
        .writeCharacteristic("e00" + (model.runeLayer + 1).toString());
  }

  _sendState(BuildContext context) {
    sleep(const Duration(seconds: 2));

    List<int> evaluatedResult =
        ScopedModel.of<QuestModel>(context).evaluatedResult;
    String sendingString = "f";
    evaluatedResult.asMap().forEach(
          (index, evaluatedResult) =>
              {sendingString = sendingString + evaluatedResult.toString()},
        );
    ScopedModel.of<AbstractBluetoothModel>(context)
        .writeCharacteristic(sendingString);
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _opacityBubble = 0;
        _opacityButton = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _sendState(context);
    return ScopedModelDescendant<QuestModel>(
      builder: (context, child, model) => Scaffold(
          body: Stack(
            children: <Widget>[
              Container(
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: new AssetImage("assets/pages/result/background.png"),
                      fit: BoxFit.cover,
                    ),
                  )),
              Positioned(
                top: 125,
                left: 30,
                child:
                  Image(
                    height: 100,
                    width: 100,
                    image: AssetImage("assets/pages/runes/rune_" +
                        model.interimResult[0].toString() +
                        ".png"),
                  )
              ),
              Positioned(
                top: 20,
                left: 70,
                child:
                  Image(
                    height: 100,
                    width: 100,
                    image: AssetImage("assets/pages/runes/rune_" +
                        model.interimResult[1].toString() +
                        ".png"),
                  )
              ),
              Positioned(
                top: 20,
                right: 70,
                child:
                  Image(
                    height: 100,
                    width: 100,
                    image: AssetImage("assets/pages/runes/rune_" +
                        model.interimResult[2].toString() +
                        ".png"),
                  )
              ),
              Positioned(
                top: 125,
                right: 30,
                child:
                  Image(
                    height: 100,
                    width: 100,
                    image: AssetImage("assets/pages/runes/rune_" +
                        model.interimResult[3].toString() +
                        ".png"),
                  )
              ),
              AnimatedOpacity(
                  opacity: _opacityBubble,
                  duration: Duration(milliseconds: 400),
                  child: Container(
                      margin: const EdgeInsets.only(
                          top: 430.0, left: 60.0, right: 10, bottom: 30.0),
                      decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: Image.asset("assets/pages/result/bubble.png").image,
                            fit: BoxFit.fill,
                          )))
              ),
               AnimatedOpacity(
                  opacity: _opacityButton,
                  duration: Duration(milliseconds: 400),
                  child: Container(
                      margin: const EdgeInsets.only(
                          top: 550.0, left: 40.0, right: 40.0),
                      child: ConstrainedBox(
                          constraints: BoxConstraints.expand(),
                          child: FlatButton(
                            child: Image.asset("assets/pages/result/btn_next.png"),
                            onPressed: () {
                              ScopedModel.of<AudioModel>(context).play("click.mp3");
                              _goToRunes(context, model);
                            },
                          )
                      )
                  )),
            ],
          )),
    );
  }

}
