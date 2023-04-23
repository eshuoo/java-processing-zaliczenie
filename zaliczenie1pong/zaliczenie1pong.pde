Player p1, p2;
Ball ball;

void setup() {
  size(800, 600);
  ball = new Ball();
  p1 = new Player(1);
  p2 = new Player(2);
}

void draw() {
  background(0);
  strokeWeight(5);
  strokeCap(SQUARE);
  int colorswap=0;
  for (int i=0; i<height; i+=ceil(height/75)) {
    if (colorswap==0) {
      stroke(0);
      colorswap=1;
    } else {
      stroke(255);
      colorswap=0;
    }
    line(width/2, i, width/2, i+height/2);
  }
  strokeWeight(0);

  textSize(100);
  textAlign(CENTER);
  text(p1.points, width*1/4, height*1/5);
  text(p2.points, width*3/4, height*1/5);

  if (ball.vel.x==0) {
    ball.startGame();
  }
  ball.pos.add(ball.vel);
  ball.detectCollision();
  p1.move();
  p2.move();
  ball.show();
  p1.show();
  p2.show();
  ball.bounce();
  ball.point();
}

//clesses
class Player {
  int points = 0;
  int vel = 5;
  int size = 100;
  int number;
  PVector pos = new PVector(0, (height/2)-(size/2));

  Player(int number) {
    this.number = number;
    if (number==1) {
      pos.add(width*1/40, 0);
    } else {
      pos.add(width*38/40, 0);
    }
  }

  void show() {
    rect(pos.x, pos.y, width*1/40, size);
  }
  void move() {
    if (number==1 && keyPressed && key=='w' && pos.y>0) {
      pos.y-=vel;
    }
    if (number==1 && keyPressed && key=='s' && pos.y<500) {
      pos.y+=vel;
    }
    if (number==2 && keyPressed && keyCode==UP && pos.y>0) {
      pos.y-=vel;
    }
    if (number==2 && keyPressed && keyCode==DOWN && pos.y<500) {
      pos.y+=vel;
    }
  }
}

class Ball {
  PVector pos = new PVector(width/2, height/2);
  PVector vel = new PVector(0, 0);

  void show() {
    fill(255);
    ellipse(pos.x, pos.y, 16, 16);
  }
  void startGame() {
    if (keyPressed) {
      if (random(2)<1) {
        vel.x+=3;
      } else {
        vel.x-=3;
      }
      vel.y=random(-4/3*vel.x, 4/3*vel.x);
    }
  }
  void bounce() {
    if (pos.y<8 || pos.y>height-8) {
      vel.y*=-1;
    }
  }
  void point() {
    if (pos.x<=0) {
      p2.points+=1;
      pos.set(width/2, height/2);
      vel.set(0, 0);
    } else if (pos.x>=width) {
      p1.points+=1;
      pos.set(width/2, height/2);
      vel.set(0, 0);
    }
  }
  void detectCollision() {
    if (pos.x<=width*2/40+8 && pos.y>=p1.pos.y-8 && pos.y<=p1.pos.y+108) {
      float hit = pos.y-p1.pos.y;
      if (hit<50) {
        vel.y=-abs(vel.x)*((4/3)*((50-hit)/50));
      } else if (hit>50) {
        vel.y=abs(vel.x)*((4/3)*((hit-50)/50));
      } else {
        vel.y=0;
      }
      vel.x=abs(vel.x)+0.5;
    } else if (pos.x>=width*38/40-8 && pos.y>=p2.pos.y-8 && pos.y<=p2.pos.y+108) {
      float hit = pos.y-p2.pos.y;
      if (hit<50) {
        vel.y=-abs(vel.x)*((4/3)*((50-hit)/50));
      } else if (hit>50) {
        vel.y=abs(vel.x)*((4/3)*((hit-50)/50));
      } else {
        vel.y=0;
      }
      vel.x=-abs(vel.x)-0.5;
    }
  }
}
