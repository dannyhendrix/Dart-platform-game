/**
Platform game example
 
@author Danny Hendrix
**/

part of game;

/**
Main Game class
**/
class Game {
  Render render;
  List<GameObject> gameobjects;
  Level level;
  Player player;
  Camera camera;
  bool showCollisionField = false;
  ResourceManager<String> resourceManager;
  GameLoop gameloop;
  GameOutput gameOutput;

  int currentlevel = 0;
  String levelsource;

  static final double GRAVITY = 0.3;

  Game(this.resourceManager, this.gameOutput)
      : render = new Render(),
        gameobjects = new List<GameObject>(),
        camera = new Camera() {
    level = new Level(this);
    player = new Player(this);
  }

  void start() {
    gameloop = new GameLoop(update);
    //create sprites
    //create gameobjects
    level.start();
    camera.start(this);
    render.init(this);
    player.start(this);

    gameobjects.add(player);

    loadLevel();

    //window.requestAnimationFrame(loop);
    gameloop.play();

    gameOutput.onGameMessage("Hello there :). Messages will pop-up here.");
  }

  void loadLevel() {
    level.loadLevel(resourceManager.getJson("level$currentlevel"));

    render.start(this);

    //place in middle of first tile
    player.reset(level.startx.toDouble(), level.starty.toDouble());
    gameOutput.onGameLevelLoaded();
  }

  void resetLevel() {
    player.reset(level.startx.toDouble(), level.starty.toDouble());
  }

  void goToLevel(int id) {
    currentlevel = id;
    resourceManager.onResourcesLoaded = loadLevel;
    resourceManager.reset();

    resourceManager.loadJson("level$currentlevel", "resources/levels/level_$currentlevel.json");
    resourceManager.startLoading();
  }

  void goToNextLevel() {
    goToLevel(currentlevel + 1);
  }

  void update(int looptime) {
    for (int i = 0; i < gameobjects.length; i++) gameobjects[i].update();

    render.update();
  }
}
