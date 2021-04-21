class Penge{



int currentValue;

Penge(int currentValue_){
  
  
currentValue = currentValue_;
    
}

void display(){
fill(0);
textSize(30);
   for (int x = -3; x < 4; x++) {
        text(currentValue, 720+x, 30);
        text(currentValue, 720, 30+x);
    }
    fill(255);
    text(currentValue, 720, 30);
}



}
