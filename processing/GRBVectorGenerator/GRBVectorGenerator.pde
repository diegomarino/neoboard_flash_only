// Original code by https://www.instructables.com/member/ethanpnorton/
// Code found inside this project: https://www.instructables.com/id/The-NeoBoard-16x16-LED-Display-w-Arduino/
// There's no license associated to the original code

PImage input;
PImage thumbnail;

String[] outputRows = new String[256];

String inputFilename = "penguin.bmp";
String outputFilename = "penguin_vector";

void setup() {
  size(16, 16);
}

void draw() {

  input = loadImage(inputFilename);
  thumbnail = createImage(16, 16, RGB);

  thumbnail.copy(input, 0, 0, 16, 16, 0, 0, 16, 16);  // 16 is a hardcoded value for my needs
  image(thumbnail, 0, 0);

  processThumbnail();

  noLoop();
}

void processThumbnail() {
  int pixelNum = 0;

  thumbnail.loadPixels();

  for (int y = 0; y < 16; y++) {    // 16 is a hardcoded value for my needs
    for (int x = 0; x < 16; x++) {  // 16 is a hardcoded value for my needs
      int index = 0;

      if (y % 2 == 1) {
        int rawIndex = (x + (y * 16));
        int begin = y * 16;
        int end = (y * 16) + 15;
        index = end - (rawIndex - begin);
      } else {
        index = x + (y * 16);
      }


      color c = thumbnail.pixels[index];

      String GRBvalues = ""; // Will have a {G, R, B} format so it can be consumed as an array of uint8s by the arduino code
      GRBvalues += "{";
      GRBvalues += Math.round(red(c));
      GRBvalues += ",";
      GRBvalues += Math.round(green(c));
      GRBvalues += ",";
      GRBvalues += Math.round(blue(c));
      GRBvalues += "},";

      // The need for the "abs(pixelNum-255)" modification cames from the 
      //difference of how Processing and the led strips are typically connected.
      //For Processing the (0,0) coordinate is situated at the top-left corner, 
      //while for the led strips is situated at the bottom-left corner. 
      outputRows[abs(pixelNum-255)] = GRBvalues;

      pixelNum++;
    }
  }

  outputRows[0] = "const PROGMEM uint8_t "+ outputFilename + "[][3]{"+outputRows[0];
  outputRows[255] = outputRows[255] + "};";

  //outputRows[256] = str(0);

  saveStrings(outputFilename, outputRows);
}
