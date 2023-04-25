Ball ball;
Player player;
Brick[] bricks = new Brick[23];

void setup() {
  size(800, 600);
  player = new Player();
  ball = new Ball();
  int counter = 0;
  for (int i=0; i<=2; i+=1) {
    int row=8;
    if (i%2==1) {
      row=7;
    }
    for (int j=0; j<row; j++) {
      if (row==8) {
        bricks[counter] = new Brick(j*width/8+5, ((i)*height/10+5)+height/40);
      } else if (row==7) {
        bricks[counter] = new Brick((j*width/8+5+50), ((i)*height/10+5)+height/40);
      }
      counter++;
    }
  }
}

void draw() {
  background(0);
  noStroke();
  if (ball.vel.y==0) {
    if (frameCount%60<=30) {
      fill(255);
    } else {
      fill(0);
    }
    textSize(33);
    textAlign(CENTER);
    text("Press SPACE to start!", width/2, height*5/7);
    fill(255);
    ball.pos.x=player.pos.x+player.size.x/2;
    ball.gameStart();
  }
  boolean end = true;
  for (int i=0; i<bricks.length; i++) {
    if (bricks[i].alive==true) {
      bricks[i].show();
      ball.brickBounce(bricks[i].pos.x, bricks[i].pos.y, i);
      end = false;
    }
  }
  if (end==true) {
    gameOver();
  }
  player.move();
  ball.playerBounce();
  ball.borderBounce();
  player.show();
  ball.show();
}

class Player {
  int vel = 6;
  PVector size = new PVector (width/8, height/40);
  PVector pos = new PVector (width/2-size.x/2, 38*height/40);

  void show() {
    rect(pos.x, pos.y, size.x, size.y);
  }

  void move() {
    if (keyPressed && (key=='a' || keyCode==LEFT) && pos.x>0) {
      pos.x-=vel;
    }
    if (keyPressed && (key=='d' || keyCode==RIGHT) && pos.x<width-size.x) {
      pos.x+=vel;
    }
  }
}

class Ball {
  PVector pos = new PVector(width/2, player.pos.y-8);
  PVector vel = new PVector(0, 0);

  void show() {
    pos.add(vel);
    ellipse(pos.x, pos.y, 16, 16);
  }

  void gameStart() {
    if (keyCode==32) {
      vel.y=-5;
      vel.x=random(-5/3*abs(vel.y), 5/3*abs(vel.y) );
    }
  }

  void borderBounce() {
    if (pos.x<=8 || pos.x>=width-8) {
      vel.x*=-1;
    }
    if (pos.y<=8) {
      vel.y*=-1;
    }
    if (pos.y>=height-8) {
      gameOver();
    }
  }

  void playerBounce() {
    if (pos.y>=38*height/40-7 && pos.x<=player.pos.x + player.size.x+8 && pos.x>=player.pos.x-8) {
      float hit = pos.x - player.pos.x;
      if (hit<50) {
        vel.x=-vel.y*((5/3)*((50-hit)/50));
      } else if (hit>50) {
        vel.x=vel.y*((5/3)*((hit-50)/50));
      } else {
        vel.x=0;
      }
      vel.y=-vel.y-0.1;
    }
  }

  void brickBounce(float x, float y, int i) {
    if (pos.y>=y-8 && pos.y<=y+height/10-2 && pos.x<=x+width/8-2 && pos.x>=x-8) {
      if (pos.y<=y+height/10-8 && pos.y>=y+8) {
        vel.x=-vel.x;
        bricks[i].alive=false;
      }
      if (pos.x<=x+width/8-4 && pos.x>=x+4) {
        vel.y=-vel.y;
        bricks[i].alive=false;
      }
    }
  }
}

class Brick {
  PVector pos = new PVector(0, 0);
  boolean alive = true;
  PVector size = new PVector(width/8-10, height/10-10);

  Brick(int x, int y) {
    pos.x=x;
    pos.y=y;
  }

  void show() {
    rect(pos.x, pos.y, size.x, size.y);
  }
}

void gameOver() {
  ball.pos = new PVector(width/2, player.pos.y-8);
  ball.vel = new PVector(0, 0);
  int counter = 0;
  for (int i=0; i<=2; i+=1) {
    int row=8;
    if (i%2==1) {
      row=7;
    }
    for (int j=0; j<row; j++) {
      if (row==8) {
        bricks[counter] = new Brick(j*width/8+5, ((i)*height/10+5)+height/40);
      } else if (row==7) {
        bricks[counter] = new Brick((j*width/8+5+50), ((i)*height/10+5)+height/40);
      }
      counter++;
    }
  }
}
