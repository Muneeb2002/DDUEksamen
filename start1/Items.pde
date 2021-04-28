class Items {
    PVector itemsLocation;
    String name;
    float itemsDia = squareSize;
    int counter, counterInc = 1;
    String speech;
    boolean pickedUp, showtext = true, showItem;
    Items(int x_, int y_, String name_) {
        itemsLocation = new PVector(x_, y_);
        name = name_;
        felter.add(itemsLocation);
    }
    void display() {
        if (showtext) {
            fill(255, 255, 240);
            square(itemsLocation.x*squareSize+location.x, itemsLocation.y*squareSize+location.y, itemsDia);
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
}
