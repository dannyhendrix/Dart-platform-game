part of game;

abstract class Drawable
{
  void draw(DrawableRenderLayer targetLayer, int offsetx, int offsety);
}

abstract class DrawableSprite implements Drawable
{
  Sprite sprite;
  int framex = 0;
  int framey = 0;
  double x,y;
  void draw(DrawableRenderLayer targetLayer, int offsetx, int offsety) {
    sprite.drawOnPosition((x - offsetx).round().toInt(), (y - offsety).round().toInt(), framex, framey, targetLayer);
  }
}

abstract class DrawableAnimation
{
  int framex = 0;
  int framey = 0;
  int lastframeupdate = 0;
  AnimationFrames currentAnimation;

  bool updateAnimation(AnimationFrames changeTo) {
    int oldframe = framex;
    // next frame?
    if (currentAnimation == changeTo) {
      //per 20 frames add 1
      lastframeupdate++;
      if (lastframeupdate < currentAnimation.framerate) return false;
      lastframeupdate = 0;
      if (framex == changeTo.end)
        this.framex = changeTo.start;
      else
        this.framex++;
    } else {
      this.framex = changeTo.start;
    }
    currentAnimation = changeTo;
    return (oldframe != framex);
  }
}