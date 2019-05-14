import 'package:flutter/material.dart';
import 'package:illuminated_mind/pages/runesPage/runesWidgets.dart';
import 'package:illuminated_mind/utils/Constants.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:illuminated_mind/models/QuestModel.dart';
import 'package:illuminated_mind/models/BluetoothModel.dart';

class RunesPage extends StatelessWidget {
  void _handleRuneTapped(BuildContext context, int color, QuestModel model) {
    model.replaceValueOfInterimResult(model.runeLayer, color);
    _sendState(
        context, "e" + (model.runeLayer + 1).toString() + color.toString());
    model.setNextLayer();

    if (model.runeLayer == 4) {
      model.generateEvaluatedResult();
      print(model.evaluatedResult);

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

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<QuestModel>(
      builder: (context, child, model) => Scaffold(
            body: Column(children: <Widget>[
              model.finalResult.length < 1
                  ? RaisedButton(
                      child: Text("Debug: generiere Lösungscode"),
                      onPressed: () => model.generateFinalResult())
                  : Text("L: " + model.finalResult.toString()),
              Text("Z: " + model.interimResult.toString()),
              Padding(
                padding: EdgeInsets.all(30),
                child: Text("Wirke ein Element auf Stein " +
                    (model.runeLayer + 1).toString()),
              ),
              Expanded(
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20.0),
                  crossAxisSpacing: 10.0,
                  crossAxisCount: 3,
                  children: <Widget>[
                    RuneSection(
                        color: Constants.RED,
                        onTap: () =>
                            _handleRuneTapped(context, Constants.RED, model)),
                    RuneSection(
                        color: Constants.GREEN,
                        onTap: () =>
                            _handleRuneTapped(context, Constants.GREEN, model)),
                    RuneSection(
                        color: Constants.BLUE,
                        onTap: () =>
                            _handleRuneTapped(context, Constants.BLUE, model)),
                    RuneSection(
                        color: Constants.PURPLE,
                        onTap: () => _handleRuneTapped(
                            context, Constants.PURPLE, model)),
                    RuneSection(
                        color: Constants.YELLOW,
                        onTap: () => _handleRuneTapped(
                            context, Constants.YELLOW, model)),
                    RuneSection(
                        color: Constants.BROWN,
                        onTap: () =>
                            _handleRuneTapped(context, Constants.BROWN, model)),
                    RuneSection(
                        color: Constants.ORANGE,
                        onTap: () => _handleRuneTapped(
                            context, Constants.ORANGE, model)),
                    RuneSection(
                        color: Constants.CYAN,
                        onTap: () =>
                            _handleRuneTapped(context, Constants.CYAN, model)),
                  ],
                ),
              ),
            ]),
          ),
    );
    ;
  }
}
