

#include "XLR8_LFSR.h"

void setup() {
  Serial.begin(115200);
  XLR8_LFSR.set_seed(0x55);
  XLR8_LFSR.set_freerunning_mode(false);
}

void loop() {
  Serial.println(XLR8_LFSR.get_lfsr(), BIN);
  delay(1000);
}

