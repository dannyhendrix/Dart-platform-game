/**
Platform game example
 
@author Danny Hendrix
**/

#library('PlatformGame');

#import("dart:html");
#import("../../utils/ImageController.dart");
#import("../../utils/RenderLayer.dart");


class Sprite
{
  int spritex;
  int spritey;
  int framew;
  int frameh;
  String imgurl = "";
  ImageElement img;

  Sprite(this.imgurl, this.spritex, this.spritey,this.framew,this.frameh)
  {
    img = ImageController.getImage(imgurl);
  }

  drawOnPosition(int x, int y, int frameX, int frameY, RenderLayer targetlayer)
  {
    targetlayer.ctx.drawImage(img,frameX * framew + spritex,frameY * frameh + spritey,framew,frameh, x,y,framew,frameh);
  }
}
