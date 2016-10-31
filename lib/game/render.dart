/**
Platform game example
 
@author Danny Hendrix
**/

part of game;

/**
Renders the game (main canvas)
**/
class Render {
  Game game;

  DrawableRenderLayer layer;

  Render() {
    /*
    layer = new RenderLayer();

    layer.canvas.id = "game";
    //fade-in effect
    layer.canvas.style.opacity = "0.0";
    layer.canvas.style.transition = "opacity 1s ease-in-out";
    document.body.nodes.add(layer.canvas);
    */
  }

  void init(Game g) {
    this.game = g;
    layer = game.resourceManager.createNewDrawableImage(game.camera.w, game.camera.h);
    /*
    layer.canvas.style.opacity = "1.0";
    layer.width = g.camera.w;
    layer.height = g.camera.h;
*/
  }

  void start(Game g) {
    layer.resize(g.camera.w, g.camera.h);
  }

  void update() {
    layer.clear();

    game.level.draw(layer, game.camera.x, game.camera.y);

    //layer.ctx.fillText("FPS: ${game.gameloop.fps}", 10, 20);
  }
}
