import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/session.dart';
import 'package:usb_serial/usb_serial.dart';

class PulseUsbService with ChangeNotifier {
  List<int> pulses = [];
  Timer? _autoSaveTimer;
  UsbPort? _port;

  PulseUsbService() {
    _startAutoSave();
    initConnection(); // ✅ เรียกเชื่อมต่อ USB ตอนเริ่มต้น
  }

  Future<void> initConnection() async {
    List<UsbDevice> devices = await UsbSerial.listDevices();

    if (devices.isEmpty) {
      print('❌ ไม่เจออุปกรณ์ USB');
      return;
    }

    _port = await devices[0].create();

    bool openSuccess = await _port!.open();

    if (!openSuccess) {
      print('❌ เปิดพอร์ตไม่สำเร็จ');
      return;
    }

    // ✅ ตั้ง baudRate ให้ตรงกับ Arduino (เช่น 9600 หรือ 115200)
    await _port!.setDTR(true); // optional ถ้าเจอบางบอร์ดไม่ตอบ
    await _port!.setRTS(true); // optional เช่นกัน
    _port = await devices[0].create();
    await _port!.open();

// ไม่ต้อง .setConfig อะไรทั้งนั้น

    print('✅ USB พร้อมใช้งานแล้ว');

    _port!.inputStream?.listen((data) {
      final line = String.fromCharCodes(data).trim();
      final bpm = int.tryParse(line);
      if (bpm != null) {
        pulses.add(bpm);
        notifyListeners();
        print('BPM รับแล้ว: $bpm');
      }
    });
  }

  void _startAutoSave() {
    _autoSaveTimer = Timer.periodic(const Duration(minutes: 30), (_) {
      savePartialSession(); // บันทึก session ย่อย
    });
  }

  @override
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
