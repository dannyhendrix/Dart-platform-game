/**
Platform game example
 
@author Danny Hendrix
**/

import 'dart:html';
import 'package:dart_platform_game/game.dart';

void main() 
{
  Game game = new Game();
  game.start();
  document.onKeyDown.listen(game.handleKey);
  document.onKeyUp.listen(game.handleKey);
}
