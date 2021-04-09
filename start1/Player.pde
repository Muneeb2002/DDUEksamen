class Player {

  boolean dirUp, dirLeft, dirRight, dirDown;
  boolean movedirUp, movedirLeft, movedirRight, movedirDown, keyIsPressed;

  int playerDia = 24;  

  Player() {
  }
  void display() {
    circle(0, 0, playerDia);
  }

  void move() {
    if (movedirLeft && player.dirLeft) {
      location.x+=movementSpeed;
    }
    if (movedirRight && player.dirRight) {
      location.x-=movementSpeed;
    }
    if (movedirUp && player.dirUp) {
      location.y+=movementSpeed;
    }
    if (movedirDown && player.dirDown) {
      location.y-=movementSpeed;
    }
  }
  void collision() {
    dirUp = true;
    dirLeft = true;
    dirRight = true;
    dirDown = true;
    for (int j =0; j<felter.size(); j++) { 

      //UP
      if (width/2-location.x > felter.get(j).x*24-playerDia/2 && width/2-location.x < felter.get(j).x*24 + squareSize + playerDia/2
        && height/2-location.y > felter.get(j).y*24-playerDia/2 && height/2-location.y < felter.get(j).y*24 + squareSize + playerDia/2+1) {
        dirUp = false;
      }
      //Down
      if (width/2-location.x > felter.get(j).x*24-playerDia/2 && width/2-location.x < felter.get(j).x*24 + squareSize + playerDia/2
        && height/2-location.y > felter.get(j).y*24-playerDia/2-1 && height/2-location.y < felter.get(j).y*24 + squareSize + playerDia/2) {
        dirDown = false;
      }
      //Left
      if (width/2-location.x > felter.get(j).x*24-playerDia/2 && width/2-location.x < felter.get(j).x*24 + squareSize + playerDia/2+1
        && height/2-location.y > felter.get(j).y*24-playerDia/2 && height/2-location.y < felter.get(j).y*24 + squareSize + playerDia/2) {
        dirLeft = false;
      }
      if (width/2-location.x > felter.get(j).x*24-playerDia/2-1 && width/2-location.x < felter.get(j).x*24 + squareSize + playerDia/2
        && height/2-location.y > felter.get(j).y*24-playerDia/2 && height/2-location.y < felter.get(j).y*24 + squareSize + playerDia/2) {
        dirRight = false;
      }
      /*if (width/2-location.x > felter.get(j).x*24-playerDia/2 && width/2-location.x < felter.get(j).x*24 + squareSize + playerDia/2 
       && height/2-location.y > felter.get(j).y*24-playerDia/2 && height/2-location.y < felter.get(j).y*24 + squareSize + playerDia/2) {
       println("dd");
       
       }*/
    }
  }
}

void keyPressed() {
  if (player.keyIsPressed==false) {
    if (keyPressed) {
      if (key == 'a') {
        player.movedirLeft = true;
      }
      if (key == 'd') {
        player.movedirRight=true;
      }
      if (key == 'w' ) {
        player.movedirUp=true;
      }
      if (key == 's') {
        player.movedirDown=true;
      }
      player.keyIsPressed = true;
    }
  }
}

void keyReleased() {
  if (key == 'a') {
    player.movedirLeft = false;
  }
  if (key == 'd') {
    player.movedirRight=false;
  }
  if (key == 'w') {
    player.movedirUp=false;
  }
  if (key == 's') {
    player.movedirDown=false;
  }
  player.keyIsPressed=false;
}
