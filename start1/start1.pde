PImage map;
ArrayList<PVector> coord = new ArrayList<PVector>();
PVector location = new PVector();
void setup() {
  size(800, 800);
  map = loadImage("pic.png");
  coords();
}
void draw() {
  pushMatrix();

  image(map, location.x, location.y);
  translate(width/2, height/2);
    for (int i =0; i<coord.size(); i++) {
    noFill();
    rect(coord.get(i).x, coord.get(i).y, 10, 10);
  }
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
void coords() {
  for (int i = 0; i<800; i+=10) {

    for (int j = 0; j<800; j+=10) {
      coord.add(new PVector(i, j));
    }
  }
}
