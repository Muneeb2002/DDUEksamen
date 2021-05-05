class Player {

    boolean dirUp, dirLeft, dirRight, dirDown;
    boolean movedirUp, movedirLeft, movedirRight, movedirDown, keyIsPressed;
    boolean questActive;
    boolean questCompleted;
    boolean questCompleted2;

    float playerDia = squareSize*0.75;
    int movementSpeed = 4;
    int QuestNumber = 0;
    int questComp = 0;
    int itemsPickedUp=0;
    int reward;
    int[] itemsNeeded;
    int[] itemsPicked = new int[5];
    int pickedup = 0;
    int givenAway = 0;
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
                itemProx(j);
                dirUp = false;
                npcProx(j);
            }


            //Down
            if (width/2-location.x > felter.get(j).x*squareSize-playerDia*0.4 && width/2-location.x < felter.get(j).x*squareSize + squareSize + playerDia*0.4
                && height/2-location.y > felter.get(j).y*squareSize-playerDia*0.4-col && height/2-location.y < felter.get(j).y*squareSize + squareSize + playerDia*0.4) {
                itemProx(j);
                dirDown = false;
                npcProx(j);
            }
            //Left
            if (width/2-location.x > felter.get(j).x*squareSize-playerDia*0.4 && width/2-location.x < felter.get(j).x*squareSize + squareSize + playerDia*0.4+col
                && height/2-location.y > felter.get(j).y*squareSize-playerDia*0.4 && height/2-location.y < felter.get(j).y*squareSize + squareSize + playerDia*0.4) {
                itemProx(j);
                dirLeft = false;
                npcProx(j);
            }
            //right
            if (width/2-location.x > felter.get(j).x*squareSize-playerDia*0.4-col && width/2-location.x < felter.get(j).x*squareSize + squareSize + playerDia*0.4
                && height/2-location.y > felter.get(j).y*squareSize-playerDia*0.4 && height/2-location.y < felter.get(j).y*squareSize + squareSize + playerDia*0.4) {
                itemProx(j);
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
                        if (questCompleted) {
                            questCompleted = false;
                            questCompleted2 = true;
                        }
                    }
                }
            }
            if (questCompleted2) {
                questActive = false;
                QuestNumber++;
                for (int i = 0; i < itemsNeeded.length; i++) {
                    itemsNeeded[i] = -1;
                }
                for (int i = 0; i < itemsPicked.length; i++) {
                    itemsPicked[i] = 100;
                }
                penge.currentValue += reward;
                reward = 0;
                questComp = 0;
                questCompleted2 = false;
            }
            for (Items i : items) {
                if (i.pickedUp) {
                    if (felter.get(j) == i.itemsLocation) {

                        if (dirRight && dirLeft && dirDown && dirUp) {
                            i.showtext = false;
                            felter.remove(j);
                            break;
                        }
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

    void itemProx(int j) {
        for (Items i : items) {
            if (felter.get(j) == i.itemsLocation) {
                for (TableRow row : itemsTable.rows()) {
                    if (row.getInt("cash") !=0 && i.cashGiven == false && i.id == row.getInt("itemNr")) {
                        penge.currentValue+=row.getInt("cash");
                        i.cashGiven = true;
                    }
                }
                if (i.showtext) {
                    if (i.pickedUp == false && i.cashGiven == false) {
                        inventory.itemsNumber++;
                    }
                    i.textmsg();
                }
                if (i.pickedUp && i.cashGiven == false) {
                    if (i.showItem) {
                        itemsPickedUp = inventory.itemsNumber-givenAway;

                        i.itemsLocation.set( i.itemsLocation.x, i.itemsLocation.y, itemsPickedUp);
                        i.showItem = false;
                    }

                    for (TableRow rows : itemsTable.rows()) {
                        //for (TableRow rows : questTable.rows()) {
                        if (rows.getString("name")==i.name) {


                            if (QuestNumber == rows.getInt("quest")-1 && rows.getInt("pickedUp") == 0) {

                                itemsPicked[pickedup] = (rows.getInt("itemNr"));
                                pickedup++;
                            }
                            rows.setInt("pickedUp", 1);
                        }
                        //}
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
        if (key == 'i') {

            if (inventory.showInventory) {
                inventory.showInventory= false;
            } else {
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
