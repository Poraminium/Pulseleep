// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/user_response.dart';
import '../services/psqi_calculator.dart';
import 'dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:pulseleep/services/pulse_usb_service.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatefulWidget {
  final UserResponse user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    final rawPsqi = PsqiCalculator.calculate(widget.user);
    final psqi = rawPsqi.clamp(0, 21);

    final List<String> riskFactors = [];

    if (widget.user.family <= 5) {
      riskFactors.add('ความสัมพันธ์ในครอบครัวอาจมีผลลบต่อการนอน');
    }
    if (widget.user.exercise < 2)
      riskFactors.add('ออกกำลังกายน้อย อาจทำให้นอนแย่');
    if (widget.user.caffeine >= 0.4)
      riskFactors.add('ดื่มคาเฟอีนเยอะ อาจรบกวนการนอน');
    if (widget.user.activityCount >= 8) {
      riskFactors.add('มีกิจกรรมเยอะ อาจทำให้นอนไม่เพียงพอ');
    }
    if (widget.user.friend < 6) {
      riskFactors.add('มีความสัมพันธ์กับเพื่อนต่ำ อาจเสี่ยงเครียด');
    }
    if (widget.user.gpax < 2.75)
      riskFactors.add('GPAX ต่ำ อาจส่งผลต่อคุณภาพการนอน');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('ผลการวิเคราะห์', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'คะแนน PSQI ของคุณคือ:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: Container(
                width: 195,
                height: 195,
                decoration: BoxDecoration(
                  color: Color(0xFFD1C4E9),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  psqi.toStringAsFixed(2),
                  style: TextStyle(
                      fontSize: 58,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 12),
            _buildCard(
              title: 'ชีพจรของวันนี้:',
              child: Consumer<PulseUsbService>(
                builder: (context, pulseService, _) {
                  final pulses = pulseService.pulses;
                  if (pulses.isEmpty) {
                    return Text('ยังไม่มีข้อมูลชีพจร');
                  }
                  return SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles:
                                SideTitles(showTitles: true, reservedSize: 40),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                              getTitlesWidget: (value, meta) {
                                final minute = (value * 30).toInt();
                                return Text("${minute}m",
                                    style: TextStyle(fontSize: 10));
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: pulses
                                .asMap()
                                .entries
                                .map((e) => FlSpot(
                                    e.key.toDouble(), e.value.toDouble()))
                                .toList(),
                            isCurved: true,
                            color: Colors.deepPurple,
                            barWidth: 2,
                            dotData: FlDotData(show: false),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 12),
            _buildCard(
              title: 'ปัจจัยเสี่ยงที่ควรระวัง:',
              child: riskFactors.isEmpty
                  ? Text('ไม่มี 🎉 คุณไม่มีปัจจัยเสี่ยงที่ต้องระวัง')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: riskFactors
                          .map((risk) => Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text('- $risk'),
                              ))
                          .toList(),
                    ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: isSaving
                  ? null
                  : () async {
                      setState(() => isSaving = true);

                      final pulseService =
                          Provider.of<PulseUsbService>(context, listen: false);
                      await Future.delayed(Duration(seconds: 2));
                      pulseService.saveFullDayToHive();

                      setState(() => isSaving = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('✅ บันทึกชีพจรทั้งวันเรียบร้อยแล้ว')),
                      );
                    },
              child: isSaving
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text('บันทึกชีพจรทั้งหมดของวันนี้'),
            ),
            SizedBox(height: 12),
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

  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      color: Color(0xFFF3E5F5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
