/**
Platform game example
 
@author Danny Hendrix
**/

part of game;

class Flag extends GameObject with InteractiveObject, DrawableSprite {
  Flag.fromJson(Game game, Map json, int offsetx, int offsety){
    init(game, json['x'].toDouble() + offsetx, json['y'].toDouble() + offsety, 32, 32);
    sprite = new Sprite(game.resourceManager.getImage("assets"), 0, 128, 32, 32);
    collision.x = (w / 2).round().toInt() - 3;
    collision.w = 6;
  }

  void onOver(GameObject object) {
    game.level.flags--;

    if (game.level.flags <= 0) {
      game.gameOutput.onGameMessage("Level complete.");
      game.goToNextLevel();
    } else {
      game.gameOutput.onGameMessage("Flag collected ${game.level.flags} flags left!");
    }
    updateDrawLocation(true);
  }
}
