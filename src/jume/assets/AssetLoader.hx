package jume.assets;

import jume.di.Injectable;

import haxe.Exception;

/**
 * Generic asset loader that can be extended to load custom asset types.
 */
class AssetLoader<T> implements Injectable {
  /**
   * The class type that this loader loads.
   */
  public final assetType: Class<T>;

  /**
   * Map of loaded assets of this type.
   */
  final loadedAssets: Map<String, T>;

  /**
   * Create a new instance of the loader.
   * @param assetType The type of asset this loader loads.
   */
  public function new(assetType: Class<T>) {
    this.assetType = assetType;
    loadedAssets = new Map<String, T>();
  }

  /**
   * Load a new asset.
   * @param id The id to store it as.
   * @param path The path to the asset.
   * @param callback The function to return the loaded assets in.
   * @param props Optional extra props needed to load the asset.
   * @param keep Should the asset be stored.
   */
  public function load(id: String, path: String, callback: (asset: T) -> Void, ?props: Dynamic, ?keep: Bool) {}

  /**
   * Add an asset to this loaded that was loaded externally.
   * @param id The id to store it as.
   * @param instance The asset to store.
   */
  public function add(id: String, instance: T) {
    this.loadedAssets[id] = instance;
  }

  /**
   * Get a loaded asset.
   * @param id The id of the asset.
   * @return The loaded asset.
   */
  public function get(id: String): T {
    if (loadedAssets.exists(id)) {
      return loadedAssets[id];
    }

    throw new Exception('Asset with id ${id} not loaded.');
  }

  /**
   * Remove and destroy an asset.
   * @param id The id of the asset.
   * @return True if unload was successful.
   */
  public function unload(id: String): Bool {
    if (loadedAssets.exists(id)) {
      loadedAssets.remove(id);

      return true;
    }

    return false;
  }
}
