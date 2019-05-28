import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:illuminated_mind/models/QuestModel.dart';
import 'package:illuminated_mind/models/BluetoothModel.dart';
import 'dart:io';

class InterimResultPage extends StatelessWidget {
  _goToRunes(BuildContext context, QuestModel model) {
    model.generateInterimResult();
    model.setNextLayer();
    Navigator.pushReplacementNamed(context, "/runes");
  }

  _sendState(BuildContext context) {
    sleep(const Duration(seconds: 1));

    List<int> evaluatedResult =
        ScopedModel.of<QuestModel>(context).evaluatedResult;
    String sendingString = "f";
    evaluatedResult.asMap().forEach(
          (index, evaluatedResult) =>
              {sendingString = sendingString + evaluatedResult.toString()},
        );
    ScopedModel.of<AbstractBluetoothModel>(context)
        .writeCharacteristic(sendingString);
    print("FEEDBACK => " + sendingString);
  }

  @override
  Widget build(BuildContext context) {
    _sendState(context);
    return ScopedModelDescendant<QuestModel>(
      builder: (context, child, model) => Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(30),
                  child: Text("Zwischenergebnis:"),
                ),
                Expanded(
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20.0),
                    crossAxisSpacing: 10.0,
                    crossAxisCount: 2,
                    children: <Widget>[
                      Image(
                        image: AssetImage("assets/pages/runes/rune_" +
                            model.interimResult[0].toString() +
                            ".png"),
                      ),
                      Image(
                        image: AssetImage("assets/pages/runes/rune_" +
                            model.interimResult[1].toString() +
                            ".png"),
                      ),
                      Image(
                        image: AssetImage("assets/pages/runes/rune_" +
                            model.interimResult[2].toString() +
                            ".png"),
                      ),
                      Image(
                        image: AssetImage("assets/pages/runes/rune_" +
                            model.interimResult[3].toString() +
                            ".png"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30),
                  child: RaisedButton(
                      onPressed: () {
                        _goToRunes(context, model);
                      },
                      child: Text(("Nächste Runde"))),
                ),
              ],
            ),
          ),
    );
  }
}
