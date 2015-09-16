/**
Platform game example
 
@author Danny Hendrix
**/

part of Utils;

/**
Makes it easier to work with canvases, you can always access the canvas and ctx resource
**/
class RenderLayer
{
  CanvasElement canvas;
  CanvasRenderingContext2D ctx;

  RenderLayer()
  {
    canvas = new Element.tag("canvas");
    ctx = canvas.getContext("2d");
  }

  RenderLayer.fromCanvas(CanvasElement element)
  {
    canvas = element;
    ctx = canvas.getContext("2d");
  }

  set width(int value) => canvas.width = value;
  set height(int value) => canvas.height = value;

  int get height => canvas.height;
  int get width => canvas.width;

  void clear()
  {
    canvas.width = canvas.width;
  }
}
