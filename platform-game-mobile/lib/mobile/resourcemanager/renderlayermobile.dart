part of game.mobile;

abstract class RenderLayerMobile extends RenderLayer {
  int _w, _h;
  @override
  int get h => _h;
  @override
  int get w => _w;
  ui.Picture picture;
}

class RenderLayerMobileCanvas extends DrawableRenderLayer<RenderLayerMobile> with RenderLayerMobile {
  static ImageText imageText;
  Rect paintBounds;

  RenderLayerMobileCanvas.withSize(int w, int h) {
    _w = w;
    _h = h;

    ui.PictureRecorder recorder = new ui.PictureRecorder();
    paintBounds = new Rect.fromLTWH(0.0, 0.0, _w * 1.0, _h * 1.0);
    new Canvas(recorder, paintBounds);
    picture = recorder.endRecording();
  }

  @override
  void resize(int w, int h) {
    _w = w;
    _h = h;
    paintBounds = new Rect.fromLTWH(0.0, 0.0, _w * 1.0, _h * 1.0);

    ui.PictureRecorder recorder = new ui.PictureRecorder();
    new Canvas(recorder, paintBounds);
    picture = recorder.endRecording();
  }

  @override
  void drawLayer(RenderLayerMobile layer, int x, int y) {
    ui.PictureRecorder recorder = new ui.PictureRecorder();
    new Canvas(recorder, paintBounds)
      ..clipRect(paintBounds)
      ..drawPicture(picture)
      ..translate(x * 1.0, y * 1.0)
      ..drawPicture(layer.picture);

    picture.dispose();
    picture = recorder.endRecording();
  }

  @override
  void drawLayerPart(RenderLayerMobile layer, int x, int y, int img_x, int img_y, int img_w, int img_h) {
    // This is where the hacking begins..
    // Create new Canvas for image (we need this to set the drawing bounds)
    ui.PictureRecorder recorderImage = new ui.PictureRecorder();
    ui.Rect paintBoundsImage = new Rect.fromLTWH(0.0, 0.0, img_w * 1.0, img_h * 1.0);
    new Canvas(recorderImage, paintBoundsImage)
      ..clipRect(paintBoundsImage)
      ..translate(-img_x * 1.0, -img_y * 1.0)
      ..drawPicture(layer.picture);
    ui.Picture pictureImage = recorderImage.endRecording();

    // Create new main Canvas and add the Canvas with the image
    ui.PictureRecorder recorder = new ui.PictureRecorder();
    new Canvas(recorder, paintBounds)
      ..clipRect(paintBounds)
      ..drawPicture(picture)
      ..translate(x * 1.0, y * 1.0)
      ..drawPicture(pictureImage);

    picture.dispose();
    picture = recorder.endRecording();
  }

  @override
  void clear() {
    ui.PictureRecorder recorder = new ui.PictureRecorder();
    new Canvas(recorder, paintBounds);
    picture.dispose();
    picture = recorder.endRecording();
  }

  @override
  void clearArea(int x, int y, int w, int h) {
    // Currently not supported
    throw new Exception("clearArea is not implemented!");
  }

  @override
  void drawFilledRect(int x, int y, int w, int h, RenderColor c) {
    ui.PictureRecorder recorder = new ui.PictureRecorder();
    new Canvas(recorder, paintBounds)
      ..clipRect(paintBounds)
      ..drawPicture(picture)
      ..drawRect(
          new Rect.fromLTWH(
            x * 1.0,
            y * 1.0,
            w * 1.0,
            h * 1.0,
          ),
          new Paint()..color = new Color.fromARGB(255, c.r, c.g, c.b));
    picture.dispose();
    picture = recorder.endRecording();
  }

  @override
  void drawText(int x, int y, String text, RenderColor color) {
    // Currently only support for white text. Why? Because this comment says so. Deal with it.
    if (imageText == null) throw new Exception("imageText is not initialized!");
    imageText.drawText(this, text, x, y);
  }

  @override
  int getTextHeight(String text) {
    if (imageText == null) throw new Exception("imageText is not initialized!");
    return imageText.letterh;
  }

  @override
  int getTextWidth(String text) {
    if (imageText == null) throw new Exception("imageText is not initialized!");
    return imageText.getTextWidth(text);
  }
}

class RenderLayerMobileImage extends RenderLayer with RenderLayerMobile {
  RenderLayerMobileImage(ui.Image img) {
    _w = img.width.toInt();
    _h = img.height.toInt();

    ui.PictureRecorder recorder = new ui.PictureRecorder();
    new Canvas(recorder, new Rect.fromLTWH(0.0, 0.0, _w * 1.0, _h * 1.0))..drawImage(img, new Point(0.0, 0.0), new Paint());
    picture = recorder.endRecording();
  }
}
