import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/daily_session.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<DailySession>('daily_sessions');
    final sessions = box.values.toList();

    // เรียงจากวันล่าสุด → วันเก่า
    sessions.sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(title: const Text('สถิติย้อนหลัง')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          final formattedDate = DateFormat('dd MMM yyyy').format(session.date);

          return Card(
            color: Color(0xFFF3E5F5),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Scaffold(
                      appBar:
                          AppBar(title: Text('กราฟชีพจรวันที่ $formattedDate')),
                      body: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(show: true),
                              borderData: FlBorderData(show: false),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: true, reservedSize: 40),
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
                                  spots: session.pulses
                                      .asMap()
                                      .entries
                                      .map((e) => FlSpot(
                                          e.key.toDouble(), e.value.toDouble()))
                                      .toList(),
                                  isCurved: true,
                                  dotData: FlDotData(show: false),
                                  color: Colors.deepPurple,
                                  barWidth: 2.5,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📅 $formattedDate',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: true),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true, reservedSize: 40),
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
                              spots: session.pulses
                                  .asMap()
                                  .entries
                                  .map((e) => FlSpot(
                                      e.key.toDouble(), e.value.toDouble()))
                                  .toList(),
                              isCurved: true,
                              dotData: FlDotData(show: false),
                              color: Colors.deepPurple,
                              barWidth: 2.5,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
