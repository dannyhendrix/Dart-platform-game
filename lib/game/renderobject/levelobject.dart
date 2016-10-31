/**
Platform game example
 
@author Danny Hendrix
**/

part of game;

/**
Base object for level objects
**/
class LevelObject extends RenderObject
{
  Sprite sprite;
  
  LevelObject(Game game, double x,double y,int w,int h): super(game, x,y,w,h);
}
