import 'package:flutter/material.dart';
import 'package:illuminated_mind/pages/runesPage/runesWidgets.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:illuminated_mind/models/QuestModel.dart';

class RunesPage extends StatefulWidget {
  @override
  _RunesState createState() => new _RunesState();
}

class _RunesState extends State<RunesPage> {
//States
  List<int> _interimResult;
  int layerCount;

  @override
  void initState() {
    super.initState();
    _interimResult = [0, 0, 0, 0];
    layerCount = 0;
  }

  void handleSectionTapped(int color, QuestModel model) {
    if (layerCount < 4) {
      setState(() {
        _interimResult.replaceRange(layerCount, layerCount + 1, [color]);
        layerCount++;
      });
      print("Zwischenergebnis: " + _interimResult.toString());
      if (layerCount == 4) {
        List<int> test = model.compareResult(_interimResult);
        print(" -> Auswertung: " + test.toString());
        if (test.contains(0) || test.contains(1)) {
          _goToInterimResultPage(context);
        } else {
          _goToFinalPage(context);
        }
      }
    }
  }

  _goToInterimResultPage(BuildContext context) {
    // Navigator.push<bool>(
    //   context,
    //   MaterialPageRoute(builder: (BuildContext context) => StartPage()),
    // );
  }

  _goToFinalPage(BuildContext context) {
    // Navigator.push<bool>(
    //   context,
    //   MaterialPageRoute(builder: (BuildContext context) => StartPage()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<QuestModel>(
      builder: (context, child, model) => Scaffold(
            body: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20.0),
              crossAxisSpacing: 10.0,
              crossAxisCount: 3,
              children: <Widget>[
                RaisedButton(onPressed: () => model.generateSolution()),
                RuneSection(onTap: () => {handleSectionTapped(1, model)}),
                RuneSection(onTap: () => {handleSectionTapped(2, model)}),
                RuneSection(onTap: () => {handleSectionTapped(3, model)}),
                RuneSection(onTap: () => {handleSectionTapped(4, model)}),
                RuneSection(onTap: () => {handleSectionTapped(5, model)}),
                RuneSection(onTap: () => {handleSectionTapped(6, model)}),
                RuneSection(onTap: () => {handleSectionTapped(7, model)}),
                RuneSection(onTap: () => {handleSectionTapped(8, model)}),
              ],
            ),
          ),
    );
  }
}
