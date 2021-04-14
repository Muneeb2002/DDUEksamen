class Player {

    boolean dirUp, dirLeft, dirRight, dirDown;
    boolean movedirUp, movedirLeft, movedirRight, movedirDown, keyIsPressed;

    float playerDia = squareSize*0.75;
    int movementSpeed = 4;


    Player() {
    }
    void display() {
        noFill();
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
        float col = 2.01;
        for (int j =0; j<felter.size(); j++) { 

            //UP
            if (width/2-location.x > felter.get(j).x*squareSize-playerDia/2 && width/2-location.x < felter.get(j).x*squareSize + squareSize + playerDia/2
                && height/2-location.y > felter.get(j).y*squareSize-playerDia/2 && height/2-location.y < felter.get(j).y*squareSize + squareSize + playerDia/2+col) {
                dirUp = false;
                npcProx(j);
            }
            //Down
            if (width/2-location.x > felter.get(j).x*squareSize-playerDia/2 && width/2-location.x < felter.get(j).x*squareSize + squareSize + playerDia/2
                && height/2-location.y > felter.get(j).y*squareSize-playerDia/2-col && height/2-location.y < felter.get(j).y*squareSize + squareSize + playerDia/2) {
                dirDown = false;
                npcProx(j);
            }
            //Left
            if (width/2-location.x > felter.get(j).x*squareSize-playerDia/2 && width/2-location.x < felter.get(j).x*squareSize + squareSize + playerDia/2+col
                && height/2-location.y > felter.get(j).y*squareSize-playerDia/2 && height/2-location.y < felter.get(j).y*squareSize + squareSize + playerDia/2) {
                dirLeft = false;
                npcProx(j);
            }
            //right
            if (width/2-location.x > felter.get(j).x*squareSize-playerDia/2-col && width/2-location.x < felter.get(j).x*squareSize + squareSize + playerDia/2
                && height/2-location.y > felter.get(j).y*squareSize-playerDia/2 && height/2-location.y < felter.get(j).y*squareSize + squareSize + playerDia/2) {
                dirRight = false;
                npcProx(j);
            }
        }
    }
}

void npcProx(int j) {
    for (int i = 0; i < npc.size(); i++) {
        if (felter.get(j).x == npc.get(i).NPClocation.x && felter.get(j).y == npc.get(i).NPClocation.y) {
            for (TableRow row : NPCQuestTable.rows()) {
                if (npc.get(i).id == row.getInt("NPCid") && npc.get(i).once) {
                    npc.get(i).speech(row.getString("nonQuestString"));
                }
            }
        }else { 
                    npc.get(i).counter = 0;
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
