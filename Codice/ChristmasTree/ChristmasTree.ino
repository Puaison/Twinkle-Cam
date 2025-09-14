#include <Adafruit_NeoPixel.h>

#include "Libs/CColor.h"
#include "Libs/CColor.cpp"

#include "Libs/CPixel.h"
#include "Libs/CPixel.cpp"

#define LED_PIN 6
#define LED_COUNT 50

int coordinates[100];
bool firstContact = false;

float rect[8];
int colors[8];

float Offset = 0;
float Speed = 5;
float x1 = 0;
float y1 = 0;
float dist = 50;
float vertLineOrt = 0; //0 == false, 1 == true
float m_ort = 0.5;
float q_ort = 0;

CColor* generalColor = new CColor();
CColor* c1 = new CColor();
CColor* c2 = new CColor();
uint32_t intercolor;

float interpolationValue = 0;
float p_dist = 0;



Adafruit_NeoPixel strip(LED_COUNT, LED_PIN, NEO_GRB + NEO_KHZ800);

CPixel* LedArr[LED_COUNT];

void setup() 
{
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN,LOW);
  
  Serial.begin(9600);
  strip.begin();

  c1->setColorRGB(255,255,255);  
  c2->setColorRGB(0,0,255);  

  while (!firstContact)
    {
        for(int i=0; i<strip.numPixels(); i++) 
        { 
          ColorWipe();
          strip.setPixelColor(i,2147483647);
          strip.show();
          delay(2000);
          CheckCommand();
          if (firstContact)
            break;
        }   
    }
    
  digitalWrite(LED_BUILTIN,HIGH);
  delay(500);
  Serial.println("Setup Completo");
}

void loop() 
{
  //Serial.println("Loop");
  delay(50);
  
  CheckCommand();
  UpdatePixels();
  ShowLights();
}

void CheckCommand()
{
  if (!Serial.available())
    return;
  delay(50);
  char command = Serial.read();
  Serial.println(command);
  switch (command)
  {
    case 's':
      if (!firstContact)
        MapPixels();
      break;
    case 'r':
      MapRect();
      break;
    case '+':
      Speed += 1;
      break;
    case '-':
      Speed -= 1;
      break;
    case 'c':
      MapColors();
      break;
    default:
      break;
  }
}

void MapPixels()
{
  firstContact= true;
  int arraySetupCounter = 0;
  int coordtemp;
  while (true)
  {
    delay(50);
    if (Serial.available()) // SE ci sono dati da leggere sulla porta seriale
    {
      coordtemp = Serial.parseInt();
      Serial.println(coordtemp);
      coordinates[arraySetupCounter] = coordtemp;
      arraySetupCounter++;
      if (arraySetupCounter == 100)
      {
        for (int i = 0; i<50;i++)
          LedArr[i] = new CPixel(coordinates[2*i],coordinates[(2*i)+1]);
        return;
      }
        
    }
    else
      Serial.println("s");
  }
}

void MapRect()
{
  int arraySetupCounter = 0;
  float data;
  while (true)
  {
    if (Serial.available())
    {
      data = Serial.parseFloat();
      Serial.println(data);
      rect[arraySetupCounter] = data;
      arraySetupCounter++;
      if (arraySetupCounter == 8)
        {
          Offset = rect[0];
          Speed = rect[1];
          x1 = rect[2];
          y1 = rect[3];
          dist = rect[4];
          vertLineOrt = rect[5];
          m_ort = rect[6];
          q_ort = rect[7];
          return;
        }   
    }
  }
}

void MapColors()
{
  int arraySetupCounter = 0;
  int data;
  while (true)
  {
    if (Serial.available())
    {
      data = Serial.parseFloat();
      Serial.println(data);
      //Serial.println("sto salvando un dato");
      colors[arraySetupCounter] = data;
      arraySetupCounter++;
      if (arraySetupCounter == 8)
      {
        c1->setColorRGB(colors[0],colors[1],colors[2]);
        c2->setColorRGB(colors[4],colors[5],colors[6]);
        return;
      }
        
    }
  }
}

void ColorWipe() 
{
  for(int i=0; i<strip.numPixels(); i++) 
  { 
    strip.setPixelColor(i,0);
  }
  strip.show(); 
}

void UpdatePixels() 
{
  Offset = Offset + Speed;
  for(int i=0; i<strip.numPixels(); i++) 
  {
    if (vertLineOrt == 1) { p_dist = LedArr[i]->getX() - x1; } //Calcolo p_dist se ho una retta verticale
    else if (m_ort == 0) { p_dist = LedArr[i]->getY() - y1; } //Calcolo p_dist se ho una retta orizzontale
    else { p_dist = abs(LedArr[i]->getY() - (m_ort * LedArr[i]->getX() + q_ort)) / sqrt(1 + m_ort * m_ort); } //Calcolo p_dist altrimenti
    interpolationValue = handmademap(cos((p_dist+Offset)*(2*PI/dist))); //Valore di interpolazione calcolato in base a distanza e offset dalla retta 
    intercolor = generalColor->interpolate(c1,c2,interpolationValue); //Interpolazione tra due colori e valore
    LedArr[i]->setColor32(intercolor); //Assegnazione del nuovo colore al mio array di CPixels
  }
}

void ShowLights() 
{
  for(int i=0; i<strip.numPixels(); i++) 
  { 
    strip.setPixelColor(i,LedArr[i]->getColor());
  }
  strip.show(); 
}

void ReadStrip() 
{
  Serial.println("\nStrip:");
  for(int i=0; i<strip.numPixels(); i++) 
  { 
    Serial.print("Led ");
    Serial.print(i+1);
    Serial.print(" :");
    Serial.print(LedArr[i]->getX());
    Serial.print(",");    
    Serial.println(LedArr[i]->getY());
  } 
}

double handmademap(double input)
{
  double slope = 1.0 * (1) / (2); 
  return (slope * (input +1));
}
