package jume.assets;

import js.Browser;

class TextLoader extends AssetLoader<String> {
  public function new() {
    super(String);
  }

  public override function load(id: String, path: String, callback: (asset: String)->Void, ?props: Dynamic,
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