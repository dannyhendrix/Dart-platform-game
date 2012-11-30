/**
Platform game example
 
@author Danny Hendrix
**/

import 'dart:html';
import 'lib/Game.dart';

void main() 
{
  Game game = new Game();
  game.start();
  document.on.keyDown.add(game.handleKey);
  document.on.keyUp.add(game.handleKey);
}
