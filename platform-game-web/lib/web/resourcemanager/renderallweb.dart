part of game.web;

/**
 * Slow redering, this is how Flutter will draw it atm :/
 */

class RenderAllWeb extends Render {
  Game game;

  DrawableRenderLayer layer;

  RenderAllWeb();

  @override
  void init(Game g) {
    super.init(g);
    layer = game.resourceManager.createNewDrawableImage(game.camera.w, game.camera.h);
  }

  @override
  void changeLevelSize(int w, int h)
  {
    /*
    tileslayer = game.resourceManager.createNewDrawableImage(w, h);
    for (int i = 0; i < game.level.leveltiles.length; i++) game.level.leveltiles[i].draw(tileslayer, 0, 0);
    */
  }

  @override
  void render() {
    layer.clear();

    //repaint tiles that changed
    for (LevelTile tile in game.level.getTilesAt(game.camera.x, game.camera.y, game.camera.w, game.camera.h))
    {
      tile.draw(layer, -game.camera.x, -game.camera.y);
    }
    updatetiles.clear();
  }
}