package jume.assets;

import jume.graphics.Image;
import jume.graphics.atlas.Atlas;

@:dox(hide)
class AtlasLoader extends AssetLoader<Atlas> {
  @:inject
  var assets: Assets;

  public function new() {
    super(Atlas);
  }

  public override function load(id: String, path: String, callback: (asset: Atlas) -> Void, ?options: Dynamic,
      ?keep: Bool) {
    keep ??= true;
    assets.load({
      assetType: Image,
      id: 'jume_atlas_${id}',
      path: '${path}.png',
      keep: keep,
      callback: (image) -> {
        assets.load({
          assetType: String,
          id: 'jume_atlas_${id}',
          path: '${path}.json',
          keep: keep,
          callback: (text) -> {
            if (image == null || text == null) {
              callback(null);
            } else {
              final atlas = new Atlas(image, text);
              if (keep) {
                loadedAssets[id] = atlas;
              }
              callback(atlas);
            }
          }
        });
      }
    });
  }

  public override function unload(id: String): Bool {
    if (loadedAssets.exists(id)) {
      assets.unload(Image, 'jume_atlas_${id}');
      assets.unload(String, 'jume_atlas_${id}');

      return super.unload(id);
    }

    return false;
  }
}
