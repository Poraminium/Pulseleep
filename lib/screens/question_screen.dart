import 'package:flutter/material.dart';
import '../models/user_response.dart';

class QuestionScreen extends StatefulWidget {
  final void Function(UserResponse) onSubmit;

  const QuestionScreen({super.key, required this.onSubmit});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final user = UserResponse();

  // ค่าเริ่มต้นของ activity ทั้ง 11 รายการ
  final Map<String, bool> _activities = {
    'รับน้อง': false,
    'แข่งกีฬา': false,
    'เชียร์หลีดเดอร์': false,
    'ค่ายอาสา': false,
    'ชมรม': false,
    'สแตนด์เชียร์': false,
    'ประกวดดาวเดือน': false,
    'งานวิจัย': false,
    'กิจกรรมบังคับ': false,
    'กิจกรรมหาเพื่อน': false,
    'จิตอาสา': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('แบบสอบถาม')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('อายุ'),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (val) => user.age = int.tryParse(val) ?? 0,
              ),
              SizedBox(height: 16),
              Text('เพศ'),
              DropdownButtonFormField<int>(
                items: [
                  DropdownMenuItem(value: 0, child: Text('หญิง')),
                  DropdownMenuItem(value: 1, child: Text('ชาย')),
                ],
                onChanged: (val) => user.gender = val ?? 0,
              ),
              SizedBox(height: 16),
              Text('BMI'),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (val) => user.bmi = double.tryParse(val) ?? 0.0,
              ),
              SizedBox(height: 16),
              Text('ความสัมพันธ์ในครอบครัว (0-10)'),
              Slider(
                value: user.family,
                onChanged: (val) => setState(() => user.family = val),
                divisions: 10,
                min: 0,
                max: 10,
                label: user.family.toStringAsFixed(1),
              ),
              SizedBox(height: 16),
              Text('ออกกำลังกาย (1-5)'),
              Slider(
                value: user.exercise,
                onChanged: (val) => setState(() => user.exercise = val),
                divisions: 4,
                min: 1,
                max: 5,
                label: user.exercise.toStringAsFixed(1),
              ),
              SizedBox(height: 16),
              Text('ดื่มคาเฟอีน (กี่แก้วต่อวัน)'),
              Slider(
                value: user.caffeine,
                onChanged: (val) => setState(() => user.caffeine = val),
                divisions: 10,
                min: 0,
                max: 5,
                label: user.caffeine.toStringAsFixed(1),
              ),
              SizedBox(height: 16),
              Text('กิจกรรมมหาวิทยาลัย (เลือกทั้งหมดที่เคยทำ)'),
              ..._activities.keys.map((name) {
                return CheckboxListTile(
                  title: Text(name),
                  value: _activities[name],
                  onChanged: (val) => setState(() {
                    _activities[name] = val ?? false;
                    user.activityCount =
                        _activities.values.where((v) => v).length;
                  }),
                );
              }).toList(),
              SizedBox(height: 16),
              Text('ความสัมพันธ์กับเพื่อน (0-10)'),
              Slider(
                value: user.friend,
                onChanged: (val) => setState(() => user.friend = val),
                divisions: 10,
                min: 0,
                max: 10,
                label: user.friend.toStringAsFixed(1),
              ),
              SizedBox(height: 16),
              Text('มีแฟนหรือไม่'),
              DropdownButtonFormField<bool>(
                items: [
                  DropdownMenuItem(value: true, child: Text('มี')),
                  DropdownMenuItem(value: false, child: Text('ไม่มี')),
                ],
                onChanged: (val) => user.hasBF = val ?? false,
              ),
              SizedBox(height: 16),
              Text('GPAX'),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (val) => user.gpax = double.tryParse(val) ?? 0.0,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onSubmit(user);
                  }
                },
                child: Text('บันทึกข้อมูล'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
