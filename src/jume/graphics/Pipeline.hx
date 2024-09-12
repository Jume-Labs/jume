package jume.graphics;

import js.html.webgl.GL;
import js.html.webgl.Program;
import js.html.webgl.UniformLocation;

import jume.di.Injectable;
import jume.graphics.gl.BlendMode;
import jume.graphics.gl.BlendOperation;
import jume.graphics.gl.Context;

/**
 * The pipeline class to store and use shaders.
 */
class Pipeline implements Injectable {
  /**
   * Defaults to BlendOne.
   */
  public var blendSource: BlendMode;

  /**
   * Defaults to InverseSourceAlpha.
   */
  public var blendDestination: BlendMode;

  /**
   * Defaults to Add.
   */
  public var blendOperation: BlendOperation;

  /**
   * Defaults to BlendOne.
   */
  public var alphaBlendSource: BlendMode;

  /**
   * Defaults to InverseSourceAlpha.
   */
  public var alphaBlendDestination: BlendMode;

  /**
   * Defaults to Add.
   */
  public var alphaBlendOperation: BlendOperation;

  /**
   * Matrix projection location.
   */
  public var projectionLocation: UniformLocation;

  /**
   * Texture location for shaders that use a texture.
   */
  public var textureLocation: UniformLocation;

  /**
   * The vertex position in the shader.
   */
  public var vertexPositionLocation: Int;

  /**
   * The vertex color in the shader.
   */
  public var vertexColorLocation: Int;

  /**
   * The vertex uv in the shader.
   */
  public var vertexUVLocation: Int;

  // The shaders.
  var vertexShader: Shader;
  var fragmentShader: Shader;

  // The shader program.
  var program: Program;

  @:inject
  var context: Context;

  /**
   * Create a new shader pipeline.
   * @param vertexShader
   * @param fragmentShader
   * @param useTexture Does this shader use a texture.
   */
  public function new(vertexShader: Shader, fragmentShader: Shader, useTexture: Bool) {
    this.vertexShader = vertexShader;
    this.fragmentShader = fragmentShader;
    program = createProgram(useTexture);

    #if !headless
    final projection = context.gl.getUniformLocation(program, 'projectionMatrix');
    if (projection == null) {
      throw 'projectionMatrix not available in the vertex shader';
    }
    projectionLocation = projection;

    textureLocation = null;
    if (useTexture) {
      final tex = context.gl.getUniformLocation(program, 'tex');
      if (tex == null) {
        throw 'tex not available in the fragment shader';
      }
      textureLocation = tex;
    }
    #end

    blendSource = BLEND_ONE;
    blendDestination = INVERSE_SOURCE_ALPHA;
    blendOperation = ADD;

    alphaBlendSource = BLEND_ONE;
    alphaBlendDestination = INVERSE_SOURCE_ALPHA;
    alphaBlendOperation = ADD;
  }

  /**
   * Start rendering using this shader. This gets called by Graphics.
   */
  public inline function use() {
    #if !headless
    context.gl.useProgram(this.program);
    #end
  }

  /**
   * Get a WebGL uniform location for this pipeline.
   * @param location The location name
   * @returns The uniform location or null if not found.
   */
  public function getUniformLocation(location: String): UniformLocation {
    #if !headless
    return context.gl.getUniformLocation(this.program, location);
    #end

    return null;
  }

  /**
   * Create a new shader program.
   * @param useTexture
   * @returns The shader program.
   */
  function createProgram(useTexture: Bool): Program {
    #if !headless
    final gl = context.gl;
    final program = gl.createProgram();
    if (program != null) {
      gl.attachShader(program, vertexShader.glShader);
      gl.attachShader(program, fragmentShader.glShader);
      gl.linkProgram(program);

      final success: Bool = gl.getProgramParameter(program, GL.LINK_STATUS);
      if (!success) {
        var error = gl.getProgramInfoLog(program);
        if (error == null) {
          error = '';
        }
        throw 'Error while linking shader program: ${error}';
      }

      gl.bindAttribLocation(program, vertexPositionLocation, 'vertexPosition');
      gl.bindAttribLocation(program, vertexColorLocation, 'vertexColor');

      if (useTexture) {
        gl.bindAttribLocation(program, vertexUVLocation, 'vertexUV');
      }

      return program;
    } else {
      throw 'Unable to create shader program';
    }
    #end

    return null;
  }
}
