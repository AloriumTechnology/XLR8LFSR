uint8_t lfsr_data;
uint8_t feedback;

uint8_t __attribute__ ((noinline)) advance_lfsr (uint8_t seed) {
  uint8_t result = 0;
  uint8_t feedback = 0;
  feedback = ~( ( ((seed & 0x80) >> 7) ^
                  ((seed & 0x20) >> 5) ^
                  ((seed & 0x10) >> 4) ^
                  ((seed & 0x08) >> 3) ) | 0xFE );
  result = seed << 1;
  result |= feedback;
  return result;
}

void setup() {
  Serial.begin(115200);
  lfsr_data = 0x55;
  feedback = 0;
}

void loop() {
  lfsr_data = advance_lfsr(lfsr_data);
  Serial.print("Result: ");
  Serial.println(bin2string(lfsr_data)); // binary print
  delay(1000);
}

char* bin2string(uint8_t data) {
  char ret[9];
  ret[0] = '\0';
  for (int idx = 7; idx >= 0; idx--) {
    strcat(ret, ((data >> idx) & 0x01) ? "1" : "0");
  }
  return ret;
}

