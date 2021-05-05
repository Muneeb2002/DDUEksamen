class Inventory {
    PVector inventoryLoc;
    boolean showInventory;
    int itemsNumber = 0;
    ArrayList<PVector>inventoryItemsCoords = new ArrayList<PVector>();
    Inventory() {
    }
    void inventoryItemsCoords_() {
        int h = 1;
        for (int i = 90; i<600; i+=210) {
            for (int j =100; j<600; j+=210) {
                inventoryItemsCoords.add(new PVector(j, i, h));
                h++;
            }
        }
    }

    void display () {
        fill(255);
        rect(50, 50, 700, 700);
        textAlign(CENTER);
        fill(0);
        textSize(30);
        text("Inventory", width/2, 80);
        showInventory();
    }
    void showInventory() {
        for (int i = 0; i<inventoryItemsCoords.size(); i++) {
            noFill();
            rect(inventoryItemsCoords.get(i).x, inventoryItemsCoords.get(i).y, 200, 200);
            for (Items item : items) {
                for (TableRow row : itemsTable.rows()) {
                    //println(inventoryItemsCoords.get(i).z, item.itemsLocation.z);
                    if (inventoryItemsCoords.get(i).z == item.itemsLocation.z) {

                        if (row.getInt("pickedUp") ==1 && item.givenAway == false) {

                            if (row.getString("name") == item.name) {
                                textSize(20);
                                textAlign(CENTER);
                                text(row.getString("name"), inventoryItemsCoords.get(i).x+205/2, inventoryItemsCoords.get(i).y+150/2);
                                textAlign(LEFT);
                            }
                        }
                    }
                }
            }
        }
    }
}
