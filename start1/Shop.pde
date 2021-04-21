class Shop {
    PVector shopLocation;
    ArrayList<PVector>shopItemsCoords = new ArrayList<PVector>();
    boolean mouseRel;

    Shop(int x_, int y_) {
        shopLocation = new PVector(x_, y_);
    }
    void shopItemsCoords_() {
        int h = 1;
        for (int i = 70; i<700; i+=230) {
            for (int j =65; j<350; j+=170) {
                shopItemsCoords.add(new PVector(i, j, h));
                h++;
            }
        }
    }
    void display() {
        fill(255, 255, 255);
        rect(50, 50, 700, 350);
        shopItems();
    }

    void shopItems() {


        for (int i = 0; i<shopItemsCoords.size(); i++) {
            noFill();
            rect(shopItemsCoords.get(i).x, shopItemsCoords.get(i).y, 205, 150);
            for (TableRow row : itemsTable.rows()) {
                if (shopItemsCoords.get(i).z == row.getInt("nummer")) {

                    fill(0);
                    text(row.getInt("pris"), shopItemsCoords.get(i).x, shopItemsCoords.get(i).y);
                }
            }
        }
    }
    void itemBuy() {
        for (int i = 0; i<shopItemsCoords.size(); i++) {
            if (shopItemsCoords.get(i).x<mouseX && shopItemsCoords.get(i).x+205>mouseX && shopItemsCoords.get(i).y<mouseY && shopItemsCoords.get(i).y+150>mouseY && mousePressed && mouseRel == false) {
                println("hi");
                mouseRel = true;
            }
        }
    }
}
