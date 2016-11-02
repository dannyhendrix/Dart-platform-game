/**
Platform game example
 
@author Danny Hendrix
**/

part of game;

/**
A field that defines a collision area for an object
**/
class CollisionField {
  int x, y, w, h;
  int midpointx, midpointy;

  CollisionField(this.x, this.y, this.w, this.h, [int midx, int midy]) {
    midpointx = midx ?? (x + w) ~/ 2;
    midpointy = midy ?? (y + h) ~/ 2;
  }

  set x2(int value) => w = value - x;
  int get x2 => x + w;
  set y2(int value) => h = value - y;
  int get y2 => y + h;
}
