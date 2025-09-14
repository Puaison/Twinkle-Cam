class CPickerBox {
  
  float x1, y1; //upper left corner
  float x2, y2; //lower right corner
  
  color col;
  boolean active;
  
  CPickerBox(float x1t, float y1t, float x2t, float y2t, color colt){
    x1 = x1t;
    y1 = y1t;
    x2 = x2t;
    y2 = y2t;
    active = false;
    col = colt;
  }
  
  void setColor(color ct){
    col = ct;
  }
  
  color getColor(){
    return col;
  }
  
  boolean is_active(){
    return active;
  }
  
  void set_active(boolean act){
    active = act;
  }
  
  boolean is_click_in(float xt, float yt){
    boolean ret = true;
    ret &= ((xt >= x1) & (xt <= x2));
    ret &= ((yt >= y1) & (yt <= y2));
    return ret;
  }
  
  void display(){
    noStroke();
    fill(64,64,64);
    rect(x1-3, y1-3, x2-x1+6, y2-y1+6);
    if(active){
      stroke(255,0,0);
      strokeWeight(2);
    } else {
      stroke(0);
      strokeWeight(1);
    }
    fill(col);
    rect(x1, y1, x2-x1, y2-y1);
    noStroke();
  }
}
