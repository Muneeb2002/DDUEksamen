PImage map;
PVector location = new PVector();
void setup() {
    size(800, 800);
    map = loadImage("pic.jpg");
}
void draw() {
    pushMatrix();
    image(map, location.x, location.y);
    translate(width/2, height/2);
    circle(0, 0, 30);
    move();
    popMatrix();
    println(location);
}

void move() {
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
