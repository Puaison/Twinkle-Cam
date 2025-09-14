#ifndef CColor_h
#define CColor_h

#include <Arduino.h>

class CColor
{
  public:

    uint8_t R;
    uint8_t G;
    uint8_t B; 

    CColor();
    uint32_t interpolate(CColor* c1,CColor* c2, float F);

    void setColorRGB(uint8_t RedTemp,uint8_t GreenTemp,uint8_t BlueTemp);
};

#endif