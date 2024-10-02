package jume.graphics;

import js.html.webgl.Framebuffer;
import js.html.webgl.GL;
import js.html.webgl.Texture;

import jume.di.Injectable;
import jume.graphics.gl.Context;
import jume.graphics.gl.TextureFilter;
import jume.graphics.gl.TextureWrap;
import jume.math.Mat4;
import jume.math.Size;

/**
 * A target to render to instead of the screen.
 * You can transform this and render it to the screen.
 */
class RenderTarget implements Injectable {
  /**
   * The width in pixels.
   */
  public final width: Int;

  /**
   * The height in pixels.
   */
  public final height: Int;

  /**
   * The target projection.
   */
  public var projection(default, null): Mat4;

  /**
   * The target texture.
   */
  public var texture(default, null): Texture;

  /**
   * The target frame buffer.
   */
  public var buffer(default, null): Framebuffer;

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
   * The rendering context.
   */
  @:inject
  var context: Context;

  /**
   * Create a new render target.
   * @param width The width in pixels.
   * @param height The height in pixels.
   */
  @SuppressWarnings('checkstyle:ParameterNumber')
  public function new(size: Size, magFilter: TextureFilter = LINEAR, minFilter: TextureFilter = LINEAR,
      uWrap: TextureWrap = CLAMP_TO_EDGE, vWrap: TextureWrap = CLAMP_TO_EDGE) {
    width = size.widthi;
    height = size.heighti;

    projection = new Mat4();
    projection.ortho({
      left: 0,
      right: width,
      bottom: height,
      top: 0,
      near: 0,
      far: 1000
    });

    this.magFilter = magFilter;
    this.minFilter = minFilter;
    this.uWrap = uWrap;
    this.vWrap = vWrap;

    #if !headless
    final gl = context.gl;
    buffer = gl.createFramebuffer();
    texture = gl.createTexture();

    gl.bindTexture(GL.TEXTURE_2D, texture);
    gl.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, width, height, 0, GL.RGBA, GL.UNSIGNED_BYTE, null);

    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, context.getTextureFilter(magFilter));
    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, context.getTextureFilter(minFilter));
    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, context.getTextureWrap(uWrap));
    gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, context.getTextureWrap(vWrap));

    gl.bindFramebuffer(GL.FRAMEBUFFER, buffer);
    gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, texture, 0);

    gl.bindFramebuffer(GL.FRAMEBUFFER, null);
    #end
  }

  /**
   * destroy the WebGL variables.
   */
  public function destroy() {
    #if !headless
    final gl = context.gl;
    gl.deleteTexture(texture);
    texture = null;

    gl.deleteFramebuffer(buffer);
    buffer = null;
    #end
  }
}
