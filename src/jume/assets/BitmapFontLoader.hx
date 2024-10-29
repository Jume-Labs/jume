package jume.assets;

import jume.graphics.Image;
import jume.graphics.bitmapFont.BitmapFont;

@:dox(hide)
class BitmapFontLoader extends AssetLoader<BitmapFont> {
  @:inject
  var assets: Assets;

  public function new() {
    super(BitmapFont);
  }

  public override function load(id: String, path: String, callback: (asset: BitmapFont) -> Void, ?options: Dynamic,
      ?keep: Bool) {
    keep ??= true;
    assets.load({
      assetType: Image,
      id: 'jume_bitmap_font_${id}',
      path: '${path}.png',
      keep: keep,
      callback: (image) -> {
        assets.load({
          assetType: String,
          id: 'jume_bitmap_font_${id}',
          path: '${path}.fnt',
          keep: keep,
          callback: (text) -> {
            if (image == null && text == null) {
              callback(null);
            } else {
              final font = new BitmapFont(image, text);
              if (keep) {
                loadedAssets[id] = font;
              }

              callback(font);
            }
          }
        });
      }
    });
  }

  public override function unload(id: String): Bool {
    if (loadedAssets.exists(id)) {
      assets.unload(Image, 'jume_bitmap_font_${id}');
      assets.unload(String, 'jume_bitmap_font_${id}');
    }

    return super.unload(id);
  }
}
