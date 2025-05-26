/*
  Paredolia-GridSystem Visuals
  by KlaasKlee
  www.klaasklee.de


  this Code displays colages of images
  
  -- generate AlphaMasks --
  just comment out everything but the generateMasks(); function in draw().
  
  You have some setting parameters in the "image/mask Variables" section to play around with.
  
  I suggest keeping an eye on the out folder during the runtime and ending the program when enough masks have been generated.
  Alternatively, you can of course use a for loop to generate a certain number of masks.
  The generated masks are needed to finally create the collages.
  Then comment out the generateMasks(); function and activate the other code in draw() again.
  
  
  -- make the Collages --
  collage with curved alpha masks that are randomly generated
 
  put the images you want to use for the collages in the data folder of the processing sketch with the correct naming convention:
  img_0.jpg, img_1.jpg, img_2.jpg, ...
  same for masks mask_0.jpg, ...
 
  When you start the program, a new collage should be displayed every 4 frames.
  If you want to save the collages at the same time, activate the line in draw() with "saveFrame("data/out/outVid####.jpg");".
 
  You also have some setting parameters in the "gridsystem Variables" section to play around with.
   
  Have Fun!
 */

boolean debug = false;

color bg = #000000;

//-----
//gridsystem Variables
//-----
color[] fg = {#67FF81,#FF67EE,#FF6274,#62FFF1};

int[] tileSizeArr = {1, 4, 20, 5, 10, 30, 20, 20, 20};
int tileSizeArrLen = tileSizeArr.length;


//-----
//image/mask Variables
//-----
int everyFrame = 4;

//img variables
int numberOfImages = 61;
PImage image;
int numberOfMasks = 50;
PImage maskImage;

//mask variables
color maskCol = #ffffff;



void setup() {
  fullScreen();
  frameRate(24);
  background(bg);
}


void draw() {
  // only if you want to generate new masks
  //generateMasks();

  blendMode(NORMAL);
  //draws every "everyFrame" a new masked image
  if (frameCount % everyFrame == 0) {
    drawMaskedImage();
  }
  blendMode(DARKEST);
  gridSystem();
  
  //saveFrame("data/out/outVid####.jpg");
}


//generates alphaMasks and stores them as jpg
//only use to init masks, coment out function in draw() while performing
void generateMasks() {
  background(color(#000000));
  fill(maskCol);

  beginShape();

  //random points for shape
  for (int y = 0; y<15; y++) {
    curveVertex(int(random(0, width)), int(random(0, height)));
  }

  endShape(CLOSE);

  filter(BLUR, 40);
  filter(POSTERIZE, 2);

  saveFrame("data/masks/mask####.jpg");
}

// masks random image with random mask and draws it
void drawMaskedImage() {

  int randImg = int(random(0, numberOfImages));
  int randMask = int(random(0, numberOfMasks));

  // image/mask loading and resize
  image = loadImage( "img/img_" + randImg + ".jpg" );
  image.resize(width, height);
  maskImage = loadImage( "masks/mask_" + randMask + ".jpg" );
  maskImage.resize(width, height);

  image.mask(maskImage);
  image(image, 0, 0);
}

//generates lineshapes in a gridsystem
void gridSystem() {

  noFill();
  stroke(fg[int(random(0, fg.length))]);

  float tilesX = tileSizeArr[int(map(cos(radians(frameCount*1)), -1, 1, 0, tileSizeArrLen-1))];
  float tilesY = tilesX;

  float tileW = width/tilesX;
  float tileH= tileW;

  int[] numStrokesArr = {1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 1, 1, 1, 11, 3, 20, 10, 10, 10, 3, 5, 5, 5, 5, 5, 5, 2};
  int numStrokesArrLen = numStrokesArr.length;
  int numStrokes = numStrokesArr[int(map(sin(radians(frameCount*0.2)), -1, 1, 0, numStrokesArrLen-1))];

  strokeWeight(map(numStrokes, 0, 30, 4, 0.5)+random(-1, 1));

  for (int x = 0; x < tilesX; x++) {
    for (int y = 0; y < tilesY; y++) {
      float posX = tileW *x;
      float posY = tileH *y;

      float wave = sin(radians(frameCount + x * sin(radians(frameCount+100)) + y * tan(radians(frameCount+100))*12));
      float mappedWave = map(wave, -1, 1, 0, 4)-0.01;
      int selector = int(mappedWave);
      if (debug) {
        println(wave);
      };

      pushMatrix();
      translate(posX, posY);

      switch(selector) {
      case 0:
        for (int s = numStrokes; s > 0; s--) {
          arc(0, 0, tileW*map(s, 0, numStrokes, 0, 2), tileH*map(s, 0, numStrokes, 0, 2), radians(0), radians(90));
        }
        break;
      case 1:
        for (int s = numStrokes; s > 0; s--) {
          arc(tileW, 0, tileW*map(s, 0, numStrokes, 0, 2), tileH*map(s, 0, numStrokes, 0, 2), radians(90), radians(180));
        }
        break;
      case 2:
        for (int s = numStrokes; s > 0; s--) {
          arc(tileW, tileH, tileW*map(s, 0, numStrokes, 0, 2), tileH*map(s, 0, numStrokes, 0, 2), radians(180), radians(270));
        }
        break;
      case 3:
        for (int s = numStrokes; s > 0; s--) {
          arc(0, tileH, tileW*map(s, 0, numStrokes, 0, 2), tileH*map(s, 0, numStrokes, 0, 2), radians(270), radians(360));
        }
        break;
      }
      popMatrix();
    }
  }
}
