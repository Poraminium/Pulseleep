import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/session.dart';

class PulseUsbService with ChangeNotifier {
  List<int> pulses = [];
  Timer? _autoSaveTimer;

  PulseUsbService() {
    _startAutoSave();
  }

  void _startAutoSave() {
    _autoSaveTimer = Timer.periodic(const Duration(minutes: 30), (_) {
      savePartialSession(); // บันทึก session ย่อย
    });
  }

  void dispose() {
    _autoSaveTimer?.cancel();
    super.dispose();
  }

  void savePartialSession() async {
    if (pulses.isEmpty) return;

    final box = Hive.box<Session>('sessions');
    final now = DateTime.now();

    for (int i = 0; i < pulses.length; i++) {
      box.add(Session(
        date: now,
        index: i,
        pulse: pulses[i],
      ));
    }

    print('✅ Auto-save: บันทึก ${pulses.length} จุด');
    pulses.clear();
    notifyListeners();
  }

  void saveFullDayToHive() async {
    if (pulses.isEmpty) return;

    final box = Hive.box<Session>('sessions');
    final now = DateTime.now();

    // รวมชีพจรของทั้งวันเป็น session เดียว
    final avgPulse = pulses.reduce((a, b) => a + b) ~/ pulses.length;

    box.add(Session(
      date: now,
      index: 0, // day session index 0
      pulse: avgPulse,
    ));

    print('✅ บันทึกทั้งวัน = ค่าเฉลี่ย $avgPulse bpm');
    pulses.clear();
    notifyListeners();
  }
}
