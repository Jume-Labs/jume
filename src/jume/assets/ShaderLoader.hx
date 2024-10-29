package jume.assets;

import haxe.io.Path;

import jume.graphics.Shader;
import jume.graphics.ShaderType;
import jume.graphics.gl.Context;

@:dox(hide)
class ShaderLoader extends AssetLoader<Shader> {
  @:inject
  var assets: Assets;

  @:inject
  var context: Context;

  public function new() {
    super(Shader);
  }

  public override function load(id: String, path: String, callback: (asset: Shader) -> Void, ?options: Dynamic,
      ?keep: Bool) {
    keep ??= true;
    final extension = Path.extension(path);
    if (context.isGL1) {
      final dirAndFile = Path.withoutExtension(path);
      path = '${dirAndFile}.gl1${extension}';
    }

    final shaderType: ShaderType = extension == 'vert' ? VERTEX : FRAGMENT;
    assets.load({
      assetType: String,
      id: 'jume_shader_${id}',
      path: path,
      callback: (text) -> {
        if (text == null) {
          callback(null);
        } else {
          final shader = new Shader(text, shaderType);
          if (keep) {
            loadedAssets[id] = shader;
          }

          callback(shader);
        }
      }
    });
  }

  public override function unload(id: String): Bool {
    final shader = loadedAssets[id];
    if (shader != null) {
      shader.destroy();
      return super.unload(id);
    }

    return false;
  }
}
