import KinectPV2.*;
// KinectV2 kinect;

KinectPV2 kinect;

int leftSideScore = 0;
int rightSideScore = 0;
int windowX = 500;
int windowY = 500;

int rad = 10;
int ballposx = 250;
int ballposy = 250;
float xpos = 150; 
float ypos = 150;
int ballvelX = 10;
int ballvelY = 10;
int paddlevelY = 40;
int paddle2velY = 20;
int rectSize = 100;

int paddleHeight = 90;
int paddleWidth = 10;
int pad1xpos = 0;
int pad1ypos = 250;
int pad2xpos = 490;
int pad2ypos = 250;
int initpad1Xpos = pad1xpos;
int initpad2Xpos = pad2xpos;

int count = 0;
int lastAvgDepth = 0;
int [] rawDepthData; 
int rawDepthDataSum;
int rawDepthDataSum2;
int rawDepthDataLth; 
int rawDepthDataAvg;
int rawDepthDataIndex;
int [] rawDepthData2;
int rawDepthDataIndex2;
int rawDepthDataAvg2;

boolean absoluteWinFlag = false;
boolean firstTimeTest = true; 

int dataIsBigger;
int dataIsSmaller;
int dataIsEqual;
// boolean absoluteWinFlag = 

void setup() {
    size(500, 500, P2D);
    noStroke(); //Disabling the outline of shapes
    ellipseMode(RADIUS);

    kinect = new KinectPV2(this);
    kinect.enableDepthImg(true);
    kinect.init();
    frameRate(120);
}

void draw() {
    background(0, 0, 0);
    //values for [0 - 256] strip
    rawDepthData = kinect.getRawDepth256Data();
    // rawDepthDataIndex = rawDepthData.length / 2;
    rawDepthDataLth = rawDepthData.length;
        
    for (int index = 0; index < rawDepthDataLth; index += 80) {
        rawDepthDataSum += rawDepthData[index];
    }

    rawDepthDataAvg = rawDepthDataSum / rawDepthDataLth;

    delay(100);

    // if (count == 0) {
    // lastAvgDepth = rawDepthDataSum / rawDepthDataLth;

    // rawDepthDataAvg = rawDepthData[rawDepthDataIndex];
    //   collide();
    move();
    
    
    display();
}

void move() {
    // Pong game mechanics

    absoluteWinFlag = false;
   
    // rawDepthDataAvg2 = rawDepthDataSum2 / rawDepthData2.length;

    // If the ball his the y-axis walls
    if (ballposy > windowY || ballposy < 0 ) {
        ballvelY = ballvelY * -1; // Going a little faster...
        // ballposy = ballposy + ballvelY;
    }

    // If the ball goes out of right boundary (left side wins)
    if ( ballposx < 0 ) {
        leftSideScore = leftSideScore + 1; 
        absoluteWinFlag = true;
        // Maybe a reset method?
    }
    
    else if (ballposx > windowX) {
        rightSideScore += 1;
        absoluteWinFlag = true;
        // init() method need to be called here!
        // Maybe let ball go back?
    }

    /* print("trial number #" + count);
    print("dataIsBigger:" + dataIsBigger);
    print("dataIsSmaller:" + dataIsSmaller); 
    print("dataIsEqual:" + dataIsEqual);

    else if ( rawDepthDataAvg == lastAvgDepth) { 
        print("It's a trap!");
    } */
    
    // Moving the paddles by pressing keys
    if (keyPressed) {
        /* if (key == 'w') {
            pad1ypos -= paddlevelY;
        }
        else if (key == 's') {
            pad1ypos += paddlevelY;
        }
        */
        if (key == 'o') {
            pad2ypos -= paddlevelY;
        }
        else if (key == 'l') {
            pad2ypos += paddlevelY;
        }
    }

    rawDepthData2 = kinect.getRawDepth256Data();
    
    for (int i = 0; i < rawDepthData2.length; i += 80) {
        if (rawDepthData2[i] > rawDepthData[i]) { 
            dataIsBigger += 1; 
        }
        else if (rawDepthData2[i] < rawDepthData[i]) {
            dataIsSmaller += 1;
        }
        else if (rawDepthData2[i] == rawDepthData[i]) { 
            dataIsEqual += 1;
        }
    }

    if (dataIsEqual <= dataIsBigger + dataIsSmaller) { // Number of the beast... 
        if ( dataIsBigger > dataIsSmaller) {
            // firstTimeTest = false;
            pad1ypos -= paddle2velY; // Woah, slow down!
        }

        else if ( dataIsSmaller > dataIsBigger) { 
            // firstTimeTest = false;
            pad1ypos += paddle2velY;
        }
    }

    dataIsBigger = 0;
    dataIsEqual = 0;
    dataIsSmaller = 0;
    count += 1;

    if (pad1ypos < 0) {
        pad1ypos = 0;
    }
    else if (pad1ypos > windowY - paddleHeight/2) { 
        pad1ypos = windowY - paddleHeight/2;
    }
     
    if (pad2ypos < 0) {
        pad2ypos = 0;
    }
    else if (pad2ypos > windowY - paddleHeight/2) { 
        pad2ypos = windowY - paddleHeight/2;
    }

    if ( ballposx == pad1xpos && ballposy-rad >= pad1ypos && ballposy+rad <= pad1ypos+paddleHeight ) {
        ballvelX *= -1;
    } 

    else if ( ballposx == pad2xpos && ballposy-rad >= pad2ypos && ballposy+rad <= pad2ypos+paddleHeight ) {
        ballvelX *= -1;
    }

    ballposx = ballposx + ballvelX; // Updating the ball's speed
    ballposy = ballposy + ballvelY;

}

void init() {
    clear();
    background(0, 0, 0);
    ellipse(windowX/2, windowY/2, rad, rad);
    rect(initpad1Xpos, windowY/2, paddleWidth, paddleHeight);
    rect(initpad2Xpos, windowY/2, paddleWidth, paddleHeight);
    pad1ypos = 250;
    pad2ypos = 250;
    absoluteWinFlag = false;
    ballposx = windowX/2;
    ballposy = windowY/2;
    rawDepthDataAvg = 0;
    rawDepthDataAvg2 = 0;
    firstTimeTest = true;
}

void display() {
    fill(255);
    rect(pad1xpos, pad1ypos, paddleWidth, paddleHeight); // Paddle 1
    rect(pad2xpos, pad2ypos, paddleWidth, paddleHeight); // Paddle 2
    // Left/Right side scores 

    ellipse(ballposx, ballposy, rad, rad);
    
    fill(255, 255, 255);
    PFont myFont;
    myFont = createFont("Georgia", 32);
    textFont(myFont);
    textAlign(CENTER, CENTER);
    text("Score:"+leftSideScore, 100, 50);
    text("Score:"+rightSideScore, windowY-100, 50);

    fill(255);

    if (absoluteWinFlag) {
        int indicator = int(random(1,10));
        if (indicator <= 5) { 
            ballvelX *= -1;
            ballvelY *= -1;
        }
        else { 
            ballvelX *= -1;
        }
        //int ballvelX = int(random(2, 4));
        //int ballvelY = int(random(2, 4));

        init();
    }
}