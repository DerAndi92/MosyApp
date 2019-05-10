import 'package:flutter/material.dart';
import 'package:illuminated_mind/pages/runesPage/runesWidgets.dart';
import 'package:illuminated_mind/pages/interimResultPage/interimResult.dart';
import 'package:illuminated_mind/pages/finalPage/final.dart';

import 'package:illuminated_mind/utils/Constants.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:illuminated_mind/models/QuestModel.dart';

class RunesPage extends StatelessWidget {
  void handleRuneTapped(BuildContext context, int color, QuestModel model) {
    model.replaceValueOfInterimResult(model.layer, color);
    model.setNextLayer();

    if (model.layer == 4) {
      model.generateEvaluatedResult();

      if (model.evaluatedResult.contains(0) ||
          model.evaluatedResult.contains(1)) {
        _goToInterimResultPage(context);
      } else {
        _goToFinalPage(context);
      }
    }
  }

  _goToInterimResultPage(BuildContext context) {
    Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (BuildContext context) => InterimResultPage()),
    );
  }

  _goToFinalPage(BuildContext context) {
    Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (BuildContext context) => FinalPage()),
    );
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
                    (model.layer + 1).toString()),
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
                            handleRuneTapped(context, Constants.RED, model)),
                    RuneSection(
                        color: Constants.GREEN,
                        onTap: () =>
                            handleRuneTapped(context, Constants.GREEN, model)),
                    RuneSection(
                        color: Constants.BLUE,
                        onTap: () =>
                            handleRuneTapped(context, Constants.BLUE, model)),
                    RuneSection(
                        color: Constants.PURPLE,
                        onTap: () =>
                            handleRuneTapped(context, Constants.PURPLE, model)),
                    RuneSection(
                        color: Constants.YELLOW,
                        onTap: () =>
                            handleRuneTapped(context, Constants.YELLOW, model)),
                    RuneSection(
                        color: Constants.BROWN,
                        onTap: () =>
                            handleRuneTapped(context, Constants.BROWN, model)),
                    RuneSection(
                        color: Constants.ORANGE,
                        onTap: () =>
                            handleRuneTapped(context, Constants.ORANGE, model)),
                    RuneSection(
                        color: Constants.CYAN,
                        onTap: () =>
                            handleRuneTapped(context, Constants.CYAN, model)),
                  ],
                ),
              ),
            ]),
          ),
    );
    ;
  }
}
