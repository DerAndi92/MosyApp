import 'package:scoped_model/scoped_model.dart';
import 'dart:math';

class QuestModel extends Model {
  List<int> _finalSolution = [];
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

  List<int> compareResult(List<int> interimResult) {
    print("______________");
    print(interimResult.toString() + " -> Zwischenergebnis ");
    print(_finalSolution.toString() + " -> Endergebnis ");
        print("______________");

    List<int> resultToSend = [];
    finalSolution.asMap().forEach((index, value) =>
        {resultToSend.add(checkValues(value, interimResult[index]))});
    return resultToSend;
  }

  int checkValues(int solutionValue, int testValue) {
    if (solutionValue == testValue) {
      print(solutionValue.toString() + " == " + testValue.toString());
      return 2;
    } else if (_finalSolution.contains(testValue)) {
      print(_finalSolution.toString() + " contains " + testValue.toString());

      return 1;
    } else {
      print(_finalSolution.toString() +
          " doesnt contains  " +
          testValue.toString());

      return 0;
    }
  }

  List<int> get finalSolution {
    return _finalSolution;
  }

  String get finalSolutionString {
    return _finalSolution.toString();
  }
}
