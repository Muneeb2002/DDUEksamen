class NPC {
    PVector NPClocation;
    float NPCDia = squareSize;
    int id;
    int counter = 0;
    int counterInc = 1;
    int speechOf = 1;
    boolean once = true;
    String speech;
    boolean speechIsFinished;
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
            if (row.getInt("questRelated") == 1) {
                if (row.getInt("questNumber") == player.QuestNumber) {
                    if (row.getInt("number") <= row.getInt("of") && speechOf == row.getInt("number") && speechIsFinished == false) {
                        speech = row.getString("questString");
                    }
                }
            }


            counter+=counterInc;
            if (counter <= speech.length()) {
                fill(0);
                textSize(20);
                text(speech.substring(0, counter), 20, height*0.6, width-20, height);
                //println(speec.substring(0, counter));
                if (counter == speech.length()) {
                    counterInc=0;
                    speechIsFinished = true;
                }
            }
            if (mousePressed && speechIsFinished == false) {
                //    counter = speech.length()-1;
            }
        }
        //println(counter);
    }
}
