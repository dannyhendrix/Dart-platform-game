/**
Platform game example
 
@author Danny Hendrix
**/

part of game;

abstract class GameObject implements Drawable
{
  double x;
  double y;
  int w;
  int h;

  Game game;

  CollisionField collision;

  double get collisionx => x + collision.x;
  double get collisiony => y + collision.y;
  double get collisionx2 => x + collision.x2;
  double get collisiony2 => y + collision.y2;
  double get collisionmidpointy => y + collision.midpointy;
  double get collisionmidpointx => x + collision.x + (collision.w ~/ 2);

  int get objectTileX => (x / 32).floor().toInt();
  int get objectTileY => (y / 32).floor().toInt();

  int get objectTileEndX => ((x + w) / 32).ceil().toInt();
  int get objectTileEndY => ((y + h) / 32).ceil().toInt();

  void init(Game game, double x, double y, int w, int h) {
    this.game = game;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;

    collision = new CollisionField(0, 0, w, h);
  }

  void update() {}

  bool isCollisionField(double relativex, double relativey, CollisionField collisionfield) {
    if (collision == null) return false;
    return collisionx2 > relativex && collisionx < relativex + collisionfield.x2 && collisiony2 > relativey && collisiony < relativey + collisionfield.y2;
  }

  void repairLevelBorderCollision() {
    if (collisionx2 > game.level.x + game.level.w) x = game.level.x + game.level.w - collision.x2 * 1.0;
    if (collisionx < game.level.x) x = game.level.x - collision.x * 1.0;
    if (collisiony2 > game.level.y + game.level.h) y = game.level.y + game.level.h - collision.y2 * 1.0;
    if (collisiony < game.level.y) y = game.level.y - collision.y * 1.0;
  }

  void repairCollisionTile(LevelTile tile) {
    if (isCollisionField(tile.x.toDouble(), tile.y.toDouble(), LevelTile.TILE_COLLISIONFIELD)) onTileCollision(tile);
  }

  void repairCollisionObject(GameObject obj) {
    if (isCollisionField(obj.x, obj.y, obj.collision)) onObjectCollision(obj);
  }

  void onTileCollision(LevelTile tile) {}
  void onObjectCollision(GameObject o) {}

  void updateDrawLocation([bool remove = false]) {
    //update all tiles that change
    int objectTileX = (x / 32).floor().toInt();
    int objectTileY = (y / 32).floor().toInt();

    int objectTileEndX = ((x + w) / 32).ceil().toInt();
    int objectTileEndY = ((y + h) / 32).ceil().toInt();

    int tilesx = (game.level.w / 32).ceil().toInt();

    int intkey;

    for (int iy = objectTileY; iy < objectTileEndY; iy++)
      for (int ix = objectTileX; ix < objectTileEndX; ix++) {
        intkey = iy * tilesx + ix;
        if (game.level.leveltiles.length <= intkey || intkey < 0) continue;
        if (remove == true)
          game.level.leveltiles[intkey].remove(this);
        else
          game.level.leveltiles[intkey].update(this);
      }
  }
}

abstract class StaticGameObject extends GameObject {
}

abstract class MovableGameObject extends GameObject {

  double prev_x = 0.0;
  double prev_y = 0.0;

  void updateDrawLocation([bool remove = false]) {
    //update all tiles that change
    int maxx = Math.max(x.ceil().toInt(), prev_x.ceil().toInt());
    int minx = Math.min(x.floor().toInt(), prev_x.floor().toInt());

    int maxy = Math.max(y.ceil().toInt(), prev_y.ceil().toInt());
    int miny = Math.min(y.floor().toInt(), prev_y.floor().toInt());

    int objectTileX = (minx / 32).floor().toInt();
    int objectTileY = (miny / 32).floor().toInt();

    int objectTileEndX = ((maxx + w) / 32).ceil().toInt();
    int objectTileEndY = ((maxy + h) / 32).ceil().toInt();

    int tilesx = (game.level.w / 32).ceil().toInt();

    int intkey;

    for (int iy = objectTileY; iy < objectTileEndY; iy++)
      for (int ix = objectTileX; ix < objectTileEndX; ix++) {
        intkey = iy * tilesx + ix;
        if (game.level.leveltiles.length <= intkey || intkey < 0) continue;
        if (remove == true)
          game.level.leveltiles[intkey].remove(this);
        else
          game.level.leveltiles[intkey].update(this);
      }
  }
}

abstract class GravityGameObject extends MovableGameObject
{
  Vector vector = new Vector();
  bool onPlatform = false;

  void repairLevelBorderCollision() {
    super.repairLevelBorderCollision();
    if (collisiony2 + 1 > game.level.y + game.level.h) onPlatform = true;
  }

  void onTileCollision(LevelTile tile) {
    //collision
    double dif_x = prev_x - x;
    double dif_y = prev_y - y;
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
    onPlatform = (collisionx2 > tile.x && collisionx < tile.x + LevelTile.TILE_COLLISIONFIELD.x2 && collisiony2 + 1 > tile.y && collisiony < tile.y + LevelTile.TILE_COLLISIONFIELD.y2);

    return;
  }
}