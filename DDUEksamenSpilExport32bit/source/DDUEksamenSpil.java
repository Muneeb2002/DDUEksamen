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

public class DDUEksamenSpil extends PApplet {

//
Player player;
Shop shop; 
Penge penge;
Inventory inventory;
ArrayList<NPC> npc;
ArrayList <Items> items;

PImage map;
PImage coin;
PImage[] pic = new PImage[14];
PImage[] npcDesign = new PImage [6];
PImage chest;
PImage textBubble;
PFont font;

PImage[] sprite = new PImage[16];
PImage[] spriteUp = new PImage[4];
PImage[] spriteLeft = new PImage[4];
PImage[] spriteRight = new PImage[4];
PImage[] spriteDown = new PImage[4];
PImage spritesheet;
int W, H, h=4, w=4; // variabler der bruges til spirtesheet, W og H = størrelsen af spritesheetet. h og w antallet af spirtes på sheetet.

int storyCounter, storyCounterInc = 1, storyOf=1;
String storySpeech;

PVector startScreen = new PVector(-500, -500);
PVector startScreenMovement = new PVector(-2, 0);


ArrayList<PVector> coord = new ArrayList<PVector>();
PVector location = new PVector(-588, -428);
PVector triangleLocation = new PVector(729, 756, -1);
float squareSize;


ArrayList<PVector> felter = new ArrayList<PVector>();
PVector pos;

//forskellige tables der indeholder data fra CSV filerne
Table obstacleTable;
Table NPCTable;
Table NPCQuestTable;
Table questTable;
Table shopTable;
Table itemsTable;
Table questItemTable;
Table storyTable;

//booleans der styrer  skræmene der bliver vist(om man spillet er begyndt eller det start skærm osv)
boolean showStartScreen = true;
boolean gameBegun;
boolean transitionScreen;
boolean transitionScreenCoordOnce=true;
boolean howToPlay;
boolean storyScreen;
ArrayList<PVector> transitionScreenCoord = new ArrayList<PVector>();


public void setup() {
    
    images();

    coords();
    npc = new ArrayList<NPC>(); 
    items = new ArrayList<Items>();
    inventory = new Inventory();
    tables();
    shop.shopItemsCoords_();
    inventory.inventoryItemsCoords_();
    player = new Player();

    penge = new Penge (0);
    font = createFont("font.ttf", 60);
}
public void tables() { //I denne funktion bliver alle alle CSV filerne loadet
    NPCTable = loadTable("NPCID.csv", "header");
    for (TableRow row : NPCTable.rows()) { // vi køre i gennem hele tabbellen
        // tilføjer objekter til NPC classen ud fra data hentet fra CSV
        npc.add(new NPC(row.getInt("id"), row.getInt("x"), row.getInt("y"), row.getInt("picture")));
        // tilføjer deres position med data fra csv filen
        pos =  new PVector(row.getInt("x"), row.getInt("y")); 
        felter.add(pos); // tilføjer positionen til felter arraylisten
        if (row.getInt("shop") == 1) { //checker om NPC er en shop eller ej. og tilføjer et element til shop classen
            shop = new Shop(row.getInt("x"), row.getInt("y"));
        }
    }
    NPCQuestTable = loadTable("NPCSpeech.csv", "header");
    questTable = loadTable("Quests.csv", "header");
    shopTable = loadTable("shop.csv", "header");
    storyTable = loadTable("story.csv", "header");
    itemsTable = loadTable("items.csv", "header");
    for (TableRow row : itemsTable.rows()) {
        if (row.getInt("quest")==0) { //Tilføjer alle de items der ikke har noget med en quest af gøre i starten
            items.add(new Items(row.getInt("x"), row.getInt("y"), row.getString("name"), row.getInt("itemNr"), row.getInt("inQuest")));
        }
    }
}
public void images() { //I denne funktion bliver alle billederne indlæst og deres størrelse bliver
    map = loadImage("/sprites/pic.png");
    coin = loadImage("/sprites/coins.png");
    textBubble = loadImage("/sprites/textBubble.png");
    textBubble.resize(width-10, PApplet.parseInt(height*0.45f)-5);
    map.resize(map.width*2, map.height*2);
    coin.resize(30, 30);
    squareSize = map.width/105;

    for (int j = 1; j < pic.length; j++) { //Tilføjer billederne der bruges til itemsne i et Image array
        pic[j] = loadImage("/sprites/pic"+j+".png");
        pic[j].resize(2*PApplet.parseInt(squareSize), 2*PApplet.parseInt(squareSize));
    }
    for (int j = 0; j < npcDesign.length; j++) { // tilføjer de forskellige NPC design i et image Array
        npcDesign[j] = loadImage("/sprites/NPC"+(j+1)+".png");
        npcDesign[j].resize(PApplet.parseInt(squareSize*1.2f), PApplet.parseInt(squareSize*1.2f));
    }
    chest = loadImage("/sprites/chest.png");
    chest.resize(PApplet.parseInt(squareSize), PApplet.parseInt(squareSize));
    int number = 1;
    spritesheet = loadImage("/sprites/spritesheet.png");
    W = spritesheet.width/w;
    H = spritesheet.height/h;
    for (int i = 0; i < h; i++) {
        for (int j = 0; j < w; j++) {
            //Koden her deler spirtesheetet op i 4 mindre dele der hver så bliver delt op i hver sit billede array  
            sprite[number-1] = spritesheet.get(j*H, i*W, H, W);
            sprite[number-1].resize(PApplet.parseInt(squareSize*1.2f), PApplet.parseInt(squareSize*1.2f));
            switch (i+1) {
            case 4:
                spriteUp[j] = sprite[number-1];
                break;
            case 1:
                spriteDown[j] = sprite[number-1];
                break;
            case 2:
                spriteLeft[j] = sprite[number-1];
                break;
            case 3:
                spriteRight[j] = sprite[number-1];
                break;
            }
            number++;
        }
    }
}
public void draw() {
    textFont(font);
    if (showStartScreen) { // kører start skærmsfunktionen
        startScreen();
    }
    if (showStartScreen == false) {
        if (storyScreen) {
            //kører storyScreen funktionen
            StoryScreen();
        }
        if (transitionScreen) {
            //kører transitionScreen funktionen
            transitionScreen();
        }
        if (gameBegun) { // hvis spillet er begyndt
            pushMatrix();
            image(map, location.x, location.y); // tegner mappet der bevæger sig rundt
            //tegner NPCer og items
            for (NPC n : npc) {
                n.display();
            }
            for (Items i : items) {
                i.display();
            }
            //laver translate for at få spilleren i midten af skærmen
            translate(width/2, height/2);
            player.display();
            popMatrix();
            
            penge.display(); // køre display funktionen i penge klassen
            player.collision(); //laver collision i player klassen
            player.move(); // laver bevægelse i player klassen
            if (inventory.showInventory) { // hvis man viser inventory ved at trykke på 'I'
                inventory.display();
            }
        }
    }
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

public void startScreen() {
    image(map, startScreen.x, startScreen.y); // 
    startScreen.add(startScreenMovement); // laver bevægelser
    //de if statements under sørger for at skærmen bevæger sig rundt i en firkant omkring mappet
    if (startScreen.x <= -2800 && startScreen.y >= -500) { 
        startScreenMovement.x = 0;
        startScreenMovement.y = -2;
    }
    if (startScreen.x <= -2800 && startScreen.y <=-2100) {
        startScreenMovement.x = 2;
        startScreenMovement.y = 0;
    }
    if (startScreen.x >= -500 && startScreen.y <=-2100) {
        startScreenMovement.x = 0;
        startScreenMovement.y = 2;
    }
    if (startScreen.x >= -500 && startScreen.y >=-500) {
        startScreenMovement.x = -2;
        startScreenMovement.y = 0;
    }
    if (howToPlay == false) {
        //her bliver der lavet tre knapper 
        textAlign(CENTER);
        fill(255, 150);
        rect(width/4, height/3, 2*(width/4), 50);
        rect(width/4, 60+(height/3), 2*(width/4), 50);
        rect(width/4, 120+(height/3), 2*(width/4), 50);
        fill(0, 0, 255);
        //skriver knappernes tekst
        textSize(20);
        text("PLAY", width/2, 30+(height/3));
        text("How To Play", width/2, 90+(height/3));
        text("Quit", width/2, 150+(height/3));


        // sørger for at der sker noget når man trykker på knapperne 
        if (mouseX>width/4 && mouseY >height/3 && mouseX<3*(width/4) && mouseY <50+(height/3) && showStartScreen && mousePressed) {
            showStartScreen = false;
            storyScreen = true;
        }

        if (mouseX>width/4 && mouseY >60+height/3 && mouseX<3*(width/4) && mouseY <60+50+(height/3) && showStartScreen && mousePressed) {
            howToPlay = true;
        }

        if (mouseX>width/4 && mouseY >120+height/3 && mouseX<3*(width/4) && mouseY <120+50+(height/3)&& showStartScreen && mousePressed) {
            exit();
        }
    } else {
        HowToPlay();
    }
}
public void HowToPlay() {
    // laver instruktions skærmen
    fill(255, 150);
    rect(100, 100, 600, 600);
    fill(255);
    textSize(20);
    textAlign(LEFT);
    text("X", 105, 120);
    if (mousePressed) {
        //lukker informations skærmenen
        if (mouseX >105 && mouseX < 125 && mouseY >100 && mouseY < 120 ) {
            howToPlay = false;
        }
    }
    textAlign(CENTER);
    textSize(30);
    text("Instruktioner", width/2, 130);
}
public void StoryScreen() {
    background(0);
    image(textBubble, 5, height*0.55f);

    for (TableRow row : storyTable.rows()) {
        //tjekker om den nuverænde historie der bliver vist har det samme nummer som det i teksten
        if (storyOf == row.getInt("number")) {
            storySpeech = row.getString("story");
        }
        //Når den nuværende historie er færdig og der ikke er fler, så stopper den storyScreen og start transition screen
        if (storyOf >row.getInt("outOf") ) {
            storyScreen = false;
            transitionScreen = true;
        }
    }

    if (storyCounter <= storySpeech.length()) { //tjekker om antallet af tegn vist er mindre end eller lig med antallet af tegn i storySpeech stringen 
        fill(0);
        textSize(15);
        textAlign(LEFT);
        text(storySpeech.substring(0, storyCounter), 50, height*0.6f, width-100, height);

        if (storyCounter == storySpeech.length()) { // tjekker om antallet af tegn vist er lig med antallet af tegn i storySpeech stringen 
            storyCounterInc=0;
            fill(0);
            //tegner en trekant der går op og ned for at indikere at teksten er færdig og at man venter på user input
            if (triangleLocation.y < 751) {
                triangleLocation.z = 1;
            }
            if (triangleLocation.y > 761) {
                triangleLocation.z = -1;
            }
            triangleLocation.y += triangleLocation.z;
            triangle(triangleLocation.x, triangleLocation.y, triangleLocation.x-10, triangleLocation.y-20, triangleLocation.x+10, triangleLocation.y-20);
            if (mousePressed) {//sørger for at tekst skriveren bliver genstartet 
                storyOf++;
                storyCounter = 0;
                storyCounterInc = 1;
            }
        }
    }

    storyCounter+=storyCounterInc;
}
public void transitionScreen() {
    image(map, location.x, location.y);
    // tegner alle npcer og items
    for (NPC n : npc) {
        n.display();
    }
    for (Items i : items) {
        i.display();
    }
    imageMode(CENTER);
    //tegner spilleren der står stille
    image(spriteDown[0], width/2, height/2-10);
    imageMode(CORNER);
    if (transitionScreenCoordOnce) {

        for (int i = 0; i < 20; i++) {
            for (int j = 0; j < 20; j++) {
                //laver en koordinaterne for en masse firkanter
                transitionScreenCoord.add(new PVector(i, j, 255));
            }
        }
        //sørger for at det kun sker 1 gang
        transitionScreenCoordOnce = false;
    }


    for (int i = 0; i < transitionScreenCoord.size(); i++) {//Tegner alle firkanterne så hele skræmen bliver dækket
        noStroke();
        fill(0, transitionScreenCoord.get(i).z);
        rect(transitionScreenCoord.get(i).x*width/20, transitionScreenCoord.get(i).y*height/20, width/20, height/20);
    }

    //fjerner en firkant af gangen
    for (int i = 0; i < transitionScreenCoord.size()+1; i = PApplet.parseInt(random(0, transitionScreenCoord.size()))) {
        if (transitionScreenCoord.get(i).z == 255) {
            transitionScreenCoord.get(i).z = 0;
            break;
        }
    }

    boolean allGone = true;
    //Tjekker om alle firkanter er væk
    for (int i = 0; i < transitionScreenCoord.size(); i++) {
        if (transitionScreenCoord.get(i).z == 255) {
            allGone = false;
        }
    }
    //sørger for at man kan springe transtionscreenen over
    if (keyPressed) {
        allGone = true;
    }
    //hvis der ikke er flere firkanter så begynder spillet
    if (allGone) {
        gameBegun = true;
        transitionScreen = false;
    }
}
public void mouseReleased() {
    if (storyScreen) {
        if (storyCounter > 10) {
            storyCounter = storySpeech.length();
        }
    }
    if (shop.mouseRel) {
        shop.mouseRel=false;
    }
}
class Inventory {
    PVector inventoryLoc;
    boolean showInventory;
    int itemsNumber = 0;
    ArrayList<PVector>inventoryItemsCoords = new ArrayList<PVector>();
    Inventory() {
    }
    public void inventoryItemsCoords_() {
        int h = 1;
        for (int i = 90; i<600; i+=210) {
            for (int j =100; j<600; j+=210) {
                inventoryItemsCoords.add(new PVector(j, i, h));
                h++;
            }
        }
    }

    public void display () {
        //tegner firkanten der laver inventoryen.
        fill(255);
        rect(50, 50, 700, 700);
        textAlign(CENTER);
        fill(0);
        textSize(30);
        text("Inventory", width/2, 80);
        showInventory(); //kører showInventory funktionen
    }
    public void showInventory() {
        for (int i = 0; i<inventoryItemsCoords.size(); i++) {
            noFill();
            stroke(0);
            strokeWeight(2);
            rect(inventoryItemsCoords.get(i).x, inventoryItemsCoords.get(i).y, 200, 200);
            for (Items item : items) {
                for (TableRow row : itemsTable.rows()) {
                    if (inventoryItemsCoords.get(i).z == item.itemsLocation.z) {
                        if (row.getInt("pickedUp") ==1 && item.givenAway == false && row.getInt("cash") == 0) { // tjekker om itemen er samlet op, ikke givet væk og ikke er en penge gave
                            if (row.getString("name") == item.name) { // navnet på itemen er ens i tabellen og objektet
                                textSize(20);
                                textAlign(CENTER);
                                imageMode(CENTER);
                                if (item.id < pic.length) { // sætter billedet af itemen ind på dens plads
                                    image(pic[item.id], inventoryItemsCoords.get(i).x+205/2, inventoryItemsCoords.get(i).y+150/2);
                                }
                                imageMode(CORNER);
                                //skriver navnet på itemen
                                text(row.getString("name"), inventoryItemsCoords.get(i).x+205/2, inventoryItemsCoords.get(i).y+150/2+100);
                                textAlign(LEFT);
                            }
                        } 
                    }
                }
            }
        }
    }
}
class Items {
    PVector itemsLocation;
    String name;
    float itemsDia = squareSize;
    int counter, counterInc = 1, id;
    String speech;
    boolean pickedUp, showText = true, showItem = true;
    boolean inGame;
    boolean givenInQuest;
    boolean givenAway;
    boolean cashGiven;
    boolean textIsFinished;
    Items(int x_, int y_, String name_, int id_, int inQuest_) {
        id = id_;
        itemsLocation = new PVector(x_, y_);
        name = name_;
        felter.add(itemsLocation);
        if (inQuest_ == 1) {
            givenInQuest = true;
        } else if (inQuest_ == 0) {
            givenInQuest = false;
        }
    }
    public void display() {
        if (showText && givenInQuest == false) { // tegner npcen, på den plads hvis den ikke gives i en quest og ikke er fundet endnu
            image(chest, itemsLocation.x*squareSize+location.x+5, itemsLocation.y*squareSize+location.y);
        }
    }
    public void textmsg() { // skriver teksten der popper op når man har fundet en item
        if (givenInQuest) { // tjekker om enten finder itemen eller modtager den fra en NPC
            speech = "Du har modtaget \"" + name + "\"";
        } else {
            speech = "Du har fundet \"" + name + "\"";
        }
        pickedUp=true;
        //tegner feltet hvor teksten står
        fill(0, 200);
        rect(5, height*0.55f, width-10, height*0.45f-5);
        noFill();
        stroke(192, 192, 192);
        strokeWeight(5);
        rect(5, height*0.55f, width-10, height*0.45f-5);
        noStroke();
        //skriver teksten
        if (counter <= speech.length()) {
            fill(255);
            textSize(20);
            text(speech.substring(0, counter), 20, height*0.6f, width-30, height);
            //tjekker om teksten er færdig med at blive vist
            if (counter == speech.length()) {
                counterInc=0;
                textIsFinished = true;
                //tegner en trekant der går op og ned for at indikere at teksten er færdig og at man venter på user input
                if (triangleLocation.y < 751) {
                    triangleLocation.z = 1;
                }
                if (triangleLocation.y > 761) {
                    triangleLocation.z = -1;
                }
                triangleLocation.y += triangleLocation.z;
                fill(255);
                triangle(triangleLocation.x, triangleLocation.y, triangleLocation.x-10, triangleLocation.y-20, triangleLocation.x+10, triangleLocation.y-20);
            }
        }

        counter+=counterInc;
        if (mousePressed && textIsFinished) { // sørger for at teksten stopper med at blive vist
            showText = false;
        }
    }

    public void removeItem() { // fjerner itemen fra spillet, hvis den bliver givet væk for at klare en quest
        if (givenAway) {
            items.remove(this);
        }
    }
}
class NPC {
    PVector NPClocation;
    float NPCDia = squareSize;
    int id;
    int counter = 0;
    int counterInc = 1;
    int speechOf = 1;
    int pic;
    boolean once = true;
    String speech = "";
    boolean speechIsFinished;

    boolean done;
    NPC(int id_, int locX, int locY, int picture) {
        NPClocation = new PVector(locX, locY); // tilføjer npcens locX/Y til NPClocation PVectoren
        id = id_;
        pic = picture;
    }

    public void display() { // tegner npcen  på dens position og med det valgte design til npcen
        image(npcDesign[pic], NPClocation.x*squareSize+location.x-5, NPClocation.y*squareSize+location.y-10);
    }


    public void Speech() { // Det koden her gør at den tager data fra NPC tabellen, og vælger hvilken tekst der skal siges af NPCen
        if (shop.shopSpeeking == false) { // tjekker om spilleren shoppen er i gang med at snakke(kun når man snakker med shoppen er den her sandt)
            for (TableRow row : NPCQuestTable.rows()) {
                //if statement tjekker om speechen er quest relateret eller ej, og om quest nummeret fra databasen er en mindre end det nuværende quest nummer og om id'en passer 
                if (row.getInt("questRelated") == 1 && row.getInt("questNumber")-1 == player.QuestNumber && row.getInt("NPCid") == id) {

                    if (row.getInt("number") <= row.getInt("of") && speechOf == row.getInt("number")) {
                        //Tjekker om player.questcomp = 0, altså man har klaret 0% af questen
                        if ( row.getInt("start")-1 == player.questComp &&  row.getInt("start")-1 == 0  ) {
                            player.questActive = true;
                            for (TableRow rows : questTable.rows()) {
                                //tjekker om quest nummer -1 er lig med player quest nummer
                                if (rows.getInt("questNumber")-1 == player.QuestNumber) { 
                                    //flyder arraysne de NPCer og items man skal være hos/ samle op for at klare questen
                                    player.itemsNeeded = PApplet.parseInt(splitTokens(rows.getString("items"), ","));
                                    player.NPCInQuest = PApplet.parseInt(splitTokens(rows.getString("NPCsInQuest"), ","));
                                }
                            }
                            //sender queststring til show SPeech funktionen
                            showSpeech(row.getString("questString"));
                            // gør questcomp en større
                            if (row.getInt("of") == speechOf) {
                                player.questComp = row.getInt("start");
                            }
                        }
                        // viser tekst questen for den næste del af questen og dem før 
                        if (row.getInt("start")-1 <= player.questComp && player.questActive && player.questComp != row.getInt("outOf")) {

                            if (row.getInt("start")-1 == player.questComp) {
                                //hvis det er den næste del så bliver den større
                                player.questComp = row.getInt("start");
                            }
                            showSpeech(row.getString("questString"));
                        }
                        //tjekker om man er noget til slutningen af questen
                        if (player.questComp == row.getInt("outOf") && player.questActive) {
                            //sortere items man har fundet så det ikke gør nogen forskel hvilken række følge man finder tingene
                            player.itemsPicked = sort(player.itemsPicked);
                            //laver en subInt der er ligeså lang som listen af items man har brug for, grunden til det er 
                            // at listen af times man har er 9 lang og nogle gange skal man ikke bruge 9 ting
                            int[] subInt = new int[player.itemsNeeded.length];
                            boolean ens = true;
                            for (int i = 0; i < player.itemsNeeded.length; i++) {
                                subInt[i]=player.itemsPicked[i];
                            }
                            //sammenligner de to arrays, hvis de ikke er ens så bryder den loopet og begynder på den næste del af koden
                            for (int i = 0; i < player.itemsNeeded.length; i++) {
                                if (player.itemsNeeded[i]!=subInt[i]) { 
                                    ens = false; 
                                    break;
                                }
                            }
                           
                            if (ens) {
                                showSpeech(row.getString("questString"));

                                //Når man trykker en til gang så genstarter den værdierne og man får sin reward
                                if (row.getInt("of")+1 == speechOf) {
                                    done = true;
                                    player.reward = row.getInt("reward");
                                    player.questCompleted = true;
                                    for (int i = 0; i < player.itemsNeeded.length; i++) {
                                        for (Items item : items) {
                                            if (subInt[i] == item.id && item.givenAway == false) {
                                                item.givenAway = true;
                                                player.givenAway++;
                                                item.removeItem();
                                                break;
                                            }
                                        }
                                    }
                                    for (int i = 0; i< subInt.length; i++) {
                                        subInt[i]=100;
                                    }
                                    for (int i = 0; i< player.NPCInQuest.length; i++) {
                                        player.NPCInQuest[i]=0;
                                    }
                                }
                            } else {
                                showSpeech("Det ser ud til at du ikke har fundet alle tingene endnu");
                            }
                        }
                    }
                    if (row.getInt("of")+1==speechOf) {
                        player.isTalking = false;
                    }
                    for (TableRow rows : itemsTable.rows()) {

                        if (rows.getInt("quest")-1==player.QuestNumber) {

                            if (rows.getInt("display") == player.questComp) {
                                if (rows.getInt("itemDisplayed") == 0) {
                                    items.add(new Items(rows.getInt("x"), rows.getInt("y"), rows.getString("name"), rows.getInt("itemNr"), rows.getInt("inQuest")));
                                    rows.setInt("itemDisplayed", 1);
                                }
                            }
                        }
                    }
                    //den her else if og koden i den sørger for at NPCerne der ikke er med i questen godt kan snakke også selv om de ikke er i en quest, når quest er active
                } else if (row.getInt("questRelated") == 0 && row.getInt("NPCid") == id) { 
                    if (player.questActive) {
                        boolean notIt = true;
                        for (int i = 0; i <  player.NPCInQuest.length; i++) {
                            if (player.NPCInQuest[i] == id) {
                                notIt = false;
                                break;
                            }
                        }
                        if (notIt) {
                            showSpeech(row.getString("nonQuestString"));
                        }
                        //sørger for at når questen ikke er activ at alle siger noget
                    } else if (player.questActive == false) {
                        showSpeech(row.getString("nonQuestString"));
                    }
                }
            }
        }
    }
    public void showSpeech(String speech ) { // skriver den tekst som NPCen siger 
        image(textBubble, 5, height*0.55f);
        player.isTalking = true;
        if (counter <= speech.length()) { //tjekker om antallet af tegn vist er mindre end eller lig med antallet af tegn i storySpeech stringen 
            fill(0);
            textSize(20);
            text(speech.substring(0, counter), 50, height*0.6f, width-100, height);

            if (counter == speech.length()) { // tjekker om antallet af tegn vist er lig med antallet af tegn i storySpeech stringen 
                counterInc=0;
                speechIsFinished = true;
                //tegner en trekant der går op og ned for at indikere at teksten er færdig og at man venter på user input
                if (triangleLocation.y < 751) {
                    triangleLocation.z = 1;
                }
                if (triangleLocation.y > 761) {
                    triangleLocation.z = -1;
                }
                triangleLocation.y += triangleLocation.z;
                triangle(triangleLocation.x, triangleLocation.y, triangleLocation.x-10, triangleLocation.y-20, triangleLocation.x+10, triangleLocation.y-20);
                //
            }
        }
        counter+=counterInc;
        if (mousePressed && speechIsFinished) { //sørger for at tekst skriveren bliver genstartet 
            if (speechIsFinished) {
                speechOf++; 
                speechIsFinished = false;
                counter = 0;
                counterInc = 1;
            }
        }
    }
}
class Penge {
    int currentValue;
    Penge(int currentValue_) {
        currentValue = currentValue_;
    }
    public void display() { //tegner det der viser ens penge
        image(coin, width-35, 5);
        fill(0);
        textSize(30);
        textAlign(RIGHT);
        for (int x = -3; x < 4; x++) { //laver en stroke effekt på teksten
            text(currentValue, width+x-35, 30);
            text(currentValue, width-35, 30+x);
        }
        fill(255);
        text(currentValue, width-35, 30);
        textAlign(LEFT);
    }
}
class Player {

    boolean dirUp, dirLeft, dirRight, dirDown; // styre retningen man peger
    boolean moveDirUp, moveDirLeft, moveDirRight, moveDirDown, keyIsPressed; // retningen man bevæger sig
    boolean faceUp, faceLeft, faceRight, faceDown = true; // styre retningen man peger
    boolean moving; // tjekker om man  bevæger sig;
    boolean questActive; // om man er i gang med en quest eller ej
    boolean questCompleted; // om man er færdig med en quest
    boolean closeToNPC; //om man er i nærheden af en NPC
    boolean isTalking; //om man er i gang med at snakke med en
    float playerDia = squareSize*0.60f; // spilleren størrelse
    int movementSpeed = 4; // spillerens hastighed
    int QuestNumber = 0; // den quest man er nået til
    int questComp = 0; // hvor langt man er noget i questen
    int itemsPickedUp=0; // det antal ting man har samlet op
    int reward; // den præmie, man for for at klare en quest
    int[] itemsNeeded; // array over den items man skal bruge for at klare questen
    int[] itemsPicked = new int[9]; // array over de items man har fundet (max 9 grundet inventory størrelse)
    int pickedUp = 0; // det antal items man har fundet
    int givenAway = 0; // det antal items man har givet væk (i quest)
    int current = 0; // sprite animation
    int[] NPCInQuest; // liste over de NPC du skal snakke med i en quest

    Player() {
        for (int i = 0; i < itemsPicked.length; i++) { // tilføjer 100 til itemspicked arrayen, 100 fordi det er højere end det højeste item ID
            itemsPicked[i] = 100;
        }
    }
    public void display() {
        if (current == 4) { // hvis current er det samme som antallet af billeder i spritesheeten
            current = 0;
        }
        //tegner spilleren i den retning man bevæger sig eller står stille i;
        imageMode(CENTER);
        if (moveDirLeft || faceLeft) {
            image(spriteLeft[current], 0, -10);
        }
        if (moveDirRight || faceRight) {
            image(spriteRight[current], 0, -10);
        }
        if (moveDirUp || faceUp) {
            image(spriteUp[current], 0, -10);
        }
        if (moveDirDown || faceDown) {
            image(spriteDown[current], 0, -10);
        }
        if (frameCount % 5 == 0 && moving) {
            current++;
        }
        imageMode(CORNER);
    }
    public void direction(int dir) {
        //styre hvilken vej man vender
        if (dir != 0) {
            faceLeft = false;
        }
        if (dir != 1) {
            faceRight = false;
        }
        if (dir != 2) {
            faceUp = false;
        }
        if (dir != 3) {
            faceDown = false;
        }
    }

    public void move() {
        //tilføjer bevægelse til spilleren(mere præcist til mappet rundt om spilleren)
        if (moveDirLeft && dirLeft) {
            location.x+=movementSpeed;
        } 
        if (moveDirRight && dirRight) {
            location.x-=movementSpeed;
        } 
        if (moveDirUp && dirUp) {
            location.y+=movementSpeed;
        } 
        if (moveDirDown && dirDown) {
            location.y-=movementSpeed;
        }
    }
    public void collision() {
        //Genstarter retnings værdierne
        dirUp = true;
        dirLeft = true;
        dirRight = true;
        dirDown = true;
        float col = 2.01f; // en buffer for collision, så man kan gå længere ind i feltet

        for (int j =0; j<felter.size(); j++) { 

            //UP
            //Tjekker om man er lige under et felt
            if (width/2-location.x > felter.get(j).x*squareSize-playerDia*0.4f && width/2-location.x < felter.get(j).x*squareSize + squareSize + playerDia*0.4f
                && height/2-location.y > felter.get(j).y*squareSize-playerDia*0.4f && height/2-location.y < felter.get(j).y*squareSize + squareSize + playerDia*0.4f+col) {
                itemProx(j); // kører den funktion, der tjekker om man er tæt på en item eller ej
                dirUp = false; //sørger for at man ikke kan bevæge sig i samme retning mere
                npcProx(j); // kører den funktion, der tjekker om man er tæt på en NPC eller ej
            }
            //Down
            //samme som den over
            if (width/2-location.x > felter.get(j).x*squareSize-playerDia*0.4f && width/2-location.x < felter.get(j).x*squareSize + squareSize + playerDia*0.4f
                && height/2-location.y > felter.get(j).y*squareSize-playerDia*0.4f-col && height/2-location.y < felter.get(j).y*squareSize + squareSize + playerDia*0.4f) {
                itemProx(j);
                dirDown = false;
                npcProx(j);
            }
            //Left
            //samme som den over
            if (width/2-location.x > felter.get(j).x*squareSize-playerDia*0.4f && width/2-location.x < felter.get(j).x*squareSize + squareSize + playerDia*0.4f+col
                && height/2-location.y > felter.get(j).y*squareSize-playerDia*0.4f && height/2-location.y < felter.get(j).y*squareSize + squareSize + playerDia*0.4f) {
                itemProx(j);
                dirLeft = false;
                npcProx(j);
            }
            //right
            //samme som den over
            if (width/2-location.x > felter.get(j).x*squareSize-playerDia*0.4f-col && width/2-location.x < felter.get(j).x*squareSize + squareSize + playerDia*0.4f
                && height/2-location.y > felter.get(j).y*squareSize-playerDia*0.4f && height/2-location.y < felter.get(j).y*squareSize + squareSize + playerDia*0.4f) {
                itemProx(j);
                dirRight = false;
                npcProx(j);
            }
            for (NPC n : npc) {
                //koden her tjekker om man ikke længere er i nærheden af en NPC(altså går væk fra den osv.)
                if (felter.get(j).x == n.NPClocation.x && felter.get(j).y == n.NPClocation.y) {
                    if (dirRight && dirLeft && dirDown && dirUp) {//Genstarter alle værdierne
                        n.counter = 0;
                        n.speechOf = 1;
                        n.counterInc = 1;
                        isTalking = false;
                        n.speechIsFinished = false;
                        if (n.NPClocation.x  == shop.shopLocation.x && n.NPClocation.y == shop.shopLocation.y ) {
                            shop.shopSpeeking = false;
                        }
                    }
                }
            }

            if (questCompleted && questActive) { // hvis en quest er klaret, så genstartest quest værdierne

                questActive = false; // sørger for at man ikke længere er i quest
                QuestNumber++; //gør en quest nummer størrer
                for (int i = 0; i < itemsNeeded.length; i++) {
                    itemsNeeded[i] = -1; // en værdi der er lavere end den lavete
                }
                for (int i = 0; i < itemsPicked.length; i++) {
                    itemsPicked[i] = 100;
                }
                penge.currentValue += reward; // giver ens præmie for quest
                reward = 0; 
                questComp = 0;
                questCompleted = false;
            }
            for (Items i : items) {
                if (i.pickedUp) {//  det koden her gør er at hvis man samler en item op, så bliver den fjernet fra mappet, 
                    //så man ikke kan gå ind i den og den ikke kan ses
                    if (felter.get(j) == i.itemsLocation) {

                        if (dirRight && dirLeft && dirDown && dirUp) {
                            i.showText = false;
                            felter.remove(j);
                            break;
                        }
                        if (i.showText == false) {
                            felter.remove(j);
                            break;
                        }
                    }
                }
            }
        }
    }

    public void npcProx(int j) {
        for (NPC n : npc) {
            if (felter.get(j).x == n.NPClocation.x && felter.get(j).y == n.NPClocation.y) { // tjekker om det felt man rammer er det samme som en npc
                if (n.NPClocation.x  == shop.shopLocation.x && n.NPClocation.y == shop.shopLocation.y ) { // tjekker om npcens location og shoppens location er den samme for at finde ud om ma er i nærheden af shoppen
                    //kører shop funktionerne
                    shop.display();
                    shop.itemBuy();
                }

                for (TableRow row : NPCQuestTable.rows()) {
                    if (n.id == row.getInt("NPCid")) {
                        //kører NPCens speech funktionen
                        n.Speech();
                    }
                }
            }
        }
    }

    public void itemProx(int j) {
        if (isTalking == false) { // tjekker om man snakker eller ej, for at kunne give items til quest fra en NPC
            for (Items i : items) {
                if (felter.get(j) == i.itemsLocation) { // tjekker om det felt man rammer er en item eller ej
                    for (TableRow row : itemsTable.rows()) {
                        if (row.getInt("cash") !=0 && i.cashGiven == false && i.id == row.getInt("itemNr")) { // tjekker om det er en pose penge eller ej
                            penge.currentValue+=row.getInt("cash"); // giver spilleren penge
                            i.cashGiven = true; // sørger for at det sker kun 1 gang
                        }
                    }
                    if (i.showText) {
                        if (i.pickedUp == false && i.cashGiven == false) {
                            inventory.itemsNumber++; // tilføjer antallet af items i inventoryen
                        }
                        // kører funktionen, der viser deres tekst (navn på hvad man har fundet)
                        i.textmsg();
                    }
                    if (i.pickedUp && i.cashGiven == false) { // tjekker om man ikke allerede har fundet den, og at det ikke er en penge gave
                        if (i.showItem) { // sørger for at item kommer på den første ledige plads i inventoryen
                            itemsPickedUp = inventory.itemsNumber-givenAway;

                            i.itemsLocation.set( i.itemsLocation.x, i.itemsLocation.y, itemsPickedUp);
                            i.showItem = false;
                        }

                        for (TableRow rows : itemsTable.rows()) { 
                            if (rows.getString("name")==i.name) { 
                                if (QuestNumber == rows.getInt("quest")-1 && rows.getInt("pickedUp") == 0) { // tilføjer items nummer til en itemspicked array
                                    itemsPicked[pickedUp] = (rows.getInt("itemNr"));
                                    pickedUp++;
                                }
                                rows.setInt("pickedUp", 1); // sørger for at koden kører 1 gang
                            }
                        }
                    }
                }
            }
        }
    }
}


public void keyPressed() {
    if (gameBegun) {
        if (player.keyIsPressed==false) {
            if (keyPressed) {
                if (key == 'a' || key == 'A') { //bevægelse
                    player.moveDirLeft = true;
                    player.faceLeft = true;
                    player.moving=true;
                    player.direction(0);
                }
                if (key == 'd'  || key == 'D') {//bevægelse
                    player.moveDirRight=true;
                    player.faceRight = true;
                    player.moving=true;
                    player.direction(1);
                }
                if (key == 'w'  || key == 'W') { //bevægelse
                    player.moveDirUp=true;
                    player.faceUp = true;
                    player.moving=true;
                    player.direction(2);
                } 
                if (key == 's' || key == 'S') {//bevægelse
                    player.moveDirDown=true;
                    player.faceDown = true;
                    player.moving=true;
                    player.direction(3);
                }
                player.keyIsPressed = true;
            }
            if (key == 'i' || key == 'I') { // viser inventoryen eller fjerner den

                if (inventory.showInventory) {
                    inventory.showInventory= false;
                } else {
                    inventory.showInventory= true;
                }
            }
        }
    }
}

public void keyReleased() {
    if (gameBegun) {
        if (key == 'a' || key == 'A') {
            player.moveDirLeft = false;

            player.moving=false;
        }
        if (key == 'd' || key == 'D') {
            player.moveDirRight=false;

            player.moving=false;
        }
        if (key == 'w' || key == 'W') {
            player.moveDirUp=false;

            player.moving=false;
        }
        if (key == 's' || key == 'S') {
            player.moveDirDown=false;

            player.moving=false;
        }
        player.keyIsPressed=false;
    }
}
class Shop {
    PVector shopLocation;
    ArrayList<PVector>shopItemsCoords = new ArrayList<PVector>();
    boolean bought;
    int hintId;
    boolean mouseRel;
    boolean shopSpeeking;


    Shop(int x_, int y_) {
        shopLocation = new PVector(x_, y_);
    }
    public void shopItemsCoords_() { // laver koordinaterne til shoppen
        int h = 1;
        for (int i = 70; i<700; i+=230) {
            for (int j =65; j<350; j+=170) {
                shopItemsCoords.add(new PVector(i, j, h));
                hintId = h;
                h++;
            }
        }
    }
    public void display() { // tegner firkanten i for shoppen
        stroke(0);
        fill(255, 255, 255);
        rect(50, 50, 700, 350);
        shopItems();
    }

    public void shopItems() { //tegner de enkelte felter i shoppen og deres navn og pris
        for (int i = 0; i<shopItemsCoords.size(); i++) {
            noFill();
            rect(shopItemsCoords.get(i).x, shopItemsCoords.get(i).y, 205, 150); // tenger firkanterne
            for (TableRow row : shopTable.rows()) {
                if (shopItemsCoords.get(i).z == row.getInt("nummer")) {
                    textAlign(CENTER);
                    textSize(17);
                    fill(0);
                    text(row.getString("navn"), shopItemsCoords.get(i).x+205/2, shopItemsCoords.get(i).y+130/2);//skriver navnet på itemen
                    textSize(15);
                    if (row.getInt("koebt") ==0) { // hvis den ikke er købt så viser den prisen på det du kan købe
                        if (row.getInt("pris") <= penge.currentValue) { // tjekker om du har råd  til at købe den
                            fill(0, 255, 0); // grøn hvis ja,
                        } else {
                            fill(255, 7, 58); // rød, hvis nej
                        }
                        text(row.getInt("pris"), shopItemsCoords.get(i).x+205/2, shopItemsCoords.get(i).y+170/2); // prisen
                    } else {
                        fill(0);
                        text("KØBT", shopItemsCoords.get(i).x+205/2, shopItemsCoords.get(i).y+170/2); 
                    }
                    textAlign(LEFT);
                }
            }
        }
    }
    public void itemBuy() {
        for (int i = 0; i<shopItemsCoords.size(); i++) {
            //tjekker om du trykker på et felt i shoppen eller ej
            if (shopItemsCoords.get(i).x<mouseX && shopItemsCoords.get(i).x+205>mouseX && shopItemsCoords.get(i).y<mouseY && shopItemsCoords.get(i).y+150>mouseY && mousePressed && mouseRel == false) {
                for (TableRow row : shopTable.rows()) {
                    if (shopItemsCoords.get(i).z == row.getInt("nummer")) { // tjekker om daten fra tabellen er ens med shoppens itemsens id
                        if (penge.currentValue>=row.getInt("pris")&& row.getInt("koebt") ==0) { // tjekker om man har råd til at købe den, og den ikke allerede er blevet købt
                            penge.currentValue-=row.getInt("pris"); // trækker prisen fra ens balance.
                            row.setInt("koebt", 1); 
                            if (row.getInt("hint") == 0) { // hvis det man køber ikke er et hint
                                player.movementSpeed+=row.getInt("speedBoost"); //gør spilleren hurtigere
                            }
                        }

                        if (row.getInt("hint") == 1 && row.getInt("koebt") == 1 && row.getInt("hintShown") == 0) {
                            for (NPC n : npc) {
                                if (n.id == 5) {
                                    shopSpeeking = true;
                                    hintId = row.getInt("nummer");
                                }
                            }
                        }
                    }
                }
                mouseRel = true;
            }
            if (shopSpeeking) {
                for (NPC n : npc) {
                    if (n.id == 5) {
                        for (TableRow row : shopTable.rows()) {
                            if ( hintId == row.getInt("nummer")) {
                                shopSpeeking = true;
                                n.showSpeech(row.getString("hintText")); // sender hint teksten til showSpeech funktionen
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
}
    public void settings() {  size(800, 800); }
    static public void main(String[] passedArgs) {
        String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "DDUEksamenSpil" };
        if (passedArgs != null) {
          PApplet.main(concat(appletArgs, passedArgs));
        } else {
          PApplet.main(appletArgs);
        }
    }
}
