/**
Platform game example
 
@author Danny Hendrix
**/

part of game;

class Level {
  int x = 0;
  int y = 0;
  int w = 500;
  int h = 500;
  int flags = 0;

  int startx = 10;
  int starty = 10;

  Game game;

  List<LevelTile> leveltiles;

  //tiles that changed and should be redrawn
  List<LevelTile> updatetiles;

  Level(this.game) : updatetiles = new List<LevelTile>() {
  }

  void loadLevel(Map json) {
    w = json['w'];
    h = json['h'];

    if (json.containsKey("startx")) startx = json["startx"];
    if (json.containsKey("starty")) starty = json["starty"];

    //create a levelTileObject foreach x/y position in the map
    int tilesx = (w / 32).ceil().toInt();
    int tilesy = (h / 32).ceil().toInt();
    leveltiles = new List<LevelTile>();

    LevelTile obj;
    //create all tiles in the map
    for (int iy = 0; iy < tilesy; iy++) for (int ix = 0; ix < tilesx; ix++) leveltiles.add(new LevelTile(ix * 32, iy * 32, this, json['tiles'][iy][ix]));

    flags = 0;
    int intkey = 0;
    LevelObject levelobj;

    //create objects
    for (int i = 0; i < json['objects'].length; i++) {
      //currntly only support for doors and flags
      if (json['objects'][i]['type'] == "door")
        levelobj = new Door.fromJson(game, json['objects'][i], x.toInt(), y.toInt());
      else if (json['objects'][i]['type'] == "flag") {
        levelobj = new Flag.fromJson(game, json['objects'][i], x.toInt(), y.toInt());
        flags++;
      } else
        continue;

      int objectTileX = (levelobj.x / 32).floor().toInt();
      int objectTileY = (levelobj.y / 32).floor().toInt();

      int objectTileEndX = ((levelobj.x + levelobj.w) / 32).ceil().toInt();
      int objectTileEndY = ((levelobj.y + levelobj.h) / 32).ceil().toInt();

      intkey = objectTileY * tilesx + objectTileX;

      //place object on all tiles that it overlaps
      for (int iy = objectTileY; iy < objectTileEndY; iy++)
        for (int ix = objectTileX; ix < objectTileEndX; ix++) {
          intkey = iy * tilesx + ix;
          if (leveltiles.length <= intkey || intkey < 0) continue;
          leveltiles[intkey].insert(levelobj);
        }
    }

    game.render.changeLevelSize(w,h);
  }

  void start() {}

  void repairCollision(GameObject object) {
    object.repairLevelBorderCollision();

    int tileCollStartX = (object.collisionx / 32).floor().toInt();
    int tileCollEndX = (object.collisionx2 / 32).ceil().toInt();

    int tileCollStartY = (object.collisiony / 32).floor().toInt();
    int tileCollEndY = (object.collisiony2 / 32).ceil().toInt();

    int tilesx = (w / 32).ceil().toInt();

    int intkey;

    //check collision on all object it overlaps
    for (int iy = tileCollStartY; iy <= tileCollEndY; iy++)
      for (int ix = tileCollStartX; ix <= tileCollEndX; ix++) {
        intkey = iy * tilesx + ix;
        if (leveltiles.length <= intkey || intkey < 0) continue;
        leveltiles[intkey].repairCollision(object);
      }
  }

  LevelTile getTileAt(int absolutex, int absolutey) {
    int tilex = (absolutex / 32).floor().toInt();
    int tiley = (absolutey / 32).floor().toInt();
    int tilesx = (w / 32).ceil().toInt();
    int key = tiley * tilesx + tilex;
    if (key < 0 || key >= leveltiles.length) return null;
    return leveltiles[key];
  }

  List<LevelTile> getTilesAt(int absolutex, int absolutey, int w, int h) {
    int tilex = (absolutex / 32).floor().toInt();
    int tiley = (absolutey / 32).floor().toInt();
    int tilex2 = tilex+(w / 32).ceil().toInt();
    int tiley2 = tiley+(h / 32).ceil().toInt();

    int tilesx = (w / 32).ceil().toInt();
    int key;

    List<LevelTile> result = [];
    for(int y = tiley; y < tiley2; y++)
    {
      key = y * tilesx + tilex;
      for (int x = tilex; x < tilex2; x++)
      {
        result.add(leveltiles[key++]);
      }
    }
    return result;
  }
}
