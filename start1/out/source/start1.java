import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class start1 extends PApplet {

PImage map;
PVector location = new PVector();
public void setup() {
    
    map = loadImage("pic.jpg");
}
public void draw() {
    pushMatrix();
    image(map, location.x, location.y);
    translate(width/2, height/2);
    circle(0, 0, 30);
    move();
    popMatrix();
    println(location);
}

public void move() {
    if (keyPressed) {
        if (key == 'a') {
            location.x+=1;
        }
        if (key == 'd') {
            location.x-=1;
        }
        if (key == 'w') {
            location.y+=1;
        }
        if (key == 's') {
            location.y-=1;
        }
    }
}
    public void settings() {  size(800, 800); }
    static public void main(String[] passedArgs) {
        String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "start1" };
        if (passedArgs != null) {
          PApplet.main(concat(appletArgs, passedArgs));
        } else {
          PApplet.main(appletArgs);
        }
    }
}
