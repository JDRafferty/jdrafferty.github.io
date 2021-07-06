class BiennialSet {
  int group;
  int[] requestF=new int[4];
  int[] users=new int[4];
  String[] year=new String[4];
  int minf, maxf;
  int minUsers, maxUsers;
  PVector[] pos=new PVector[4];
  float[] Radius=new float[4];
  int[] adjAccount = new int[4];

  float x=0;
  BiennialSet() {
  }

  void display() {
    if (currGroup==group) {
      textSize(50);
      fill(0);
      text(group, 10, 50);
      for (int i=0; i<pos.length; i++) {
        fill(0);
        noStroke();
        //ellipse(pos[i].x, pos[i].y, 15, 15);
      //if the universal y position marker (ym) is less than or more than the current groups y position value 
      //then please add or subtract the ym until it gets there
        if (ym[i]>pos[i].y) {
          ym[i]-=1;
        } else if (ym[i]<pos[i].y) {
          ym[i]+=1;
        }
        
        //this is to widen the scope of when the universal y position marker has made it to the current groups y value
        //becouse the y values of each groups are mapped and therefore decimals, it would be hard to create an algorithmn
        //to determin what exactly should be added or subtracted to the ym to make it match the current groups y value. 
        //ya know? So the range of the y value is 3 obove it and 3 below it. :) 
        //the array of boolean expressions arrived are to help me determine when all unversal y markers have gone into place
        //so they can start drwing their circles that represent the number of accounts
        if (ym[i]<pos[i].y+3&&ym[i]>pos[i].y-3) {
          arrived[i]=true;
        } else {
          arrived[i]=false;
        }

        fill(255, 00, 100);
        // ellipse(pos[i].x, ym[i], 10, 10);
        //if the previous y pos arrived at the current groups ypos then update the circles size
        //if not then keep using the prev size
        if (arrived[i]==true) {
          if (rm[i]<Radius[i]) {
            rm[i]+=0.5;
            
          } else if (rm[i]>Radius[i]) {
            rm[i]-=0.5;
          }
        }
        
        if(rm[i]<Radius[i]+3&&rm[i]>Radius[i]-3){
         circFormed[i]=true;
        }else{
         circFormed[i]=false; 
        }
        //draw circle representing ammount of users
        for (int j=0; j<300; j+=25) {
          float adjR=0;
         //if the prev y pos has arrived at the current groups y pos then please adjust the spacing of the circles
         //on the inside if not make the spaces between the inside circles the same as the previous groups adjustments ya?
          if (arrived[i]==true) {
            adjR=map(j, 0, 300, 0, Radius[i]);
          } else if (arrived[i]==false) {
            adjR=map(j, 0, 300, 0, adjRU[i]);
          }
          fill(adjR*2, adjR/4, adjR/2, adjR*4);

          ellipse(pos[i].x, ym[i], rm[i]-adjR, rm[i]-adjR);
  
        }
        //line graph
        if (i>0) {
          stroke(200, 0, 0, 120);
          strokeWeight(2);

          line(pos[i].x, ym[i], pos[i-1].x, ym[i-1]);
        }
      }
    }
  }

  void drawGUI() {
  }
  void getMinMax() {
    minf=min(requestF);
    maxf=max(requestF);
    minUsers=min(users);
    maxUsers=max(users);
  }

  void setValue() {
    for (int i=0; i<requestF.length; i++) {
      int adjVal=int(map(requestF[i], overallMin, overallMax, 0, graphHeight));
      int adjRad=int(map(users[i], overallUserMin, overallUserMax, 0, 200));
      pos[i]=new PVector();
      pos[i].x=margin+(spaceX*i+1);
      pos[i].y=margin+graphHeight-adjVal;
      Radius[i]=adjRad;
    }
  }
}
