class Player {

    boolean dirUp, dirLeft, dirRight, dirDown;
    boolean movedirUp, movedirLeft, movedirRight, movedirDown, keyIsPressed;
    boolean questActive;

    float playerDia = squareSize*0.75;
    int movementSpeed = 4;
    int QuestNumber = 0;
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
                for ( Items i : items) {
                    if (felter.get(j) == i.itemsLocation) {
                    }
                }
                dirUp = false;
                npcProx(j);
            }
            //Down
            if (width/2-location.x > felter.get(j).x*squareSize-playerDia*0.4 && width/2-location.x < felter.get(j).x*squareSize + squareSize + playerDia*0.4
                && height/2-location.y > felter.get(j).y*squareSize-playerDia*0.4-col && height/2-location.y < felter.get(j).y*squareSize + squareSize + playerDia*0.4) {
                for ( Items i : items) {
                    if (felter.get(j) == i.itemsLocation) {
                        i.textmsg();
                    }
                }
                dirDown = false;
                npcProx(j);
            }
            //Left
            if (width/2-location.x > felter.get(j).x*squareSize-playerDia*0.4 && width/2-location.x < felter.get(j).x*squareSize + squareSize + playerDia*0.4+col
                && height/2-location.y > felter.get(j).y*squareSize-playerDia*0.4 && height/2-location.y < felter.get(j).y*squareSize + squareSize + playerDia*0.4) {
                for ( Items i : items) {
                    if (felter.get(j) == i.itemsLocation) {
                        i.textmsg();
                    }
                }
                dirLeft = false;
                npcProx(j);
            }
            //right
            if (width/2-location.x > felter.get(j).x*squareSize-playerDia*0.4-col && width/2-location.x < felter.get(j).x*squareSize + squareSize + playerDia*0.4
                && height/2-location.y > felter.get(j).y*squareSize-playerDia*0.4 && height/2-location.y < felter.get(j).y*squareSize + squareSize + playerDia*0.4) {
                for ( Items i : items) {
                    if (felter.get(j) == i.itemsLocation) {
                        i.textmsg();
                    }
                }
                dirRight = false;
                npcProx(j);
            }
            for (NPC n : npc) {
                if (felter.get(j).x == n.NPClocation.x && felter.get(j).y == n.NPClocation.y) {
                    if (dirRight && dirLeft && dirDown && dirUp) {
                        n.counter = 0;
                        n.speechOf = 1;
                        n.counterInc = 1;
                        n.speechIsFinished = false;
                        n.isTalking = false;
                    }
                }
            }

            
        }
    }

    void npcProx(int j) {
        for (NPC n : npc) {
            if (felter.get(j).x == n.NPClocation.x && felter.get(j).y == n.NPClocation.y) {
                if (n.NPClocation.x  == shop.shopLocation.x && n.NPClocation.y == shop.shopLocation.y ) {
                    shop.display();
                    shop.itemBuy();
                } else {

                    for (TableRow row : NPCQuestTable.rows()) {
                        if (n.id == row.getInt("NPCid")) {
                            n.Speech();
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
   if(key == 'i'){
        
        if (inventory.showInventory){
        inventory.showInventory= false;
        
        }else{
        inventory.showInventory= true;
        }
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
