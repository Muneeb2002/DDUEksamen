class Items {
    PVector itemsLocation;
    String name;
    float itemsDia = squareSize;
    int counter, counterInc = 1, id;
    String speech;
    boolean pickedUp, showtext = true, showItem = true;
    boolean inGame;
    boolean givenAway;
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

        fill(255);
        rect(0, height*0.55, width, height*0.45);
        if (counter <= speech.length()) {
            fill(0);
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
