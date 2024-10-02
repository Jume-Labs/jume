package jume.assets;

import haxe.Exception;

import jume.graphics.Image;
import jume.tilemap.Tileset;

/**
 * The extra props to load a tileset.
 */
typedef LoadTilesetProps = {
  /**
   * The width of a single tile in pixels.
   */
  var tileWidth: Int;

  /**
   * The height of a single tile in pixels.
   */
  var tileHeight: Int;

  /**
   * The space between two tiles in pixels.
   */
  var spacing: Int;

  /**
   * The space from the edge of the image to the tiles in pixels.
   */
  var margin: Int;
}

class TilesetLoader extends AssetLoader<Tileset> {
  @:inject
  var assets: Assets;

  public function new() {
    super(Tileset);
  }

  public override function load(id: String, path: String, callback: (asset: Tileset) -> Void, ?props: Dynamic,
      ?keep: Bool) {
    keep ??= true;

    if (props == null
      || props.tileWidth == null
      || props.tileHeight == null
      || props.spacing == null
      || props.margin == null) {
      throw new Exception('Missing properties needed to load the tileset.');
    }

    final tilesetProps: LoadTilesetProps = cast props;

    assets.load({
      assetType: Image,
      id: 'jume_tileset_${id}',
      path: path,
      keep: keep,
      callback: (image) -> {
        if (image != null) {
          final tileset = new Tileset(image, tilesetProps.tileWidth, tilesetProps.tileHeight, tilesetProps.spacing,
            tilesetProps.margin);

          if (keep) {
            loadedAssets[id] = tileset;
          }

          callback(tileset);
        } else {
          callback(null);
        }
      }
    });
  }

  public override function unload(id: String): Bool {
    if (loadedAssets.exists(id)) {
      assets.unload(Image, 'jume_tileset_${id}');

      return super.unload(id);
    }

    return false;
  }
}
