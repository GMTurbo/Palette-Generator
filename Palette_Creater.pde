int numColors = 360/10;
int wheelDiameter = 250;
float colorSpacing = 0.25;
int wheelThickness = 10;
ArrayList<Point> points = new ArrayList<Point>();
boolean showText = false;
boolean lockPoints = true;
boolean lines = true;
PFont f;
void setup()
{
  size(640, 500);
  colorMode(HSB, 360, 100, 100);
  frameRate(30);
  c = 255;
  f = createFont("American Typewriter", 10, true);//32
  textFont(f);
  textSize(10);
  textAlign(LEFT, LEFT);
}

void draw(){
   background(0);
  
  strokeWeight(wheelThickness);
  noFill();
  smooth();
  strokeCap(SQUARE);
  
  int colorAngle = 360 / numColors;
  
  translate(width / 2, height / 2);
  
  for(int i = 0; i < 4*numColors; i++)
  {
    float startAngle = i * 0.25 * colorAngle + colorSpacing;
    float stopAngle = (i * 0.25 + 1) * colorAngle - colorSpacing;
    
    stroke(startAngle, 100, 100); // 80,90
    arc(0, 0, wheelDiameter, wheelDiameter, radians(startAngle), radians(stopAngle));
  }
  strokeWeight(1);
  fill(255);
  textSize(14);
  stroke(255);
  fill(360);
  textAlign(LEFT, LEFT);
  if(showText){
    text("keys:\n\tf = toggle fixed points\n\tl = toggle lines\n\tr = toggle animate", -160, height/2-70);
    text("mouse:\n\tclick = add color trace\n\tctrl-click = remove color trace\n\tclick & drag = move color trace", -10, height/2-70);
  }else{
    text("t = toggle text", -50, height/2 - 10);
  }
  
  int dotSize = 15;
  if(points.size()> 1 && lines){
    //connected
    
  for(int i = 1 ; i < points.size(); i++)
    line(points.get(i-1).x - dotSize, points.get(i-1).y - dotSize, points.get(i).x - dotSize, points.get(i).y - dotSize);
  line(points.get(0).x - dotSize, points.get(0).y - dotSize, points.get(points.size()-1).x - dotSize, points.get(points.size()-1).y - dotSize);
  
     //from Center
    for(int i = 0 ; i < points.size(); i++)
      line(points.get(i).x - dotSize, points.get(i).y - dotSize, 0, 0);
  }
  
  for(Point p : points){
   stroke(0);
   fill(GetColorFromAngle(p.angle));
   arcBound(p.x - dotSize, p.y - dotSize, 80, 80, p.angle - radians(30), p.angle + radians(30));
   println("angle = " + p.angle);
  }
  
  stroke(360);
  //noFill();
  if(points.size() > 0){
  fill(0);
  stroke(360);
  textAlign(CENTER, CENTER);
  textSize(18);
  color c = GetColorFromAngle(points.get(0).angle);
  if(showText)
    text("#" + hex(c), -width/2 + width/12 , -height/2 + (height/points.size())/2);  //-width/2

  for(int i = 0 ; i< points.size(); i++){
      c = GetColorFromAngle(points.get(i).angle);
     
      fill(c);
      rect(-width/2,  -height/2 + (height/points.size()) + i * (height/points.size()), width/6, -(height/points.size()));
      rect( width/2 - width/6,  -height/2 + (height/points.size()) + i * (height/points.size()), width/6, -(height/points.size()));  
      fill(360);
      stroke(360);
      if(showText)
        text("#"+hex(c), -width/2 + width/12 , -height/2 + (height/points.size()) + i * (height/points.size()) - (height/points.size()) / 2);  //-width/2
    }
  }
  
  if(run){
    if(lockPoints)
      RotatePoints(0,  rotation % (2*PI));
    else
      RotatePoints(-1,  speed);
    rotation += speed;
  }
}

void arcBound( float x, float y, float w, float h, float s, float e ){
  stroke(360);
  strokeWeight(3);
  arc(x, y, w, h, s, e );
  line( x, y, x + w/2.0 * cos(s), y + h/2.0 * sin(s) );
  line( x, y, x + w/2.0 * cos(e), y + h/2.0 * sin(e) );
}

float speed = PI/100;
float rotation = 0;

void AddPointToColorCircle(int x, int y){
  
   points.add(new Point(x, y, 0));
   int size = points.size();
   points.clear();
   float step = 360.0/float(size);
   for(int i = 0 ; i < size; i++){
      float angle = i * step;
      //println("angle = " +i * step);
      angle *= PI/180;
      points.add(new Point((int)(wheelDiameter/2 * cos(angle)) + 10,  (int)(wheelDiameter/2 * sin(angle)) + 10, angle));
    }
}

void RotatePoints(int index, float ang){
    if(points.size() == 0)
      return;
      
    float step = (2*PI)/float(points.size());
    int count = 0;
    if(index > -1){
      for(int i = index ; i < points.size(); i++){
        float angle = ang + count * step;
        //println("angle = "+ ang + count * step);
       // angle *= PI/180;
        points.get(i).x = (int)(wheelDiameter/2 * cos(angle)) + 15;
        points.get(i).y = (int)(wheelDiameter/2 * sin(angle)) + 15;
        points.get(i).angle = angle;
        count++;
      }
      
      for(int i = 0 ; i < index; i++){
        float angle = ang + count * step;
        //println("angle = " + ang + count * step);
        //angle *= PI/180;
        points.get(i).x = (int)(wheelDiameter/2 * cos(angle)) + 15;
        points.get(i).y = (int)(wheelDiameter/2 * sin(angle)) + 15;
        points.get(i).angle = angle;
        count++;
      }
    }else{
      for(int i = 0 ; i < points.size(); i++){
        points.get(i).angle += ang;
        //println("angle = " + points.get(i).angle);
        //angle *= PI/180;
        points.get(i).x = (int)(wheelDiameter/2 * cos(points.get(i).angle)) + 15;
        points.get(i).y = (int)(wheelDiameter/2 * sin(points.get(i).angle)) + 15;
       // points.get(i).angle = angle;
        count++;
      }
    }
     
}
color GetColorFromAngle(float angle){
 return color(degrees(2*PI + angle)%360, 100, 100); 
}
color c;
void mouseDragged(){
    println("mouseMoved");
   if(mousePressed && foundIndex != -1 ){
       if(!lockPoints){
         points.get(foundIndex).angle = atan2(mouseY - height/2 ,mouseX - width/2);
         points.get(foundIndex).x = (int)(wheelDiameter/2 * cos(points.get(foundIndex).angle)) + 15; 
         points.get(foundIndex).y = (int)(wheelDiameter/2 * sin(points.get(foundIndex).angle)) + 15;
       }else{
         RotatePoints(foundIndex,  atan2(height/2 - mouseY,width/2 - mouseX));
       }
   }
}

void mouseReleased(){
  println("mouseReleased");
   foundIndex = -1; 
}

int foundIndex = -1;

void mousePressed(){
  println("mousePressed with key " + keyCode);
 // c = get(mouseX, mouseY);
  //if(c!=255){
      PVector vec;
      boolean found = false;
      //foundIndex = -1;
      for(Point p : points){
        vec = new PVector(p.x - (mouseX - width/2), p.y - (mouseY - height/2));
        if(vec.mag() < 50){
          foundIndex = points.indexOf(p);
          found = true;
          break;
        }
      }
      vec = new PVector((mouseX - width/2),(mouseY - height/2));
      //i//f(){
     if(!found && !lockPoints && vec.mag() < wheelDiameter/2 + 30){
       //float angle = atan2(mouseY - height/2 ,mouseX - width/2);
       points.add(new Point(mouseX - width/2, mouseY - height/2, 0));
       points.get(points.size()-1).angle = atan2(mouseY - height/2 ,mouseX - width/2);
       points.get(points.size()-1).x = (int)(wheelDiameter/2 * cos(points.get(points.size()-1).angle)) + 15; 
       points.get(points.size()-1).y = (int)(wheelDiameter/2 * sin(points.get(points.size()-1).angle)) + 15;
     }
     else if(!found && lockPoints){
       AddPointToColorCircle(mouseX - width/2, mouseY - height/2);
     }
     else if(mousePressed && keyPressed && keyCode == CONTROL)
       points.remove(foundIndex);
  //}
}
boolean run = false;
void keyPressed(){
  if(key == 'r'){
     run = !run; 
  }
  if( keyCode == UP ){
    speed += 0.01;
  }
  if( keyCode == DOWN ){
     speed -= 0.01; 
  }
  if(key == 'f'){
   lockPoints = !lockPoints; 
  }
  if(key == 'l'){
    lines = !lines;
  }
  if(key == 't'){
    showText = !showText; 
  }
}

class Point{
  int x, y;
  float angle;
   Point(int xpos, int ypos, float ang){
    x = xpos;
    y = ypos;
    angle = ang;
   } 
}
