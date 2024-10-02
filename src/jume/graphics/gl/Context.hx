package jume.graphics.gl;

import haxe.Exception;

import js.Browser;
import js.html.CanvasElement;
import js.html.webgl.ContextAttributes;
import js.html.webgl.GL2;
import js.html.webgl.GL;

import jume.di.Service;

/**
 * WebGL context service.
 */
class Context implements Service {
  /**
   * Is the game running WebGL 1.
   */
  public final isGL1: Bool;

  /**
   * The WebGL context.
   */
  public var gl(default, null): GL2;

  /**
   * Create a new Context instance.
   * @param canvasId The id of the canvas element.
   * @param forceWebGL1 Should WebGL 1 be forced.
   */
  public function new(canvasId: String, forceWebGL1: Bool) {
    var gl1 = false;

    #if !headless
    final attributes: ContextAttributes = {
      alpha: false,
      antialias: true
    };

    final canvas: CanvasElement = cast Browser.document.getElementById(canvasId);
    var context = forceWebGL1 ? null : canvas.getContextWebGL2(attributes);

    if (context == null) {
      context = cast canvas.getContextWebGL(attributes);
      if (context == null) {
        throw new Exception('Unable to initialize WebGL context.');
      }
      gl1 = true;
    }

    gl = context;

    gl.pixelStorei(GL.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 1);
    gl.getExtension('OES_texture_float_linear');
    gl.getExtension('OES_texture_half_float_linear');

    if (gl1) {
      gl.getExtension('OES_texture_float');
      gl.getExtension('EXT_shader_texture_lod');
      gl.getExtension('OES_standard_derivatives');
    } else {
      gl.getExtension('EXT_color_buffer_float');
    }

    gl.enable(GL.BLEND);
    gl.blendFunc(GL.ONE, GL.ONE_MINUS_SRC_ALPHA);
    #end

    isGL1 = gl1;
  }

  /**
   * Get the WebGL blend mode.
   * @param mode The blend mode.
   * @return The GL blend mode.
   */
  public function getGLBlendMode(mode: BlendMode): Int {
    #if !headless
    switch (mode) {
      case BLEND_ZERO:
        return GL.ZERO;

      case UNDEFINED:
        return GL.ZERO;

      case BLEND_ONE:
        return GL.ONE;

      case SOURCE_ALPHA:
        return GL.SRC_ALPHA;

      case DESTINATION_ALPHA:
        return GL.DST_ALPHA;

      case INVERSE_SOURCE_ALPHA:
        return GL.ONE_MINUS_SRC_ALPHA;

      case INVERSE_DESTINATION_ALPHA:
        return GL.ONE_MINUS_DST_ALPHA;

      case SOURCE_COLOR:
        return GL.SRC_COLOR;

      case DESTINATION_COLOR:
        return GL.DST_COLOR;

      case INVERSE_SOURCE_COLOR:
        return GL.ONE_MINUS_SRC_COLOR;

      case INVERSE_DESTINATION_COLOR:
        return GL.ONE_MINUS_DST_COLOR;
    }
    #else
    return -1;
    #end
  }

  /**
   * Get the WebGL blend operation.
   * @param operation The blend operation.
   * @return The GL blend operation.
   */
  public function getBlendOperation(operation: BlendOperation): Int {
    #if !headless
    switch (operation) {
      case ADD:
        return GL.FUNC_ADD;

      case SUBTRACT:
        return GL.FUNC_SUBTRACT;

      case REVERSE_SUBTRACT:
        return GL.FUNC_REVERSE_SUBTRACT;
    }
    #else
    return -1;
    #end
  }

  /**
   * Get the WebGL texture wrap mode.
   * @param wrap The texture wrap mode.
   * @return The GL wrap mode.
   */
  public function getTextureWrap(wrap: TextureWrap): Int {
    switch (wrap) {
      case CLAMP_TO_EDGE:
        return GL.CLAMP_TO_EDGE;

      case REPEAT:
        return GL.REPEAT;

      case MIRRORED_REPEAT:
        return GL.MIRRORED_REPEAT;
    }
  }

  /**
   * Get the WebGL texture filter.
   * @param filter The texture filter.
   * @param mipmap The mipmap filter.
   * @return The GL texture filter.
   */
  public function getTextureFilter(filter: TextureFilter, mipmap: MipmapFilter = NONE): Int {
    switch (filter) {
      case NEAREST:
        switch (mipmap) {
          case NONE:
            return GL.NEAREST;

          case NEAREST:
            return GL.NEAREST_MIPMAP_NEAREST;

          case LINEAR:
            return GL.NEAREST_MIPMAP_LINEAR;
        }

      case LINEAR:
        switch (mipmap) {
          case NONE:
            return GL.LINEAR;

          case NEAREST:
            return GL.LINEAR_MIPMAP_NEAREST;

          case LINEAR:
            return GL.LINEAR_MIPMAP_LINEAR;
        }

      case ANISOTROPIC:
        switch (mipmap) {
          case NONE:
            return GL.LINEAR;

          case NEAREST:
            return GL.LINEAR_MIPMAP_NEAREST;

          case LINEAR:
            return GL.LINEAR_MIPMAP_LINEAR;
        }
    }
  }
}
