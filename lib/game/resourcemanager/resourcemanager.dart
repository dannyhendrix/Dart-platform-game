part of game;

typedef void OnResourcesLoaded();
typedef void OnResourceLoaded<K, V>(K key, V value);

abstract class ResourceManager<K> {
  int loaded = 0;
  int files = 0;
  bool started = false;

  OnResourcesLoaded onResourcesLoaded;
  OnResourceLoaded<K, Map> onJsonLoaded;
  OnResourceLoaded<K, RenderLayer> onImageLoaded;

  void startLoading() {
    started = true;
    if (onResourcesLoaded != null && loaded >= files) onResourcesLoaded();
  }

  void reset() {
    loaded = 0;
    files = 0;
    started = false;
  }

  void onResource(K key, RenderLayer layer, OnResourceLoaded callback) {
    loaded++;
    if (!started) return;

    callback?.call(key, layer);
    if (onResourcesLoaded != null && loaded >= files) onResourcesLoaded();
  }

  void loadJson(K key, String path) {
    files++;
  }

  void loadImage(K key, String path) {
    files++;
  }

  DrawableRenderLayer createNewDrawableImage(int w, int h);
  RenderLayer getImage(K key);
  Map getJson(K key);
}

abstract class ResourceMapping<K, V> {
  OnResourceLoaded<K, V> onResourceLoaded;
  Map<K, V> _resources = {};
  V get(K key) => _resources[key];
  bool isLoaded(K key) => _resources.containsKey(key);
  void set(K key, V value) {
    _resources[key] = value;
  }

  void load(K key, String path);
}
