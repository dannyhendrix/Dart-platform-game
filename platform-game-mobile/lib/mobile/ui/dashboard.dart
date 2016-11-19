part of game.mobile;

/*
1. new Dashboard
2. new Game
3.
 */

class Dashboard extends GameOutput {
  Game game;
  RenderMobile render;
  ResourceManager resourceManager;
  InputControllerWebKeyboard inputController;
  //MessageController messages;
  Dashboard() {
    resourceManager = new ResourceManagerMobile();
    //messages = new MessageController();
  }
  void init() {}
  void start() {
    resourceManager.onResourcesLoaded = _loadingFinished;

    //load resources
    resourceManager.loadJson("level0", "resources/levels/level_0.json");
    resourceManager.loadImage("assets", "resources/images/images.png");
    resourceManager.loadImage("player", "resources/images/player.png");
    resourceManager.loadImage("text", "resources/images/text_arial.png");
    resourceManager.startLoading();
  }

  void _loadingFinished() {
    RenderLayerMobileCanvas.imageText = new ImageText(resourceManager.getImage("text"));

    render = new RenderMobile();
    game = new Game(resourceManager, render, this, new GameLoopMobile(this));
    inputController = new InputControllerWebKeyboard(game);

    game.start();
    game.player.setMove(Player.MOVE_RIGHT, true);

  }
  @override
  void onGameGoToLocation(String url) {
    //Not supported for mobile
    //messages.sendMessage("Going to $url is currently not supported.");
  }

  @override
  void onGameMessage(String message) {
    //messages.sendMessage(message);
  }
  @override
  void onGameLevelFinished() {
    // TODO: implement onGameLevelFinished
  }

  @override
  void onGameLevelLoaded() {
    print("level loaded");
    game.gameloop.stop();

    Size size = ui.window.physicalSize;
    game.camera.w = 300;//Math.min(size.width, game.level.w);
    //-38 for top bar
    game.camera.h = 300;//Math.min(size.height, game.level.h);

    int minborder = Math.min(game.camera.w, game.camera.h);
    game.camera.border = (minborder * 0.3).toInt(); //10%

    render.layer.resize(game.camera.w, game.camera.h);

  }

  @override
  void onGameStart() {
    // TODO: implement onGameStart
  }
}
