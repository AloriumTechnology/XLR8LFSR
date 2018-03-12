#include "XLR8_LFSR.h"

void setup() {
  Serial.begin(115200);
  XLR8_LFSR.set_seed(0x55);
  XLR8_LFSR.set_freerunning_mode(false);
}

void loop() {
  Serial.println(bin2string(XLR8_LFSR.get_lfsr()));
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

