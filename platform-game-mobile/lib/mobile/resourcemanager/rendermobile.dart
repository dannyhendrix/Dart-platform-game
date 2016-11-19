part of game.mobile;

/**
 * Slow redering, this is how Flutter will draw it atm :/
 */

class RenderMobile extends Render {
  Game game;

  DrawableRenderLayer layer;

  @override
  void init(Game g) {
    super.init(g);
    layer = game.resourceManager.createNewDrawableImage(game.camera.w, game.camera.h);
  }

  @override
  void changeLevelSize(int w, int h) {}

  @override
  void render() {
    layer.clear();

    //repaint tiles that changed
    for (LevelTile tile in game.level.getTilesAt(game.camera.x, game.camera.y, game.camera.w, game.camera.h)) {
      tile.draw(layer, game.camera.x, game.camera.y);
    }
    updatetiles.clear();
  }
}
