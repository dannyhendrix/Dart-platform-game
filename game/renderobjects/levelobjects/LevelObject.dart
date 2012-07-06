/**
Platform game example
 
@author Danny Hendrix
**/

#library('PlatformGame');

#import("dart:html");

#import("../../Game.dart");
#import("../RenderObject.dart");
#import("../../sprite/Sprite.dart");

/**
Base object for level objects
**/
class LevelObject extends RenderObject
{
  Sprite sprite;
  
  LevelObject(Game game, double x,double y,int w,int h): super(game, x,y,w,h);
}
