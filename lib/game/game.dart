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
  MessageController messages;
  bool showCollisionField = false;
  ResourceManager<String> resourceManager;
  GameLoop gameloop;

  int currentlevel = 0;
  String levelsource;

  static final double GRAVITY = 0.3;

  Game(this.resourceManager)
      : render = new Render(),
        gameobjects = new List<GameObject>(),
        camera = new Camera() {
    level = new Level(this);
    player = new Player(this);
    messages = new MessageController();
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

    messages.sendMessage("Hello there :). Messages will pop-up here.");
  }

  void loadLevel() {
    level.loadLevel(resourceManager.getJson("level$currentlevel"));

    camera.w = Math.min(window.innerWidth, level.w);
    //-38 for top bar
    camera.h = Math.min(window.innerHeight - 44, level.h);

    //verticaly center the game
    int offsettop = 38;
    if (camera.h == level.h) offsettop = (window.innerHeight - 44 - camera.h) ~/ 2;

    //TODO: this was removed when introducing the new renderlayer
    //render.layer.canvas.style.marginTop = "${offsettop}px";

    render.start(this);

    int minborder = Math.min(camera.w, camera.h);
    camera.border = (minborder * 0.3).toInt(); //10%

    //place in middle of first tile
    player.reset(level.startx.toDouble(), level.starty.toDouble());
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
