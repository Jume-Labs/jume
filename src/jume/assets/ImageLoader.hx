package jume.assets;

import js.Browser;
import js.html.CanvasElement;
import js.lib.Uint8ClampedArray;

import jume.graphics.Image;

@:dox(hide)
class ImageLoader extends AssetLoader<Image> {
  public function new() {
    super(Image);
  }

  public override function load(id: String, path: String, callback: (asset: Image) -> Void, ?options: Dynamic,
      ?keep: Bool) {
    keep ??= true;
    final element = Browser.document.createImageElement();
    element.onload = () -> {
      element.onload = null;
      final canvas: CanvasElement = cast Browser.document.createElement('canvas');
      canvas.width = element.width;
      canvas.height = element.height;

      final canvasContext = canvas.getContext2d();
      canvasContext.drawImage(element, 0, 0);

      final data: Uint8ClampedArray = cast canvasContext.getImageData(0, 0, element.width, element.height).data;
      final image = new Image(element.width, element.height, data);
      if (keep) {
        loadedAssets[id] = image;
      }

      callback(image);
    }

    element.onerror = () -> {
      trace('Unable to load image ${id}.');
      callback(null);
    }

    element.src = path;
  }

  public override function unload(id: String): Bool {
    final image = loadedAssets[id];
    if (image != null) {
      image.destroy();
      return super.unload(id);
    }

    return false;
  }
}
