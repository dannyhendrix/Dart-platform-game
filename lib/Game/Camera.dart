/**
Platform game example
 
@author Danny Hendrix
**/

#library('PlatformGame');

#import ("Game.dart");
#import ("renderobjects/gameobjects/GameObject.dart");

class Camera
{
  int x = 0;
  int y = 0;
  int w = 400;
  int h = 400;

  Game game;

  int border = 64;

  void start(Game g)
  {
    game = g;
  }

  //place the camera on a specific object
  void centerObject(GameObject object)
  {
    if(object.collisionmidpointx > x + w - border)
      x = (object.collisionmidpointx + border - w).toInt();
    if(object.collisionmidpointx < x + border)
      x = (object.collisionmidpointx - border).toInt();

    if(object.collisionmidpointy > y + h - border)
      y = (object.collisionmidpointy + border - h).toInt();
    if(object.collisionmidpointy < y + border)
      y = (object.collisionmidpointy - border).toInt();

    if(x < game.level.x)
      x = (game.level.x).toInt();
    if(x+w >= game.level.x + game.level.w)
      x = game.level.w - w;

    if(y < game.level.y)
      y = (game.level.y).toInt();
    if(y+h >= game.level.y + game.level.h)
      y = game.level.h - h;
  }
}
