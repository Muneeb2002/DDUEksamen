class Items {
    PVector itemsLocation;
    String name;
    float itemsDia = squareSize;
    int counter, counterInc = 1, id;
    String speech;
    boolean pickedUp, showtext = true, showItem = true;
    boolean inGame;
    boolean givenAway;
    boolean cashGiven;
    Items(int x_, int y_, String name_, int id_) {
        id = id_;
        itemsLocation = new PVector(x_, y_);
        name = name_;
        felter.add(itemsLocation);
    }
    void display() {
        if (showtext) {
            image(chest, itemsLocation.x*squareSize+location.x+5, itemsLocation.y*squareSize+location.y);
        }
    }
    void textmsg() {
        speech = "Du har fundet \"" + name + "\"";
        pickedUp=true;

        fill(0,200);
        rect(5, height*0.55, width-10, height*0.45-5);
        noFill();
        stroke(192,192,192);
        strokeWeight(5);
        rect(5, height*0.55, width-10, height*0.45-5);
        noStroke();
        if (counter <= speech.length()) {
            fill(255);
            textSize(20);
            text(speech.substring(0, counter), 20, height*0.6, width-20, height);
            //println(speec.substring(0, counter));
            if (counter == speech.length()) {
                counterInc=0;
            }
        }

        counter+=counterInc;
    }

    void removeItem() {
        if (givenAway) {
            items.remove(this);
        }
    }
}
