
class Strate{
    int id;
    int off = 0;
    int imgPos = 0;
    boolean rotation = false;
    Strate(int _id){
        id = _id;
    }
    void draw(){
        if(off > -1){
            imageMode(CENTER);
            tint( colors[off], opacity );
            pushMatrix();
                translate(width/2,height/2);
                scale((height-100*1.0)/hauteur*1.0);
                if (rotation) rotate(PI);
                if (imgPos != 0) translate(-largeur/2,-hauteur/2);
                if (imgPos == 1) translate(largeur/2, 698+582/2);
                if (imgPos == 2) translate(471/2, 698/2);
                if (imgPos == 3) translate(471+293/2, 434/2);
                if (imgPos == 4) translate(471+391/2, 434+264/2);
                if (imgPos == 0) image( imgs[off], 0, 0, largeur, hauteur );
                if (imgPos == 1){ rotate(PI/2); image( imgs[off], 0,0, 582, 862 ); }
                if (imgPos == 2) image( imgs[off], 0, 0, 471, 698 );
                if (imgPos == 3) image( imgs[off], 0, 0, 293, 434 );
                if (imgPos == 4){ rotate(PI/2); image( imgs[off], 0,0, 264, 391 ); }
            popMatrix();
        }
    }
    void deal(Strate s){
        Strate tmp = new Strate(-1);
        tmp.copyStrate(this);
        this.copyStrate(s);
        s.copyStrate(tmp);
    }
    void copyStrate(Strate s){
        this.off = s.off;
        this.rotation = s.rotation;
        this.imgPos = s.imgPos;
    }
}
