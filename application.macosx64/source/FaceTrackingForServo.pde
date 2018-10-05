import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import processing.serial.*;

Serial myPort;

Capture video;
OpenCV opencv;
float xScaler = 180.0/250;
float yScaler = 180.0/200;
int serX;
int serY;
String data;


void setup() {
  size(640, 480);
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  myPort = new Serial(this, "/dev/cu.usbmodemFD131", 9600);

  video.start();
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
    serX = floor(faces[i].x*xScaler);
    serY = 180 - floor(faces[i].y*yScaler);
    data = "X" + str(serX) + "Y" + str(serY) ;
    println(data);
    myPort.write(data + "\n");
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  }
}

void captureEvent(Capture c) {
  c.read();
}