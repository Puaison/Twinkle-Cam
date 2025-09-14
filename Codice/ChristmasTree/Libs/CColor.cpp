#include "CColor.h"

CColor::CColor()
{
  this->R = 255;
  this->G = 255;
  this->B = 255;
}

uint32_t CColor::interpolate(CColor* c1,CColor* c2, float F)
{
   int Re = (c2->R - c1->R) * F + c1->R;
   int Gr = (c2->G - c1->G) * F + c1->G;
   int Bl = (c2->B - c1->B) * F + c1->B;
   return (Re * 65536 + Gr * 256 + Bl);
}

void CColor::setColorRGB(uint8_t RedTemp,uint8_t GreenTemp,uint8_t BlueTemp){
    this-> R = RedTemp;
    this-> G = GreenTemp;
    this-> B = BlueTemp;
}
