PFont font;
//String ASCIIStr = " !\"#$%&\'()*+,-./0123456789:;<=>?ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ÇüâäàåçêëèïîìÅÄÉæÆôöòÿÖÜø£Ø×ƒáíóúñÑªº¿®¬½¼¡«»░▒▓│┤ÁÂÀ©╣║╗╝¢¥┐└┴┬├─┼ãÃ╚╔╩╦═╬¤ðÐÊËÈıÍÏÎ┘┌█▄¦Ì▀ÓßÔÒõÕµþÞÚÛÙýÝ¯´≡±‗¾¶§÷¸°·¹³²■";
String ASCIIStr = " !\"#$%&\'()*+,-./0123456789:;<=>?ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ÇüâäàåçêëèïîìÅÄÉæÆôöòÿÖÜø£Ø×ƒáíóúñÑªº¿®¬½¼¡«»│┤ÁÂÀ©╣║╗╝¢¥┐└┴┬├─┼ãÃ╚╔╩╦═╬¤ðÐÊËÈıÍÏÎ┘┌¦ÌÓßÔÒõÕµþÞÚÛÙýÝ¯´≡±‗¾¶§÷¸°·¹³²";

boolean rgb = false;
char[] ASCII = ASCIIStr.toCharArray();
PImage[] ASCIIImgs = new PImage[ASCII.length];
PImage img;
int w, h;
void settings(){
  size(100, 100);
}

void setup(){
  //surface.setResizable(true);
  font = createFont("Menlo", 12, true); // Currently must be monospace
  selectInput("Choose a file to ASCII:", "saveFile");
  img = createImage(100, 100, RGB);
  background(51);
  noLoop();
  stroke(0);
  fill(0);
  textAlign(LEFT, TOP);
  textFont(font);
  w = ceil(textWidth('|'));
  h = ceil(textAscent()+textDescent());
  println(w, h);
  PGraphics cvs = createGraphics(w, h);
  cvs.beginDraw();
  cvs.stroke(0);
  cvs.fill(0);
  cvs.textAlign(LEFT, TOP);
  cvs.textFont(font);
  cvs.endDraw();
  int i = 0;
  for (char c : ASCII){
    cvs.beginDraw();
    cvs.background(255);
    cvs.text(str(c), 0, 0);
    cvs.endDraw();
    ASCIIImgs[i] = cvs.get();
    i++;
  }
}

void saveFile(File file){
  if (file == null || !file.canRead()) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + file.getAbsolutePath());
    img = loadImage(file.getAbsolutePath());
    
    ASCIIify(img);
  }
}

void ASCIIify(PImage inp){
  
  int nW = inp.width/w;
  int wMargin = 0;
  if (nW > 1){
    wMargin = (inp.width % w)/(nW-1);
  }
  
  int nH = inp.height/h;
  int hMargin = 0;
  if (nH > 1){
    hMargin = (inp.height % h)/(nH-1);
  }
  String ASCIIResultR = "";
  String ASCIIResultG = "";
  String ASCIIResultB = "";
  String ASCIIResult = "";
  for (int j = 0; j < nH; j++){
    int y = (h+hMargin)*j;
    for (int i = 0; i < nW; i++){
      int x = (w+wMargin)*i;
      char best = ' ';
      int bestError= -1;
      containingLoop: for (int k = 0; k < ASCII.length; k++){
        int error = 0;
        for (int pX = 0; pX < w; pX++){
          for (int pY = 0; pY < h; pY++){
            error+=abs(brightness(inp.get(x+pX, y+pY))-brightness(ASCIIImgs[k].get(pX, pY)));
            if (bestError != -1 && error >= bestError) continue containingLoop;
          }
        }
        bestError = error;
        best = ASCII[k];
      }
      char bestR = ' ';
      char bestG = ' ';
      char bestB = ' ';
      if (rgb){
        
        //Red
        
        bestR = ' ';
        int bestErrorR= -1;
        containingLoop: for (int k = 0; k < ASCII.length; k++){
          int error = 0;
          for (int pX = 0; pX < w; pX++){
            for (int pY = 0; pY < h; pY++){
              error+=abs(red(inp.get(x+pX, y+pY))-red(ASCIIImgs[k].get(pX, pY)));
              if (bestErrorR != -1 && error >= bestErrorR) continue containingLoop;
            }
          }
          bestErrorR = error;
          bestR = ASCII[k];
        }
        
        //Green
        
        bestG = ' ';
        int bestErrorG= -1;
        containingLoop: for (int k = 0; k < ASCII.length; k++){
          int error = 0;
          for (int pX = 0; pX < w; pX++){
            for (int pY = 0; pY < h; pY++){
              error+=abs(green(inp.get(x+pX, y+pY))-green(ASCIIImgs[k].get(pX, pY)));
              if (bestErrorG != -1 && error >= bestErrorG) continue containingLoop;
            }
          }
          bestErrorG = error;
          bestG = ASCII[k];
        }
        
        //Blue
        
        bestB = ' ';
        int bestErrorB= -1;
        containingLoop: for (int k = 0; k < ASCII.length; k++){
          int error = 0;
          for (int pX = 0; pX < w; pX++){
            for (int pY = 0; pY < h; pY++){
              error+=abs(blue(inp.get(x+pX, y+pY))-blue(ASCIIImgs[k].get(pX, pY)));
              if (bestErrorB != -1 && error >= bestErrorB) continue containingLoop;
            }
          }
          bestErrorB = error;
          bestB = ASCII[k];
        }
      }
      
      ASCIIResult += best;
      
      if (rgb){
        ASCIIResultR += bestR;
        ASCIIResultG += bestG;
        ASCIIResultB += bestB;
      }
      println(str(((float) (i+j*nW))/((float) (nW+(nH-1)*nW-1))*100)+"% Done ("+str(i+j*nW)+"/"+str(nW+(nH-1)*nW-1)+")");
    }
    ASCIIResult += '\n';
    if (rgb){
      ASCIIResultR += '\n';
      ASCIIResultG += '\n';
      ASCIIResultB += '\n';
    }
  }
  
  saveStrings("Result2.txt" , ASCIIResult .split("/n"));
  if (rgb){
    saveStrings("ResultR.txt", ASCIIResultR.split("/n"));
    saveStrings("ResultG.txt", ASCIIResultG.split("/n"));
    saveStrings("ResultB.txt", ASCIIResultB.split("/n"));
  }
  exit();
}
