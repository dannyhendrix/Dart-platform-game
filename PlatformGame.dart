/**
Platform game example
 
@author Danny Hendrix
**/

#library('PlatformGame');

#import('dart:html');

#import('game/Game.dart');

void main() 
{
  Game game = new Game();
  game.start();
  document.on.keyDown.add(game.handleKey);
  document.on.keyUp.add(game.handleKey);
}