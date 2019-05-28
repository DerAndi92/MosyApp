import 'package:flutter/material.dart';
import 'package:illuminated_mind/pages/runesPage/runesWidgets.dart';
import 'package:illuminated_mind/utils/Constants.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:illuminated_mind/models/QuestModel.dart';
import 'package:illuminated_mind/models/BluetoothModel.dart';
import 'package:illuminated_mind/models/AudioModel.dart';

class RunesPage extends StatelessWidget {
  void _handleRuneTapped(BuildContext context, int color, QuestModel model) {
    ScopedModel.of<AudioModel>(context).play('magic.mp3');
    model.replaceValueOfInterimResult(model.runeLayer, color);
    _sendState(
        context, "e" + (model.runeLayer + 1).toString() + color.toString());
    model.setNextLayer();

    if (model.runeLayer == 4) {
      model.generateEvaluatedResult();
      // print(model.evaluatedResult);

      if (model.evaluatedResult.contains(Constants.WRONG) ||
          model.evaluatedResult.contains(Constants.EXISTS)) {
        Navigator.pushReplacementNamed(context, '/interimResult');
      } else {
        Navigator.pushReplacementNamed(context, '/finalResult');
      }
    }
  }

  _sendState(BuildContext context, String code) {
    print("SENDING => " + code.toString());
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
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Stack(children: [
                  RuneSection(
                    position: [0, 0],
                    color: Constants.RED,
                    onTap: () =>
                        _handleRuneTapped(context, Constants.RED, model),
                  ),
                  RuneSection(
                    position: [0, 170],
                    color: Constants.GREEN,
                    onTap: () =>
                        _handleRuneTapped(context, Constants.GREEN, model),
                  ),
                  RuneSection(
                    position: [170, 0],
                    color: Constants.BLUE,
                    onTap: () =>
                        _handleRuneTapped(context, Constants.BLUE, model),
                  ),
                  RuneSection(
                    position: [170, 170],
                    color: Constants.YELLOW,
                    onTap: () =>
                        _handleRuneTapped(context, Constants.YELLOW, model),
                  ),
                  RuneSection(
                    position: [340, 0],
                    color: Constants.PURPLE,
                    onTap: () =>
                        _handleRuneTapped(context, Constants.PURPLE, model),
                  ),
                  RuneSection(
                    position: [340, 170],
                    color: Constants.PINK,
                    onTap: () =>
                        _handleRuneTapped(context, Constants.PINK, model),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      _resetGame(context);
                    },
                  ),
                  Container(),
                ]),
              ),
            ),
          ),
    );
  }
}
