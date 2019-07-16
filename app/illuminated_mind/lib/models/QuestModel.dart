import 'package:scoped_model/scoped_model.dart';
import 'package:illuminated_mind/utils/Constants.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class QuestModel extends Model {
  List<int> _finalResult = []; // Endergebnis
  List<int> _interimResult = [0, 0, 0, 0]; // Zwischenergebnis
  List<int> _evaluatedResult = []; // ausgewertetes Ergebnis
  int _runeLayer = 0;
  int _round = 0;

  static QuestModel of(BuildContext context) =>
      ScopedModel.of<QuestModel>(context);
  // ----- aktuelle Runen-Ebene
  int get runeLayer {
    return _runeLayer;
  }

  void setNextLayer() {
    int i = _interimResult.indexOf(0);
    if (i == -1) {
      _runeLayer = 4;
    } else {
      _runeLayer = i;
    }
  }

  // ----- Endergebnis
  List<int> get finalResult {
    return _finalResult;
  }

  void generateFinalResult() {
    _round = 0;
    _finalResult = [];
    var _random = new Random();
    while (_finalResult.length < 4) {
      var randomInt =
          Constants.MIN + _random.nextInt(Constants.MAX - Constants.MIN);
      if (!_finalResult.contains(randomInt)) _finalResult.add(randomInt);
    }
    notifyListeners();
  }

  // ----- Zwischenergebnis
  List<int> get interimResult {
    return _interimResult;
  }

  void generateInterimResult() {
    _round++;
    for (var i = 0; i < _interimResult.length; i++) {
      if (_evaluatedResult[i] != Constants.RIGHT) _interimResult[i] = 0;
    }
  }

  void replaceValueOfInterimResult(int position, int value) {
    _interimResult.replaceRange(position, position + 1, [value]);
    notifyListeners();
  }

  // ----- Ausgewertetes Ergebnis
  List<int> get evaluatedResult {
    return _evaluatedResult;
  }

  void generateEvaluatedResult() {
    _evaluatedResult = [];
    finalResult.asMap().forEach((index, finalValue) =>
        {compareValues(finalValue, _interimResult[index], index)});
  }

  void compareValues(int finalValue, int interimValue, int index) {
    if (finalValue == interimValue) {
      _evaluatedResult.add(Constants.RIGHT);
    } else if (_finalResult.contains(interimValue)) {
      _evaluatedResult.add(Constants.EXISTS);
    } else {
      _evaluatedResult.add(Constants.WRONG);
    }
  }

  // ----- weitere Funktionen
  bool isRuneUsed(int color) {
    if (_interimResult.contains(color)) {
      return true;
    }
    return false;
  }

  int getRound() {
    return _round;
  }

  void resetGame() {
    _runeLayer = 0;
    _finalResult = [];
    _interimResult = [0, 0, 0, 0];
    _evaluatedResult = [];
    generateFinalResult();
  }
}
