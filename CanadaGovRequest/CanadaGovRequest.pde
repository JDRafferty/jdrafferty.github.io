String fileName="Canada.csv";
String[] allData;
ArrayList<BiennialSet> allSets=new ArrayList<BiennialSet>();
int[] mins=new int[4];
int[] maxs=new int[4];
int[] usermins=new int[4];
int[] usermaxs=new int[4];
int overallUserMin, overallUserMax;
int overallMin, overallMax;
int margin, graphHeight, spaceX;
int currGroup=1;
float speed=1;
int userCount;

//just my little clock
int index=0;
int sec=0;
int minute=0;
boolean animation=false;

//universal y value marker
float[] ym={500, 500, 500, 500};

//diameter of the circles
float[] rm={0, 0, 0, 0};

//spacing inside the circle
float[] adjRU;

//animation time span
int animIndex=0;

boolean[] arrived={false, false, false, false};
boolean[] circFormed={false, false, false, false};
boolean loopedOnce=false;


void setup() {
  size(800, 500);
  parseData();
}

void draw() {
  counter();
  background(255);

  if (keyPressed) {
    if (key=='q') {
      animation=true;
    } else if (key=='e') {
      animation=false;
    }
  }
  anim();
  //wallPaper();
  for (BiennialSet dataSet : allSets) {
    dataSet.display();
  }
  drawGUI();
  animationV2();
  refCircle();
}

void drawGUI() {
  for (BiennialSet s : allSets) {
    if (s.group==currGroup) {
      for (int i=0; i<s.requestF.length; i++) {
        smooth();
        textSize(13);
        //y margin title
        textAlign(RIGHT);
        fill(0);
        text("requests made", margin, margin-50, 5);
        //bottom y margin
        textAlign(CENTER);
        text(s.minf, margin, height-margin, 5);
        //top y margin
        text(s.maxf, margin, margin, 5);

        if (arrived[i]==true) {
          //each year recordings 
          textAlign(CENTER);
          text("requests :" +s.requestF[i], s.pos[i].x, ym[i]+20+rm[i]/2, 5);
          textAlign(CENTER);
          //adjAccount[i] =(int)map(globalAdjR, 0, adjRU[i], 0, s.users[i]);
          text("accounts :" +s.users[i]+"/ "+userCount, s.pos[i].x, ym[i]+10+rm[i]/2, 5);
          textAlign(CENTER);
          text(s.year[i], s.pos[i].x, ym[i]-20-rm[i]/2, 5);
        }
      }
    }
  }
}
void counter() {
  if (index<60) {
    index++;
  } else if (index==60) {
    index=0;
    sec++;
  } 
  if (sec>5) {
    minute++;
    sec=0;
  } //else if (minute==2) {
  // minute=0;
  // }
}

void refCircle() {
  if (mousePressed) {
    for (int i=0; i<300; i+=20) {
      float radiMax=map(overallUserMax, overallUserMin, overallUserMax, 0, 300);
      float adjC=map(i, 0, 300, 0, radiMax);
      fill(255-adjC, 0, adjC*2, adjC*4);
      noStroke();
      fill(radiMax, 0, adjC, adjC*4);
      ellipse(mouseX, mouseY, radiMax-i, radiMax-i);
    }
  }
}

void anim() {
  //sets the value for adjRU which is the universal tracker for each circles spacing
  //this is to record them so when the uni y markers are on the move they keep a recording
  //of the previous groups spacing
  //i only want the spacings of the inside to change when the
  for (BiennialSet s : allSets) {
    if (currGroup>1) {
      if (s.group==currGroup-1) {
        adjRU=s.Radius;
      }
    } else if (currGroup==1&&loopedOnce==false) {
      if (s.group==currGroup) {
        adjRU=s.Radius;
      }
    } else if (currGroup==1&&loopedOnce==true) {
      if (s.group==currGroup+3) {
        adjRU=s.Radius;
      }
    }
  }
  if (animation==true) {
    if (sec==5&&index==60) {

      if (currGroup<4) {
        currGroup++;
      } else if (currGroup==4) {
        currGroup=1;
      }
    }
  }
  if (currGroup==4) {
    loopedOnce=true;
  }
}

void animationV2() {
  if (circFormed[0]&&circFormed[1]&&circFormed[2]&&circFormed[3]) {
    if (animIndex<100) {
      animIndex++;
      //save(currGroup+"Canada.png");
    } else if (animIndex>=100) {
      animIndex=0;
      if (currGroup<4) {
        currGroup++;
      } else if (currGroup==4) {
        currGroup=1;
      }
    }
  }
}

void keyPressed() {
  if (key=='w') {
    if (currGroup<4) {
      currGroup++;
    } else if (currGroup==4) {
      currGroup=1;
    }
  }
}

void parseData() {
  allData=loadStrings(fileName);
  for (int i=3; i<allData.length-1; i+=4) {
    BiennialSet dataSet=new BiennialSet();
    for (int j=0; j<4; j++) {
      String[] thisRow=split(allData[i+j], ",");
      //  printArray(thisRow);
      float groupAdj=map(i, 2, allData.length-1, 1, 5);
      dataSet.group=int(groupAdj);
      dataSet.year[j]=thisRow[0];
      dataSet.requestF[j]=int(thisRow[11]);
      dataSet.users[j]=int(thisRow[13]);
      userCount+=dataSet.users[j];
    }
    dataSet.getMinMax();
    allSets.add(dataSet);
  }
  for (int i=0; i<allSets.size(); i++) {
    BiennialSet dataSet=allSets.get(i);
    mins[i]=dataSet.minf;
    maxs[i]=dataSet.maxf;
    usermins[i]=dataSet.minUsers;
    usermaxs[i]=dataSet.maxUsers;
  }

  overallMin=min(mins);
  overallMax=max(maxs);
  overallUserMin=min(usermins);
  overallUserMax=max(usermaxs);
  for (int i=0; i<allSets.size(); i++) {
    BiennialSet dataSet=allSets.get(i);
    int groupid=dataSet.group;
    int[] requestFid=dataSet.requestF;
    int[] usersid=dataSet.users;
    String[] yearid=dataSet.year;
  }

  margin=50;
  graphHeight=height-margin*2;
  spaceX=(width+margin*2)/4+1;
  for (BiennialSet dataSet : allSets) {
    dataSet.setValue();
  }
}

void wallPaper() {
  for (int i=0; i<width; i+=50) {
    float adjW=map(i, 0, width, 0, width-margin*2);
    float adjC=map(currGroup*i, 0, 6400, 255, 0);
    float adjM=map(currGroup+1, 0, 3, 0, width+margin);
    fill(adjC);
    noStroke();
    rectMode(CORNER);
    rect(margin+adjW, 0, 50, height);
  }
  //stroke(0);
  //line(margin,0,margin,height);
  //line(width-margin,0,width-margin,height);
}
