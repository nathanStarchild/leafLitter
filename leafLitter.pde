PImage leaf1, lastFrame;
int w, h, n, m, nLeaves;
OpenSimplexNoise osNoise;
float t, offZoom, leafNZoom;
float noiseZoom = 25;
int loopFrames = 200*30;
float inc = 2 * PI / loopFrames;
Palette thePalette;

ArrayList<PImage> images = new ArrayList<PImage>();

void setup(){
    // size(1080, 1920, P3D);
    fullScreen(P3D, SPAN);
    w = 1920;
    h = 1080;
    n = 20;
    m = 20;
    
    nLeaves = loadLeaves();
    osNoise = new OpenSimplexNoise();
    thePalette = new Palette();
    thePalette.setPalette(0);

    background(0);
    imageMode(CENTER);
}

int loadLeaves() {
    images.add(loadImage("leaf1.png"));
    images.add(loadImage("leaf2.png"));
    images.add(loadImage("leaf3.png"));
    images.add(loadImage("leaf4.png"));
    images.add(loadImage("leaf5.png"));
    images.add(loadImage("leaf6.png"));
    images.add(loadImage("leaf7.png"));
    images.add(loadImage("leaf8.png"));
    return 8;
}

void draw() {
    // t = millis() * 60 / 1000;
    // if (frameCount <= 1){
        background(0);
    // } else {
    //     image(lastFrame, 0, 0, width, height);
    // }
    t = frameCount * inc;
    hint(DISABLE_DEPTH_TEST);
    hint(ENABLE_DEPTH_SORT);
    

    offZoom = map((float)osNoise.eval(t/10., 10), -1, 1, 5, 250);
    leafNZoom = map((float)osNoise.eval(t/500., 150), -1, 1, -2000, 5000);

    for (int i=0; i<n; i++){
        for (int j=0; j<m; j++){
            int x = i * w / n;
            int y = j * h / m;
            float dfcX = x - width/2.;//distance from center
            float dfcY = y - height/2.;
            float imZoom = (float)osNoise.eval(t, x/noiseZoom, y/noiseZoom, 1);
            float imZ = (float)osNoise.eval(t/10., x/noiseZoom, y/noiseZoom, 1);
            float xOff = (float)osNoise.eval(t, x/(offZoom), y/(offZoom), 10);
            float yOff = (float)osNoise.eval(t, x/(offZoom), y/(offZoom), 20);
            float theta = (float)osNoise.eval(t, x/(5*noiseZoom), y/(5*noiseZoom), 30);
            int c = (int)map((float)osNoise.eval(t/1., x/(20*noiseZoom), y/(20*noiseZoom), 100), -1, 1, 0, 255);
            int leafN = (int)map((float)osNoise.eval(t/100., x/leafNZoom, y/leafNZoom, 30), -1, 1, 0, 2*nLeaves)%nLeaves;
            PImage leaf = images.get(leafN);
            color col = thePalette.getColor(c, 255);
            imZoom = map(imZoom, -1, 1, 10, 300);
            imZ = map(imZ, -1, 1, 10, 300);
            xOff = map(xOff, -1, 1, -200, 200);
            yOff = map(yOff, -1, 1, -200, 200);
            theta = map(theta, -1, 1, -2*PI, 2*PI);
            pushMatrix();
                translate(x + xOff, y + yOff, imZ);
                rotateZ(theta);
                tint(col);
                image(leaf, 0, 0, imZoom, imZoom*leaf.height/leaf.width);
            popMatrix();

        }
    }
    hint(ENABLE_DEPTH_TEST);
    hint(DISABLE_DEPTH_SORT);
    // println("frame");
    // image(leaf1, 0, 0, 100, 100);
    // saveFrame("lastFrame.jpg");
    // lastFrame = loadImage("lastFrame.jpg");
}