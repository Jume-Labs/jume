package jume.graphics;

import jume.graphics.gl.Context;

import haxe.Exception;

import js.html.webgl.GL;
import js.html.webgl.Shader as WebGLShader;

import jume.di.Injectable;

/**
 * The shader class is used to create custom shaders.
 */
class Shader implements Injectable {
  /**
   * The shader id.
   */
  public var glShader(default, null): WebGLShader;

  /**
   * The rendering context.
   */
  @:inject
  final context: Context;

  /**
   * Create a new Shader.
   * @param source The shader source text.
   * @param type The shader type (Vertex or Fragment.)
   */
  public function new(source: String, type: ShaderType) {
    #if !headless
    final gl = context.gl;
    final shaderType = type == ShaderType.VERTEX ? GL.VERTEX_SHADER : GL.FRAGMENT_SHADER;
    final shader = gl.createShader(shaderType);
    if (shader == null) {
      throw new Exception('Unable to load shader:\n ${source}');
    }
    glShader = shader;

    gl.shaderSource(glShader, source);
    gl.compileShader(glShader);
    if (!gl.getShaderParameter(glShader, GL.COMPILE_STATUS)) {
      throw new Exception('Could not compile shader:\n, ${gl.getShaderInfoLog(glShader)}');
    }
    #end
  }

  /**
   * Delete the shader.
   */
  public inline function destroy() {
    #if !headless
    context.gl.deleteShader(glShader);
    #end
  }
}
