public static float DArea(float x1t, float y1t, float x2t, float y2t, float x3t, float y3t){
  return -1*((x2t -x1t)*(y3t -y1t) - (x3t - x1t)*(y2t - y1t));
}

public static boolean Left(float x1t, float y1t, float x2t, float y2t, float x3t, float y3t){
  return DArea(x1t, y1t, x2t, y2t, x3t, y3t) > 0;
}

class CTriangle {
  float x1, y1;
  float x2, y2;
  float x3, y3;
  color aColor;
  
  CTriangle(float x1t, float y1t, float x2t, float y2t, float x3t, float y3t, color ct){
    x1 = x1t;
    y1 = y1t;
    x2 = x2t;
    y2 = y2t;
    x3 = x3t;
    y3 = y3t;
    aColor = ct;
  }
  
  float area(){
    return DArea(x1, y1, x2, y2, x3, y3)/2;
  }
  
  boolean is_in_triangle(float px, float py){
    boolean ret = true;
    ret &= Left(x1, y1, x2, y2, px, py);
    ret &= Left(x2, y2, x3, y3, px, py);
    ret &= Left(x3, y3, x1, y1, px, py);
    return ret;
  }
  
  void display() {
    fill(aColor);
    triangle(x1, y1, x2, y2, x3, y3);
  }

}
