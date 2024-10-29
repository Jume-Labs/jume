package jume.assets;

import js.Browser;

@:dox(hide)
class TextLoader extends AssetLoader<String> {
  public function new() {
    super(String);
  }

  public override function load(id: String, path: String, callback: (asset: String) -> Void, ?options: Dynamic,
      ?keep: Bool) {
    keep ??= true;
    Browser.window.fetch(path).then((response) -> {
      if (response.status < 400) {
        response.text().then((text) -> {
          if (keep) {
            loadedAssets[id] = text;
          }
          callback(text);
        });
      } else {
        trace(response.statusText);
        callback(null);
      }
    });
  }
}
