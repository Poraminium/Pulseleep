# Pulseleep | เครื่องวิเคราะห์คุณภาพการนอนจากชีพจรแบบเรียลไทม์

![Flutter](https://img.shields.io/badge/Made_with-Flutter-02569B?logo=flutter&logoColor=white)
![Arduino](https://img.shields.io/badge/Hardware-Arduino-green)
![License](https://img.shields.io/badge/license-MIT-blue)

Pulseleep คือแอปพลิเคชัน Flutter ที่วิเคราะห์คุณภาพการนอนหลับโดยใช้ข้อมูลชีพจรจากเซนเซอร์จริงผ่าน Arduino  
รองรับการคำนวณดัชนี PSQI และบันทึกข้อมูล session พร้อม UI ที่ออกแบบมาสำหรับผู้ใช้งานจริง

---

## Features

- วัดชีพจรแบบเรียลไทม์ผ่าน USB (Serial)
- วิเคราะห์คุณภาพการนอนด้วย PSQI ตามงานวิจัยจริง
- รองรับการกรอกข้อมูลพฤติกรรมการใช้ชีวิต
- แสดงผลผ่านกราฟและสถิติย้อนหลัง
- ระบบบันทึกอัตโนมัติทุก 30 นาที
- พร้อมใช้งานจริง ไม่มี Mock Data

---

## Tech Stack

- **Flutter 3.6+**
- **Dart**
- **Hive (Local DB)**
- **Arduino (USB Serial Communication)**
- **Provider (State Management)**
- **fl_chart (Graph Visualization)**

---

## Screenshots

> *(เพิ่มรูปได้ในโฟลเดอร์ `assets/screenshots` แล้วแปะ path ด้านล่างนี้)*

<p align="center">
  <img src="assets/screenshots/home.png" width="250" />
  <img src="assets/screenshots/questionnaire.png" width="250" />
  <img src="assets/screenshots/dashboard.png" width="250" />
</p>

---

## การติดตั้ง & ใช้งาน

### 1. Clone โปรเจกต์

```bash
git clone https://github.com/yourusername/pulseleep.git
cd pulseleep
```

### 2. ติดตั้ง Dependencies

```bash
flutter pub get
```

### 3. รันแอป

```bash
flutter run
```

### 4. เชื่อมต่อ Arduino
- ใช้เซนเซอร์วัดชีพจร เช่น PulseSensor
- Upload โค้ด Arduino ที่อยู่ในโฟลเดอร์ /arduino
- เชื่อมสาย USB แล้วเปิดแอป