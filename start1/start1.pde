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

PImage[] sprite = new PImage[16];
PImage[] spriteUp = new PImage[4];
PImage[] spriteLeft = new PImage[4];
PImage[] spriteRight = new PImage[4];
PImage[] spriteDown = new PImage[4];
PImage spritesheet;
int W, H, h=4, w=4;



ArrayList<PVector> coord = new ArrayList<PVector>();
PVector location = new PVector(-500, -500);

float squareSize;

int alpha = 0;

ArrayList<PVector> felter = new ArrayList<PVector>();
PVector pos;
Table obstacleTable;
Table NPCTable;
Table NPCQuestTable;
Table questTable;
Table shopTable;
Table itemsTable;
Table questItemTable;

boolean showFelter;

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
    map.resize(map.width*2, map.height*2);
    coin.resize(30, 30);
    squareSize = map.width/105;

    for (int j = 1; j < pic.length; j++) {
        pic[j] = loadImage("/sprites/pic"+j+".png");
        pic[j].resize(2*int(squareSize), 2*int(squareSize));
    }
    for (int j = 1; j < npcDesign.length; j++) {
        npcDesign[j] = loadImage("/sprites/NPC"+j+".png");
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

void mousePressed() {

    for (int i =0; i<coord.size(); i++) {
        if (coord.get(i).x<mouseX-location.x && mouseX-location.x<coord.get(i).x + squareSize && coord.get(i).y<mouseY-location.y && mouseY-location.y-squareSize<coord.get(i).y && mousePressed) {
            // println(coord.get(i).x/48 + ", " + coord.get(i).y/48);
        }
    }
}
void mouseReleased() {

    if (shop.mouseRel) {
        shop.mouseRel=false;
    }
}
