class Penge {
    int currentValue;
    Penge(int currentValue_) {
        currentValue = currentValue_;
    }
    void display() { //tegner det der viser ens penge
        image(coin, width-35, 5);
        fill(0);
        textSize(30);
        textAlign(RIGHT);
        for (int x = -3; x < 4; x++) { //laver en stroke effekt på teksten
            text(currentValue, width+x-35, 30);
            text(currentValue, width-35, 30+x);
        }
        fill(255);
        text(currentValue, width-35, 30);
        textAlign(LEFT);
    }
}
