part of game;

abstract class RenderLayer {
  int get w;
  int get h;
}

class RenderColor{
  final int r,g,b;
  final double a;
  const RenderColor(this.r, this.g, this.b, [this.a = 1.0]);
}

abstract class DrawableRenderLayer<L extends RenderLayer> extends RenderLayer {
  void resize(int w, int h);

  void drawLayer(L layer, int x, int y);
  void drawLayerPart(L layer, int dx, int dy, int sx, int sy, int sw, int sh);

  void clear();
  void clearArea(int x, int y, int w, int h);

  void drawText(int x, int y, String text, RenderColor color);
  int getTextHeight(String text);
  int getTextWidth(String text);

  void drawFilledRect(int x, int y, int w, int h, RenderColor color);
}
