/**
Platform game example
 
@author Danny Hendrix
**/

part of Game;

/**
Base class for all objects
**/
class RenderObject
{
  double x;
  double y;
  int w;
  int h;
  
  double prev_x = 0.0;
  double prev_y = 0.0;

  Game game;

  CollisionField collision;
  RenderLayer layer;

  double get collisionx => x+collision.x;
  double get collisiony => y+collision.y;
  double get collisionx2 => x+collision.x2;
  double get collisiony2 => y+collision.y2;
  double get collisionmidpointy => y+collision.midpointy;
  double get collisionmidpointx => x+collision.x + (collision.w~/2);

  int get objectTileX => (x/32).floor().toInt();
  int get objectTileY => (y/32).floor().toInt();

  int get objectTileEndX => ((x + w)/32).ceil().toInt();
  int get objectTileEndY => ((y + h)/32).ceil().toInt();

  RenderObject(this.game,this.x,this.y,this.w,this.h)
  {
    collision = new CollisionField(0,0,w,h);
    layer = new RenderLayer.withSize(w,h);
  }
  void draw(RenderLayer targetlayer, int offsetx, int offsety)
  {
    paint();
    targetlayer.ctx.drawImage(layer.canvas, (x-offsetx).round().toInt(), (y-offsety).round().toInt());
  }
  
  void paint()
  {
    
  }

  void drawCollision(RenderLayer targetlayer, int offsetx, int offsety)
  {
    draw(targetlayer, offsetx, offsety);
    int drawx = 0;
    int drawy = 0;
    layer.ctx.fillStyle = "rgba(255,255,255,0.5)";
    layer.ctx.fillRect(drawx+collision.x, drawy+collision.y, collision.w, collision.h);

    layer.ctx.strokeStyle = "#0000ff";
    layer.ctx.beginPath();
    layer.ctx.moveTo(drawx, drawy+collision.midpointy);
    layer.ctx.lineTo(drawx+w, drawy+collision.midpointy);
    layer.ctx.stroke();

    layer.ctx.beginPath();
    layer.ctx.moveTo(drawx+collision.midpointx, drawy);
    layer.ctx.lineTo(drawx+collision.midpointx, drawy+h);
    layer.ctx.stroke();
    
    layer.ctx.strokeStyle = "rgb(255,255,0)";
    layer.ctx.strokeRect(drawx,drawy,w,h);
    
    targetlayer.ctx.drawImage(layer.canvas, (x-offsetx).round().toInt(), (y-offsety).round().toInt());
  }
  
  bool checkCollisionField(double relativex, double relativey, CollisionField collisionfield)
  {
    return false;
  }
  
  bool checkTileCollision(LevelTile tile)
  {
    return checkCollisionField(tile.x.toDouble(), tile.y.toDouble(),tile.collision);
  }
  
  bool checkObjectCollision(RenderObject o)
  {
    return checkCollisionField(o.x, o.y, o.collision);
  }
  
  void updateDrawLocation([bool remove = false])
  {
    //update all tiles that change
    int maxx = Math.max(x.ceil().toInt(),prev_x.ceil().toInt());
    int minx = Math.min(x.floor().toInt(),prev_x.floor().toInt());

    int maxy = Math.max(y.ceil().toInt(),prev_y.ceil().toInt());
    int miny = Math.min(y.floor().toInt(),prev_y.floor().toInt());

    int objectTileX = (minx/32).floor().toInt();
    int objectTileY = (miny/32).floor().toInt();

    int objectTileEndX = ((maxx + w)/32).ceil().toInt();
    int objectTileEndY = ((maxy + h)/32).ceil().toInt();

    int tilesx = (game.level.w/32).ceil().toInt();

    int intkey;

    for(int iy = objectTileY; iy < objectTileEndY; iy++)
      for(int ix = objectTileX; ix < objectTileEndX; ix++)
      {
        intkey = iy * tilesx + ix;
        if(game.level.leveltiles.length <= intkey || intkey < 0)
          continue;
        if(remove == true)
          game.level.leveltiles[intkey].remove(this);
        else
          game.level.leveltiles[intkey].update(this);
      }
  }
}
