part of game;

abstract class RenderLayer {
  int get w;
  int get h;
  //w,h;
}

abstract class DrawableRenderLayer<L extends RenderLayer> extends RenderLayer {
  void resize(int w, int h);
  void drawLayer(L layer, int x, int y);
  void drawLayerPart(L layer, int dx, int dy, int sx, int sy, int sw, int sh);
  void clear();
  void clearArea(int x, int y, int w, int h);
}
/*
abstract class ImageLayer extends RenderLayer {}
abstract class CanvasLayer extends RenderLayer {}
*/
