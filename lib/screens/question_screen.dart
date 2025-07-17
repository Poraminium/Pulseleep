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

  final _ageController = TextEditingController();
  final _bmiController = TextEditingController();
  final _gpaxController = TextEditingController();

  final Map<String, bool> _activities = {
    'ร่วมทำกิจกรรมเข้าค่ายหรือกิจกรรมกลุ่มนอกสถานที่': false,
    'เข้าร่วมการแข่งขัน(กีฬา/ทักษะ/ความรู้)': false,
    'มีส่วนร่วมในการจัดกิจกรรมหรืออีเวนต์สาธารณะ': false,
    'เข้าร่วมโครงการอาสาสมัคร/ช่วยเหลือสังคม': false,
    'ทำงานเป็นกลุ่มในโครงการ/งานชุมชน/ทีมงานต่าง ๆ': false,
    'เข้าร่วมกิจกรรมในที่ทำงาน/องค์กร/ชุมชนของตน': false,
    'เป็นสมาชิกของชมรมหรือกลุ่มสนใจเฉพาะทาง': false,
    'มีส่วนร่วมในโครงการประกวดหรือแข่งขันเพื่อพัฒนาตัวเอง': false,
    'ทำงานวิจัย/เขียนบทความ/ทำโปรเจกต์ส่วนตัวจริงจัง': false,
    'เข้าร่วมกิจกรรมเพื่อสร้างความสัมพันธ์หรือพบปะเพื่อนใหม่': false,
    'เข้าร่วมกิจกรรมทางศาสนา/จิตอาสา/พัฒนาจิตใจ': false,
  };

  String? _ageError;
  String? _bmiError;
  String? _gpaxError;
  int? _selectedGender;
  bool? _hasBF;
  bool isLoading = false;

  @override
  void dispose() {
    _ageController.dispose();
    _bmiController.dispose();
    _gpaxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'แบบสอบถาม',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 23.0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildSection(
                title: 'ข้อมูลพื้นฐาน',
                children: [
                  _buildLabeledTextField('อายุ', _ageController,
                      errorText: _ageError),
                  _buildGenderDropdown(),
                  _buildLabeledTextField('BMI', _bmiController,
                      errorText: _bmiError),
                ],
              ),
              _buildSection(
                title: 'พฤติกรรมสุขภาพ',
                children: [
                  _buildSlider('ความสัมพันธ์ในครอบครัว (0-10)', user.family, 0,
                      10, (val) => setState(() => user.family = val)),
                  _buildSlider('ออกกำลังกาย (1-5)', user.exercise, 1, 5,
                      (val) => setState(() => user.exercise = val)),
                  _buildSlider('ดื่มคาเฟอีน (กี่แก้วต่อวัน)', user.caffeine, 0,
                      5, (val) => setState(() => user.caffeine = val)),
                  _buildSlider('ความสัมพันธ์กับเพื่อน (0-10)', user.friend, 0,
                      10, (val) => setState(() => user.friend = val)),
                ],
              ),
              _buildSection(
                title: 'กิจกรรมที่เคยทำ',
                children: [
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
                  }),
                ],
              ),
              _buildSection(
                title: 'ความสัมพันธ์และผลการเรียน',
                children: [
                  Text('มีแฟนไหม', style: TextStyle(fontSize: 20.0)),
                  DropdownButtonFormField<bool>(
                    value: _hasBF,
                    items: [
                      DropdownMenuItem(value: true, child: Text('มี')),
                      DropdownMenuItem(value: false, child: Text('ไม่มี')),
                    ],
                    onChanged: (val) => setState(() {
                      _hasBF = val;
                      user.hasBF = val ?? false;
                    }),
                    validator: (val) =>
                        val == null ? 'กรุณาเลือกสถานะความสัมพันธ์' : null,
                  ),
                  SizedBox(height: 25),
                  _buildLabeledTextField('GPAX', _gpaxController,
                      errorText: _gpaxError),
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: isLoading
                    ? null
                    : () {
                        setState(() {
                          _ageError = _ageController.text.isEmpty
                              ? 'กรุณากรอกอายุ'
                              : null;
                          _bmiError = _bmiController.text.isEmpty
                              ? 'กรุณากรอก BMI'
                              : null;
                          _gpaxError = _gpaxController.text.isEmpty
                              ? 'กรุณากรอก GPAX'
                              : null;
                        });

                        if (_formKey.currentState!.validate() &&
                            _ageError == null &&
                            _bmiError == null &&
                            _gpaxError == null &&
                            _selectedGender != null &&
                            _hasBF != null) {
                          setState(() => isLoading = true);

                          user.age = int.tryParse(_ageController.text) ?? 0;
                          user.bmi =
                              double.tryParse(_bmiController.text) ?? 0.0;
                          user.gpax =
                              double.tryParse(_gpaxController.text) ?? 0.0;

                          Future.delayed(Duration(seconds: 2), () {
                            setState(() => isLoading = false);
                            widget.onSubmit(user);
                          });
                        }
                      },
                child: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text('บันทึกข้อมูล',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
      {required String title, required List<Widget> children}) {
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
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildLabeledTextField(String label, TextEditingController controller,
      {String? errorText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 20.0)),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(errorText: errorText),
        ),
        SizedBox(height: 25),
      ],
    );
  }

  Widget _buildSlider(String label, double value, double min, double max,
      Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 20.0)),
        Slider(
          value: value,
          onChanged: onChanged,
          divisions: (max - min).toInt(),
          min: min,
          max: max,
          label: value.toStringAsFixed(1),
        ),
        SizedBox(height: 25),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('เพศ', style: TextStyle(fontSize: 20.0)),
        DropdownButtonFormField<int>(
          value: _selectedGender,
          items: [
            DropdownMenuItem(value: 0, child: Text('หญิง')),
            DropdownMenuItem(value: 1, child: Text('ชาย')),
          ],
          onChanged: (val) => setState(() {
            _selectedGender = val;
            user.gender = val ?? 0;
          }),
          validator: (val) => val == null ? 'กรุณาเลือกเพศ' : null,
        ),
        SizedBox(height: 25),
      ],
    );
  }
}
