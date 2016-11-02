part of game.web;

class ResourceManagerWeb<K> extends ResourceManager {
  JsonControllerWeb<K> _jsonController;
  ImageControllerWeb<K> _imageController;

  ResourceManagerWeb() {
    _jsonController = new JsonControllerWeb<K>()
      ..onResourceLoaded = (K key, Map v) {
        onResource(() => onJsonLoaded?.call(key, v));
      };
    _imageController = new ImageControllerWeb<K>()
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
    return new RenderLayerWebCanvas.withSize(w, h);
  }
}

class JsonControllerWeb<K> extends ResourceMapping<K, Map> {
  @override
  void load(K name, String path) {
    if (isLoaded(name)) onResourceLoaded(name, get(name));

    HttpRequest.getString(path).then((String jsonText) {
      Map json = JSON.decode(jsonText);
      set(name, json);
      onResourceLoaded(name, json);
    });
  }
}

class ImageControllerWeb<K> extends ResourceMapping<K, RenderLayer> {
  @override
  void load(K name, String path) {
    if (isLoaded(name)) onResourceLoaded(name, get(name));

    ImageElement img = new Element.tag("img");
    img.src = path;
    img.onLoad.listen((Event e) {
      RenderLayerWebImage renderLayer = new RenderLayerWebImage(img);
      set(name, renderLayer);
      onResourceLoaded(name, renderLayer);
    });
  }
}
