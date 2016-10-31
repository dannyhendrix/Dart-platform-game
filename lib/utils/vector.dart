/**
Platform game example
 
@author Danny Hendrix
**/

part of Utils;

/**
Simple vector class
**/
class Vector {
  double xspeed = 0.0;
  double yspeed = 0.0;

  Vector();

  Vector.fromAngle(double angle, double power) {
    angle = _toRadians(angle);
    xspeed = Math.cos(angle) * power;
    yspeed = Math.sin(angle) * power;
  }

  double _toRadians(double degree) {
    return Math.PI / 180 * degree;
  }

  void clear() {
    xspeed = 0.0;
    yspeed = 0.0;
  }

  void reverse() {
    xspeed = -xspeed;
    yspeed = -yspeed;
  }

  void addVector(Vector v) {
    xspeed += v.xspeed;
    yspeed += v.yspeed;
  }
}
