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

    penge = new Penge (0);
    font = createFont("font.ttf", 60);
}
void Tables() { //I denne funktion bliver alle alle CSV filerne loadet
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
void images() { //I denne funktion bliver alle billederne indlæst og deres størrelse bliver
    map = loadImage("/sprites/pic.png");
    coin = loadImage("/sprites/coins.png");
    textBubble = loadImage("/sprites/textBubble.png");
    textBubble.resize(width-10, int(height*0.45)-5);
    map.resize(map.width*2, map.height*2);
    coin.resize(30, 30);
    squareSize = map.width/105;

    for (int j = 1; j < pic.length; j++) { //Tilføjer billederne der bruges til itemsne i et Image array
        pic[j] = loadImage("/sprites/pic"+j+".png");
        pic[j].resize(2*int(squareSize), 2*int(squareSize));
    }
    for (int j = 0; j < npcDesign.length; j++) { // tilføjer de forskellige NPC design i et image Array
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
            //Koden her deler spirtesheetet op i 4 mindre dele der hver så bliver delt op i hver sit billede array  
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
            TransitionScreen();
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
void HowToPlay() {
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
void StoryScreen() {
    background(0);
    image(textBubble, 5, height*0.55);

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
        text(storySpeech.substring(0, storyCounter), 50, height*0.6, width-100, height);

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
void TransitionScreen() {
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
    for (int i = 0; i < transitionScreenCoord.size()+1; i = int(random(0, transitionScreenCoord.size()))) {
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
void mouseReleased() {
    if (storyScreen) {
        if (storyCounter > 10) {
            storyCounter = storySpeech.length();
        }
    }
    if (shop.mouseRel) {
        shop.mouseRel=false;
    }
}
