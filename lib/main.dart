import 'package:flutter/material.dart';
import 'models/user_response.dart';
import 'screens/question_screen.dart';
import 'screens/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/session.dart';
import 'package:provider/provider.dart';
import 'services/pulse_usb_service.dart';
import 'models/daily_session.dart';

void main() async {
  //  กำหนดให้ Flutter รอเปิด Hive ก่อน runApp
  WidgetsFlutterBinding.ensureInitialized();

  //  เปิด Hive
  await Hive.initFlutter();

  //  บอก Hive ให้รู้จักคลาส Session
  Hive.registerAdapter(SessionAdapter());

  //  เปิดกล่อง (box) ที่ชื่อ 'sessions'
  await Hive.openBox<Session>('sessions');

  await Hive.openBox<DailySession>('daily_sessions');

  //  เริ่มแอป
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PulseUsbService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pulseleep',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Builder(
        //  ใช้ Builder เพื่อให้ได้ context ที่ชัวร์
        builder: (context) {
          return QuestionScreen(
            onSubmit: (UserResponse user) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HomeScreen(user: user),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
