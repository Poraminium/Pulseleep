// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/user_response.dart';
import '../services/psqi_calculator.dart';
import 'dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:pulseleep/services/pulse_usb_service.dart';

class HomeScreen extends StatelessWidget {
  final UserResponse user;

  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final psqi = PsqiCalculator.calculate(user);

    final List<String> riskFactors = [];

    // ปัจจัยที่ส่งผลลบตามที่มึงให้ไว้
    if (user.family <= 5)
      riskFactors.add('ความสัมพันธ์ในครอบครัวอาจมีผลลบต่อการนอน');
    if (user.exercise < 2) riskFactors.add('ออกกำลังกายน้อย อาจทำให้นอนแย่');
    if (user.caffeine >= 0.4) riskFactors.add('ดื่มคาเฟอีนเยอะ อาจรบกวนการนอน');
    if (user.activityCount >= 8)
      riskFactors.add('มีกิจกรรมเยอะ อาจทำให้นอนไม่เพียงพอ');
    if (user.friend < 6)
      riskFactors.add('มีความสัมพันธ์กับเพื่อนต่ำ อาจเสี่ยงเครียด');
    if (user.gpax < 2.75) riskFactors.add('GPAX ต่ำ อาจส่งผลต่อคุณภาพการนอน');

    return Scaffold(
      appBar: AppBar(title: Text('ผลการวิเคราะห์')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              'คะแนน PSQI ของคุณคือ:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              psqi.toStringAsFixed(2),
              style: TextStyle(fontSize: 48, color: Colors.deepPurple),
            ),
            SizedBox(height: 24),

            Text(
              'ชีพจรของวันนี้ (Mock Data):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('72, 74, 73, 71, 70, 69, 68, 70'), // แก้ทีหลังให้ดึงจาก USB

            SizedBox(height: 24),
            Text(
              'ปัจจัยเสี่ยงที่ควรระวัง:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...riskFactors.isEmpty
                ? [Text('ไม่มี 🎉 คุณไม่มีปัจจัยเสี่ยงที่ต้องระวัง')]
                : riskFactors.map((risk) => Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text('- $risk'),
                    )),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                final pulseService =
                    Provider.of<PulseUsbService>(context, listen: false);
                pulseService.saveFullDayToHive();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('บันทึกชีพจรทั้งวันเรียบร้อยแล้ว')),
                );
              },
              child: Text('บันทึกชีพจรทั้งหมดของวันนี้'),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DashboardScreen()),
                );
              },
              child: Text('ดูสถิติย้อนหลัง (Dashboard)'),
            ),
          ],
        ),
      ),
    );
  }
}
