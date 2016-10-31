/**
Platform game example
 
@author Danny Hendrix
**/

part of game;

class GameObject extends RenderObject {
  int frame = 0;
  int frameY = 0;
  int lastframeupdate = 0;
  Vector vector;
  bool onPlatform = false;

  GameObject(Game game, double x, double y, int w, int h)
      : super(game, x, y, w, h),
        vector = new Vector() {
    prev_x = x;
    prev_y = y;
  }

  AnimationFrames currentAnimation;

  void update() {}

  void repairLevelBorderCollision() {
    if (collisionx2 > game.level.x + game.level.w) x = game.level.x + game.level.w - collision.x2 * 1.0;
    if (collisionx < game.level.x) x = game.level.x - collision.x * 1.0;
    if (collisiony2 > game.level.y + game.level.h) {
      y = game.level.y + game.level.h - collision.y2 * 1.0;
      onPlatform = true;
    }
    if (collisiony < game.level.y) y = game.level.y - collision.y * 1.0;

    if (collisiony2 + 1 > game.level.y + game.level.h) onPlatform = true;
  }

  void repairCollisionTile(LevelTile tile) {
    if (isCollisionField(tile.x.toDouble(), tile.y.toDouble(), LevelTile.TILE_COLLISIONFIELD)) onTileCollision(tile);
  }

  void repairCollisionObject(RenderObject obj) {
    if (isCollisionField(obj.x, obj.y, obj.collision)) onObjectCollision(obj);
  }

  void onTileCollision(LevelTile tile) {
    //collision
    double dif_x = prev_x - x;
    double dif_y = prev_y - y;
    /*
    //if no collision, only check for platform
    if( (
        collisionx2 > tile.x
        && collisionx < tile.x+tile.collision.x2
        && collisiony2 > tile.y
        && collisiony < tile.y+tile.collision.y2
        ) == false)
    {
      //no collision but it might be on top of the object
      if( (
          collisionx2 > tile.x
          && collisionx < tile.x+tile.collision.x2
          && collisiony2+1 > tile.y
          && collisiony < tile.y+tile.collision.y2
          ) == true)
      {
          onPlatform = true;
      }
      return;
    }
    //not moved:
    if(dif_x == 0 && dif_y == 0)
        return;
    */
    double overlap_x = 0.0;
    double overlap_y = 0.0;

    if (dif_x > 0) //left
      overlap_x = tile.x + LevelTile.TILE_COLLISIONFIELD.x2 - collisionx;
    if (dif_x < 0) //right
      overlap_x = tile.x + LevelTile.TILE_COLLISIONFIELD.x - collisionx2;
    if (dif_y > 0) //top
      overlap_y = tile.y + LevelTile.TILE_COLLISIONFIELD.y2 - collisiony;
    if (dif_y < 0) //bottom
      overlap_y = tile.y + LevelTile.TILE_COLLISIONFIELD.y - collisiony2;

    double percentage = 0.0;
    double percentage_y = 0.0;

    if (dif_x != 0) percentage = (dif_x - overlap_x) / dif_x;
    if (dif_y != 0) percentage_y = (dif_y - overlap_y) / dif_y;
    percentage = Math.max(percentage, percentage_y);

    x = prev_x - (dif_x * percentage);
    y = prev_y - (dif_y * percentage);

    //check if on platform after the obj moved
    if ((collisionx2 > tile.x && collisionx < tile.x + LevelTile.TILE_COLLISIONFIELD.x2 && collisiony2 + 1 > tile.y && collisiony < tile.y + LevelTile.TILE_COLLISIONFIELD.y2) ==
        true) {
      onPlatform = true;
    }

    return;
  }

  bool changeImage(AnimationFrames changeTo) {
    int oldframe = frame;
    // next frame?
    if (currentAnimation == changeTo) {
      //per 20 frames add 1
      lastframeupdate++;
      if (lastframeupdate < currentAnimation.framerate) return false;
      lastframeupdate = 0;
      if (frame == changeTo.end)
        this.frame = changeTo.start;
      else
        this.frame++;
    } else {
      this.frame = changeTo.start;
    }
    currentAnimation = changeTo;
    return (oldframe != frame);
  }
}
