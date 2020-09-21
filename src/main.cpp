// Original code by https://www.instructables.com/member/ethanpnorton/
// Code found inside this project: https://www.instructables.com/id/The-NeoBoard-16x16-LED-Display-w-Arduino/
// There's no license associated to the original code

#include <Arduino.h>
#include <Adafruit_NeoPixel.h>
#include <sprites.h> // We'll store the vector stripes in a separate file

#define LEDS_NUMBER 256
#define LEDS_PIN 4   // Digital pin for the leds data input
#define BUTTON_PIN 2 // Digital pin to control the pushbutton
#define TOTAL_SPRITES 1

Adafruit_NeoPixel strip = Adafruit_NeoPixel(LEDS_NUMBER, LEDS_PIN, NEO_GRB + NEO_KHZ800);

byte selectedSprite = 0;

void displaySprite(const uint8_t pixelsArray[256][3])
{

  for (uint8_t i = 0; i < 256; i++)
  {
    strip.setPixelColor(i, pgm_read_byte(&pixelsArray[i][0]), pgm_read_byte(&pixelsArray[i][1]), pgm_read_byte(&pixelsArray[i][2]));
    strip.show();
  }
}

void changeSprite()
{

  if (digitalRead(BUTTON_PIN) == HIGH)
  {
    selectedSprite++;
  }

  if (selectedSprite > TOTAL_SPRITES)
  {
    selectedSprite = 1;
  }

  switch (selectedSprite)
  {

  case 1:
    displaySprite(penguin);
    break;
  // case 2:
  //   displaySprite(another sprite);
  //   break;
  // ...
  default:
    displaySprite(penguin);
    break;
  }
}

void setup()
{
  strip.begin();
  strip.setBrightness(20);
  strip.show();

  pinMode(BUTTON_PIN, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(BUTTON_PIN), changeSprite, CHANGE); // Link the changeColor function to pressing the pushbutton
  changeSprite();
}

void loop()
{
}