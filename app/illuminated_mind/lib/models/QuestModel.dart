import 'package:scoped_model/scoped_model.dart';
import 'dart:math';

class QuestModel extends Model {
  List<int> _finalSolution = [];
  List<int> _interimResult = [];
  int min = 1;
  int max = 9;

  void generateSolution() {
    _finalSolution = [];
    var _random = new Random();
    while (_finalSolution.length < 4) {
      var randomInt = min + _random.nextInt(max - min);
      if (!_finalSolution.contains(randomInt)) _finalSolution.add(randomInt);
    }

    notifyListeners();
    print(_finalSolution);
  }

  List<int> get finalSolution {
    return _finalSolution;
  }

  String get finalSolutionString {
    return _finalSolution.toString();
  }
}
