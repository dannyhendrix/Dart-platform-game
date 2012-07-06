/**
Platform game example
 
@author Danny Hendrix
**/

#library('PlatformGame');


/**
A field that defines a collision area for an object
**/
class CollisionField
{
  int x;
  int y;
  int w;
  int h;
  int _midpointy = -1;
  int _midpointx = -1;

  CollisionField(this.x,this.y,this.w,this.h);

  set x2(int value) => w = value-x;
  int get x2() => x+w;
  set y2(int value) => h = value-y;
  int get y2() => y+h;

  set midpointy(int value) => _midpointy = value;
  int get midpointy()
  {
    if(_midpointy == -1)
      return (y + h/2).toInt();
    return _midpointy;
  }

  set midpointx(int value) => _midpointx = value;
  int get midpointx()
  {
    if(_midpointx == -1)
      return (x + w/2).toInt();
    return _midpointx;
  }
}
