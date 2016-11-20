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
  List<MobileButton> buttons = [];
  ui.Picture buttonsPicture;
  bool buttonsNeedRepainting = true;

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
    resourceManager.loadImage("bg", "resources/images/bg.png");
    resourceManager.startLoading();
  }

  void _loadingFinished() {
    RenderLayerMobileCanvas.imageText = new ImageText(resourceManager.getImage("text"));

    render = new RenderMobile();
    game = new Game(resourceManager, render, this, new GameLoopMobile(this));
    inputController = new InputControllerWebKeyboard(game);

    double buttonw = 100.0;
    double buttonh = 60.0;
    buttons.add(new ControlButton(game, Player.MOVE_LEFT, new ui.Rect.fromLTWH(0.0, 330.0, buttonw, buttonh)));
    buttons.add(new ControlButton(game, Player.MOVE_RIGHT, new ui.Rect.fromLTWH((buttonw + 10) * 1, 330.0, buttonw, buttonh)));
    buttons.add(new ControlButton(game, Player.MOVE_JUMP, new ui.Rect.fromLTWH((buttonw + 10) * 2, 330.0, buttonw, buttonh)));
    buttons.add(new ControlButton(game, Player.MOVE_JUMP2, new ui.Rect.fromLTWH((buttonw + 10) * 3, 330.0, buttonw, buttonh)));
    buttons.add(new MobileButton(new ui.Rect.fromLTWH((buttonw + 10) * 4, 330.0, buttonw, buttonh),(){game.player.enterObject();}));

    paintButtons();

    game.start();


    final double devicePixelRatio = ui.window.devicePixelRatio;

    ui.window.onPointerDataPacket = (ui.PointerDataPacket packet) {
      for (MobileButton button in buttons) {
        bool isDown = false;
        for (ui.PointerData pointer in packet.data) {
          bool down = pointer.change == ui.PointerChange.down || pointer.change == ui.PointerChange.move;
          bool inRect = button.area.contains(new Point(pointer.physicalX / devicePixelRatio, pointer.physicalY / devicePixelRatio));
          if (inRect && down)
          {
            isDown = true;
            break;
          }
        }
        if(isDown && !button.isDown) button.onDown?.call();
        if(!isDown && button.isDown) button.onUp?.call();
        if(isDown != button.isDown) buttonsNeedRepainting = true;

        button.isDown = isDown;
      }
    };
  }

  void paintButtons()
  {
    if(!buttonsNeedRepainting) return;
    buttonsNeedRepainting = false;
    double buttonw = buttons.first.area.width;
    double buttonh = buttons.first.area.height;
    ui.PictureRecorder recorder = new ui.PictureRecorder();
    Rect paintBounds = new Rect.fromLTWH(0.0, 0.0, (buttonw+10) * buttons.length, 330+buttonh);
    Canvas canvas = new Canvas(recorder, paintBounds);
    Paint paint;
    for(MobileButton button in buttons){
      if(button.isDown) paint = new Paint()..color = new Color.fromARGB(255, 255,0,0);
      else paint = new Paint()..color = new Color.fromARGB(255, 0,0,255);
      canvas.drawRect(button.area, paint);
    }
    buttonsPicture = recorder.endRecording();
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

    Size size = ui.window.physicalSize;
    game.camera.w = 600; //Math.min(size.width, game.level.w);
    //-38 for top bar
    game.camera.h = 300; //Math.min(size.height, game.level.h);

    int minborder = Math.min(game.camera.w, game.camera.h);
    game.camera.border = (minborder * 0.3).toInt(); //10%

    render.layer.resize(game.camera.w, game.camera.h);
  }

  @override
  void onGameStart() {
    // TODO: implement onGameStart
  }
}
