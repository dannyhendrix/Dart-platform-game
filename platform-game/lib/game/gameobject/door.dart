/**
Platform game example
 
@author Danny Hendrix
**/

part of game;

class Door extends GameObject with InteractiveObject {
  String link;
  String name = "Secret location";
  bool hidelabel = false;

  int padding = 3;

  DrawableRenderLayer layerOver;
  DrawableRenderLayer layerOut;

  static final RenderColor ColorText = const RenderColor(255, 255, 255);
  static final RenderColor ColorTextBackground = const RenderColor(0, 0, 0);

  Door.fromJson(Game game, Map json, int offsetx, int offsety) {
    init(game, json['x'].toDouble() + offsetx, json['y'].toDouble() + offsety, 25, 49);
    if (json.containsKey("link")) link = json["link"];
    if (json.containsKey("name")) name = json["name"];
    if (json.containsKey("hidelabel")) hidelabel = json["hidelabel"];

    Sprite sprite = new Sprite(game.resourceManager.getImage("assets"), 0, 160, 25, 49);

    layerOut = game.resourceManager.createNewDrawableImage(w,h);

    int labelwidth = layerOut.getTextWidth(name) + padding * 2;
    int labelheight = layerOut.getTextHeight(name) + padding * 2;

    if (labelwidth > w) {
      w = labelwidth;
      collision.x += (w - 25) ~/ 2;
    }
    collision.y += labelheight;
    h += labelheight;
    h += 4;

    layerOut.resize(w, h);
    layerOver = game.resourceManager.createNewDrawableImage(w,h);
    paintWithFrame(layerOut,labelheight, sprite, 0);
    paintWithFrame(layerOver,labelheight, sprite,1);
  }

  void paintWithFrame(DrawableRenderLayer targetLayer, int layerheight, Sprite sprite, int frame)
  {
    int drawx = 0;
    targetLayer.clear();
    targetLayer.drawFilledRect(0, 0, w, layerheight, ColorTextBackground);
    targetLayer.drawText(padding, padding, name, ColorText);

    if (w > 25) drawx = (w - 25) ~/ 2;

    sprite.drawOnPosition(drawx, layerheight+4, frame, 0, targetLayer);
  }

  void draw(DrawableRenderLayer targetlayer, int offsetx, int offsety) {
    targetlayer.drawLayer(over ? layerOver : layerOut, (x - offsetx).round().toInt(), (y - offsety).round().toInt());
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
