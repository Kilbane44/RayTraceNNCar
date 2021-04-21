class Car extends Particle
{
  PVector accel;
  PVector vel;
  PVector dir;

  boolean alive = true;

  float angle;

  float speed;

  float coOfFric = .95;

  float topSpeed = 14;

  int fitness = 1;
  int score =0;


  float dTraveled=0;
  int checkTime =0;
  int timeOutDelay =4000;
  PVector prevPos;


  ArrayList<Token> cookies = new ArrayList<Token>();
  Car()
  {
    inputs = new float[RAY_COUNT+6];
    prevPos = new PVector(0, 0);
    for (int i=0; i < RAY_COUNT+6; i++)
    {
      inputs[i] = -1;
    }

    size = 20;
    ///Two output network or 4?
    nn = new NN(inputs, 1, 2);



    pos = new PVector(150, height/2);
    rays = new ArrayList<Ray>();

    accel = new PVector(0, 0);
    vel = new PVector(0, 0);

    angle = -PI/2;
    dir = PVector.fromAngle(angle);

    for (float i=0; i < 360; i+=360/RAY_COUNT)
    {
      rays.add(new Ray(pos, radians(i)));
    }


    cookies.add(new Token());

    for (Token cook : AllCookies)
    {
      cookies.add(new Token(cook));
    }

    nn.randomize();
    alive = true;
  }


  void Update()
  {
    Move();
    Draw();

    Brain();
    CheckTokens();
    HaveIMoved();
    DrawNet();
  }

  void Update(ArrayList<Boundary> b)
  {
    Move();
    Draw();
    LookAt(b);
    Brain();


    CheckTokens();
    HaveIMoved();

    if (SHOW_NET)
    {
      DrawNet();
    }
  }

  void HaveIMoved()
  {
    if (millis() - checkTime > timeOutDelay)
    {
      checkTime = millis();
      if (dist(prevPos.x, prevPos.y, pos.x, pos.y) < size)
      {
        //Reset();
        alive = false;
      }
      prevPos = pos.copy();
    }

    if (alive == false)
    {
      //Reset();
    }
  }


  void DrawNet()
  {

    for (int i=0; i < RAY_COUNT+6; i++)
    {
      fill(255);
      text(inputs[i], 50, 50+i*10);

      fill(255, 255, 0);
      text(nn.weights[i], 100, 50+i*10);
    }

    for (int i=0; i< nn.biases.length; i++)
    {
      fill(0, 255, 255);
      text(nn.biases[i], 130, 50+i*10);
    }
    //println( nn.outputs.length);
    for (int i=0; i < nn.outputs.length; i++)
    {
      fill(255, 0, 0);
      text(nn.outputs[i], 200, 50+i* 20);
    }
  }

  void Draw()
  {
    super.Draw();

    stroke(255, 0, 255);
    fill(255, 0, 255);
    PVector fwd = dir.copy();


    fwd.mult(10);
    ellipse(pos.x + fwd.x, pos.y+fwd.y, 4, 4);
    line(pos.x, pos.y, pos.x + fwd.x, pos.y+fwd.y);

    fwd.normalize();
    fwd.mult(20);
    stroke(0, 255, 0);
    line(pos.x, pos.y, pos.x + fwd.x, pos.y+fwd.y);
  }


  void Move()
  {
    dir = PVector.fromAngle(angle);
    dir.normalize();
    dir.mult(speed);


    // println(dir);
    pos.add(dir);


    if (speed > topSpeed)
    {
      speed = topSpeed;
    }

    if (speed < -topSpeed)
    {
      speed = -topSpeed;
    }

    //if(Shift)
    //{
    //  coOfFric = .80;
    //}
    //else
    //{
    //  coOfFric = .95;
    //}

    speed *=coOfFric;

    //W
    if (nn.outputs[0] > .5)
    {
      speed += .3;
    }
    //S
    else if (nn.outputs[0] < .5)
    {
      speed -= .3;
    }

    //A
    if (nn.outputs[1] > .5)
    {
      angle -= PI/60;

      //if (Shift)
      //{
      //  c.angle-=PI/120;
      //}
    }



    //D
    else if (nn.outputs[1] < .5)
    {
      angle += PI/60;
      //if (Shift)
      //{
      //  c.angle+=PI/120;
      //}
    }


    UpdatePos();
  }


  void LookAt(ArrayList<Boundary> w)
  {
    boolean reset = false;

    int i=0;
    for (Ray r : rays)
    {
      PVector closestPt = new PVector(0, 0);
      float closestDistance = 99999;
      for (Boundary wall : w)
      {
        PVector pt = r.Cast(wall);


        if (pt.x ==0 && pt.y == 0)
        {
        } else
        {
          float dToPoint =dist(pos.x, pos.y, pt.x, pt.y);
          if ( dToPoint< closestDistance)
          {
            closestDistance = dToPoint;
            closestPt.x = pt.x;
            closestPt.y = pt.y;

            //
            //
            //
            //
            //Set the NN brain inputs to the updated dist for each ray cast
            inputs[i] = dToPoint;
            //
            //
            //
            //



            //is player touchuing wall? DIE
            if (dist(closestPt.x, closestPt.y, pos.x, pos.y) < size/2)
            {
              alive = false;
              reset = true;
              break;
            }
          }
        }
      }

      if (reset)
      {
        break;
      }

      if (closestPt.x != 0 && closestPt.y !=0)
      {
        if (SHOW_RAYS)
        {
          stroke(255);
          fill(255);
          line(pos.x, pos.y, closestPt.x, closestPt.y);
          ellipse(closestPt.x, closestPt.y, 8, 8);
        }
      }

      i++;
    }

    if (reset)
    {
      //Reset();
    }
  }

  void Reset()
  {
    pos = new PVector(150, height/2);
    rays.clear();
    accel = new PVector(0, 0);
    vel = new PVector(0, 0);
    angle = -PI/2;
    dir = PVector.fromAngle(angle);
    alive = true;

    for (Token token : cookies)
    {
      token.touched = false;
    }
    fitness = 1;

    for (float i=0; i < 360; i+=360/RAY_COUNT)
    {
      rays.add(new Ray(pos, radians(i)));
    }
  }


  void Brain() {
    inputs[RAY_COUNT] =angle;
    inputs[RAY_COUNT+1] =speed;
    inputs[RAY_COUNT+2] =dir.x;
    inputs[RAY_COUNT+3] =dir.y;
    inputs[RAY_COUNT+4] =pos.x;
    inputs[RAY_COUNT+5] =pos.y;


    nn.compute();
  }





  void CheckTokens()
  {
    for (Token token : cookies)
    {
      if (dist(pos.x, pos.y, token.pos.x, token.pos.y) < (size/2 + token.size/2))
      {
        if (token.touched == false)
        {
          token.touched = true;
          fitness++;
        }
      }

      if (SHOW_TOKENS)
      {
        //token.Draw();
      }
    }
  }


  String toString()
  {
    String finalOutput ="";

    finalOutput += fitness;
    finalOutput += "\n";

    for (int i=0; i < nn.weights.length; i++)
    {
      finalOutput += nn.weights[i];
      finalOutput += " ";
    }
    finalOutput += "\n";

    for (int i=0; i < nn.biases.length; i++)
    {
      finalOutput += nn.biases[i];
      finalOutput += " ";
    }
    //Fit / Weights / Biases

    return finalOutput;
  }
}
