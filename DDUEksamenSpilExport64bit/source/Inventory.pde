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
        //tegner firkanten der laver inventoryen.
        fill(255);
        rect(50, 50, 700, 700);
        textAlign(CENTER);
        fill(0);
        textSize(30);
        text("Inventory", width/2, 80);
        showInventory(); //kører showInventory funktionen
    }
    void showInventory() {
        for (int i = 0; i<inventoryItemsCoords.size(); i++) {
            noFill();
            stroke(0);
            strokeWeight(2);
            rect(inventoryItemsCoords.get(i).x, inventoryItemsCoords.get(i).y, 200, 200);
            for (Items item : items) {
                for (TableRow row : itemsTable.rows()) {
                    if (inventoryItemsCoords.get(i).z == item.itemsLocation.z) {
                        if (row.getInt("pickedUp") ==1 && item.givenAway == false && row.getInt("cash") == 0) { // tjekker om itemen er samlet op, ikke givet væk og ikke er en penge gave
                            if (row.getString("name") == item.name) { // navnet på itemen er ens i tabellen og objektet
                                textSize(20);
                                textAlign(CENTER);
                                imageMode(CENTER);
                                if (item.id < pic.length) { // sætter billedet af itemen ind på dens plads
                                    image(pic[item.id], inventoryItemsCoords.get(i).x+205/2, inventoryItemsCoords.get(i).y+150/2);
                                }
                                imageMode(CORNER);
                                //skriver navnet på itemen
                                text(row.getString("name"), inventoryItemsCoords.get(i).x+205/2, inventoryItemsCoords.get(i).y+150/2+100);
                                textAlign(LEFT);
                            }
                        } 
                    }
                }
            }
        }
    }
}
