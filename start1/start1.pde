PImage map; //<>//
ArrayList<PVector> coord = new ArrayList<PVector>();
PVector location = new PVector();
int alpha = 0;
int squareSize = 24; 
boolean dirUp = true, dirLeft = true, dirRight = true, dirDown = true;
int playerDia = 24;

ArrayList<PVector> felter = new ArrayList<PVector>();
PVector pos;
Table table;
int movementSpeed = 4;
void setup() {
    size(800, 800);
    map = loadImage("pic.png");
    table = loadTable("felter.csv", "header");
    coords();

    for (TableRow row : table.rows()) {
        pos =  new PVector(row.getInt("x"), row.getInt("y")); 
        felter.add(pos);
    }
    println(felter);
}
void draw() {


    pushMatrix();
    image(map, location.x, location.y);

    for (int i =0; i<coord.size(); i++) {

        for (int j =0; j<felter.size(); j++) {
            alpha = 0;

            if (coord.get(i).x/squareSize == felter.get(j).x && coord.get(i).y/squareSize == felter.get(j).y) {
                alpha=255;
            }

            fill(255, 105, 180, alpha);
            rect(coord.get(i).x+location.x, coord.get(i).y+location.y, squareSize, squareSize);
        }
    }


    translate(width/2, height/2);

    circle(0, 0, playerDia);

    popMatrix();
    collision();
    move();
    //println(location);
}



void move() {
    if (keyPressed) {
        if (key == 'a' && dirLeft) {
            location.x+=movementSpeed;
        }
        if (key == 'd' && dirRight) {
            location.x-=movementSpeed;
        }
        if (key == 'w' && dirUp) {
            location.y+=movementSpeed;
        }
        if (key == 's' && dirDown) {
            location.y-=movementSpeed;
        }
    }
}
void collision() {
    for (int j =0; j<felter.size(); j++) { 
        //UP
            if(width/2-location.x > ){
                
            }
       /*if (width/2-location.x > felter.get(j).x*24-playerDia/2 && width/2-location.x < felter.get(j).x*24 + squareSize + playerDia/2 
            && height/2-location.y > felter.get(j).y*24-playerDia/2 && height/2-location.y < felter.get(j).y*24 + squareSize + playerDia/2) {
            println("dd");
            
        }*/
    }
}

void coords() {
    for (int i = 0; i<map.width; i+=squareSize) {

        for (int j = 0; j<map.height; j+=squareSize) {
            coord.add(new PVector(i, j));
        }
    }
}

void mousePressed(){
 println("");   
}
