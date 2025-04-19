// lib/services/psqi_calculator.dart
import '../models/user_response.dart';

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
