class NPC {
    PVector NPClocation;
    ArrayList<ArrayList> speech = new ArrayList<ArrayList>();
    float NPCDia = squareSize;
    int id;
    int counter = 0;
    int counterInc = 1;
    boolean once = true;
    NPC(int id_, int locX, int locY) {
        NPClocation = new PVector(locX, locY);
        id = id_;
    }

    void display() {
        fill(57, 255, 20);
        square(NPClocation.x*squareSize+location.x, NPClocation.y*squareSize+location.y, NPCDia);
    }


    void speech(String speec) {
        fill(255);
        rect(0, height*0.55, width, height*0.45);
        counter+=counterInc;
        if (counter <= speec.length()) {
            fill(0);
            textSize(20);
            text(speec.substring(0, counter), 20, height*0.6, width-20, height);
            //println(speec.substring(0, counter));
            if (counter == speec.length()) {
                counterInc=0;
            }
        }
        if (mousePressed) {
            counter = speec.length()-1;
        }
    }
}
