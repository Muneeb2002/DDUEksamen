
Player player;
Shop shop;
Penge penge;
Inventory inventory;
ArrayList<NPC> npc;
ArrayList <Items> items;

PImage map;
PImage coin;
PImage[] pic = new PImage[13];
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
int W, H, h=4, w=4;

PVector startScreen = new PVector(-500, -500);
PVector startScreenMovement = new PVector(-2, 0);


ArrayList<PVector> coord = new ArrayList<PVector>();
PVector location = new PVector(-500, -500);

float squareSize;


ArrayList<PVector> felter = new ArrayList<PVector>();
PVector pos;
Table obstacleTable;
Table NPCTable;
Table NPCQuestTable;
Table questTable;
Table shopTable;
Table itemsTable;
Table questItemTable;

boolean showStartScreen = true;

void setup() {
    size(800, 800);
    images();

    coords();
    npc = new ArrayList<NPC>();
    items = new ArrayList<Items>();
    inventory = new Inventory();
    Tables();
    shop.shopItemsCoords_();
    inventory.inventoryItemsCoords_();
    player = new Player();
    for (int i = 0; i < player.itemsPicked.length; i++) {
        player.itemsPicked[i] = 100;
    }
    penge = new Penge (420420);
     font = loadFont("UGLYBYTEFONT.vlw");
}
void Tables() { 
    NPCTable = loadTable("NPCID.csv", "header");
    for (TableRow row : NPCTable.rows()) {
        npc.add(new NPC(row.getInt("id"), row.getInt("x"), row.getInt("y"), row.getInt("picture")));
        pos =  new PVector(row.getInt("x"), row.getInt("y")); 
        felter.add(pos);
        if (row.getInt("shop") == 1) {
            shop = new Shop(row.getInt("x"), row.getInt("y"));
        }
    }
    NPCQuestTable = loadTable("NPCSpeech.csv", "header");
    questTable = loadTable("Quests.csv", "header");
    shopTable = loadTable("shop.csv", "header");
    itemsTable = loadTable("items.csv", "header");
    for (TableRow row : itemsTable.rows()) {
        if (row.getInt("quest")==0) {
            items.add(new Items(row.getInt("x"), row.getInt("y"), row.getString("name"), row.getInt("itemNr")));
        }
    }
}
void images() {
    map = loadImage("/sprites/pic.png");
    coin = loadImage("/sprites/coins.png");
    textBubble = loadImage("/sprites/textBubble.png");
    textBubble.resize(width-10, int(height*0.45)-5);
    map.resize(map.width*2, map.height*2);
    coin.resize(30, 30);
    squareSize = map.width/105;

    for (int j = 1; j < pic.length; j++) {
        pic[j] = loadImage("/sprites/pic"+j+".png");
        pic[j].resize(2*int(squareSize), 2*int(squareSize));
    }
    for (int j = 0; j < npcDesign.length; j++) {
        npcDesign[j] = loadImage("/sprites/NPC"+(j+1)+".png");
        npcDesign[j].resize(int(squareSize*1.2), int(squareSize*1.2));
    }
    chest = loadImage("/sprites/chest.png");
    chest.resize(int(squareSize), int(squareSize));
    int number = 1;
    spritesheet = loadImage("/sprites/spritesheet.png");
    W = spritesheet.width/w;
    H = spritesheet.height/h;
    for (int i = 0; i < h; i++) {
        for (int j = 0; j < w; j++) {
            sprite[number-1] = spritesheet.get(j*H, i*W, H, W);
            sprite[number-1].resize(int(squareSize*1.2), int(squareSize*1.2));
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
void draw() {
    startScreen();
    if (showStartScreen == false) {
        pushMatrix();
        image(map, location.x, location.y);
        for (NPC n : npc) {
            n.display();
        }
        for (Items i : items) {
            i.display();
        }
        translate(width/2, height/2);
        player.display();

        popMatrix();

        penge.display();
        player.collision();
        player.move();
        if (inventory.showInventory) {
            inventory.display();
        }
    }
}

void coords() {
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

void startScreen() {
    image(map, startScreen.x, startScreen.y);
    startScreen.add(startScreenMovement);
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

    textAlign(CENTER);
    fill(255,150);
    rect(width/4, height/3, 2*(width/4), 50);
    rect(width/4, 60+(height/3), 2*(width/4), 50);
    rect(width/4, 120+(height/3), 2*(width/4), 50);
    fill(0, 0, 255);
    textFont(font);
    text("PLAY", width/2, 30+(height/3));
    text("How To Play", width/2, 90+(height/3));
    text("Quit", width/2, 150+(height/3));
}

void mousePressed() {
    if (mouseX>width/4 && mouseY >height/3 && mouseX<3*(width/4) && mouseY <50+(height/3)) {
        showStartScreen = false;
    }

    if (mouseX>width/4 && mouseY >60+height/3 && mouseX<3*(width/4) && mouseY <60+50+(height/3)) {
        fill(255);
        rect(20, 20, 20, 20);
    }

    if (mouseX>width/4 && mouseY >120+height/3 && mouseX<3*(width/4) && mouseY <120+50+(height/3)) {
        exit();
    }
    for (int i =0; i<coord.size(); i++) {
        if (coord.get(i).x<mouseX-location.x && mouseX-location.x<coord.get(i).x + squareSize && coord.get(i).y<mouseY-location.y && mouseY-location.y-squareSize<coord.get(i).y && mousePressed) {
            //println(coord.get(i).x/48 + ", " + coord.get(i).y/48);
        }
    }
}
void mouseReleased() {

    if (shop.mouseRel) {
        shop.mouseRel=false;
    }
}
