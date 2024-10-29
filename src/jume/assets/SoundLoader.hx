package jume.assets;

import js.Browser;

import jume.audio.Audio;
import jume.audio.Sound;

@:dox(hide)
class SoundLoader extends AssetLoader<Sound> {
  @:inject
  var audio: Audio;

  public function new() {
    super(Sound);
  }

  public override function load(id: String, path: String, callback: (asset: Sound) -> Void, ?options: Dynamic,
      ?keep: Bool) {
    keep ??= true;
    Browser.window.fetch(path).then((response) -> {
      if (response.status < 400) {
        response.arrayBuffer().then((buffer) -> {
          audio.decodeSound(id, buffer, (sound) -> {
            if (sound != null) {
              if (keep) {
                loadedAssets[id] = sound;
              }

              callback(sound);
            } else {
              trace(response.statusText);
              callback(null);
            }
          });
        });
      }
    });
  }
}
