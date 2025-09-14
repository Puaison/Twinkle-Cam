class CPixel {
  int seq;
  float x, y;
  color aColor;
  float speed; 
  
  // Contructor
  CPixel(int seqTemp, float xTemp, float yTemp, float speedTemp) {
    seq = seqTemp;
    x = xTemp;
    y = yTemp;
    aColor = color( random(255),random(255),random(255) );
    speed = speedTemp;
  }
  
  void setColor(color ct){
    aColor = ct;
  }
  
  float getX(){
    return x;
  }
  float getY(){
    return y;
  }
  
  // Custom method for updating the variables
  void update() {
    
  }
  
  // Custom method for drawing the object
  void display() {
    fill(aColor);
    ellipse(x, y, 10, 10);
  }
}
