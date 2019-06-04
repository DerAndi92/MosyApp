import 'package:flutter/material.dart';
import 'dart:async';
import 'package:illuminated_mind/pages/runesPage/runesWidgets.dart';
import 'package:illuminated_mind/utils/Constants.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:illuminated_mind/models/QuestModel.dart';
import 'package:illuminated_mind/models/BluetoothModel.dart';
import 'package:illuminated_mind/models/AudioModel.dart';
import 'dart:io';

class RunesPage extends StatelessWidget {

  bool _inAction = false;

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
    ScopedModel.of<QuestModel>(context).resetGame();
    ScopedModel.of<AbstractBluetoothModel>(context).writeCharacteristic("xa");
    Navigator.pushReplacementNamed(context, '/start');
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
                      Container(
                        alignment: Alignment(0.0, 0.0),
                        height: 63,
                        margin: EdgeInsets.all(30),
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new AssetImage("assets/pages/runes/choose_rune.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          _resetGame(context);
                        },
                      ),
                      Container(
                        child:
                        Stack(
                          children: [
                        RuneSection(
                          position: [120, 20],
                          color: Constants.RED,
                          onTap: () =>
                              _handleRuneTapped(context, Constants.RED, model),
                        ),
                        RuneSection(
                          position: [120, 190],
                          color: Constants.GREEN,
                          onTap: () =>
                              _handleRuneTapped(context, Constants.GREEN, model),
                        ),
                        RuneSection(
                          position: [290, 20],
                          color: Constants.BLUE,
                          onTap: () =>
                              _handleRuneTapped(context, Constants.BLUE, model),
                        ),
                        RuneSection(
                          position: [290, 190],
                          color: Constants.YELLOW,
                          onTap: () =>
                              _handleRuneTapped(context, Constants.YELLOW, model),
                        ),
                        RuneSection(
                          position: [460, 20],
                          color: Constants.PURPLE,
                          onTap: () =>
                              _handleRuneTapped(context, Constants.PURPLE, model),
                        ),
                        RuneSection(
                          position: [460, 190],
                          color: Constants.PINK,
                          onTap: () =>
                              _handleRuneTapped(context, Constants.PINK, model),
                        ),
                        Container(

                        ),
                      ])),
                    ]
                  ),
            ),
          ),
    );
  }
}
