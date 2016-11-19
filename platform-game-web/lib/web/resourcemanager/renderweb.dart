part of game.web;

class RenderWeb extends Render {
  Game game;

  DrawableRenderLayer layer;
  DrawableRenderLayer tileslayer;

  RenderWeb();

  @override
  void init(Game g) {
    super.init(g);
    layer = game.resourceManager.createNewDrawableImage(game.camera.w, game.camera.h);
  }

  @override
  void changeLevelSize(int w, int h)
  {
    tileslayer = game.resourceManager.createNewDrawableImage(w, h);
    for (int i = 0; i < game.level.leveltiles.length; i++) game.level.leveltiles[i].draw(tileslayer, 0, 0);
  }

  @override
  void render() {
    //repaint tiles that changed
    for (LevelTile tile in updatetiles)
    {
      tileslayer.clearArea(tile.x, tile.y, 32, 32);
      tile.draw(tileslayer, 0, 0);
    }
    updatetiles.clear();
    //repaint main layer
    layer.clear();
    layer.drawLayer(tileslayer, -game.camera.x, -game.camera.y);
  }
}