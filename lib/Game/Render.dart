/**
Platform game example
 
@author Danny Hendrix
**/

part of Game;

/**
Renders the game (main canvas)
**/
class Render
{
  Game game;

  RenderLayer layer;

  Render()
  {
    layer = new RenderLayer();

    layer.canvas.id = "game";
    //fade-in effect
    layer.canvas.style.opacity = "0.0";
    layer.canvas.style.transition = "opacity 1s ease-in-out";
    document.body.nodes.add(layer.canvas);
  }

  void start(Game g)
  {
    layer.canvas.style.opacity = "1.0";
    layer.width = g.camera.w;
    layer.height = g.camera.h;

    this.game = g;
  }
  void update(double lastTime,double looptime)
  {
    layer.clear();

    game.level.draw(layer, game.camera.x, game.camera.y);

    layer.ctx.fillText("FPS: ${game.fps}", 10, 20);
  }
}
