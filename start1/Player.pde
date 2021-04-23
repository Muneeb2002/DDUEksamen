class Player {

    boolean dirUp, dirLeft, dirRight, dirDown;
    boolean movedirUp, movedirLeft, movedirRight, movedirDown, keyIsPressed;
    boolean questActive;

    float playerDia = squareSize*0.75;
    int movementSpeed = 4;
    int QuestNumber = 1;
    int questComp = 0;

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
            if (width/2-location.x > felter.get(j).x*squareSize-playerDia*0.4 && width/2-location.x < felter.get(j).x*squareSize + squareSize + playerDia*0.4
                && height/2-location.y > felter.get(j).y*squareSize-playerDia*0.4 && height/2-location.y < felter.get(j).y*squareSize + squareSize + playerDia*0.4+col) {
                dirUp = false;
                npcProx(j);
            }
            //Down
            if (width/2-location.x > felter.get(j).x*squareSize-playerDia*0.4 && width/2-location.x < felter.get(j).x*squareSize + squareSize + playerDia*0.4
                && height/2-location.y > felter.get(j).y*squareSize-playerDia*0.4-col && height/2-location.y < felter.get(j).y*squareSize + squareSize + playerDia*0.4) {
                dirDown = false;
                npcProx(j);
            }
            //Left
            if (width/2-location.x > felter.get(j).x*squareSize-playerDia*0.4 && width/2-location.x < felter.get(j).x*squareSize + squareSize + playerDia*0.4+col
                && height/2-location.y > felter.get(j).y*squareSize-playerDia*0.4 && height/2-location.y < felter.get(j).y*squareSize + squareSize + playerDia*0.4) {
                dirLeft = false;
                npcProx(j);
            }
            //right
            if (width/2-location.x > felter.get(j).x*squareSize-playerDia*0.4-col && width/2-location.x < felter.get(j).x*squareSize + squareSize + playerDia*0.4
                && height/2-location.y > felter.get(j).y*squareSize-playerDia*0.4 && height/2-location.y < felter.get(j).y*squareSize + squareSize + playerDia*0.4) {
                dirRight = false;
                npcProx(j);
            }
            for (int i = 0; i < npc.size(); i++) {
                if (felter.get(j).x == npc.get(i).NPClocation.x && felter.get(j).y == npc.get(i).NPClocation.y) {
                    if (dirRight && dirLeft && dirDown && dirUp) {
                        npc.get(i).counter = 0;
                        npc.get(i).speechOf = 1;
                        npc.get(i).counterInc = 1;
                        npc.get(i).speechIsFinished = false;
                        npc.get(i).isTalking = false;
                    }
                }
            }
        }
    }

    void npcProx(int j) {
        for (int i = 0; i < npc.size(); i++) {
            if (felter.get(j).x == npc.get(i).NPClocation.x && felter.get(j).y == npc.get(i).NPClocation.y) {
                if (npc.get(i).NPClocation.x  == shop.shopLocation.x && npc.get(i).NPClocation.y == shop.shopLocation.y ) {
                    shop.display();
                    shop.itemBuy();
                } else {

                    for (TableRow row : NPCQuestTable.rows()) {
                        if (npc.get(i).id == row.getInt("NPCid")) {
                            npc.get(i).Speech();
                        }
                    }
                }
            }
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
