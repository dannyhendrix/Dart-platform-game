/**
Platform game example
 
@author Danny Hendrix
**/

part of Game;
/**
Main Game class
**/
class Game
{
  Render render;
  List<GameObject> gameobjects;
  Level level;
  Player player;
  Camera camera;
  MessageController messages;
  bool showCollisionField = false;
  PreLoader loader;
  GameLoop gameloop;

  int currentlevel = 0;
  String levelsource;

  static final double GRAVITY = 0.3;

  Game() : render = new Render(), gameobjects = new List<GameObject>(), camera = new Camera()
  {
    level = new Level(this);
    player = new Player(this);
    messages = new MessageController();
  }

  void start()
  {
    loader = new PreLoader(loadingFinished);
    
    levelsource = "resources/levels/level_$currentlevel.json";

    //load resources
    loader.loadJson(levelsource);
    loader.loadImage("resources/images/images.png");
    loader.loadImage("resources/images/c0v0a16t1uv1t80Cs1Cd.png");
    loader.start();
  }
  
  void loadingFinished()
  {
    //when loading has finsished, display a start button
    ButtonElement dombutton = new ButtonElement();
    DivElement main = document.querySelector("#openscreen");
    main.style.transition = "opacity 0.5s ease-in-out";

    document.querySelector("#loading").text = "";
    
    dombutton.text = "Start!";
    
    //messy jquery style code YAY!
    dombutton.onClick.listen((e)
        {
        main.style.opacity = "0.0";
        new Timer(const Duration(milliseconds: 500),()
          {
          main.remove(); 
          startGame();
          });
        });
    main.nodes.add(dombutton);
  }
  
  void startGame()
  {
    gameloop = new GameLoop(update);
    //create sprites
    //create gameobjects
    level.start();
    camera.start(this);
    render.start(this);
    
    gameobjects.add(player);
    
    loadLevel();

    //window.requestAnimationFrame(loop);
    gameloop.play();
    
    messages.sendMessage("Hello there :). Messages will pop-up here.");
  }
  
  void loadLevel()
  {
    level.loadLevel(JsonController.getJson(levelsource));
    
    camera.w = Math.min(window.innerWidth, level.w);
    //-38 for top bar
    camera.h = Math.min(window.innerHeight - 44, level.h);
    
    //verticaly center the game
    int offsettop = 38;
    if(camera.h == level.h)
      offsettop = (window.innerHeight - 44 - camera.h)~/2;
    
    render.layer.canvas.style.marginTop = "${offsettop}px";
    
    render.start(this);

    int minborder = Math.min(camera.w, camera.h);
    camera.border = (minborder*0.3).toInt(); //10%

    //place in middle of first tile
    player.reset(level.startx.toDouble(),level.starty.toDouble());
  }
  
  void resetLevel()
  {
    player.reset(level.startx.toDouble(),level.starty.toDouble());
  }
  
  void goToLevel(String location)
  {
    loader.callback = loadLevel;
    loader.reset();
    levelsource = location;
    
    loader.loadJson(levelsource);
    loader.start();
  }
  
  void goToLevelid(int id)
  {
    currentlevel = id;
    goToLevel("resources/levels/level_$currentlevel.json");
  }
  
  void goToNextLevel()
  {
    currentlevel++;
    goToLevel("resources/levels/level_$currentlevel.json");
  }

  void update(int looptime)
  {
    for(int i = 0; i < gameobjects.length; i++)
      gameobjects[i].update();

    render.update();
  }
  
  void handleKey(KeyboardEvent event)
  {
    //event.preventDefault();
    int key = event.keyCode;
    bool down = event.type == "keydown";//event.KEYDOWN
    
    //print(key);

    if(key == 37 || key == 65)//left & a
      player.setMove(Player.MOVE_LEFT, down);
    if(key == 39 || key == 68)//right & d
      player.setMove(Player.MOVE_RIGHT,down);
    if(key == 38 || key == 87)//up & w
      player.setMove(Player.MOVE_JUMP, down);
    if(key == 40 || key == 83)//down & s
      player.setMove(Player.MOVE_JUMP2, down);
    
    if((key == 13 || key == 81) && down)//enter & q
      player.enterObject();
    if(key == 67 && down)//c
      showCollisionField = showCollisionField == false;
  }
}