package jume.assets;

import jume.di.Injectable;

import haxe.Exception;

class AssetLoader<T> implements Injectable {
  public final assetType: Class<T>;

  final loadedAssets: Map<String, T>;

  public function new(assetType: Class<T>) {
    this.assetType = assetType;
    loadedAssets = new Map<String, T>();
  }

  public function load(id: String, path: String, callback: (asset: T)->Void, ?props: Dynamic, ?keep: Bool) {}

  public function add(id: String, instance: T) {
    this.loadedAssets[id] = instance;
  }

  public function get(id: String): T {
    if (loadedAssets.exists(id)) {
      return loadedAssets[id];
    }

    throw new Exception('Asset with id ${id} not loaded.');
  }

  public function unload(id: String): Bool {
    if (loadedAssets.exists(id)) {
      loadedAssets.remove(id);

      return true;
    }

    return false;
  }
}
