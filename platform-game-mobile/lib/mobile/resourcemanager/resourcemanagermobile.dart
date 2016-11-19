part of game.mobile;

class ResourceManagerMobile<K> extends ResourceManager {
  JsonControllerMobile<K> _jsonController;
  ImageControllerMobile<K> _imageController;

  ResourceManagerMobile() {
    _jsonController = new JsonControllerMobile<K>()
      ..onResourceLoaded = (K key, Map v) {
        onResource(() => onJsonLoaded?.call(key, v));
      };
    _imageController = new ImageControllerMobile<K>()
      ..onResourceLoaded = (K key, RenderLayer v) {
        onResource(() => onImageLoaded?.call(key, v));
      };
  }

  @override
  void loadJson(K key, String path) {
    super.loadJson(key, path);
    _jsonController.load(key, path);
  }

  @override
  void loadImage(K key, String path) {
    super.loadImage(key, path);
    _imageController.load(key, path);
  }

  @override
  RenderLayer getImage(K key) => _imageController.get(key);

  @override
  Map getJson(K key) => _jsonController.get(key);

  @override
  DrawableRenderLayer createNewDrawableImage(int w, int h) {
    return new RenderLayerMobileCanvas.withSize(w, h);
  }
}

class JsonControllerMobile<K> extends ResourceMapping<K, Map> {
  @override
  void load(K name, String path) {
    if (isLoaded(name)) onResourceLoaded(name, get(name));

    rootBundle.loadString(path).then((String jsonText){
      Map json = JSON.decode(jsonText);
      set(name, json);
      onResourceLoaded(name, json);
    });
  }
}

class ImageControllerMobile<K> extends ResourceMapping<K, RenderLayer> {
  @override
  void load(K name, String path) {
    if (isLoaded(name)) onResourceLoaded(name, get(name));

    rootBundle.load(path).then((ByteData bytes) {
      decodeImageFromList(bytes.buffer.asUint8List()).then((ui.Image img){
        RenderLayerMobileImage renderLayer = new RenderLayerMobileImage(img);
        set(name, renderLayer);
        onResourceLoaded(name, renderLayer);
      });
    });
  }
}
