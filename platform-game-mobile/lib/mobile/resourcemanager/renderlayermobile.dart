part of game.mobile;

abstract class RenderLayerMobile extends RenderLayer {
  int _w,_h;
  @override
  int get h => _h;
  @override
  int get w => _w;
}

class RenderLayerMobileCanvas extends DrawableRenderLayer<RenderLayerMobile> with RenderLayerMobile {
  static ImageText imageText;
  ui.Picture picture;

  RenderLayerMobileCanvas.withSize(int w, int h) {
    _w = w;
    _h = h;

    ui.PictureRecorder recorder = new ui.PictureRecorder();
    Canvas canvas = new Canvas(recorder, new Rect.fromLTWH(0.0,0.0,_w*1.0,_h*1.0));
    picture = recorder.endRecording();
  }

  @override
  void resize(int w, int h) {
    _w = w;
    _h = h;

    ui.PictureRecorder recorder = new ui.PictureRecorder();
    Canvas canvas = new Canvas(recorder, new Rect.fromLTWH(0.0,0.0,_w*1.0,_h*1.0));
    picture = recorder.endRecording();
  }

  @override
  void drawLayer(RenderLayerMobile layer, int x, int y) {
    if(layer is RenderLayerMobileCanvas)
    {
      ui.PictureRecorder recorder = new ui.PictureRecorder();
      Canvas canvas = new Canvas(recorder, new Rect.fromLTWH(0.0,0.0,_w*1.0,_h*1.0));
      canvas.drawPicture(picture);
      canvas.translate(x*1.0, y*1.0);
      canvas.drawPicture(layer.picture);

      picture.dispose();
      picture = recorder.endRecording();
    }
    else if(layer is RenderLayerMobileImage)
    {
      ui.PictureRecorder recorder = new ui.PictureRecorder();
      Canvas canvas = new Canvas(recorder, new Rect.fromLTWH(0.0,0.0,_w*1.0,_h*1.0));
      canvas.drawPicture(picture);
      canvas.drawImage(layer.img, new Point(x*1.0,y*1.0),new Paint());

      picture.dispose();
      picture = recorder.endRecording();
    }
  }

  @override
  void drawLayerPart(RenderLayerMobile layer, int x, int y, int img_x, int img_y, int img_w, int img_h) {
    if (layer is RenderLayerMobileImage) {
      ui.PictureRecorder recorder = new ui.PictureRecorder();
      Canvas canvas = new Canvas(recorder, new Rect.fromLTWH(0.0,0.0,_w*1.0,_h*1.0));
      canvas.drawPicture(picture);
      canvas.drawImageRect(layer.img, new Rect.fromLTWH(img_x*1.0, img_y*1.0, img_w*1.0,img_h*1.0),
          new Rect.fromLTWH(x*1.0, y*1.0, img_w*1.0, img_h*1.0), new Paint());

      picture.dispose();
      picture = recorder.endRecording();
    }
    if (layer is RenderLayerMobileCanvas) {
      ui.PictureRecorder recorder = new ui.PictureRecorder();
      Canvas canvas = new Canvas(recorder, new Rect.fromLTWH(0.0,0.0,_w*1.0,_h*1.0));
      canvas.drawPicture(picture);
      //TODO: how do I cut a part of the canvas?
      canvas.translate(x*1.0, y*1.0);
      canvas.drawPicture(layer.picture);

      picture.dispose();
      picture = recorder.endRecording();
    }
  }

  @override
  void clear() {
    ui.PictureRecorder recorder = new ui.PictureRecorder();
    Canvas canvas = new Canvas(recorder, new Rect.fromLTWH(0.0,0.0,_w*1.0,_h*1.0));

    picture.dispose();
    picture = recorder.endRecording();
  }

  @override
  void clearArea(int x, int y, int w, int h) {
    ui.PictureRecorder recorder2 = new ui.PictureRecorder();
    Canvas canvas2 = new Canvas(recorder2, new Rect.fromLTWH(0.0,0.0,w*1.0,h*1.0));
    ui.Picture picture2 = recorder2.endRecording();

    ui.PictureRecorder recorder = new ui.PictureRecorder();
    Canvas canvas = new Canvas(recorder, new Rect.fromLTWH(0.0,0.0,_w*1.0,_h*1.0));
    canvas.drawPicture(picture);
    canvas.translate(x*1.0, y*1.0);
    canvas.drawPicture(picture2);
    picture2.dispose();
    picture.dispose();
    picture = recorder.endRecording();
  }
  @override
  void drawFilledRect(int x, int y, int w, int h, RenderColor c) {
    ui.PictureRecorder recorder = new ui.PictureRecorder();
    Canvas canvas = new Canvas(recorder, new Rect.fromLTWH(0.0,0.0,_w*1.0,_h*1.0));
    canvas.drawPicture(picture);
    canvas.drawRect(new Rect.fromLTWH(x*1.0,y*1.0,w*1.0,h*1.0,), new Paint()..color = new Color.fromARGB(255,c.r,c.g,c.b));
    picture.dispose();
    picture = recorder.endRecording();
  }

  @override
  void drawText(int x, int y, String text, RenderColor color) {
    //currently only support for white text. Why? Because this comment says so. Deal with it.
    if(imageText == null)
      throw new Exception("imageText is not initialized!");
    imageText.drawText(this, text, x, y);
  }

  @override
  int getTextHeight(String text) {
    if(imageText == null)
      throw new Exception("imageText is not initialized!");
    return imageText.letterh;
  }

  @override
  int getTextWidth(String text) {
    if(imageText == null)
      throw new Exception("imageText is not initialized!");
    return imageText.getTextWidth(text);
  }
}
/*
class RenderLayerMobileCanvas extends DrawableRenderLayer<RenderLayerMobile> with RenderLayerMobile {
  Canvas canvas;
  ui.PictureRecorder recorder;
  static ImageText imageText;

  /*
  RenderLayerMobileCanvas() {
    ui.PictureRecorder recorder = new ui.PictureRecorder();
    canvas = new Canvas(recorder, new Rect.fromLTWH(0.0,0.0,1.0,1.0));
  }
*/
  RenderLayerMobileCanvas.withSize(int w, int h) {
    _w = w;
    _h = h;
    recorder = new ui.PictureRecorder();
    canvas = new Canvas(recorder, new Rect.fromLTWH(0.0,0.0,w*1.0,h*1.0));
  }

  @override
  void resize(int w, int h) {
    _w = w;
    _h = h;
    recorder = new ui.PictureRecorder();
    canvas = new Canvas(recorder, new Rect.fromLTWH(0.0,0.0,w*1.0,h*1.0));
  }

  @override
  void drawLayer(RenderLayerMobile layer, int x, int y) {
    if(layer is RenderLayerMobileCanvas)
    {
      RenderLayerMobileCanvas layerCanvas = layer;
      canvas.translate(x*1.0, y*1.0);
      canvas.drawPicture(layer.recorder.endRecording());
      canvas.restore();
    }
    else if(layer is RenderLayerMobileImage)
    {
      RenderLayerMobileImage layerImage = layer;
      canvas.drawImage(layer.img, new Point(x*1.0,y*1.0),new Paint());
    }
  }

  @override
  void drawLayerPart(RenderLayerMobile layer, int x, int y, int img_x, int img_y, int img_w, int img_h) {
    if (layer is RenderLayerMobileImage) {
      RenderLayerMobileImage layerimg = layer;
      canvas.drawImageRect(layer.img, new Rect.fromLTWH(img_x*1.0, img_y*1.0, img_w*1.0,img_h*1.0),
          new Rect.fromLTWH(x*1.0, y*1.0, img_w*1.0, img_h*1.0), new Paint());
    }
    if (layer is RenderLayerMobileCanvas) {
      RenderLayerMobileCanvas layerCanvas = layer;
      //TODO: how do I cut a part of the canvas?
      canvas.translate(x*1.0, y*1.0);
      canvas.drawPicture(layer.recorder.endRecording());
      canvas.restore();
    }
  }

  @override
  void clear() {
    //??
  }

  @override
  void clearArea(int x, int y, int w, int h) {
    //??
  }
  @override
  void drawFilledRect(int x, int y, int w, int h, RenderColor c) {
    canvas.drawRect(new Rect.fromLTWH(x*1.0,y*1.0,w*1.0,h*1.0,), new Paint()..color = new Color.fromARGB(255,c.r,c.g,c.b));
  }

  @override
  void drawText(int x, int y, String text, RenderColor color) {
    //currently only support for white text. Why? Because this comment says so. Deal with it.
    if(imageText == null)
      throw new Exception("imageText is not initialized!");
    imageText.drawText(this, text, x, y);
  }

  @override
  int getTextHeight(String text) {
    if(imageText == null)
      throw new Exception("imageText is not initialized!");
    return imageText.letterh;
  }

  @override
  int getTextWidth(String text) {
    if(imageText == null)
      throw new Exception("imageText is not initialized!");
    return imageText.getTextWidth(text);
  }
}
*/
class RenderLayerMobileImage extends RenderLayer with RenderLayerMobile {
  ui.Image img;

  RenderLayerMobileImage(this.img) {
    _w = img.width.toInt();
    _h = img.height.toInt();
  }
}
