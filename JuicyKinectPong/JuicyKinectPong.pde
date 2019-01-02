import KinectPV2.*;
// KinectV2 kinect;

int leftSideScore = 0;
int rightSideScore = 0;
int windowX = 500;
int windowY = 500;

int rad = 10;
int ballposx = 250;
int ballposy = 250;
float xpos = 150; 
float ypos = 150;
int ballvelX = int(random(2, 4));
int ballvelY = int(random(2, 4));
int paddlevelY = 5; 
int rectSize = 100;

int paddleHeight = 90;
int paddleWidth = 10;
int pad1xpos = 0; 
int pad1ypos = 250;
int pad2xpos = 490;
int pad2ypos = 250;
int initpad1Xpos = pad1xpos;
int initpad2Xpos = pad2xpos;

boolean absoluteWinFlag = false;

// boolean absoluteWinFlag = 

void setup() {   
    size(500, 500);
    noStroke(); //Disabling the outline of shapes
    ellipseMode(RADIUS);
}

void draw() {
    background(0, 0, 0);
    move();
    display();
}

void move() {
    // Pong game mechanics

    absoluteWinFlag = false;

    if (pad1ypos < 0) {
        pad1ypos += paddlevelY;
    }
    else if (pad1ypos > windowY - paddleHeight/2) { 
        pad1ypos -= paddlevelY;
    }
     
    if (pad2ypos < 0) {
        pad2ypos += paddlevelY;
    }
    else if (pad2ypos > windowY - paddleHeight/2) { 
        pad2ypos -= paddlevelY;
    }

    if ( ballposx == pad1xpos && ballposy >= pad1ypos && ballposy <= pad1ypos+paddleHeight ) {
        ballvelX *= -1.1;
    } 

    else if ( ballposx == pad2xpos && ballposy >= pad2ypos && ballposy <= pad2ypos+paddleHeight ) {
        ballvelX *= -1.1;
    }

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
    
    // Moving the paddles by pressing keys
    if (keyPressed) {
        if (key == 'w') {
            pad1ypos -= paddlevelY;
        }
        else if (key == 's') {
            pad1ypos += paddlevelY;
        }
        else if (key == 'o') {
            pad2ypos -= paddlevelY;
        }
        else if (key == 'l') {
            pad2ypos += paddlevelY;
        }
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
    absoluteWinFlag = false;
    ballposx = windowX/2;
    ballposy = windowY/2;
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