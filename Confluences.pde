//    SPACE = exporter le visuel
//    RIGHT = selectioner une image
//    LEFT  = selectioner une image
//    UP   = selectioner une strate
//    DOWN = selectioner une strate
//    DELETE = desactiver l'image de la strate
//    ENTER = echanger avec la strate superieure
//    SHIFT = echanger avec la strate inferieure
//    c = select color
//    a z e r t = position de l'image
//    CONTROL = rotation 180 deg

int maxStrat = 4;
int opacity = 240; // opacité sur 255
color background = color( 25 ); // valeur de gris sur 255
color papier = color( 230 ); // valeur de gris sur 255
int largeur = 862, hauteur = 1280; // en pixels

import javax.swing.JColorChooser;
import java.awt.Color; Color javaColor;
import javax.swing.*;
import java.io.File;
// import drop.*; SDrop drop;
color[] colors;
int w, h, col;
int off = 0;
String[] imageNames;
ArrayList<Strate> strates = new ArrayList<Strate>();
Strate strateOff;
java.io.FilenameFilter extfilter = new java.io.FilenameFilter() { boolean accept(File dir, String name){ return name.toLowerCase().endsWith(".png"); } };
PImage[] imgs;
PFont mono;
void settings() { fullScreen(2); }
void setup() {
    // size(1900, 1200);
    mono = createFont(sketchPath("consola.ttf"), 20);
    textFont(mono, 20);
    surface.setResizable(true);
    for(int i=0; i<maxStrat; i++) strates.add( new Strate(i) );
    h = height - 100;
    w = largeur*h /hauteur;
    strateOff = strates.get(off);

    java.io.File folder = new java.io.File( dataPath("") );
    imageNames = folder.list(extfilter);
    imageNames = sort(imageNames);
    imgs = new PImage[ imageNames.length +1 ];
    colorsDataFile_setup();

    imgs[0] = loadImage(sketchPath("blank.png"));
    for(int i=0; i<imageNames.length; i++){
        imgs[i+1] = loadImage(folder+"/"+imageNames[i]);
        imgs[i+1].resize(w,h);
        imgs[i+1].filter(INVERT);
    }
    col = floor(width/imgs.length);
    try { UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName()); } catch (Exception e) { e.printStackTrace(); }  //  platform specific UI
}

void draw() {
    background(background);
    if(isMouseDown){
        stroke(50); noFill(); for(int i=0; i<imgs.length; i++) line(i*col, 0, i*col, height);
        stroke(50); line(mouseX,0,mouseX,15); line(mouseX,height-15,mouseX,height);
        fill(255,5); rectMode(CORNER);
        rect(strates.get(off).off *col,0, col,height );
        rectMode(CORNER); stroke(50); fill(background); rect(0,0,2*col, 130+ 24*maxStrat); // bg text
    }
    rectMode(CENTER); fill(papier); noStroke(); rect(width/2,height/2,largeur*h/hauteur,h); // papier
    for(int i=0; i<maxStrat; i++) {
        Strate s = strates.get(i);
        fill(255);
        if( s.off==0 && i!=off){text( "  "+(i+1)+"  Strate -       "+s.imgPos+((s.rotation)?"r":" ")+"     -", 50,50+24*maxStrat-24*i );}
        if( s.off!=0 && i!=off){text( "  "+(i+1)+"  Strate         "+s.imgPos+((s.rotation)?"r":" ")+"     "+imageNames[s.off-1], 50,50+24*maxStrat-24*i ); }
        if( s.off==0 && i==off){text( "[ "+(i+1)+"  Strate - ]     "+s.imgPos+((s.rotation)?"r":" ")+"     -", 50,50+24*maxStrat-24*i );}
        if( s.off!=0 && i==off){text( "[ "+(i+1)+"  Strate   ]     "+s.imgPos+((s.rotation)?"r":" ")+"     "+imageNames[s.off-1], 50,50+24*maxStrat-24*i ); }
        fill(colors[s.off]);
        if(s.off != 0) rect(50+136,50+24*maxStrat-24*i-4, 16,16);
        s.draw();
    }
    noLoop();
}
void keyPressed(){
    if ( key == '1' || key == '!' ) off = 0;
    if ( key == '2' || key == '@' ) off = 1;
    if ( key == '3' || key == '#' ) off = 2;
    if ( key == '4' || key == '$' ) off = 3;
    if ( key == ' ') {
        String name = "";
        for(Strate s:strates) if(s.off != 0) name += "-"+imageNames[s.off-1].substring(0,imageNames[s.off-1].indexOf("."))+"("+s.imgPos+((s.rotation)?"r":"")+")" ;
        get(width/2-w/2,height/2-h/2,w,h).save(name+".png");
    }
    if ( keyCode == RIGHT) strates.get(off).off = constrain(strates.get(off).off+1,0,imgs.length-1 );
    if ( keyCode == LEFT) strates.get(off).off = constrain(strates.get(off).off-1,0,imgs.length-1 );
    if ( keyCode == UP)   { off = constrain(off+1,0,maxStrat-1 ); strateOff = strates.get(off); }
    if ( keyCode == DOWN) { off = constrain(off-1,0,maxStrat-1 ); strateOff = strates.get(off); }
    if ( keyCode == DELETE) strateOff.off = 0;
    if ( keyCode == ENTER){ if(off<maxStrat-1){ strateOff.deal( strates.get(off+1) ); off ++; strateOff = strates.get(off); } }
    if ( keyCode == SHIFT){ if(off>0)         { strateOff.deal( strates.get(off-1) ); off --; strateOff = strates.get(off); } }
    if ( keyCode == CONTROL ) strateOff.rotation = !strateOff.rotation ;
    if ( key == 'a' ) strateOff.imgPos = 0 ;
    if ( key == 'z' ) strateOff.imgPos = 1 ;
    if ( key == 'e' ) strateOff.imgPos = 2 ;
    if ( key == 'r' ) strateOff.imgPos = 3 ;
    if ( key == 't' ) strateOff.imgPos = 4 ;
    if ( key == 'c' ){
        JColorChooser jcc = new JColorChooser();
        javaColor = jcc.showDialog( new JFrame(), "Color picker",Color.white);
        jcc.setPreviewPanel(new JPanel());
        color newColor = colors[ strates.get(off).off ] ;
        if(javaColor!=null) newColor = color(javaColor.getRed(),javaColor.getGreen(),javaColor.getBlue());
        colors[ strates.get(off).off ] = newColor ;
    }
    loop();
}
void mouseDragged(){
    strateOff.off = constrain(floor( mouseX/col ), 0, imgs.length-1);
    loop();
}
boolean isMouseDown = false;
void mousePressed(){ isMouseDown = true; }
void mouseReleased(){ isMouseDown = false; loop(); }
