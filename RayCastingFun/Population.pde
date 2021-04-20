class Population {

  Car[] players;

  int genCounter = 0;
  int num_of_players;
  int living_players;

  boolean allDead;

  Population(int player_num) {
    num_of_players = player_num;
    players = new Car[num_of_players];
    for (int i = 0; i < num_of_players; i++) {
      // INJECTING SAVED INTO NEXT GENERATION AND RESETTING ALL RELEVANT VARIABLES IN PLAYER CLASS
      players[i] = new Car();
      
      transferPlayer(savedBrains[i], players[i]);
      
      
      players[i].Reset();
    }
    living_players = players.length;
    allDead = false;
  }

  void checkPlayers() {
    living_players = 0;
    for (int i = 0; i < num_of_players; i++) {
      if (players[i].alive) {
        living_players++;
      }
    }
    if (living_players == 0) {
      allDead = true;
      //restart();
    } else {
      allDead = false;
    }
  }

  void update() {
    for (int i = 0; i < num_of_players; i++) {
      checkPlayers();
      if (players[i].alive)
      {
        players[i].Update();
      }
    }
  }

  void update(ArrayList<Boundary> b) {
    for (int i = 0; i < num_of_players; i++) {
      checkPlayers();
      if (players[i].alive)
      {
        players[i].Update(b);
      }
    }
  }
}
