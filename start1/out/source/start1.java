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

Player player; //<>//
ArrayList<NPC> npc;

PImage map;
ArrayList<PVector> coord = new ArrayList<PVector>();
PVector location = new PVector(-500, -500);

float squareSize;

int alpha = 0;

ArrayList<PVector> felter = new ArrayList<PVector>();
PVector pos;
Table obstacleTable;
Table NPCTable;
Table NPCQuestTable;

boolean showFelter;

public void setup() {
    
    images();

    coords();
    NPCTables();
    player = new Player();
}
public void NPCTables() {
    npc = new ArrayList<NPC>();
    NPCTable = loadTable("NPCID.csv", "header");
    for (TableRow row : NPCTable.rows()) {
        npc.add(new NPC(row.getInt("id"), row.getInt("x"), row.getInt("y")));
        pos =  new PVector(row.getInt("x"), row.getInt("y")); 
        felter.add(pos);
    }
    NPCQuestTable = loadTable("NPCSpeech.csv", "header");
    for (int i = 0; i < npc.size(); i++) {
        for (TableRow row : NPCQuestTable.rows()) {
            if (npc.get(i).id == row.getInt("NPCid")) {
                npc.get(i).speech.add(new ArrayList());
            }
        }
    }
}
public void images() {
    map = loadImage("pic.png");
    map.resize(map.width*2, map.height*2);
    squareSize = map.width/105;
    println(squareSize);
}
public void draw() {
    pushMatrix();
    image(map, location.x, location.y);
    if (showFelter) {
        for (int i =0; i<coord.size(); i++) {

            for (int j =0; j<felter.size(); j++) {
                alpha = 0;

                if (coord.get(i).x/squareSize == felter.get(j).x && coord.get(i).y/squareSize == felter.get(j).y) {
                    alpha=255;
                    fill(255, 105, 180, alpha);
                    square(coord.get(i).x+location.x, coord.get(i).y+location.y, squareSize);
                }
            }
        }
    }
    for (int i = 0; i < npc.size(); i++) {
        npc.get(i).display();
        
    }
    translate(width/2, height/2);
    player.display();

    popMatrix();
    player.collision();
    player.move();
}

public void coords() {
    obstacleTable = loadTable("felter.csv", "header");
    for (TableRow row : obstacleTable.rows()) {
        pos =  new PVector(row.getInt("x"), row.getInt("y")); 
        felter.add(pos);
    }
    for (int i = 0; i<map.width; i+=squareSize) {

        for (int j = 0; j<map.height; j+=squareSize) {
            coord.add(new PVector(i, j));
        }
    }
}

public void mousePressed() {
    println("");
}
class NPC {
    PVector NPClocation;
    ArrayList<ArrayList> speech = new ArrayList<ArrayList>();
    float NPCDia = squareSize;
    int id;
    int counter = 0;
    int counterInc = 1;
    boolean once = true;
    NPC(int id_, int locX, int locY) {
        NPClocation = new PVector(locX, locY);
        id = id_;
    }

    public void display() {
        fill(57, 255, 20);
        square(NPClocation.x*squareSize+location.x, NPClocation.y*squareSize+location.y, NPCDia);
    }


    public void speech() {
        fill(255);
        rect(0, height*0.55f, width, height*0.45f);
        for (TableRow row : NPCQuestTable.rows()) {
            if (row.getInt("questRelated") == 1) {
                if (row.getInt("questNumber") == player.QuestNumber) {
                    println(row.getRowCount());
                }
            }


            counter+=counterInc;
          /*  if (counter <= speec.length()) {
                fill(0);
                textSize(20);
                text(speec.substring(0, counter), 20, height*0.6, width-20, height);
                //println(speec.substring(0, counter));
                if (counter == speec.length()) {
                    counterInc=0;
                }
            }
            if (mousePressed) {
                counter = speec.length()-1;
            }*/
        }
    }
}
class Player {

    boolean dirUp, dirLeft, dirRight, dirDown;
    boolean movedirUp, movedirLeft, movedirRight, movedirDown, keyIsPressed;

    float playerDia = squareSize*0.75f;
    int movementSpeed = 4;
    int QuestNumber = 1;

    Player() {
    }
    public void display() {
        noFill();
        circle(0, 0, playerDia);
    }

    public void move() {
        if (movedirLeft && player.dirLeft) {
            location.x+=movementSpeed;
        }
        if (movedirRight && player.dirRight) {
            location.x-=movementSpeed;
        }
        if (movedirUp && player.dirUp) {
            location.y+=movementSpeed;
        }
        if (movedirDown && player.dirDown) {
            location.y-=movementSpeed;
        }
    }
    public void collision() {
        dirUp = true;
        dirLeft = true;
        dirRight = true;
        dirDown = true;
        float col = 2.01f;
        for (int j =0; j<felter.size(); j++) { 

            //UP
            if (width/2-location.x > felter.get(j).x*squareSize-playerDia/2 && width/2-location.x < felter.get(j).x*squareSize + squareSize + playerDia/2
                && height/2-location.y > felter.get(j).y*squareSize-playerDia/2 && height/2-location.y < felter.get(j).y*squareSize + squareSize + playerDia/2+col) {
                dirUp = false;
                npcProx(j);
            }
            //Down
            else if (width/2-location.x > felter.get(j).x*squareSize-playerDia/2 && width/2-location.x < felter.get(j).x*squareSize + squareSize + playerDia/2
                && height/2-location.y > felter.get(j).y*squareSize-playerDia/2-col && height/2-location.y < felter.get(j).y*squareSize + squareSize + playerDia/2) {
                dirDown = false;
                npcProx(j);
            }
            //Left
            else if (width/2-location.x > felter.get(j).x*squareSize-playerDia/2 && width/2-location.x < felter.get(j).x*squareSize + squareSize + playerDia/2+col
                && height/2-location.y > felter.get(j).y*squareSize-playerDia/2 && height/2-location.y < felter.get(j).y*squareSize + squareSize + playerDia/2) {
                dirLeft = false;
                npcProx(j);
            }
            //right
            else if (width/2-location.x > felter.get(j).x*squareSize-playerDia/2-col && width/2-location.x < felter.get(j).x*squareSize + squareSize + playerDia/2
                && height/2-location.y > felter.get(j).y*squareSize-playerDia/2 && height/2-location.y < felter.get(j).y*squareSize + squareSize + playerDia/2) {
                dirRight = false;
                npcProx(j);
            }
        }
    }
}

public void npcProx(int j) {
    for (int i = 0; i < npc.size(); i++) {
        if (felter.get(j).x == npc.get(i).NPClocation.x && felter.get(j).y == npc.get(i).NPClocation.y) {
            for (TableRow row : NPCQuestTable.rows()) {
                if (npc.get(i).id == row.getInt("NPCid") && npc.get(i).once) {
                    npc.get(i).speech();
                }
            }
        }
    }
}

public void keyPressed() {
    if (player.keyIsPressed==false) {
        if (keyPressed) {
            if (key == 'a') {
                player.movedirLeft = true;
            }
            if (key == 'd') {
                player.movedirRight=true;
            }
            if (key == 'w' ) {
                player.movedirUp=true;
            }
            if (key == 's') {
                player.movedirDown=true;
            }
            player.keyIsPressed = true;
        }
    }
}

public void keyReleased() {
    if (key == 'a') {
        player.movedirLeft = false;
    }
    if (key == 'd') {
        player.movedirRight=false;
    }
    if (key == 'w') {
        player.movedirUp=false;
    }
    if (key == 's') {
        player.movedirDown=false;
    }
    player.keyIsPressed=false;
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
