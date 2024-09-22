package jume.assets;

import haxe.Exception;

/**
 * Type used when loading multiple assets at the same time.
 */
typedef AssetItem = {
  /**
   * The type of asset to load.
   */
  var type: Class<Dynamic>;

  /**
   * The id to store the asset as.
   */
  var id: String;

  /**
   * The url path to the asset.
   */
  var path: String;

  /**
   * Any additional properties needed to load the assets.
   */
  var ?props: Dynamic;
}

/**
 * Parameters used when loading an assets.
 */
typedef LoadParams<T> = {
  /**
   * The type of asset to load.
   */
  var assetType: Class<T>;

  /**
   * The id to store the asset as.
   */
  var id: String;

  /**
   * The url path to the asset.
   */
  var path: String;

  /**
   * The function used to return the loaded asset.
   */
  var callback: (asset: T) -> Void;

  /**

    * Any additional properties needed to load the assets.
   */
  var ?props: Dynamic;

  /**
   * Should this asset be stored in the manager or not.
   */
  var ?keep: Bool;
}

/**
 * The asset manager class.
 */
class Assets {
  /**
   * The asset loaders that are active.
   */
  final loaders: Map<String, AssetLoader<Dynamic>>;

  /**
   * Create a new assets instance.
   */
  public function new() {
    loaders = new Map<String, AssetLoader<Dynamic>>();
  }

  /**
   * Register a new loader type.
   * @param loader The loader to register.
   */
  public function registerLoader<T>(loader: AssetLoader<T>) {
    final name = Type.getClassName(loader.assetType);
    loaders[name] = loader;
  }

  /**
   * Load an assets.
   * @param params The load parameters.
   */
  public function load<T>(params: LoadParams<T>) {
    final name = Type.getClassName(params.assetType);
    if (loaders.exists(name)) {
      loaders[name].load(params.id, params.path, params.callback, params.props, params.keep);
    } else {
      throw new Exception('Loader is not registered for type ${name}');
    }
  }

  /**
   * Load multiple assets at the same time.
   * @param items The list of items to load.
   * @param callback The function to call when the loading is complete.
   * @param progressCallback Optional function to call every time an asset is done loading.
   */
  public function loadAll(items: Array<AssetItem>, callback: () -> Void,
      ?progressCallback: (id: String, loaded: Int, total: Int) -> Void) {
    var loaded = 0;
    final total = items.length;

    for (item in items) {
      load({
        assetType: item.type,
        id: item.id,
        path: item.path,
        props: item.props,
        callback: (asset) -> {
          loaded++;

          if (progressCallback != null) {
            progressCallback(item.id, loaded, total);
          }

          if (loaded == total) {
            callback();
          }
        }
      });
    }
  }

  /**
   * Add an externally loaded asset.
   * @param assetType The type of asset to add.
   * @param id The id to store the asset as.
   */
  public function add<T>(assetType: Class<T>, id: String, instance: T) {
    final name = Type.getClassName(assetType);
    if (loaders.exists(name)) {
      loaders[name].add(id, instance);
    } else {
      throw new Exception('Loader is not registered for type ${name}');
    }
  }

  /**
   * Get a loaded asset from the manager.
   * @param assetType The type of asset to add.
   * @param id The id to store the asset as.
   * @return The loaded asset.
   */
  public function get<T>(assetType: Class<T>, id): T {
    final name = Type.getClassName(assetType);
    if (loaders.exists(name)) {
      return loaders[name].get(id);
    } else {
      throw new Exception('Loader is not registered for type ${name}');
    }
  }

  /**
   * Remove an asset from the manager.
   * @param assetType The type of asset to add.
   * @param id The id to store the asset as.
   */
  public function unload<T>(assetType: Class<T>, id: String): Bool {
    final name = Type.getClassName(assetType);
    if (loaders.exists(name)) {
      return loaders[name].unload(id);
    } else {
      throw new Exception('Loader is not registered for type ${name}');
    }
  }
}
