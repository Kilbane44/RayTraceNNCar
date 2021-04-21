 //<>//
Boundary wall;
Ray ray;
Particle player;


boolean W, A, S, D, Shift = false;


////////////////////////////////Player Count//////////////////////////////
int number_of_players =1000;
float mutRate = 10;


boolean SHOW_TOKENS = false;
boolean SHOW_RAYS = false;
boolean SHOW_NET = false;


PrintWriter output;

PVector newPointA = new PVector(0, 0);
PVector newPointB = new PVector(0, 0);

ArrayList<Boundary> walls = new ArrayList<Boundary>();

Car[] savedBrains;
Car[] childPlayers;
int fit_sum;
int[] fitness_scores;
int[] fit_array;
int movingIndex = 0;

int fit_record = 0;

Car parentone;
Car child;







int genCounter=1;
Population population;




ArrayList<Token> AllCookies = new ArrayList<Token>();

String level = "raceTrack.txt";
//Token tok = new Token();
void setup()
{
  size(800, 800, P2D);
  // wall = new Boundary(300,100,300,300);

  //walls.add(wall);
  //walls.add(new Boundary(200,200,150,100));
  player = new Particle();

  walls.add(new Boundary(1, 1, width, 1));
  walls.add(new Boundary(width, 0, width, height));
  walls.add(new Boundary(width, height, 1, height));
  walls.add(new Boundary(1, height, 1, 1));

  LoadLevel(level);

  // c = new Car();

  childPlayers = new Car[number_of_players];
  for (int i = 0; i < number_of_players; i++) {
    childPlayers[i] = new Car();
  }

  savedBrains = new Car[number_of_players];
  for (int i = 0; i < number_of_players; i++) {
    savedBrains[i] = new Car();
    savedBrains[i].nn.randomize();
  }

 // AllCookies.add(new Token());
  parentone = new Car();
  child = new Car();
  population = new Population(number_of_players);
}



void draw()
{
  background(0);
  DrawWalls();
  DrawCookies();

  //Mouse Attached Particle
  player.SetPos(mouseX, mouseY);
  player.Draw();
  player.LookAt(walls);

  population.update(walls);

  textSize(20);
  text("Fitness Record: "+fit_record, 500, 50);
  text("Current Pop: "+ population.living_players, 500, 100);
  textSize(10);
  //Inputs(); WASD Player Movement
}


void DrawCookies()
{

  if (SHOW_TOKENS)
  {
    int i=0;
    for (Token cook : AllCookies)
    {
      fill(0);

      cook.Draw();
      text(i, cook.pos.x, cook.pos.y);
      i++;
    }
  }
}
void Inputs()
{
  /*
  //W
   if (W)
   {
   c.speed += .3;
   }
   //S
   else if (S)
   {
   c.speed -= .3;
   }
   
   //A
   if (A)
   {
   c.angle -= PI/60;
   
   //if (Shift)
   //{
   //  c.angle-=PI/120;
   //}
   }
   
   
   
   //D
   else if (D)
   {
   c.angle += PI/60;
   //if (Shift)
   //{
   //  c.angle+=PI/120;
   //}
   }
   */
}




void DrawWalls()
{
  for (Boundary ws : walls)
  {
    ws.Draw();
  }
}



void mousePressed()
{
  if (mouseButton == RIGHT)
  {
    newPointA = new PVector(mouseX, mouseY);
  }
}


void mouseReleased()
{
  if (mouseButton == RIGHT)
  {

    //CREATE WALL CODE
    //newPointB = new PVector(mouseX, mouseY);
    //walls.add(new Boundary(newPointA, newPointB));

    //int counter= 0;
    for (Car car : population.players)
    {
      car.cookies.add(new Token(mouseX, mouseY));
      //savedBrains[counter].cookies.add(new Token(mouseX, mouseY));
    }
    AllCookies.add(new Token(mouseX, mouseY));



    //c.cookies.add(new Token(mouseX, mouseY));
  }
}


void keyPressed()
{
  if (key == '0')
  {
    output = createWriter("level.txt");
    for (Boundary ws : walls)
    {
      output.println(ws.toString());
    }
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
  }
  if (key == '9')
  {
    output = createWriter("tokens.txt");
    for (Token tk : AllCookies)
    {
      output.println(tk.toString());
    }
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
  }


  if (key == '1')
  {
    SHOW_TOKENS = !SHOW_TOKENS;
    println("SHOW TOKENS: "+SHOW_TOKENS);
  }
  if (key == '2')
  {
    SHOW_RAYS = !SHOW_RAYS;
    println("SHOW RAYS: "+SHOW_RAYS);
  }

  //if (key=='w'||key=='W')
  //{
  //  W = true;
  //}
  //if (key=='a'||key=='A')
  //{
  //  A = true;
  //}
  //if (key=='s'||key=='S')
  //{
  //  S = true;
  //}
  //if (key=='d'||key=='D')
  //{
  //  D = true;
  //}
  //if (keyCode == SHIFT)
  //{
  //  Shift = true;
  //}

  if (key == 'c')
  {
    walls.clear();
  }
}


void keyReleased()
{
  if (key=='w' ||key=='W')
  {
    W = false;
  }
  if (key=='a'||key=='A')
  {
    A = false;
  }
  if (key=='s'||key=='A')
  {
    S = false;
  }
  if (key=='d'||key=='D')
  {
    D = false;
  }
  if (keyCode == SHIFT)
  {
    Shift = false;
  }
}



void LoadLevel(String s)
{
  String[] lines = loadStrings(s);

  for (int i=0; i < lines.length; i++)
  {
    String[] coords =lines[i].split(" ");

    walls.add(new Boundary(Float.parseFloat(coords[0]), Float.parseFloat(coords[1]), Float.parseFloat(coords[2]), Float.parseFloat(coords[3])));
  }


  lines = loadStrings("tokens.txt");

  if (lines != null)
  {
    for (int i=0; i < lines.length; i++)
    {
      String[] coords =lines[i].split(" ");

      AllCookies.add(new Token(Float.parseFloat(coords[0]), Float.parseFloat(coords[1])));
    }
  }
}





void restart() {
  if (population.allDead == true) {

    //added to population
    println("Generation: "+ genCounter);
    genCounter++;


    for (int i = 0; i < number_of_players; i++) {
      transferPlayer(population.players[i], savedBrains[i]);
    }

    selectParents();


    for (int i = 0; i < number_of_players; i++) {
      transferPlayer(childPlayers[i], savedBrains[i]);
    }

    population = new Population(number_of_players);
    population.allDead = false;
  }
}



void transferPlayer(Car toTransfer, Car toTransferTo) {
  toTransferTo.size = toTransfer.size;

  toTransferTo.cookies.clear();
  //toTransferTo.cookies = AllCookies;

  for (Token tk : AllCookies)
  {
    toTransferTo.cookies.add(new Token(tk));
  }
  toTransferTo.fitness = toTransfer.fitness;

  toTransferTo.pos = toTransfer.pos.copy();
  toTransferTo.angle = toTransfer.angle;
  toTransferTo.alive = toTransfer.alive;
  toTransferTo.dir = toTransfer.dir.copy();



  for (int i = 0; i < toTransfer.nn.weights.length; i++) {
    toTransferTo.nn.weights[i] = toTransfer.nn.weights[i];
  }
  for (int i = 0; i < toTransfer.nn.biases.length; i++) {
    toTransferTo.nn.biases[i] = toTransfer.nn.biases[i];
  }
}



void selectParents() {

  //SORT BY HIGHEST
  int number_of_best_players = 5;
  Car[] sortedCars = new Car[number_of_players];

  for (int i=0; i < number_of_players; i++)
  {
    sortedCars[i] = new Car();
    transferPlayer(savedBrains[i], sortedCars[i]);
  }

  for (int i=0; i < sortedCars.length; i++)
  {
    for (int j=0; j < sortedCars.length-1; j++)
    {
      if (sortedCars[j].fitness < sortedCars[j+1].fitness)
      {
        Car temp = new Car();
        transferPlayer(sortedCars[j], temp);
        transferPlayer(sortedCars[j+1], sortedCars[j]);
        transferPlayer(temp, sortedCars[j+1]);
      }
    }
  }

  //for(int i =0; i < 2; i++)
  //{
  //  transferPlayer(savedBrains[i], sortedCars[i]);
  //}


  //println("SORTED FITNESS");
  for (int i=0; i < sortedCars.length; i++)
  {
    //println(sortedCars[i].fitness);

    if (sortedCars[i].fitness > fit_record)
    {
      fit_record = sortedCars[i].fitness;
      println("NEW RECORD: "+ fit_record);

      if (fit_record >= 13)
      {
        output = createWriter("Champion/"+sortedCars[i].RAY_COUNT+"/"+fit_record+"/"+day()+"_"+month()+"_"+hour()+"_"+minute()+"_"+second()+"_"+millis()+".txt");

        output.println(sortedCars[i].toString());

        output.flush(); // Writes the remaining data to the file
        output.close();
        println("file write for champion");
      }
    }
  }






  //fit_sum = 0;
  //int[] fitness_scores = new int[number_of_players];
  //for (int i = 0; i < number_of_players; i++) {
  //  fitness_scores[i] = savedBrains[i].fitness;
  //  fit_sum += fitness_scores[i];
  //}





  //fit_sum = 0;
  //int[] fitness_scores = new int[number_of_players];
  //for (int i = 0; i < number_of_players; i++) {
  //  fitness_scores[i] = sortedCars[i].fitness;
  //  fit_sum += fitness_scores[i];
  //}




  //fit_array = new int[fit_sum];
  //movingIndex = 0;
  //for (int i = 0; i < fitness_scores.length; i++) {
  //  for (int w = 0; w < fitness_scores[i]; w++) {
  //    fit_array[movingIndex++] = i;
  //  }
  //}

  for (int i = 0; i < childPlayers.length; i++) {
    transferPlayer(savedBrains[i], childPlayers[i]);
  }

  // println("FIT LENGTH" + fit_array.length);

  for (int i=0; i< number_of_best_players; i++)
  {
    transferPlayer(sortedCars[i], childPlayers[i]);
  }

  for (int i = number_of_best_players; i < number_of_players; i++) 
  {
    //fit_array.length
    transferPlayer(sortedCars[int(random(number_of_best_players))], parentone);  
    makeChild(i);
  }
}



void makeChild(int i) {
  transferPlayer(parentone, child);
  //SET X VALUES OF FIRST TWO FOR LOOPS FOR ASEXUAL REPRODUCTION
  //Mutate
  for (int x = 0; x < child.nn.weights.length; x++) {
    if ((random(0, 100))<mutRate) {
      child.nn.weights[x] = random(-1, 1);
    }
  }
  for (int x = 0; x < child.nn.biases.length; x++) {
    if (random(0, 100)<mutRate) {
      child.nn.biases[x] = random(-1, 1);
    }
  }
  transferPlayer(child, childPlayers[i]);
}
