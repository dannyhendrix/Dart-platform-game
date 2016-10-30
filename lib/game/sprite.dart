/**
Platform game example
 
@author Danny Hendrix
**/

part of Game;

class Sprite
{
  int spritex, spritey;
  final int framew, frameh;
  final ImageElement img;

  Sprite(String imgurl, this.spritex, this.spritey,this.framew,this.frameh) : img = ImageController.getImage(imgurl);

  drawOnPosition(int x, int y, int frameX, int frameY, RenderLayer targetlayer)
  {
    targetlayer.ctx.drawImageScaledFromSource(img,frameX * framew + spritex,frameY * frameh + spritey,framew,frameh, x,y,framew,frameh);
  }
}
