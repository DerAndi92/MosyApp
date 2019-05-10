import 'package:scoped_model/scoped_model.dart';
import 'package:illuminated_mind/utils/Constants.dart';
import 'dart:math';

class QuestModel extends Model {
  List<int> _finalResult = []; // Endergebnis
  List<int> _interimResult = [0, 0, 0, 0]; // Zwischenergebnis
  List<int> _evaluatedResult = []; // ausgewertetes Ergebnis
  int _layer = 0;

  // ----- layer
  int get layer {
    return _layer;
  }

  void setNextLayer() {
    int i = _interimResult.indexOf(0);
    if (i == -1) {
      _layer = 4;
    } else {
      _layer = i;
    }
  }

  // ----- final result
  List<int> get finalResult {
    return _finalResult;
  }

  void generateFinalResult() {
    _finalResult = [];
    var _random = new Random();
    while (_finalResult.length < 4) {
      var randomInt =
          Constants.MIN + _random.nextInt(Constants.MAX - Constants.MIN);
      if (!_finalResult.contains(randomInt)) _finalResult.add(randomInt);
    }
    notifyListeners();
  }

  // ----- interim result
  List<int> get interimResult {
    return _interimResult;
  }

  void replaceValueOfInterimResult(int position, int value) {
    _interimResult.replaceRange(position, position + 1, [value]);
    notifyListeners();
  }

  void generateInterimResult() {
    for (var i = 0; i < _interimResult.length; i++) {
      if (_evaluatedResult[i] != 2) _interimResult[i] = 0;
    }
  }

  // ----- evalutated result
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

  // ----- others
  bool isRuneUsed(int color) {
    if (_interimResult.contains(color)) {
      return true;
    }
    return false;
  }
}
