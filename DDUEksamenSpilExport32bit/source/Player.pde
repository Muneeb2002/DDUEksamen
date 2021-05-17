class Player {

    boolean dirUp, dirLeft, dirRight, dirDown; // styre retningen man peger
    boolean moveDirUp, moveDirLeft, moveDirRight, moveDirDown, keyIsPressed; // retningen man bevæger sig
    boolean faceUp, faceLeft, faceRight, faceDown = true; // styre retningen man peger
    boolean moving; // tjekker om man  bevæger sig;
    boolean questActive; // om man er i gang med en quest eller ej
    boolean questCompleted; // om man er færdig med en quest
    boolean closeToNPC; //om man er i nærheden af en NPC
    boolean isTalking; //om man er i gang med at snakke med en
    float playerDia = squareSize*0.60; // spilleren størrelse
    int movementSpeed = 4; // spillerens hastighed
    int QuestNumber = 0; // den quest man er nået til
    int questComp = 0; // hvor langt man er noget i questen
    int itemsPickedUp=0; // det antal ting man har samlet op
    int reward; // den præmie, man for for at klare en quest
    int[] itemsNeeded; // array over den items man skal bruge for at klare questen
    int[] itemsPicked = new int[9]; // array over de items man har fundet (max 9 grundet inventory størrelse)
    int pickedUp = 0; // det antal items man har fundet
    int givenAway = 0; // det antal items man har givet væk (i quest)
    int current = 0; // sprite animation
    int[] NPCInQuest; // liste over de NPC du skal snakke med i en quest

    Player() {
        for (int i = 0; i < itemsPicked.length; i++) { // tilføjer 100 til itemspicked arrayen, 100 fordi det er højere end det højeste item ID
            itemsPicked[i] = 100;
        }
    }
    void display() {
        if (current == 4) { // hvis current er det samme som antallet af billeder i spritesheeten
            current = 0;
        }
        //tegner spilleren i den retning man bevæger sig eller står stille i;
        imageMode(CENTER);
        if (moveDirLeft || faceLeft) {
            image(spriteLeft[current], 0, -10);
        }
        if (moveDirRight || faceRight) {
            image(spriteRight[current], 0, -10);
        }
        if (moveDirUp || faceUp) {
            image(spriteUp[current], 0, -10);
        }
        if (moveDirDown || faceDown) {
            image(spriteDown[current], 0, -10);
        }
        if (frameCount % 5 == 0 && moving) {
            current++;
        }
        imageMode(CORNER);
    }
    void direction(int dir) {
        //styre hvilken vej man vender
        if (dir != 0) {
            faceLeft = false;
        }
        if (dir != 1) {
            faceRight = false;
        }
        if (dir != 2) {
            faceUp = false;
        }
        if (dir != 3) {
            faceDown = false;
        }
    }

    void move() {
        //tilføjer bevægelse til spilleren(mere præcist til mappet rundt om spilleren)
        if (moveDirLeft && dirLeft) {
            location.x+=movementSpeed;
        } 
        if (moveDirRight && dirRight) {
            location.x-=movementSpeed;
        } 
        if (moveDirUp && dirUp) {
            location.y+=movementSpeed;
        } 
        if (moveDirDown && dirDown) {
            location.y-=movementSpeed;
        }
    }
    void collision() {
        //Genstarter retnings værdierne
        dirUp = true;
        dirLeft = true;
        dirRight = true;
        dirDown = true;
        float col = 2.01; // en buffer for collision, så man kan gå længere ind i feltet

        for (int j =0; j<felter.size(); j++) { 

            //UP
            //Tjekker om man er lige under et felt
            if (width/2-location.x > felter.get(j).x*squareSize-playerDia*0.4 && width/2-location.x < felter.get(j).x*squareSize + squareSize + playerDia*0.4
                && height/2-location.y > felter.get(j).y*squareSize-playerDia*0.4 && height/2-location.y < felter.get(j).y*squareSize + squareSize + playerDia*0.4+col) {
                itemProx(j); // kører den funktion, der tjekker om man er tæt på en item eller ej
                dirUp = false; //sørger for at man ikke kan bevæge sig i samme retning mere
                npcProx(j); // kører den funktion, der tjekker om man er tæt på en NPC eller ej
            }
            //Down
            //samme som den over
            if (width/2-location.x > felter.get(j).x*squareSize-playerDia*0.4 && width/2-location.x < felter.get(j).x*squareSize + squareSize + playerDia*0.4
                && height/2-location.y > felter.get(j).y*squareSize-playerDia*0.4-col && height/2-location.y < felter.get(j).y*squareSize + squareSize + playerDia*0.4) {
                itemProx(j);
                dirDown = false;
                npcProx(j);
            }
            //Left
            //samme som den over
            if (width/2-location.x > felter.get(j).x*squareSize-playerDia*0.4 && width/2-location.x < felter.get(j).x*squareSize + squareSize + playerDia*0.4+col
                && height/2-location.y > felter.get(j).y*squareSize-playerDia*0.4 && height/2-location.y < felter.get(j).y*squareSize + squareSize + playerDia*0.4) {
                itemProx(j);
                dirLeft = false;
                npcProx(j);
            }
            //right
            //samme som den over
            if (width/2-location.x > felter.get(j).x*squareSize-playerDia*0.4-col && width/2-location.x < felter.get(j).x*squareSize + squareSize + playerDia*0.4
                && height/2-location.y > felter.get(j).y*squareSize-playerDia*0.4 && height/2-location.y < felter.get(j).y*squareSize + squareSize + playerDia*0.4) {
                itemProx(j);
                dirRight = false;
                npcProx(j);
            }
            for (NPC n : npc) {
                //koden her tjekker om man ikke længere er i nærheden af en NPC(altså går væk fra den osv.)
                if (felter.get(j).x == n.NPClocation.x && felter.get(j).y == n.NPClocation.y) {
                    if (dirRight && dirLeft && dirDown && dirUp) {//Genstarter alle værdierne
                        n.counter = 0;
                        n.speechOf = 1;
                        n.counterInc = 1;
                        isTalking = false;
                        n.speechIsFinished = false;
                        if (n.NPClocation.x  == shop.shopLocation.x && n.NPClocation.y == shop.shopLocation.y ) {
                            shop.shopSpeeking = false;
                        }
                    }
                }
            }

            if (questCompleted && questActive) { // hvis en quest er klaret, så genstartest quest værdierne

                questActive = false; // sørger for at man ikke længere er i quest
                QuestNumber++; //gør en quest nummer størrer
                for (int i = 0; i < itemsNeeded.length; i++) {
                    itemsNeeded[i] = -1; // en værdi der er lavere end den lavete
                }
                for (int i = 0; i < itemsPicked.length; i++) {
                    itemsPicked[i] = 100;
                }
                penge.currentValue += reward; // giver ens præmie for quest
                reward = 0; 
                questComp = 0;
                questCompleted = false;
            }
            for (Items i : items) {
                if (i.pickedUp) {//  det koden her gør er at hvis man samler en item op, så bliver den fjernet fra mappet, 
                    //så man ikke kan gå ind i den og den ikke kan ses
                    if (felter.get(j) == i.itemsLocation) {

                        if (dirRight && dirLeft && dirDown && dirUp) {
                            i.showText = false;
                            felter.remove(j);
                            break;
                        }
                        if (i.showText == false) {
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
            if (felter.get(j).x == n.NPClocation.x && felter.get(j).y == n.NPClocation.y) { // tjekker om det felt man rammer er det samme som en npc
                if (n.NPClocation.x  == shop.shopLocation.x && n.NPClocation.y == shop.shopLocation.y ) { // tjekker om npcens location og shoppens location er den samme for at finde ud om ma er i nærheden af shoppen
                    //kører shop funktionerne
                    shop.display();
                    shop.itemBuy();
                }

                for (TableRow row : NPCQuestTable.rows()) {
                    if (n.id == row.getInt("NPCid")) {
                        //kører NPCens speech funktionen
                        n.Speech();
                    }
                }
            }
        }
    }

    void itemProx(int j) {
        if (isTalking == false) { // tjekker om man snakker eller ej, for at kunne give items til quest fra en NPC
            for (Items i : items) {
                if (felter.get(j) == i.itemsLocation) { // tjekker om det felt man rammer er en item eller ej
                    for (TableRow row : itemsTable.rows()) {
                        if (row.getInt("cash") !=0 && i.cashGiven == false && i.id == row.getInt("itemNr")) { // tjekker om det er en pose penge eller ej
                            penge.currentValue+=row.getInt("cash"); // giver spilleren penge
                            i.cashGiven = true; // sørger for at det sker kun 1 gang
                        }
                    }
                    if (i.showText) {
                        if (i.pickedUp == false && i.cashGiven == false) {
                            inventory.itemsNumber++; // tilføjer antallet af items i inventoryen
                        }
                        // kører funktionen, der viser deres tekst (navn på hvad man har fundet)
                        i.textmsg();
                    }
                    if (i.pickedUp && i.cashGiven == false) { // tjekker om man ikke allerede har fundet den, og at det ikke er en penge gave
                        if (i.showItem) { // sørger for at item kommer på den første ledige plads i inventoryen
                            itemsPickedUp = inventory.itemsNumber-givenAway;

                            i.itemsLocation.set( i.itemsLocation.x, i.itemsLocation.y, itemsPickedUp);
                            i.showItem = false;
                        }

                        for (TableRow rows : itemsTable.rows()) { 
                            if (rows.getString("name")==i.name) { 
                                if (QuestNumber == rows.getInt("quest")-1 && rows.getInt("pickedUp") == 0) { // tilføjer items nummer til en itemspicked array
                                    itemsPicked[pickedUp] = (rows.getInt("itemNr"));
                                    pickedUp++;
                                }
                                rows.setInt("pickedUp", 1); // sørger for at koden kører 1 gang
                            }
                        }
                    }
                }
            }
        }
    }
}


void keyPressed() {
    if (gameBegun) {
        if (player.keyIsPressed==false) {
            if (keyPressed) {
                if (key == 'a' || key == 'A') { //bevægelse
                    player.moveDirLeft = true;
                    player.faceLeft = true;
                    player.moving=true;
                    player.direction(0);
                }
                if (key == 'd'  || key == 'D') {//bevægelse
                    player.moveDirRight=true;
                    player.faceRight = true;
                    player.moving=true;
                    player.direction(1);
                }
                if (key == 'w'  || key == 'W') { //bevægelse
                    player.moveDirUp=true;
                    player.faceUp = true;
                    player.moving=true;
                    player.direction(2);
                } 
                if (key == 's' || key == 'S') {//bevægelse
                    player.moveDirDown=true;
                    player.faceDown = true;
                    player.moving=true;
                    player.direction(3);
                }
                player.keyIsPressed = true;
            }
            if (key == 'i' || key == 'I') { // viser inventoryen eller fjerner den

                if (inventory.showInventory) {
                    inventory.showInventory= false;
                } else {
                    inventory.showInventory= true;
                }
            }
        }
    }
}

void keyReleased() {
    if (gameBegun) {
        if (key == 'a' || key == 'A') {
            player.moveDirLeft = false;

            player.moving=false;
        }
        if (key == 'd' || key == 'D') {
            player.moveDirRight=false;

            player.moving=false;
        }
        if (key == 'w' || key == 'W') {
            player.moveDirUp=false;

            player.moving=false;
        }
        if (key == 's' || key == 'S') {
            player.moveDirDown=false;

            player.moving=false;
        }
        player.keyIsPressed=false;
    }
}
