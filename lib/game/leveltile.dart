/**
Platform game example
 
@author Danny Hendrix
**/

part of Game;

class LevelTile
{
  int x = 0;
  int y = 0;
  int w = 32;
  int h = 32;
  
  int _tileid = 0;
  List<RenderObject> objects;
  bool changed = true;
  CollisionField collision;
  Sprite sprite;

  RenderLayer layer;

  Level level;
  
  void set tileid(int value)
  {
    _tileid = value;
    sprite.spritex = (_tileid - 1) * 32;
    if(_tileid != 0)
      setCollision(true);
    else
      setCollision(false);
  }
  int get tileid => _tileid;

  LevelTile(this.x, this.y, this.level, this._tileid)
  {
    layer = new RenderLayer();
    layer.width = w;
    layer.height = h;
    
    if(_tileid != 0)
      setCollision(true);

    sprite = new Sprite("resources/images/images.png",(_tileid - 1) * 32,0,32,32);
  }

  void insert(RenderObject obj)
  { 
    if(objects == null)
      objects = new List<RenderObject>();
    objects.add(obj);
    changed = true;
    repaint();
  }
  
  void update(RenderObject obj)
  {
    int index = (objects == null) ? -1 : objects.indexOf(obj);
    
    //out of range
    if(obj.x >= x+w || obj.x + obj.w <= x || obj.y >= y+h || obj.y + obj.h <= y)
      return remove(obj);
    if(index == -1)
      return insert(obj);
    changed = true;
    
    repaint();
  }
  
  void setCollision(bool value)
  {
    if(value == false)
      collision = null;
    else
      collision = new CollisionField(0,0,w,h);
  }

  void isCollision(RenderObject obj)
  {
    
    if(collision != null)
    {
        obj.checkTileCollision(this);
        return;
    }
    if(objects == null)
      return;
    
    if( (
        obj.collisionx2 > x
        && obj.collisionx < x+w
        && obj.collisiony2+1 > y
        && obj.collisiony < y+h
        ) == false
    )
    {
      return;
    }
    RenderObject levelobject;
    for(int i = 0; i < objects.length; i++)
    {
      if(objects[i] == obj)
        continue;
      levelobject = objects[i];
      obj.checkObjectCollision(levelobject);
    }
  }

  void remove(RenderObject obj)
  {
    int index = (objects == null) ? -1 : objects.indexOf(obj);

    if(index == -1)
      return;
    objects.removeAt(index);
    //objects.removeRange(index, 1);
    if(objects.length == 0)
      objects = null;
    changed = true;
    repaint();
  }

  void draw(RenderLayer targetlayer, double offsetx, double offsety)
  {
    if(changed == true)
      paint();
    changed = false;
    targetlayer.ctx.clearRect(x, y, 32, 32);
    targetlayer.ctx.drawImage(layer.canvas, (x-offsetx).toInt(), (y-offsety).toInt());
  }
  
  //bool for displaying how the redrawing works ;) (press c during the game)
  bool a = false;
  void paint()
  {
    layer.clear();
    
    if(level.game.showCollisionField == true)
    {
      if(a == true)
        layer.ctx.strokeStyle = "rgb(255,0,0)";
      else
        layer.ctx.strokeStyle = "rgb(0,255,0)";
      a = a==false;
      layer.ctx.strokeRect(0,0,32,32);
    }
    //draw tile
    if(_tileid != 0)
      sprite.drawOnPosition(0,0,0,0,layer);
    if(objects == null)
      return;
    //draw objects
    for(int i = 0; i < objects.length; i++)
    {
      if(level.game.showCollisionField == true)
        objects[i].drawCollision(layer, x, y);
      else
        objects[i].draw(layer, x, y);
    }
    return;
  }

  void repaint()
  {
    level.updatetiles.add(this);
  }
}
