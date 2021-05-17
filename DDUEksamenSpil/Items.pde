class Items {
    PVector itemsLocation;
    String name;
    float itemsDia = squareSize;
    int counter, counterInc = 1, id;
    String speech;
    boolean pickedUp, showText = true, showItem = true;
    boolean inGame;
    boolean givenInQuest;
    boolean givenAway;
    boolean cashGiven;
    boolean textIsFinished;
    Items(int x_, int y_, String name_, int id_, int inQuest_) {
        id = id_;
        itemsLocation = new PVector(x_, y_);
        name = name_;
        felter.add(itemsLocation);
        if (inQuest_ == 1) {
            givenInQuest = true;
        } else if (inQuest_ == 0) {
            givenInQuest = false;
        }
    }
    void display() {
        if (showText && givenInQuest == false) { // tegner npcen, på den plads hvis den ikke gives i en quest og ikke er fundet endnu
            image(chest, itemsLocation.x*squareSize+location.x+5, itemsLocation.y*squareSize+location.y);
        }
    }
    void textmsg() { // skriver teksten der popper op når man har fundet en item
        if (givenInQuest) { // tjekker om enten finder itemen eller modtager den fra en NPC
            speech = "Du har modtaget \"" + name + "\"";
        } else {
            speech = "Du har fundet \"" + name + "\"";
        }
        pickedUp=true;
        //tegner feltet hvor teksten står
        fill(0, 200);
        rect(5, height*0.55, width-10, height*0.45-5);
        noFill();
        stroke(192, 192, 192);
        strokeWeight(5);
        rect(5, height*0.55, width-10, height*0.45-5);
        noStroke();
        //skriver teksten
        if (counter <= speech.length()) {
            fill(255);
            textSize(20);
            text(speech.substring(0, counter), 20, height*0.6, width-30, height);
            //tjekker om teksten er færdig med at blive vist
            if (counter == speech.length()) {
                counterInc=0;
                textIsFinished = true;
                //tegner en trekant der går op og ned for at indikere at teksten er færdig og at man venter på user input
                if (triangleLocation.y < 751) {
                    triangleLocation.z = 1;
                }
                if (triangleLocation.y > 761) {
                    triangleLocation.z = -1;
                }
                triangleLocation.y += triangleLocation.z;
                fill(255);
                triangle(triangleLocation.x, triangleLocation.y, triangleLocation.x-10, triangleLocation.y-20, triangleLocation.x+10, triangleLocation.y-20);
            }
        }

        counter+=counterInc;
        if (mousePressed && textIsFinished) { // sørger for at teksten stopper med at blive vist
            showText = false;
        }
    }

    void removeItem() { // fjerner itemen fra spillet, hvis den bliver givet væk for at klare en quest
        if (givenAway) {
            items.remove(this);
        }
    }
}
