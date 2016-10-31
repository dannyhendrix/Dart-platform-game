/**
Platform game example
 
@author Danny Hendrix
**/

part of game;

class Sprite {
  int spritex, spritey;
  final int framew, frameh;
  final RenderLayer img;

  Sprite(this.img, this.spritex, this.spritey, this.framew, this.frameh);

  drawOnPosition(int x, int y, int frameX, int frameY, DrawableRenderLayer targetlayer) {
    targetlayer.drawLayerPart(img, x, y, frameX * framew + spritex, frameY * frameh + spritey, framew, frameh);
  }
}
