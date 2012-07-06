/**
Platform game example
 
@author Danny Hendrix
**/

#library('PlatformGame');

#import("../../Game.dart");
#import("LevelObject.dart");
#import("../gameobjects/GameObject.dart");

class InteractiveObject extends LevelObject
{
  bool over = false;

  InteractiveObject(Game game, double x, double y, int w, int h): super(game, x,y,w,h)
  {
    
  }

  void onOver(GameObject object)
  {
    over = true;
  }

  void onOut(GameObject object)
  {
    over = false;
  }

  void onEnter(GameObject object)
  {

  }
}
