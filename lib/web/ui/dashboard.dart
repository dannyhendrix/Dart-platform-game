part of game.web;

/*
1. new Dashboard
2. new Game
3.
 */

class Dashboard {
  Game game;
  ResourceManager resourceManager;
  InputControllerWebKeyboard inputController;
  Dashboard() {
    resourceManager = new ResourceManagerWeb();
    game = new Game(resourceManager);
    inputController = new InputControllerWebKeyboard(game);
  }
  void init() {}
  void start() {
    resourceManager.onResourcesLoaded = _loadingFinished;
    game.levelsource = "resources/levels/level_${game.currentlevel}.json";

    //load resources
    resourceManager.loadJson("level${game.currentlevel}", game.levelsource);
    resourceManager.loadImage("assets", "resources/images/images.png");
    resourceManager.loadImage("player", "resources/images/c0v0a16t1uv1t80Cs1Cd.png");
    resourceManager.startLoading();
  }

  void _loadingFinished() {
    //when loading has finsished, display a start button
    ButtonElement dombutton = new ButtonElement();
    DivElement main = document.querySelector("#openscreen");
    main.style.transition = "opacity 0.5s ease-in-out";

    document.querySelector("#loading").text = "";

    dombutton.text = "Start!";

    //messy jquery style code YAY!
    dombutton.onClick.listen((e) {
      main.style.opacity = "0.0";
      new Timer(const Duration(milliseconds: 500), () {
        main.remove();

        game.start();

        RenderLayerWebCanvas gameLayer = game.render.layer;
        gameLayer.el_canvas.id = "game";
        //fade-in effect
        gameLayer.el_canvas.style.opacity = "0.0";
        gameLayer.el_canvas.style.transition = "opacity 1s ease-in-out";
        document.body.nodes.add(gameLayer.el_canvas);
        gameLayer.el_canvas.style.opacity = "1.0";

        document.onKeyDown.listen(inputController.handleKey);
        document.onKeyUp.listen(inputController.handleKey);
      });
    });
    main.nodes.add(dombutton);
  }
}
