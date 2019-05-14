import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:illuminated_mind/models/QuestModel.dart';
import 'package:illuminated_mind/models/BluetoothModel.dart';

class FinalPage extends StatelessWidget {
  _sendState(BuildContext context) {
    ScopedModel.of<AbstractBluetoothModel>(context).writeCharacteristic("xq");
  }

  @override
  Widget build(BuildContext context) {
    _sendState(context);
    return ScopedModelDescendant<QuestModel>(
      builder: (context, child, model) => Scaffold(
            body: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/award.png"),
                      width: 200,
                    ),
                    Padding(
                      padding: EdgeInsets.all(30),
                      child: Text("Du hast gewonnen"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(30),
                      child: RaisedButton(
                        child: Text("Neu starten"),
                        onPressed: () {
                          model.resetGame();
                          Navigator.pushReplacementNamed(context, "/runes");
                        },
                      ),
                    )
                  ]),
            ),
          ),
    );
  }
}
