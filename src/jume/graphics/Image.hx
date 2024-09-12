package jume.graphics;

import js.html.webgl.GL;
import js.html.webgl.Texture;
import js.lib.Uint8ClampedArray;

import jume.graphics.gl.Context;
import jume.graphics.gl.TextureFilter;
import jume.graphics.gl.TextureWrap;
import jume.view.View;

/**
 * The image class is used to display images.
 */
class Image {
  /**
   * The image width in pixels.
   */
  public final width: Int;

  /**
   * The image height in pixels.
   */
  public final height: Int;

  /**
   * The image data array.
   */
  public final data: Uint8ClampedArray;

  /**
   * The texture to render.
   */
  public var texture(default, null): Texture;

  /**
   * The magnify filter.
   */
  public var magFilter(default, null): TextureFilter;

  /**
   * The minify filter.
   */
  public var minFilter(default, null): TextureFilter;

  /**
   * The u axis wrap.
   */
  public var uWrap(default, null): TextureWrap;

  /**
   * The v axis wrap.
   */
  public var vWrap(default, null): TextureWrap;

  /**
   * The WebGL context service.
   */
  @:inject
  var context: Context;

  /**
   * The view service.
   */
  @:inject
  var view: View;

  /**
   * Create a new image instance.
   * @param width The width in pixels.
   * @param height The height in pixels.
   * @param data The image data.
   */
  public function new(width: Int, height: Int, data: Uint8ClampedArray) {
    this.width = width;
    this.height = height;
    this.data = data;
    this.magFilter = view.pixelFilter ? NEAREST : LINEAR;
    this.minFilter = view.pixelFilter ? NEAREST : LINEAR;

    #if !headless
    texture = this.createTexture();
    updateTexture(magFilter, minFilter, uWrap, vWrap);
    #end
  }

  /**
   * Get a pixel color in the image.
   * @param x The x position in pixels.
   * @param y The y position in pixels.
   * @param out Optional color to store the result in.
   * @return The pixel color.
   */
  public function getPixel(x: Int, y: Int, ?out: Color): Color {
    if (out == null) {
      out = new Color();
    }
    if (x < 0 || x >= width || y < 0 || y >= height) {
      #if debug
      trace('Pixel position is out of range.');
      #end
      out.copyFrom(Color.TRANSPARENT);

      return out;
    }

    final pos = x * 4 + y * width * 4;
    out.set({
      red: data[pos] / 255,
      green: data[pos + 1] / 255,
      blue: data[pos + 2] / 255,
      alpha: data[pos + 3] / 255
    });

    return out;
  }

  /**
   * Set a pixel color in the image.
   * @param x The x position in pixels.
   * @param y The y position in pixels.
   * @param color The color to set.
   */
  public function setPixel(x: Int, y: Int, color: Color) {
    if (x < 0 || x >= width || y < 0 || y >= height) {
      #if debug
      trace('Pixel position is out of range.');
      #end
      return;
    }

    final pos = x * 4 + y * width * 4;

    data[pos] = Math.floor(color.red * 255);
    data[pos + 1] = Math.floor(color.green * 255);
    data[pos + 2] = Math.floor(color.blue * 255);
    data[pos + 3] = Math.floor(color.alpha * 255);
  }

  /**
   * Update the WebGL texture.
   * @param magFilter Magnify filter.
   * @param minFilter Minify filter.
   * @param uWrap U axis wrapping.
   * @param vWrap V axis wrapping.
   */
  public function updateTexture(magFilter: TextureFilter = LINEAR, minFilter: TextureFilter = LINEAR,
      uWrap: TextureWrap = CLAMP_TO_EDGE, vWrap: TextureWrap = CLAMP_TO_EDGE) {
    #if !headless
    if (texture == null) {
      return;
    }

    this.magFilter = magFilter;
    this.minFilter = minFilter;
    this.uWrap = uWrap;
    this.vWrap = vWrap;

    final gl = context.gl;

    gl.bindTexture(GL.TEXTURE_2D, texture);
    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, context.getTextureFilter(magFilter));
    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, context.getTextureFilter(minFilter));
    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, context.getTextureWrap(uWrap));
    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, context.getTextureWrap(vWrap));

    gl.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, width, height, 0, GL.RGBA, GL.UNSIGNED_BYTE, data);

    gl.bindTexture(GL.TEXTURE_2D, null);
    #end
  }

  /**
   * Destroy the texture.
   */
  public function destroy() {
    #if !headless
    context.gl.deleteTexture(texture);
    #end
  }

  /**
   * Create a new WebGL texture.
   * @return The created texture.
   */
  function createTexture(): Texture {
    #if !headless
    final gl = context.gl;
    if (texture != null) {
      gl.deleteTexture(texture);
    }

    return gl.createTexture();
    #end

    return null;
  }
}
