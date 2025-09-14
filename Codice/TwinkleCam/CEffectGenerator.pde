class CEffectGenerator {
  
  String name;
  PGraphics pg;//FORSE quella cosa grossa che vedo in fase di debug
  CPixel cpa[];
  
  CEffectGenerator(String namet, PGraphics pgt, CPixel cpat[]){
    name = namet;
    pg = pgt;
    cpa = cpat;
  }
  
  void setColors(color col1t, color col2t){
  }
  
  void setPoints(float x1t, float y1t, float x2t, float y2t){
  }
  
  void manageKey(char key){
  }
    
  
  void update(){
    
  }
  
  void display(){
    
  }
  
}

class CfxGradient extends CEffectGenerator {
  float x1, y1; // coordinate del punto dove ho iniziato a tracciare la retta
  float x2, y2; // coordinate del punto dove ho rilasciato il mouse
  public color col1;
  public color col2;
  PImage _img;
  boolean is_ready;
  boolean colors_set;
  boolean points_set;
  int dist; //distanza tra un punto e l'altro dove ho cliccato per fare l'effetto
  float m;// coefficiente della retta passante per quel segmento
  float m_ort;//coefficente della retta ortogonale a quella tracciata
  boolean vert_line; // scrivo se la retta è verticale
  boolean vert_line_ort; //scrivo se la retta ortogonale è verticale
  float q;// termine noto della retta dell'effetto
  float q_ort;// termine noto della retta ortogonale dell'effetto
  float angle; //angolo tra i due estremi del segmento tracciato
  public float speed; //velocità dell'effetto
  float offset;
  
  CfxGradient(PGraphics pgt, CPixel cpat[]) {
    super("CfxGradient", pgt, cpat);
    is_ready = false;
    colors_set = false;
    points_set = false;
    vert_line = false;
    vert_line_ort = false;
    speed = 0;
    offset = 0;
  }
  
  void setColors(color col1t, color col2t){
    col1 = col1t;
    col2 = col2t;
    colors_set = true;
    if(points_set == true) _redraw();
    is_ready = colors_set & points_set;
  }
  //Prendo le coordinate della linea che ho tracciato e trova le informazioni che servono, come la retta che passa per quel segmento(con coefficiente angolare e termine noto), se è verticale o orizzontale e salvo nella classe (e salvo anche la retta perprendicolare
  void setPoints(float x1t, float y1t, float x2t, float y2t){
    x1 = x1t;
    y1 = y1t;
    x2 = x2t;
    y2 = y2t;
    dist = (int) sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));
    angle = atan2(y2-y1,x2-x1);
    if(x1 != x2){
      m = (y2-y1)/(x2-x1);
      println("m="+m);
      q = y2 - m * x2;
      println("q="+q);
      vert_line = false;
      // orth line...
      if(m==0){
        vert_line_ort = true;
      } else {
        vert_line_ort = false;
        m_ort = -1/m;
        q_ort = x1/m + y1;
      }
    } else {
      vert_line = true;
      vert_line_ort = false;
      m_ort = 0;
      q_ort = y1;
    }
      
    println("dist="+dist);
    println("angle="+degrees(angle));
    points_set = true;
    if(colors_set == true) _redraw();
    is_ready = colors_set & points_set;
  }
  //cosa succede se premo i pulsanti per modificare la velocità dell'effetto
  void manageKey(char key){
    switch(key){
      case '+':
        println("CfxGradient manage +");
        speed += 1;
        break;
      case '-':
        println("CfxGradient manage -");
        speed -= 1;
        break;
      case '0':
        println("CfxGradient manage 0");
        speed = 0;
        break;
    }
  }
  
  void _redraw(){
    _img = createImage(dist*2, dist, RGB);
    _img.loadPixels();
    for (int x=0; x<dist; x++) {
      float inter = map(cos((x)*(2*PI/dist)), 1, -1, 0, 1);
      color c = lerpColor(col1, col2, inter);
      for (int y=0; y<dist; y++) {
        int index1 = x + y * _img.width;
        int index2 = x+dist + y * _img.width;
        _img.pixels[index1] = c;
        _img.pixels[index2] = c;
      }
    }
    // important! update the pixels
    _img.updatePixels();
  }
  
  void update() {
    if(is_ready){
      offset += speed;//QUESTO IMPORTANTE
      pg.beginDraw();
      pg.background(0);
      pg.noStroke();
      pg.fill(col1);
      pg.ellipse(x1, y1, 20, 20);
      pg.fill(col2);
      pg.ellipse(x2, y2, 20, 20);
      pg.pushMatrix();
      pg.translate(x1, y1);
      pg.rotate(angle);
      pg.translate(0, -dist/2);
      
      //pg.image(_img, 0, 0, dist, dist, ((int)offset)%dist, 0, dist, dist);
      //pg.image(_img, 0, 0, dist*2, dist, ((int)offset)%dist, 0, dist, dist);
      
      //pg.copy(_img, ((int)offset)%dist, 0, dist, dist, 0, 0, dist, dist);
       //This was V1
      for (int i = 0; i <= dist; i++) { //interpolazione strana ma non delle luci
        float inter = map(cos((i+offset)*(2*PI/dist)), 1, -1, 0, 1);
        color c = lerpColor(col1, col2, inter); //il colore di mezzo tra i 2
        pg.stroke(c); //salvo nella figura il colore appena calcolato 
        pg.strokeWeight(2);
        pg.line(i, 0, i, dist);//faccio la linea con il colore appena deciso
      }
      
      // //This was V0
      //for (int i = 0; i <= (int)dist/2; i++) {
      //  float inter = map(i, 0, dist/2, 0, 1);
      //  color c = lerpColor(col1, col2, inter);
      //  pg.stroke(c);
      //  pg.strokeWeight(2);
      //  pg.line(i, 0, i, dist);
      //}
      //for (int i = (int)dist/2; i <= dist; i++) {
      //  float inter = map(i, dist/2, dist, 0, 1);
      //  color c = lerpColor(col2, col1, inter);
      //  pg.stroke(c);
      //  pg.strokeWeight(2);
      //  pg.line(i, 0, i, dist);
      //}
      pg.popMatrix();
      pg.endDraw();
      
      //NOW UPDATING CPixel[] IMPORTANTE PERCHE' QUI DECIDIAMO IL COLORE DELLE LUCI USANDO OFFSET
      for (CPixel cpx : cpa) {
        float p_dist = 0;
        if(vert_line_ort == true) p_dist = cpx.getX() - x1; //se è orizzontale l'effetto calcolo così la distanza del Pixel da dove ho iniziato a tracciare la retta
        else if(m_ort==0) p_dist = cpx.getY() - y1;//altrimenti se è verticale l'effetto faccio quest'altro
        else {
          p_dist = abs(cpx.getY() - (m_ort * cpx.getX() + q_ort)) / sqrt(1 + m_ort * m_ort);//altrimenti faccio la distanza punto/retta (ma è quella ortogonale e nel debug si vede che è rispetto a quella che si muove l'effetto)
        }
        float inter = map(cos((p_dist+offset)*(2*PI/dist)), 1, -1, 0, 1);//funzione che mappa un valore da un sistema di riferimento ad un altro. In questo caso dal coseno che varia tra -1 e 1 a 0 e 1 che è l'intervallo della funzione sotto
        color c = lerpColor(col1, col2, inter);//crea un colore di mezzo a seconda dell'interpolazione
        cpx.setColor(c);//poi accende il led singolarmente di quel colore
      }
    }
  }
  //funzione che mostra il debug e le linee
  void display() {
    if(is_ready){
      image(pg, 0, 0);
      
      //line in direction
      stroke(255,0,0);
      strokeWeight(1);
      if(vert_line == true) line(x1, 0, x1, height);
      else if(m<0) line(0, q, -q/m, 0);
      else if(m==0) line(0, y1, width, y1);
      else line(0, q, width, m * width + q);
      
      //line orthogonal
      stroke(0,255,0);
      strokeWeight(1);
      if(vert_line_ort == true) line(x1, 0, x1, height);
      else if(m_ort<0) line(0, q_ort, -q_ort/m_ort, 0);
      else if(m_ort==0) line(0, y1, width, y1);
      else line(0, q_ort, width, m_ort * width + q_ort);
      
    }
    
    //strokeWeight(1);
    //stroke(0);
    //pushMatrix();
    //translate(x, y);
    //angle += speed;
    //rotate(angle);
    //line(0, 0, 165, 0);
    //popMatrix();
  }
}

//class CfxArmAndSpots extends CEffectGenerator { // https://processing.org/examples/inheritance.html
//faderCircle // https://processing.org/examples/creategraphics.html
