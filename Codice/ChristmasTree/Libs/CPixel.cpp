#include "CPixel.h"

CPixel::CPixel(float xTemp, float yTemp)
{
    this->x = xTemp;
    this->y = yTemp;
    this->PColor = new CColor();
}

float CPixel::getX()
{
    return this->x;
}

float CPixel::getY()
{
    return this->y;
}
  
uint32_t CPixel::getColor()
{
    return (this->PColor->R*65536)+(this->PColor->G*256)+(this->PColor->B);
}

void CPixel::setColorRGB(uint8_t RedTemp,uint8_t GreenTemp,uint8_t BlueTemp){
    this->PColor-> R = RedTemp;
    this->PColor-> G = GreenTemp;
    this->PColor-> B = BlueTemp;
}

void CPixel::setColor32(uint32_t Col){
    this->PColor-> R = Col >> 16 & 0xff;
    this->PColor-> G = Col >> 8 & 0xff;
    this->PColor-> B = Col & 0xff;
}

void CPixel::interpolation(uint8_t R1,uint8_t G1,uint8_t Bl1,uint8_t R2,uint8_t G2,uint8_t B2,float F) 
{
   uint8_t IR = (R2 - R1)*F + R1;
   uint8_t IG = (G2 - G1)*F + G1;
   uint8_t IB = (B2 - Bl1)*F + Bl1;
   this->setColorRGB(IR,IG,IB); 
}








