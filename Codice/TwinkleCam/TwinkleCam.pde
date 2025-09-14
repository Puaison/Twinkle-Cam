import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import processing.serial.*;
Serial myPort;  //the Serial port object
String val;
String serialVar = "";
int i = 0;
PVector loc;

boolean configurationMode = true;//booleano che ci dice se siamo nella fase di mappatura delle luci
boolean readyToSend = false;//booleano che ci dice se siamo pronti ad inviare

Capture cam;
OpenCV opencv;
ArrayList<PVector> points = new ArrayList<PVector>();//array contenente i punti
ArrayList<Float> toSend = new ArrayList<Float>();//array contenente le x e le y (separati) dei punti

int Skipped = 0;



import controlP5.*; //classe per rappresentare la GUI
CPixel[] cpa;//vettore virtuale delle luci da mostrare nella gui
ControlP5 cp5;

ColorPicker cp; //qualcosa della libreria ControlP5 ancora non ho capito cosa

// box color 1 and 2 che saranno associate al colorpicker grafico
CPickerBox cpb1;
CPickerBox cpb2;
boolean cpbs_active = false;

PGraphics pg;
CfxGradient cfx = null;

float mprex, mprey; //dove il mouse è stato premuto
float mrelx, mrely;// dove il mosue è stato rilasciato

boolean effect_show_state = false;
int last_ts;
float fr = 0;

void setup()
{
  size(640, 480, P2D);
  String[] cameras = Capture.list();
  cam = new Capture(this, cameras[2]);
  //cam = new Capture(this, "pipeline:autovideosrc");
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);

  myPort = new Serial(this, "COM5", 9600);
  myPort.bufferUntil('\n');

  cam.start();
  cpb1 = new CPickerBox(20, 20, 40, 40, color(255));
  cpb2 = new CPickerBox(45, 20, 65, 40, color(32, 32, 255));

  cp5 = new ControlP5(this);
  cp = cp5.addColorPicker("picker")
    .setPosition(80, 10)
    .setColorValue(color(255, 128, 0, 255))
    .hide()
    ;
  pg = createGraphics(width, height);

  last_ts = millis();
}

void draw()
{
  if (configurationMode)//il draw si comporterà diversamente a seconda se sono in fase di mappatura delle luci o 
  {
    if (cam.available() == true) {
      cam.read();
    }
    opencv.loadImage(cam);
    image(cam, 0, 0);

    loc = opencv.max();
    stroke(255, 0, 0);
    strokeWeight(5);
    ellipse(loc.x, loc.y, 10, 10);

    stroke(0, 255, 0);
    strokeWeight(5);

    for (int i = 0; i < points.size(); i++)
    {
      ellipse(points.get(i).x, points.get(i).y, 10, 10);
    }
  } else //qui mostro tutti gli oggetti grafici dopo la fase di mappatura
  {
    background(0);//riempio di nero la schermata
    if (!effect_show_state) {//vedo in che modalità mi trovo. Se non sono in modalità debug mostro l'albero con tutte le lucette
      if (cfx != null) {
        cfx.update();//NON SOLO GRAFICO:oltre a tutto il casino che fa che non ho capito,aggiorna il colore delle luci singolarmente (l'ultimo for) a seconda di vari calcoli di interpolazione. QUEST'ULTIMA PARTE MODIFICA I COLORI
      }
      //SOLO GRAFICO visto che ho cambiato il colore adesso disegno un nuovo ellisse con un nuovo colore 
      for (CPixel cpx : cpa) {
        cpx.display();//SOLO GRAFICO chiedo ad ogni luce di mostrarsi nella figura, del colore a lui assegnato inizialmnte a random
      }
      cpb1.display();//SOLO GRAFICO chiedo ai due colorpicker di mostrarsi nella GUI
      cpb2.display();
    } else {//se sono in modalità debug

      if (cfx != null) {
        cfx.update();//stesso concetto di sopra
        cfx.display();//SOLO GRAFICO:chiedo al debugger di mostrarsi
      }
    }
    if (mousePressed == true) {
      stroke(255, 0, 0); //bordo delle prossime figure che andrò a fare
      strokeWeight(10); //grandezza del bordo
      line(mprex, mprey, mouseX, mouseY);//disegna la linea temporanea finchè non rilascio il mouse, che parte da dove l'ho premuto e arriva fino a dove è attualmente il mouse. Solo dopo aver rilasciato il mouse parte l'interrupt. Questa parte non è bloccante
      noStroke();
    }
    //DBG text
    fill(255, 0, 0);//riempie una figura
    if (millis() - last_ts >= 1000) {
      last_ts = millis();
      fr = frameRate;
    }
  }
}
//viene richiamata automaticamente non si sa dove.
void picker(int col) {
  //println("picker\talpha:"+int(alpha(col))+"\tred:"+int(red(col))+"\tgreen:"+int(green(col))+"\tblue:"+int(blue(col))+"\tcol"+col);
  if(cpb1.is_active()){
    cpb1.setColor(col);
    //println(alpha(cpb1.getColor()));
  }
  if(cpb2.is_active()){
    cpb2.setColor(col);
    //println(alpha(cpb2.getColor()));
  }
}

//Vedo dove ho iniviato a premere
void mousePressed(){
  println("mousePressed(): "+mouseX+","+mouseY);
  mprex = mouseX;
  mprey = mouseY;
}
//Vedo dove ho rilasciato
void mouseReleased(){
  println("mouseReleased(): "+mouseX+","+mouseY);
  mrelx = mouseX;
  mrely = mouseY;
  if(cfx != null){
    cfx.setColors(cpb1.getColor(),cpb2.getColor());
    if( ((mprex!=mrelx)|(mprey!=mrely)) & (!cpbs_active)) 
    {
      cfx.setPoints(mprex, mprey, mrelx, mrely);
      toSend.clear();
      toSend.add(cfx.offset);
      toSend.add(cfx.speed);
      toSend.add(cfx.x1);
      toSend.add(cfx.y1);
      toSend.add((float)cfx.dist);
      if(cfx.vert_line_ort)
        toSend.add(1.00);
      else
        toSend.add(0.00);
      toSend.add(cfx.m_ort);
      toSend.add(cfx.q_ort);
      myPort.write("r");//questo diventa:
      for(int j=0;j<8;j++)
      {
        myPort.write("\n"+ str(toSend.get(j)));
      }
    }
    else
    {
      toSend.clear();
      toSend.add(red(cfx.col1));
      toSend.add(green(cfx.col1));
      toSend.add(blue(cfx.col1));
      toSend.add(alpha(cfx.col1));
      toSend.add(red(cfx.col2));
      toSend.add(green(cfx.col2));
      toSend.add(blue(cfx.col2));
      toSend.add(alpha(cfx.col2));
      myPort.write("c");
      for(int j=0;j<8;j++)
      {
        myPort.write("\n"+ str(toSend.get(j)));
      }
    }
    
  }
}

//Interrupt che controlla se ho premuto uno dei due picker e li mostra o nasconde.
//Se un ColorPicker è aperto metto il suo stato ad attivo(true) altrimenti è disattivato(false)
void mouseClicked() {
  float xt = mouseX;
  float yt = mouseY;
  if(cpb1.is_click_in(xt, yt)) {
    cpb1.set_active(!cpb1.is_active());//diventa attivo e quindi da false diventa true
    cpb2.set_active(false);//disattivo l'altro
    if(cpb1.is_active()){
      cp.setColorValue(cpb1.getColor());//uso il colopicker della libreria di ControlP5
      cp.show();
    } else { 
      cp.hide();
    }
  } 
  if(cpb2.is_click_in(xt, yt)) {
    cpb2.set_active(!cpb2.is_active());
    cpb1.set_active(false);
    if(cpb2.is_active()){
      cp.setColorValue(cpb2.getColor());
      cp.show();
    } else {
      cp.hide();
    }
  } 
  cpbs_active = cpb1.is_active() | cpb2.is_active();
  
}

void keyPressed()
{
  if (configurationMode)//quali comandi sono attivi a seconda dello stato dell'applicazione
  {
    if (key == 'q') // Questo è per accettare un punto
    {
      if (Skipped > 0)
      {
        float Xstart;
        float Ystart;
        float Xdistance;
        float Ydistance;

        while (Skipped > 0)
        {
          Xstart = points.get(points.size() - 1).x;
          Ystart = points.get(points.size() - 1).y;
          Xdistance = loc.x - points.get(points.size() - 1).x;
          Ydistance = loc.y - points.get(points.size() - 1).y;
          points.add(new PVector(Xstart + Xdistance/(Skipped+1), Ystart + Ydistance/(Skipped+1)));
          Skipped--;
        }
      }
      points.add(loc);
    }
    if (key == 'w') //Questo è per considerare un punto nascosto
    {
      Skipped++;
    }
    if (key == 'e') //Questo è quando ho finito di leggere i punti
    {
      cpa = new CPixel[points.size()];
      for(int i = 0; i < points.size(); i++)
        cpa[i]=new CPixel(i, points.get(i).x, points.get(i).y, 0.8);//creazione delle luci grafiche(dovremmo cambiare il, costruttore per avere il colore)
      cfx = new CfxGradient(pg, cpa); //creo qui il gestore dell'effetto una volta che cpa è stato popolato e che ho finito (avviene prima di passare alla fase di visualizzione) 
      //ScaleRes();
      CreatePixelsSerialData();//popolo l'array che contiene i dati divisi
    }
    if (key == 'r')//quando ho visto le luci scalate, invio tutto all'arduino
    {
      delay (500);
      myPort.write('s'); //Comando seriale di iniziare a leggere le posizioni dei pixel
      configurationMode = false;
    }
  }
  else{//tasti della nonconfigurationmode
    if (key == '+')
    {
      print("aumento lo speed");
      if(cfx != null){
      cfx.speed+=1;
      myPort.write("+");  
      }
    }
    if (key == '-')
    {
      if(cfx != null){
      cfx.speed-=1;
      myPort.write("-");  
      }
    }
    if (key == '0')
    {
      if(cfx != null){
      cfx.speed=0;
      }
    }
  }
}


void CreatePixelsSerialData()
{
  for (int i = 0; i < points.size(); i++)
  {
    toSend.add(points.get(i).x);
    toSend.add(points.get(i).y);
  }
}

// Method to scale the resolution based on all current pixels
void ScaleRes()//ALESSIO Coomenta
{
  float XMin = points.get(0).x;
  float YMin = points.get(0).y;

  float XMax = 0;
  float YMax = 0;

  for (int i = 1; i < points.size(); i++)
  {
    if (points.get(i).x < XMin) XMin = points.get(i).x;
    if (points.get(i).y < YMin) YMin = points.get(i).y;
  }

  for (int i = 0; i < points.size(); i++)
  {
    points.get(i).x -= XMin;
    points.get(i).y -= YMin;
  }

  for (int i = 0; i < points.size(); i++)
  {
    if (points.get(i).x > XMax) XMax = points.get(i).x;
    if (points.get(i).y > YMax) YMax = points.get(i).y;
  }
}

void serialEvent(Serial myPort) //funzione che viene richiamata ogni volta che arriva qualcosa dall'arduino
{
  serialVar = myPort.readStringUntil('\n');
  serialVar = trim(serialVar);
  println(serialVar);

  switch (serialVar)
  {
    case ("s"): //questo segnale viene inviato dall'arduino quando è pronto a ricevere
    {
      //print("mando un dato");
      myPort.write(str(Math.round(toSend.get(i))));
      //myPort.write(Math.round(toSend.get(i)));//viene inviata una coordinata per volta nella seriale.Si attende poi che l'arduino sia pronto per ricevere
      i++;
      if(i>=120)
        i=0;
      break;
    }
  default:
    
    break;
  }
}
