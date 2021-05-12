class Shop {
    PVector shopLocation;
    ArrayList<PVector>shopItemsCoords = new ArrayList<PVector>();
    boolean bought;
    int hintId;
    boolean mouseRel;
    boolean shopSpeeking;


    Shop(int x_, int y_) {
        shopLocation = new PVector(x_, y_);
    }
    void shopItemsCoords_() {
        int h = 1;
        for (int i = 70; i<700; i+=230) {
            for (int j =65; j<350; j+=170) {
                shopItemsCoords.add(new PVector(i, j, h));
                hintId = h;
                h++;
            }
        }
    }
    void display() {
        stroke(0);
        fill(255, 255, 255);
        rect(50, 50, 700, 350);
        shopItems();
    }

    void shopItems() {
        for (int i = 0; i<shopItemsCoords.size(); i++) {
            noFill();
            rect(shopItemsCoords.get(i).x, shopItemsCoords.get(i).y, 205, 150);
            for (TableRow row : shopTable.rows()) {
                if (shopItemsCoords.get(i).z == row.getInt("nummer")) {
                    textAlign(CENTER);
                    textSize(17);
                    fill(0);
                    text(row.getString("navn"), shopItemsCoords.get(i).x+205/2, shopItemsCoords.get(i).y+130/2);
                    textSize(15);
                    if (row.getInt("koebt") ==0) {
                        if (row.getInt("pris") <= penge.currentValue) {
                            fill(0, 255, 0);
                        } else {
                            fill(255, 7, 58);
                        }
                        text(row.getInt("pris"), shopItemsCoords.get(i).x+205/2, shopItemsCoords.get(i).y+170/2);
                    } else {
                        fill(0);
                        text("KØBT", shopItemsCoords.get(i).x+205/2, shopItemsCoords.get(i).y+170/2);
                    }
                    textAlign(LEFT);
                }
            }
        }
    }
    void itemBuy() {
        for (int i = 0; i<shopItemsCoords.size(); i++) {
            if (shopItemsCoords.get(i).x<mouseX && shopItemsCoords.get(i).x+205>mouseX && shopItemsCoords.get(i).y<mouseY && shopItemsCoords.get(i).y+150>mouseY && mousePressed && mouseRel == false) {
                for (TableRow row : shopTable.rows()) {
                    if (shopItemsCoords.get(i).z == row.getInt("nummer")) {
                        if (penge.currentValue>=row.getInt("pris")&& row.getInt("koebt") ==0) {

                            penge.currentValue-=row.getInt("pris");
                            row.setInt("koebt", 1);
                            if (row.getInt("hint") == 0) {
                                player.movementSpeed+=row.getInt("speedBoost");
                            }
                        }

                        if (row.getInt("hint") == 1 && row.getInt("koebt") == 1 && row.getInt("hintShown") == 0) {
                            for (NPC n : npc) {
                                if (n.id == 5) {
                                    shopSpeeking = true;
                                    hintId = row.getInt("nummer");
                                }
                            }
                        }
                    }
                }
                mouseRel = true;
            }
            if (shopSpeeking) {
                for (NPC n : npc) {
                    if (n.id == 5) {
                        for (TableRow row : shopTable.rows()) {
                            if ( hintId == row.getInt("nummer")) {
                                shopSpeeking = true;
                                n.showSpeech(row.getString("hintText"));
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
}
