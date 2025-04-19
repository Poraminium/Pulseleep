import 'package:hive/hive.dart';

part 'daily_session.g.dart';

@HiveType(typeId: 1)
class DailySession {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final List<int> pulses;

  DailySession({required this.date, required this.pulses});
}
