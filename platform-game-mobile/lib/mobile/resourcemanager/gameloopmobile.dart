part of game.mobile;

class GameLoopMobile extends GameLoop{
  Dashboard dashboard;
  Float64List deviceTransform;
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
  }
  void play() {
    super.play();
    ui.window.scheduleFrame();
  }

  void loop(double looptime) {
    super.loop(looptime);
    if(!stopping)
    {
      RenderLayerMobileCanvas gameLayer = dashboard.game.render.layer;

      ui.SceneBuilder sceneBuilder = new ui.SceneBuilder()
        ..pushTransform(deviceTransform)
        ..addPicture(Offset.zero, gameLayer.picture)
        ..pop();

      ui.window.render(sceneBuilder.build());
      ui.window.scheduleFrame();
    }

  }
}