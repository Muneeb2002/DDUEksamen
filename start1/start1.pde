PImage map;
ArrayList<PVector> coord = new ArrayList<PVector>();
PVector location = new PVector();
int alpha = 0;
int squareSize = 24; 
ArrayList<PVector> felter = new ArrayList<PVector>(); //<>//
PVector pos;
Table table;
void setup() {
    size(800, 800);
    map = loadImage("pic.png");
    table = loadTable("felter.csv", "header");
    coords();

    for (TableRow row : table.rows()) {
         pos =  new PVector(row.getInt("x"),row.getInt("y")); 
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

        /*if (coord.get(i).x<mouseX-location.x && mouseX-location.x<coord.get(i).x + squareSize && coord.get(i).y<mouseY-location.y && mouseY-location.y-squareSize<coord.get(i).y && mousePressed) {
            alpha = 255;
        }*/
       
        if(coord.get(i).x/squareSize == felter.get(j).x && coord.get(i).y/squareSize == felter.get(j).y){
            alpha=255;
        }
        
        fill(255, 105, 180, alpha);
        rect(coord.get(i).x+location.x, coord.get(i).y+location.y, squareSize, squareSize);
        }
    }


    translate(width/2, height/2);

    circle(0, 0, squareSize);
    move();
    popMatrix();
    //println(location);
}



void move() {
    if (keyPressed) {
        if (key == 'a') {
            location.x+=2;
        }
        if (key == 'd') {
            location.x-=2;
        }
        if (key == 'w') {
            location.y+=2;
        }
        if (key == 's') {
            location.y-=2;
        }
    }
}
void coords() {
    for (int i = 0; i<2040; i+=squareSize) {

        for (int j = 0; j<1560; j+=squareSize) {
            coord.add(new PVector(i, j));
        }
    }
}
