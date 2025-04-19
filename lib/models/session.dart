import 'package:hive/hive.dart';

part 'session.g.dart'; // สำหรับ build adapter

@HiveType(typeId: 0)
class Session {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final int index;

  @HiveField(2)
  final int pulse;

  Session({required this.date, required this.index, required this.pulse});
}
