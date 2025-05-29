
void colorsDataFile_setup(){
    try { loadMidibus("colors.txt"); }catch(Exception e){
        saveMidibus("data/colors.txt"); println("the file \"colors.txt\" CREATED");
        loadMidibus("colors.txt");
    }
}
void saveMidibus(String name){
    String str[] = new String[colors.length];
    for (int i = 0; i < colors.length; ++i) {
        str[i] = hex( colors[i],6 );
    }
    saveStrings(name, str);
}

void loadMidibus(String name){
    String str[] = loadStrings(name);
    colors = new color[imageNames.length+1];
    for (int i = 0; i < str.length; ++i) {
        if((colors.length) > i){
            println("str[i]: "+str[i]);
            if(str[i].length()>=6)
            println(  unhex(str[i].substring(0,1))*255/15  );
            if(str[i].length()>=6)
            colors[i] = color(  unhex(str[i].substring(0,1))*255/15, unhex(str[i].substring(2,3))*255/15, unhex(str[i].substring(4,5))*255/15  );
        }
    }
}
void exit() {
    saveMidibus("data/colors.txt");
    super.exit();
}
