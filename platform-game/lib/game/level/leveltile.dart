/**
Platform game example
 
@author Danny Hendrix
**/

part of game;

class LevelTile {
  int x = 0;
  int y = 0;
  int w = 32;
  int h = 32;

  int _tileid = 0;
  List<RenderObject> objects;
  bool changed = true;
  bool hascollision = false;
  Sprite sprite;

  DrawableRenderLayer layer;

  Level level;

  static CollisionField TILE_COLLISIONFIELD = new CollisionField(0, 0, 32, 32);

  void set tileid(int value) {
    _tileid = value;
    sprite.spritex = (_tileid - 1) * 32;
    if (_tileid != 0)
      hascollision = true;
    else
      hascollision = false;
  }

  int get tileid => _tileid;

  LevelTile(this.x, this.y, this.level, this._tileid) {
    layer = level.game.resourceManager.createNewDrawableImage(w, h);

    if (_tileid != 0) hascollision = true;

    sprite = new Sprite(level.game.resourceManager.getImage("assets"), (_tileid - 1) * 32, 0, 32, 32);
  }

  void insert(RenderObject obj) {
    if (objects == null) objects = new List<RenderObject>();
    objects.add(obj);
    repaint();
  }

  void update(RenderObject obj) {
    int index = (objects == null) ? -1 : objects.indexOf(obj);

    //out of range
    if (obj.x >= x + w || obj.x + obj.w <= x || obj.y >= y + h || obj.y + obj.h <= y) return remove(obj);
    if (index == -1) return insert(obj);

    repaint();
  }

  void repairCollision(RenderObject obj) {
    if (hascollision) {
      obj.repairCollisionTile(this);
      return;
    }
    if (objects == null) return;
    //check if the collisionfield of the object within the bounderies of this tile
    if (!(obj.collisionx2 > x && obj.collisionx < x + w && obj.collisiony2 + 1 > y && obj.collisiony < y + h)) {
      return;
    }
    //loop through objects currently on this tile and check for collisions
    for (int i = 0; i < objects.length; i++) {
      if (objects[i] == obj) continue;
      obj.repairCollisionObject(objects[i]);
    }
  }

  void remove(RenderObject obj) {
    int index = (objects == null) ? -1 : objects.indexOf(obj);

    if (index == -1) return;
    objects.removeAt(index);
    if (objects.length == 0) objects = null;

    repaint();
  }

  void draw(DrawableRenderLayer targetlayer, int offsetx, int offsety) {
    if (changed == true) paint();
    changed = false;
    targetlayer.drawLayer(layer, x - offsetx, y - offsety);
  }

  //bool for displaying how the redrawing works ;) (press c during the game)
  bool a = false;
  void paint() {
    layer.clear();
    //TODO: draw collisions is no longer supported?
    /*
    if(level.game.showCollisionField == true)
    {
      if(a == true)
        layer.ctx.strokeStyle = "rgb(255,0,0)";
      else
        layer.ctx.strokeStyle = "rgb(0,255,0)";
      a = a==false;
      layer.ctx.strokeRect(0,0,32,32);
    }
    */
    //draw tile
    if (_tileid != 0) sprite.drawOnPosition(0, 0, 0, 0, layer);
    if (objects == null) return;
    //draw objects
    for (int i = 0; i < objects.length; i++) {
      if (level.game.showCollisionField == true)
        objects[i].drawCollision(layer, x, y);
      else
        objects[i].draw(layer, x, y);
    }
    return;
  }

  void repaint() {
    if (changed) return;
    changed = true;
    level.game.render.repaintTile(this);
  }
}
