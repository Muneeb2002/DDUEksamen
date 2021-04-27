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
                inventoryItemsCoords.add(new PVector(i, j, h));
                h++;
            }
        }
    }

    void display () {
        fill(255);
        rect(50, 50, 700, 700);
        textAlign(CENTER);
        fill(0);
        text("Inventory", width/2, 80);
        shopItems();
    }
    void shopItems() {
        for (int i = 0; i<inventoryItemsCoords.size(); i++) {
            noFill();
            rect(inventoryItemsCoords.get(i).x, inventoryItemsCoords.get(i).y, 200, 200);
        } 
        for (TableRow row : itemsTable.rows()) {
            if (row.getInt("pickedUp")==1) {
                text(row.getString("name"), inventoryItemsCoords.get(itemsNumber).x, inventoryItemsCoords.get(itemsNumber).y);
            }
        }
    }
}
