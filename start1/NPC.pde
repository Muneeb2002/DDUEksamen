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
            if (isTalking == false) {
                if (row.getInt("questRelated") == 1 && row.getInt("questNumber") == player.QuestNumber && speechIsFinished == false) {
                    println(true);
                    if (row.getInt("NPCid") == id) {
                        //println(speechOf+", "+row.getInt("number"));
                        if (row.getInt("number") <= row.getInt("of") && speechOf == row.getInt("number")) {
                            if ( row.getInt("start")-1 == player.questComp &&  row.getInt("start")-1 == 0 && player.questActive == false) {
                                player.questActive = true;
                                player.questComp = row.getInt("start");
                                speech = row.getString("questString");
                                //println("Quest Begun");
                            } 
                            if ( (row.getInt("start")-1 == player.questComp || row.getInt("start") < player.questComp ) && player.questActive) {
                                if (row.getInt("start")-1 == player.questComp) {
                                    speech = row.getString("questString");
                                }
                                player.questComp = row.getInt("start");
                            }

                            if (player.questComp == row.getInt("outOf") && player.questActive) {
                                speech = row.getString("questString");
                                player.questActive = false;
                                player.QuestNumber++;
                                // println("Quest Ended");
                                player.questComp = 0;
                            }
                        }

                        isTalking = true;
                    }
                } else if (row.getInt("questRelated") == 0 && row.getInt("NPCid") == id && speechIsFinished == false) {

                    speech = row.getString("nonQuestString");
                    isTalking = true;
                }
            }
        }


        if (counter <= speech.length()) {
            fill(0);
            textSize(20);
            text(speech.substring(0, counter), 20, height*0.6, width-20, height);
            //println(speec.substring(0, counter));
            if (counter == speech.length()) {
                counterInc=0;
                speechIsFinished = true;
                isTalking = false;
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
            }
        }
    }
    //println(counter);
}
