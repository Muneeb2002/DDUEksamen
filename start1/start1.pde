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

void setup() {
    size(800, 800);
    images();

    coords();
    NPCTables();
    player = new Player();
}
void NPCTables() {
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
void images() {
    map = loadImage("pic.png");
    map.resize(map.width*2, map.height*2);
    squareSize = map.width/105;
    println(squareSize);
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
    /*if (showFelter) {
        showFelter = false;
    } else {
        showFelter = true;
    }*/
}
