#define USE_ARDUINO_INTERRUPTS true
#include <PulseSensorPlayground.h>

const int PULSE_INPUT = A0;
const int PULSE_BLINK = 13;
const int PULSE_FADE = 5;
const int THRESHOLD = 550;

PulseSensorPlayground pulseSensor;

void setup() {
  Serial.begin(9600);  // <<< เปลี่ยนเป็น 9600 เพราะ Flutter อ่านง่ายกว่า 115200

  pulseSensor.analogInput(PULSE_INPUT);
  pulseSensor.blinkOnPulse(PULSE_BLINK);
  pulseSensor.fadeOnPulse(PULSE_FADE);
  pulseSensor.setThreshold(THRESHOLD);

  if (!pulseSensor.begin()) {
    for(;;) {
      digitalWrite(PULSE_BLINK, LOW);
      delay(100);
      digitalWrite(PULSE_BLINK, HIGH);
      delay(100);
    }
  }
}

void loop() {
  // ถ้ามีจังหวะหัวใจเกิดขึ้น
  if (pulseSensor.sawStartOfBeat()) {
    int bpm = pulseSensor.getBeatsPerMinute();

    // ✅ ส่งค่า BPM จริง ๆ แบบตัวเลขดิบไปยัง Serial
    Serial.println(bpm);

    // รอ 5 วินาทีค่อยส่งใหม่ (หรือจะลดเหลือ 1 วิ ได้ตามต้องการ)
    delay(5000);
  }
}
