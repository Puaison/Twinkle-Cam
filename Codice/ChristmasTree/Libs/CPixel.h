#ifndef CPixel_h
#define CPixel_h

#include <Arduino.h>

class CPixel
{
  public:

    float x, y;
    CColor *PColor;

    CPixel(float xTemp, float yTemp);

    float getX();
    float getY();

    uint32_t getColor();	

    void setColorRGB(uint8_t RedTemp,uint8_t GreenTemp,uint8_t BlueTemp);
    void setColor32(uint32_t Col);

    void interpolation(uint8_t R1,uint8_t G1,uint8_t Bl1,uint8_t R2,uint8_t G2,uint8_t B2,float F);
};

#endif