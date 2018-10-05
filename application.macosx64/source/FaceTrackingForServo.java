import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import gab.opencv.*; 
import processing.video.*; 
import java.awt.*; 
import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class FaceTrackingForServo extends PApplet {






Serial myPort;

Capture video;
OpenCV opencv;
float xScaler = 180.0f/250;
float yScaler = 180.0f/200;
int serX;
int serY;
String data;


public void setup() {
  
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  myPort = new Serial(this, "/dev/cu.usbmodemFD131", 9600);

  video.start();
}

public void draw() {
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

public void captureEvent(Capture c) {
  c.read();
}
  public void settings() {  size(640, 480); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "FaceTrackingForServo" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
