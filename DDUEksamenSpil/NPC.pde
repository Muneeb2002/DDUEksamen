class NPC {
    PVector NPClocation;
    float NPCDia = squareSize;
    int id;
    int counter = 0;
    int counterInc = 1;
    int speechOf = 1;
    int pic;
    boolean once = true;
    String speech = "";
    boolean speechIsFinished;

    boolean done;
    NPC(int id_, int locX, int locY, int picture) {
        NPClocation = new PVector(locX, locY); // tilføjer npcens locX/Y til NPClocation PVectoren
        id = id_;
        pic = picture;
    }

    void display() { // tegner npcen  på dens position og med det valgte design til npcen
        image(npcDesign[pic], NPClocation.x*squareSize+location.x-5, NPClocation.y*squareSize+location.y-10);
    }


    void Speech() { // Det koden her gør at den tager data fra NPC tabellen, og vælger hvilken tekst der skal siges af NPCen
        //Vi har valgt at kunden ikke har behov for at vide hvordan lige præcis denne her del af koden fungere fordi at
        //kunden ikke har behov at vide hvordan system fungere og vidre udvikle på det her "Perfekte" system. 
        if (shop.shopSpeeking == false) {
            for (TableRow row : NPCQuestTable.rows()) {
                if (row.getInt("questRelated") == 1 && row.getInt("questNumber")-1 == player.QuestNumber && row.getInt("NPCid") == id) {
                    if (row.getInt("number") <= row.getInt("of") && speechOf == row.getInt("number")) {

                        if ( row.getInt("start")-1 == player.questComp &&  row.getInt("start")-1 == 0  ) {
                            player.questActive = true;
                            for (TableRow rows : questTable.rows()) {
                                if (rows.getInt("questNumber")-1 == player.QuestNumber) {
                                    player.itemsNeeded = int(splitTokens(rows.getString("items"), ","));
                                    player.NPCInQuest = int(splitTokens(rows.getString("NPCsInQuest"), ","));
                                }
                            }
                            showSpeech(row.getString("questString"));
                            if (row.getInt("of") == speechOf) {
                                player.questComp = row.getInt("start");
                            }
                        }
                        if (row.getInt("start")-1 <= player.questComp && player.questActive && player.questComp != row.getInt("outOf")) {
                            if (row.getInt("start")-1 == player.questComp) {
                                player.questComp = row.getInt("start");
                            }
                            showSpeech(row.getString("questString"));
                        }
                        if (player.questComp == row.getInt("outOf") && player.questActive) {
                            player.itemsPicked = sort(player.itemsPicked);
                            int[] subInt = new int[player.itemsNeeded.length];
                            boolean ens = true;
                            for (int i = 0; i < player.itemsNeeded.length; i++) {
                                subInt[i]=player.itemsPicked[i];
                            }
                            for (int i = 0; i < player.itemsNeeded.length; i++) {
                                if (player.itemsNeeded[i]!=subInt[i]) { 
                                    ens = false; 
                                    break;
                                }
                            }
                            if (ens) {
                                showSpeech(row.getString("questString"));


                                if (row.getInt("of")+1 == speechOf) {
                                    done = true;
                                    player.reward = row.getInt("reward");
                                    player.questCompleted = true;
                                    for (int i = 0; i < player.itemsNeeded.length; i++) {
                                        for (Items item : items) {
                                            if (subInt[i] == item.id && item.givenAway == false) {
                                                item.givenAway = true;
                                                player.givenAway++;
                                                item.removeItem();
                                                break;
                                            }
                                        }
                                    }
                                    for (int i = 0; i< subInt.length; i++) {
                                        subInt[i]=100;
                                    }
                                    for (int i = 0; i< player.NPCInQuest.length; i++) {
                                        player.NPCInQuest[i]=0;
                                    }
                                }
                            } else {
                                showSpeech("Det ser ud til at du ikke har fundet alle tingene endnu");
                            }
                        }
                    }
                    if (row.getInt("of")+1==speechOf) {
                        player.isTalking = false;
                    }
                    for (TableRow rows : itemsTable.rows()) {

                        if (rows.getInt("quest")-1==player.QuestNumber) {

                            if (rows.getInt("display") == player.questComp) {
                                if (rows.getInt("itemDisplayed") == 0) {
                                    items.add(new Items(rows.getInt("x"), rows.getInt("y"), rows.getString("name"), rows.getInt("itemNr"), rows.getInt("inQuest")));
                                    rows.setInt("itemDisplayed", 1);
                                }
                            }
                        }
                    }
                } else if (row.getInt("questRelated") == 0 && row.getInt("NPCid") == id) {
                    if (player.questActive) {
                        boolean notIt = true;
                        for (int i = 0; i <  player.NPCInQuest.length; i++) {
                            if (player.NPCInQuest[i] == id) {
                                notIt = false;
                                break;
                            }
                        }
                        if (notIt) {
                            showSpeech(row.getString("nonQuestString"));
                        }
                    } else if (player.questActive == false) {
                        showSpeech(row.getString("nonQuestString"));
                    }
                }
            }
        }
    }
    void showSpeech(String speech ) { // skriver den tekst som NPCen siger 
        image(textBubble, 5, height*0.55);
        player.isTalking = true;
        if (counter <= speech.length()) { //tjekker om antallet af tegn vist er mindre end eller lig med antallet af tegn i storySpeech stringen 
            fill(0);
            textSize(20);
            text(speech.substring(0, counter), 50, height*0.6, width-100, height);

            if (counter == speech.length()) { // tjekker om antallet af tegn vist er lig med antallet af tegn i storySpeech stringen 
                counterInc=0;
                speechIsFinished = true;
                //tegner en trekant der går op og ned for at indikere at teksten er færdig og at man venter på user input
                if (triangleLocation.y < 751) {
                    triangleLocation.z = 1;
                }
                if (triangleLocation.y > 761) {
                    triangleLocation.z = -1;
                }
                triangleLocation.y += triangleLocation.z;
                triangle(triangleLocation.x, triangleLocation.y, triangleLocation.x-10, triangleLocation.y-20, triangleLocation.x+10, triangleLocation.y-20);
                //
            }
        }
        counter+=counterInc;
        if (mousePressed && speechIsFinished) { //sørger for at tekst skriveren bliver genstartet 
            if (speechIsFinished) {
                speechOf++; 
                speechIsFinished = false;
                counter = 0;
                counterInc = 1;
            }
        }
    }
}
