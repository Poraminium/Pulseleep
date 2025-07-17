// lib/services/psqi_calculator.dart
import '../models/user_response.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class PsqiCalculator {
  static double calculate(UserResponse user) {
    const intercept = 11.862;
    final bf = user.hasBF ? 1.0 : 0.0;

    return intercept +
        0.075 * user.age -
        0.41 * user.gender +
        0.002 * user.bmi -
        0.27 * user.family -
        0.206 * user.exercise +
        2.763 * user.caffeine +
        0.841 * user.activityCount.toDouble() -
        0.031 * user.friend -
        0.087 * bf -
        0.985 * user.gpax;
  }
}

class Ai_calculator {
  Interpreter? _interpreter;

  Ai_calculator();

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/pulseleep_model2.tflite');
  }

  Future<double> predict(UserResponse user) async {
    if (_interpreter == null) {
      await loadModel();
    }

    var input = [user.toInputList()];  // รูปแบบ [1, feature_count]
    var output = List.generate(1, (_) => List.filled(3, 0.0));

    _interpreter!.run(input, output);

    // หา index ที่ความน่าจะเป็นสูงสุด
    int bestIndex = 0;
    double maxProb = output[0][0];
    for (int i = 1; i < 3; i++) {
      if (output[0][i] > maxProb) {
        maxProb = output[0][i];
        bestIndex = i;
      }
    }

    return bestIndex.toDouble();
  }

  void close() {
    _interpreter?.close();
  }
}