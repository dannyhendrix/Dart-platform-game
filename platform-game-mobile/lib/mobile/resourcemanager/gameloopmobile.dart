part of game.mobile;

class GameLoopMobile extends GameLoop{
  Dashboard dashboard;
  Float64List deviceTransform;
  RenderLayerMobileImage background;

  GameLoopMobile(this.dashboard)
  {
    final double devicePixelRatio = ui.window.devicePixelRatio;
    deviceTransform = new Float64List(16)
      ..[0] = devicePixelRatio
      ..[5] = devicePixelRatio
      ..[10] = 1.0
      ..[15] = 1.0;

    ui.window.onBeginFrame = (Duration d) {
      loop(0.0);
    };

    background = dashboard.resourceManager.getImage("bg");
  }
  void play() {
    super.play();
    ui.window.scheduleFrame();
  }

  void loop(double looptime) {
    super.loop(looptime);
    if(!stopping)
    {
      RenderLayerMobileCanvas gameLayer = dashboard.render.layer;

      dashboard.paintButtons();


      ui.SceneBuilder sceneBuilder = new ui.SceneBuilder()
        ..pushTransform(deviceTransform)
        //..addPicture(Offset.zero, background.picture)
        ..addPicture(Offset.zero, gameLayer.picture)
        ..addPicture(Offset.zero, dashboard.buttonsPicture)
        ..pop();

      ui.window.render(sceneBuilder.build());
      ui.window.scheduleFrame();
    }

  }
}