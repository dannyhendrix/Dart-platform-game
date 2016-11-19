/**
Platform game example
 
@author Danny Hendrix
**/

part of game;

abstract class InteractiveObject extends GameObject {
  bool over = false;

  void onOver(GameObject object) {
    over = true;
  }

  void onOut(GameObject object) {
    over = false;
  }

  void onEnter(GameObject object) {}
}
