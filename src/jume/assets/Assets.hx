package jume.assets;

import haxe.Exception;

typedef AssetItem = {
  var type: Class<Dynamic>;
  var id: String;
  var path: String;
  var ?props: Dynamic;
}

typedef LoadParams<T> = {
  var assetType: Class<T>;
  var id: String;
  var path: String;
  var callback: (asset: T) -> Void;
  var ?props: Dynamic;
  var ?keep: Bool;
}

class Assets {
  final loaders: Map<String, AssetLoader<Dynamic>>;

  public function new() {
    loaders = new Map<String, AssetLoader<Dynamic>>();
  }

  public function registerLoader<T>(loader: AssetLoader<T>) {
    final name = Type.getClassName(loader.assetType);
    loaders[name] = loader;
  }

  public function load<T>(params: LoadParams<T>) {
    final name = Type.getClassName(params.assetType);
    if (loaders.exists(name)) {
      loaders[name].load(params.id, params.path, params.callback, params.props, params.keep);
    } else {
      throw new Exception('Loader is not registered for type ${name}');
    }
  }

  public function loadAll(items: Array<AssetItem>, callback: () -> Void) {
    var loaded = 0;
    for (item in items) {
      load({
        assetType: item.type,
        id: item.id,
        path: item.path,
        props: item.props,
        callback: (asset) -> {
          loaded++;
          if (loaded == items.length) {
            callback();
          }
        }
      });
    }
  }

  public function add<T>(assetType: Class<T>, id: String, instance: T) {
    final name = Type.getClassName(assetType);
    if (loaders.exists(name)) {
      loaders[name].add(id, instance);
    } else {
      throw new Exception('Loader is not registered for type ${name}');
    }
  }

  public function get<T>(assetType: Class<T>, id): T {
    final name = Type.getClassName(assetType);
    if (loaders.exists(name)) {
      return loaders[name].get(id);
    } else {
      throw new Exception('Loader is not registered for type ${name}');
    }
  }

  public function unload<T>(assetType: Class<T>, id: String) {
    final name = Type.getClassName(assetType);
    if (loaders.exists(name)) {
      loaders[name].unload(id);
    } else {
      throw new Exception('Loader is not registered for type ${name}');
    }
  }
}
