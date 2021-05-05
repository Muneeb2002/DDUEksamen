class NPC {
    PVector NPClocation;
    float NPCDia = squareSize;
    int id;
    int counter = 0;
    int counterInc = 1;
    int speechOf = 1;
    boolean once = true;
    String speech = "";
    boolean speechIsFinished;
    boolean isTalking;
    boolean done;
    NPC(int id_, int locX, int locY) {
        NPClocation = new PVector(locX, locY);
        id = id_;
    }

    void display() {
        fill(57, 255, 20);
        square(NPClocation.x*squareSize+location.x, NPClocation.y*squareSize+location.y, NPCDia);
    }


    void Speech() {
        fill(255);
        rect(0, height*0.55, width, height*0.45);
        for (TableRow row : NPCQuestTable.rows()) {
            //   if (isTalking == false) {
            if (row.getInt("questRelated") == 1 && row.getInt("questNumber")-1 == player.QuestNumber && row.getInt("NPCid") == id) {
                if (row.getInt("number") <= row.getInt("of") && speechOf == row.getInt("number")) {
                    if ( row.getInt("start")-1 == player.questComp &&  row.getInt("start")-1 == 0  ) {
                        player.questActive = true;
                        for (TableRow rows : questTable.rows()) {
                            if (rows.getInt("questNumber")-1 == player.QuestNumber) {
                                player.itemsNeeded = int(splitTokens(rows.getString("items"), ","));
                            }
                        }

                        if (row.getInt("of") == speechOf) {

                            player.questComp = row.getInt("start");
                        }
                        for (TableRow rows : itemsTable.rows()) {
                            if (rows.getInt("quest")-1==player.QuestNumber) {
                                items.add(new Items(rows.getInt("x"), rows.getInt("y"), rows.getString("name"), rows.getInt("itemNr")));
                            }
                        }
                        showSpeech(row.getString("questString"));
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
                            if (row.getInt("of") == speechOf) {
                                done = true;
                                player.reward = row.getInt("reward");
                                for (int i = 0; i < player.itemsNeeded.length; i++) {
                                    for (Items item : items) {
                                        if (subInt[i] == item.id && item.givenAway == false) {
                                            item.givenAway = true;
                                            item.removeItem();
                                            break;
                                            
                                        }
                                    }
                                }
                                for (int i = 0; i< subInt.length; i++) {
                                    subInt[i]=0;
                                }
                            }
                        } else {
                            showSpeech("Det ser ud til at du ikke har fundet alle tingene endnu");
                        }
                    }
                }
            } else if (row.getInt("questRelated") == 0 && row.getInt("NPCid") == id && player.questActive == false) {
                showSpeech(row.getString("nonQuestString"));
            }
        }
        //      }
    }
    void showSpeech(String speech ) {


        if (counter <= speech.length()) {
            fill(0);
            textSize(20);
            text(speech.substring(0, counter), 20, height*0.6, width-20, height);
            //println(speec.substring(0, counter));
            if (counter == speech.length()) {
                counterInc=0;
                speechIsFinished = true;
                //
            }
        }
        counter+=counterInc;

        if (mousePressed && speechIsFinished) {
            //    counter = speech.length()-1;
            if (speechIsFinished) {
                speechOf++; 
                speechIsFinished = false;
                counter = 0;
                counterInc = 1;
                isTalking = false;
                if (done == true) {
                    player.questCompleted = true;
                    done = false;
                }
            }
        }
    }

    //println(counter);
}
