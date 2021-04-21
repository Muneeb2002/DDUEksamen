Player player; //<>//
Shop shop;
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
Table questTable;

boolean showFelter;

void setup() {
    size(800, 800);
    images();

    coords();
    npc = new ArrayList<NPC>();

    Tables();
    shop.shopItemsCoords_();
    player = new Player();
}
void Tables() { 
    NPCTable = loadTable("NPCID.csv", "header");
    for (TableRow row : NPCTable.rows()) {
        npc.add(new NPC(row.getInt("id"), row.getInt("x"), row.getInt("y")));
        pos =  new PVector(row.getInt("x"), row.getInt("y")); 
        felter.add(pos);
        if (row.getInt("shop") == 1) {
            shop = new Shop(row.getInt("x"), row.getInt("y"));
        }
    }
    NPCQuestTable = loadTable("NPCSpeech.csv", "header");
    questTable = loadTable("Quests.csv", "header");
}
void images() {
    map = loadImage("pic.png");
    map.resize(map.width*2, map.height*2);
    squareSize = map.width/105;
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
    for (int i = 0; i < npc.size(); i++) {
        npc.get(i).display();
    }
    translate(width/2, height/2);
    player.display();

    popMatrix();
    player.collision();
    player.move();
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
    println("");
}
void mouseReleased() {
    if (shop.mouseRel) {
        shop.mouseRel=false;
    }
}
