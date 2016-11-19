/**
Platform game example
 
@author Danny Hendrix
**/

part of game;

/**
    Renders the game (main canvas)
 **/
abstract class Render
{
  Game game;
  List<LevelTile> updatetiles = [];

  void init(Game g) {
    this.game = g;
  }
  void repaintTile(LevelTile tile) => updatetiles.add(tile);
  void changeLevelSize(int w, int h);
  void render();
}

