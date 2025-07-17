// lib/models/user_response.dart
class UserResponse {
  int age = 0;
  int gender = 0; // 0 = หญิง, 1 = ชาย
  double bmi = 0.0;
  double family = 0.0;
  double exercise = 1.0;
  double caffeine = 0.0;
  int activityCount = 0;
  double friend = 0.0;
  bool hasBF = false;
  double gpax = 0.0;

  UserResponse();

  List<double> toInputList() {
      return [
        age.toDouble(),
        gender.toDouble(),
        bmi,
        family,
        exercise,
        caffeine,
        activityCount.toDouble(),
        friend,
        hasBF ? 1.0 : 0.0,  // แปลง bool เป็น 1.0 หรือ 0.0
        gpax,
      ];
    }
}



