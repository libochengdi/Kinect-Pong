import KinectPV2.*;

KinectPV2 kinect; 

int dataIsBigger; 
int dataIsEqual; 
int dataIsSmaller;
int count;

int [] rawDepthData;
int [] rawDepthData2;

void setup() {
    kinect = new KinectPV2(this);
    kinect.enableDepthImg(true);
    kinect.init();
}

void draw() {
    rawDepthData = kinect.getRawDepth256Data();
   
    delay(60); 

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

    print("Trial#" + count);
    print("dataIsBigger:" + dataIsBigger);
    print("dataIsSmaller:" + dataIsSmaller); 
    print("dataIsEqual:" + dataIsSmaller + "\n");

    dataIsBigger = 0;
    dataIsEqual = 0; 
    dataIsSmaller = 0;  
}