/**
Platform game example
 
@author Danny Hendrix
**/

part of game;

class Door extends InteractiveObject {
  String link;
  String name = "Secret location";
  bool hidelabel = false;

  int layerwidth = 0;
  int layerheight = 0; //24;
  int padding = 3;

  static final RenderColor ColorText = const RenderColor(255, 255, 255);
  static final RenderColor ColorTextBackground = const RenderColor(0, 0, 0);

  Door.fromJson(Game game, Map json, int offsetx, int offsety) : super(game, json['x'].toDouble() + offsetx, json['y'].toDouble() + offsety, 25, 49) {
    if (json.containsKey("link")) link = json["link"];
    if (json.containsKey("name")) name = json["name"];
    if (json.containsKey("hidelabel")) hidelabel = json["hidelabel"];

    sprite = new Sprite(game.resourceManager.getImage("assets"), 0, 160, 25, 49);

    layerwidth = layer.getTextWidth(name) + padding * 2;
    layerheight = layer.getTextHeight(name) + padding * 2;

    if (layerwidth > w) {
      w = layerwidth;
      collision.x += (w - 25) ~/ 2;
    }
    collision.y += layerheight;
    h += layerheight;

    layer.resize(w, h);
    layer.drawFilledRect(0, 0, w, layerheight, ColorTextBackground);
    layer.drawText(padding, padding, name, ColorText);
  }

  void paint() {
    int drawx = 0;
    if (w > 25) drawx = (w - 25) ~/ 2;

    sprite.drawOnPosition(drawx, layerheight, over ? 1 : 0, 0, layer);
  }

  void onOver(GameObject object) {
    over = true;
    if (!hidelabel) game.gameOutput.onGameMessage("Go to: $link");
    updateDrawLocation();
  }

  void onOut(GameObject object) {
    over = false;
    updateDrawLocation();
  }

  void onEnter(GameObject object) {
    List<String> linkspl = link.split(":");
    if (linkspl[0] == "http") game.gameOutput.onGameGoToLocation(link);
    if (linkspl[0] == "map") {
      object.x = double.parse(linkspl[1]);
      object.y = double.parse(linkspl[2]);
      if (object is Player) {
        Player p = object;
        p.changeState(Player.STATE_INAIR);
      }
    }
    //if (linkspl[0] == "level") game.goToLevel(linkspl[1]);
    if (linkspl[0] == "levelid") game.goToLevel(int.parse(linkspl[1]));
  }
}
