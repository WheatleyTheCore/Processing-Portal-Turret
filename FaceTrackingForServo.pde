
//   ADD CAMERA TO MOUSE CONTROLLED SERVO APP TO FIND THE CORRECT NUMBERS FOR SCALER STUFF
import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import processing.serial.*;
  
import processing.sound.*;
SoundFile ISeeYou, AreYouStillThere, HelloFriend, Goodnight, IDontHateYou, Searching, TakeMeWithYou, TargetLost;


Serial myPort;

int randomNum;
float xScaler;
float yScaler;
int state = 0;
int count = 0;
/*
TODO:
  
  -Add audio to pi zero, so serial can go from that to atmega328p, also learn to control servos and 
  read serial with avr/io in c, http://www.avr-tutorials.com/
  
  -Convert TurretControl sketch into avr c code for microprocessor, and then put it onto the chip
*/
Capture video;
OpenCV opencv;
int serX;
int serY;
String data;


void setup() {
  size(640, 480);
  video = new Capture(this, 640/2, 480/2, 90);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  ISeeYou = new SoundFile(this, "Iseeyou.mp3");
  AreYouStillThere = new SoundFile(this, "Still there.mp3");
  HelloFriend = new SoundFile(this, "Hello friend.mp3");
  Goodnight = new SoundFile(this, "goodnight.mp3");
  IDontHateYou = new SoundFile(this, "Idonthateyou.mp3");
  Searching = new SoundFile(this, "searching.mp3");
  TakeMeWithYou = new SoundFile(this, "takemewithyou.mp3");
  TargetLost = new SoundFile(this, "targetlost.mp3");
  HelloFriend.play();
  xScaler = (video.width) / (120.0 - 30);
  yScaler = (video.height) / (116.0 - 45);
  //myPort = new Serial(this, "/dev/cu.usbmodemFD131", 9600);

  video.start();
  delay(2000);
}

void draw() {
  scale(2);
  opencv.loadImage(video);

  image(video, 0, 0 );

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();
  println(faces.length);

  for (int i = 0; i < faces.length; i++) {
    serX = floor((faces[i].x + (faces[i].width/2))/ 240.0 * 180);
    serY = floor((faces[i].y + (faces[i].height/2))/ 200.0 * 180);
    serX = floor(120 - (serX / xScaler)) + 8;
    serY = floor(116 - (serY / yScaler));
    data = "X" + str(serX) + "Y" + str(serY);
    println(data);
    //myPort.write(data + "\n");
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  }
  if (faces.length > 0 && state == 0) {
    ISeeYou.play();
  }
  if (faces.length > 0) {
    state = 1;
    count = 0;
  }
  if (faces.length == 0) {
    state = 0;
    count ++;
    randomNum = floor(random(0, 3));
    switch (count) {
      case 5: TargetLost.play();
              break;
      case 40: Searching.play();
               break;
      case 70: if (randomNum == 0) AreYouStillThere.play();
               if (randomNum == 1) TakeMeWithYou.play();
               if (randomNum == 2) IDontHateYou.play();
               break;
    }
  }
}

void captureEvent(Capture c) {
  c.read();
}
