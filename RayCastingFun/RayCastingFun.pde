
Boundary wall;
Ray ray;
Particle player;


boolean W, A, S, D, Shift = false;

int number_of_players =4;
Car c;




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

Car parentone;
Car child;

float mutRate = 3;

int genCounter=1;
Population population;



String level = "raceTrack.txt";
//Token tok = new Token();
void setup()
{
  size(800, 800);
  // wall = new Boundary(300,100,300,300);

  //walls.add(wall);
  //walls.add(new Boundary(200,200,150,100));
  player = new Particle();

  walls.add(new Boundary(1, 1, width, 1));
  walls.add(new Boundary(width, 0, width, height));
  walls.add(new Boundary(width, height, 1, height));
  walls.add(new Boundary(1, height, 1, 1));

  LoadLevel(level);

  c = new Car();

  childPlayers = new Car[number_of_players];
  for (int i = 0; i < number_of_players; i++) {
    childPlayers[i] = new Car();
  }

  savedBrains = new Car[number_of_players];
  for (int i = 0; i < number_of_players; i++) {
    savedBrains[i] = new Car();
    savedBrains[i].nn.randomize();
  }


  population = new Population(number_of_players);
}



void draw()
{
  background(0);
  DrawWalls();

  //Mouse Attached Particle
  player.SetPos(mouseX, mouseY);
  player.Draw();
  player.LookAt(walls);

  //Car object
  c.Update(walls);



  population.update(walls);


  //Inputs(); WASD Player Movement
}



void Inputs()
{
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

    for (Car car : population.players)
    {
      car.cookies.add(new Token(mouseX, mouseY));
    }
    c.cookies.add(new Token(mouseX, mouseY));
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
}





void restart() {
  if (population.allDead == true) {

    //added to population
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
  toTransferTo.pos = toTransfer.pos.copy();
  toTransferTo.angle = toTransfer.angle;
  toTransferTo.alive = toTransfer.alive;
  toTransferTo.dir = toTransfer.dir.copy();


  toTransferTo.fitness = toTransfer.fitness;
  for (int i = 0; i < toTransfer.nn.weights.length; i++) {
    toTransferTo.nn.weights[i] = toTransfer.nn.weights[i];
  }
  for (int i = 0; i < toTransfer.nn.biases.length; i++) {
    toTransferTo.nn.biases[i] = toTransfer.nn.biases[i];
  }
}



void selectParents() {
  
  //SORT BY HIGHEST
  
  
  
  Car[] sortedCars = new Car[population.players.length];
  
  for(int i=0; i < population.players.length; i++)
  {
    sortedCars[i] = new Car();
    //transferPlayer(savedBrains[i], sortedCars[i]);
  }
  
  for(int i=0; i < sortedCars.length; i++)
  {
    for(int j=0; j < sortedCars.length-1; j++)
    {
      if(sortedCars[i].fitness < sortedCars[i+1].fitness)
      {
        Car temp = new Car();
        transferPlayer(sortedCars[i],temp);
        transferPlayer(sortedCars[i+1],sortedCars[i]);
        transferPlayer(temp,sortedCars[i+1]);
      }
    }
  }
  
  
  println("SORTED FITNESS");
  for(int i=0; i < sortedCars.length; i++)
  {
    println(sortedCars[i].fitness);
  }
  
  
  fit_sum = 0;
  int[] fitness_scores = new int[number_of_players];
  for (int i = 0; i < number_of_players; i++) {
    fitness_scores[i] = savedBrains[i].fitness;
    fit_sum += fitness_scores[i];
  }

  fit_array = new int[fit_sum];
  movingIndex = 0;
  for (int i = 0; i < fitness_scores.length; i++) {
    for (int w = 0; w < fitness_scores[i]; w++) {
      fit_array[movingIndex++] = i;
    }
  }

  for (int i = 0; i < childPlayers.length; i++) {
    transferPlayer(savedBrains[i], childPlayers[i]);
  }

  for (int i = 0; i < number_of_players; i++) {
    transferPlayer(savedBrains[fit_array[int(random(fit_array.length))]], parentone);
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
