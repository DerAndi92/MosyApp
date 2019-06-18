import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:illuminated_mind/models/QuestModel.dart';
import 'package:illuminated_mind/models/BluetoothModel.dart';
import 'package:illuminated_mind/models/AudioModel.dart';

class FinalPage extends StatelessWidget {
  _playAgain(model, context) {
    ScopedModel.of<AudioModel>(context).play("click.mp3");
    model.resetGame();
    ScopedModel.of<AbstractBluetoothModel>(context).sendData("xa");
    Navigator.pushReplacementNamed(context, "/start");
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<QuestModel>(
      builder: (context, child, model) => Scaffold(
            body: Stack(
              children: <Widget>[
                Container(
                    decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/pages/final/background.png"),
                    fit: BoxFit.cover,
                  ),
                )),
                GestureDetector(
                    onTap: () => {_playAgain(model, context)},
                    child: Container(
                        margin: const EdgeInsets.only(
                            top: 580, left: 315, right: 10),
                        decoration: new BoxDecoration(
                            image: new DecorationImage(
                          image:
                              new AssetImage("assets/pages/final/btn_play.png"),
                          fit: BoxFit.contain,
                        )))),
              ],
            ),
          ),
    );
  }
}
