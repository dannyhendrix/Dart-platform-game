/**
Platform game example
 
@author Danny Hendrix
**/

part of Game;

class GameObject extends RenderObject
{
  int frame = 0;
  int frameY = 0;
  int lastframeupdate = 0;
  Vector vector;
  bool onPlatform = false;

  GameObject(Game game, double x, double y, int w, int h) : super(game,x,y,w,h), vector = new Vector()
  {
    prev_x = x;
    prev_y = y;
  }

  AnimationFrames currentAnimation;

  void update()
  {
  }
  
  bool checkLevelBorderCollision()
  {
    bool ret = false;
    if(collisionx2 > game.level.x+game.level.w)
    {
      x = game.level.x+game.level.w-collision.x2;
      ret = true;
    }
    if(collisionx < game.level.x)
    {
      x = game.level.x-collision.x;
      ret = true;
    }
    if(collisiony2 > game.level.y+game.level.h)
    {
      y = game.level.y+game.level.h-collision.y2;
      onPlatform = true;
      ret = true;
    }
    if(collisiony < game.level.y)
    {
      y = game.level.y-collision.y;
       ret = true;
    }
    
    if(collisiony2+1 > game.level.y+game.level.h)
      onPlatform = true;
    return ret;
  }
  
  bool checkCollisionField(double relativex, double relativey, CollisionField collisionfield)
  {
    //collision
    double dif_x = prev_x - x;
    double dif_y = prev_y - y;
    
    //if no collision, only check for platform
    if( (
        collisionx2 > relativex
        && collisionx < relativex+collisionfield.x2
        && collisiony2 > relativey
        && collisiony < relativey+collisionfield.y2
        ) == false)
    {
      //no collision but it might be on top of the object
      if( (
          collisionx2 > relativex
          && collisionx < relativex+collisionfield.x2
          && collisiony2+1 > relativey
          && collisiony < relativey+collisionfield.y2
          ) == true)
      {
          onPlatform = true;
      }
      return false;
    }
    //not moved:
    if(dif_x == 0 && dif_y == 0)
        return false;
    
    double overlap_x = 0.0;
    double overlap_y = 0.0;
    
    if(dif_x > 0)//left
      overlap_x = relativex + collisionfield.x2 - collisionx;
    if(dif_x < 0)//right
      overlap_x = relativex + collisionfield.x - collisionx2;
    if(dif_y > 0)//top
      overlap_y = relativey + collisionfield.y2 - collisiony;
    if(dif_y < 0)//bottom
      overlap_y = relativey + collisionfield.y - collisiony2;
    
    double percentage = 0.0;
    double percentage_y = 0.0;

    if(dif_x != 0)
      percentage = (dif_x - overlap_x) / dif_x;
    if(dif_y != 0)
      percentage_y = (dif_y - overlap_y) / dif_y;
    percentage = Math.max(percentage, percentage_y);

    x = prev_x - (dif_x * percentage);
    y = prev_y - (dif_y * percentage);
    
    //check if on platform after the obj moved
    if( (
        collisionx2 > relativex
        && collisionx < relativex+collisionfield.x2
        && collisiony2+1 > relativey
        && collisiony < relativey+collisionfield.y2
        ) == true)
    {
        onPlatform = true;
    }
    
    return true;
  }


  bool changeImage(AnimationFrames changeTo)
  {
    int oldframe = frame;
    // next frame?
    if (currentAnimation == changeTo)
    {
      //per 20 frames add 1
      lastframeupdate++;
      if(lastframeupdate < currentAnimation.framerate)
        return false;
      lastframeupdate = 0;
      if (frame == changeTo.end)
        this.frame = changeTo.start;
      else
        this.frame++;
    }
    else
    {
      this.frame = changeTo.start;
    }
    currentAnimation = changeTo;
    return (oldframe != frame);
  }
}
