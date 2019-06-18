import 'package:flutter/material.dart';
import 'dart:async';
import 'package:illuminated_mind/pages/runesPage/runesWidgets.dart';
import 'package:illuminated_mind/utils/Constants.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:illuminated_mind/models/QuestModel.dart';
import 'package:illuminated_mind/models/BluetoothModel.dart';
import 'package:illuminated_mind/models/AudioModel.dart';
import 'dart:io';

class RunesPage extends StatefulWidget {
  _RunesState createState() => _RunesState();
}

class _RunesState extends State<RunesPage> {

  bool _inAction = false;
  bool _help = false;

  //Help
  bool _helpFirst = false;
  double _opacity = 1;
  bool waitHelpAnimation = false;

  bool _handleRuneTapped(BuildContext context, int color, QuestModel model) {
    if(!_inAction) {
      _inAction = true;
      ScopedModel.of<AudioModel>(context).play("rune_" + color.toString() + ".mp3");

      Future.delayed(const Duration(seconds: 1), () {
        model.replaceValueOfInterimResult(model.runeLayer, color);

        var actualLayer = (model.runeLayer + 1).toString();
        model.setNextLayer();

        if (model.runeLayer == 4) {
          _sendState(context, "e" + actualLayer + color.toString() + "5");

          model.generateEvaluatedResult();
          if (model.evaluatedResult.contains(Constants.WRONG) ||
              model.evaluatedResult.contains(Constants.EXISTS)) {
            Navigator.pushReplacementNamed(context, '/interimResult');
          } else {
            sleep(const Duration(seconds: 1));

            _sendState(context, "xg");
            ScopedModel.of<AudioModel>(context).play("final.mp3");
            Navigator.pushReplacementNamed(context, '/finalResult');
          }
        } else {
          _sendState(
              context,
              "e" +
                  actualLayer +
                  color.toString() +
                  (model.runeLayer + 1).toString());
        }
        _inAction = false;
      });
      return true;
    }
    return false;
  }

  _sendState(BuildContext context, String code) {
    ScopedModel.of<AbstractBluetoothModel>(context).writeCharacteristic(code);
  }

  _resetGame(BuildContext context) {
    ScopedModel.of<AudioModel>(context).play("click.mp3");
    ScopedModel.of<QuestModel>(context).resetGame();
    ScopedModel.of<AbstractBluetoothModel>(context).writeCharacteristic("xa");
    Navigator.pushReplacementNamed(context, '/start');
  }

  _handleHelpClick() {
    if(!waitHelpAnimation) {
      ScopedModel.of<AudioModel>(context).play("click.mp3");

      setState(() {
        waitHelpAnimation = true;
        _opacity = (_opacity == 0) ? 1 : 0;
      });

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _help = (_help || !_helpFirst) ? false : true;
          _helpFirst = true;
          waitHelpAnimation = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<QuestModel>(
      builder: (context, child, model) => Scaffold(
            body: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: new AssetImage("assets/pages/runes/background.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child:
                Stack(
                    children: <Widget> [
                    GestureDetector(
                      onTap: () => _handleHelpClick(),
                      child:
                      Container(
                          margin: const EdgeInsets.only(top: 580, left: 315, right: 10),
                          decoration: new BoxDecoration(
                              image: new DecorationImage(
                                image: new AssetImage("assets/pages/runes/help_button.png"),
                                fit: BoxFit.contain,
                              )
                          )
                        )
                      ),
                      GestureDetector(
                          onTap: () => _resetGame(context),
                          child:
                          Container(
                              margin: const EdgeInsets.only(top: 580, left: 10, right: 315),
                              decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                    image: new AssetImage("assets/pages/runes/close_button.png"),
                                    fit: BoxFit.contain,
                                  )
                              )
                          )
                      ),
                      Container(
                        child:
                        Stack(
                          children: [
                        RuneSection(
                          position: [60, 20],
                          color: Constants.RED,
                          onTap: () =>
                              _handleRuneTapped(context, Constants.RED, model),
                        ),
                        RuneSection(
                          position: [60, 190],
                          color: Constants.GREEN,
                          onTap: () =>
                              _handleRuneTapped(context, Constants.GREEN, model),
                        ),
                        RuneSection(
                          position: [230, 20],
                          color: Constants.BLUE,
                          onTap: () =>
                              _handleRuneTapped(context, Constants.BLUE, model),
                        ),
                        RuneSection(
                          position: [230, 190],
                          color: Constants.YELLOW,
                          onTap: () =>
                              _handleRuneTapped(context, Constants.YELLOW, model),
                        ),
                        RuneSection(
                          position: [400, 20],
                          color: Constants.PURPLE,
                          onTap: () =>
                              _handleRuneTapped(context, Constants.PURPLE, model),
                        ),
                        RuneSection(
                          position: [400, 190],
                          color: Constants.PINK,
                          onTap: () =>
                              _handleRuneTapped(context, Constants.PINK, model),
                        ),
                        Container(

                        ),
                      ])),
                      ((model.getRound() == 0 && !_helpFirst) || _help || waitHelpAnimation) ?
                      AnimatedOpacity(
                          opacity: _opacity,
                          duration: Duration(milliseconds: 500),
                          child: GestureDetector(
                            onTap: () => _handleHelpClick(),
                            child:
                          Container(

                              margin: const EdgeInsets.all(10),
                              decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                    image: new AssetImage("assets/pages/runes/anleitung.png"),
                                    fit: BoxFit.fill,
                                  )))
                      )) :
                          Container()
                    ]
                  ),
            ),
          ),
    );
  }
}
