/*
 * Copyright (c) 2016 Alorium Technology, Bryan Craker <bryan.craker@superiontech.com>
 * LFSR Library for XLR8.
 *
 * This file is free software; you can redistribute it and/or modify
 * it under the terms of either the GNU General Public License version 2
 * or the GNU Lesser General Public License version 2.1, both as
 * published by the Free Software Foundation.
 */

#ifndef _XLR8_LFSR_H_INCLUDED
#define _XLR8_LFSR_H_INCLUDED

#include <Arduino.h>

#define XLR8_LFSR_CTRL _SFR_MEM8(0xE0)
#define XLR8_LFSR_SEED _SFR_MEM8(0xE1)
#define XLR8_LFSR_DATA _SFR_MEM8(0xE2)

class XLR8_LFSRClass {

public:

  XLR8_LFSRClass() {}

  ~XLR8_LFSRClass() {}

  void __attribute__ ((noinline)) set_seed(uint8_t seed) {
    XLR8_LFSR_SEED = seed;
  }

  uint8_t __attribute__ ((noinline)) get_lfsr() {
    return XLR8_LFSR_DATA;
  }

  void set_freerunning_mode(boolean freerunning) {
    XLR8_LFSR_CTRL = freerunning;
  }

private:

};

extern XLR8_LFSRClass XLR8_LFSR;

#endif
