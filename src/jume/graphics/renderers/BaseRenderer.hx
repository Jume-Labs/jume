package jume.graphics.renderers;

import js.html.webgl.Buffer;
import js.lib.Float32Array;
import js.lib.Int32Array;

import jume.graphics.gl.Context;
import jume.math.Mat4;

/**
 * Base class for 2d renderers.
 */
class BaseRenderer {
  /**
   * The color for the item that will be drawn.
   */
  public var currentColor: Color;

  /**
   * The transform for the item that will be drawn.
   */
  public var currentTransform: Mat4;

  /**
   * The maximum triangles or quads to render in one draw call.
   */
  final BUFFER_SIZE = 4000;

  /**
   * The size of a float in bytes.
   */
  final FLOAT_SIZE = Float32Array.BYTES_PER_ELEMENT;

  /**
   * The current shader pipeline.
   */
  var pipeline: Pipeline;

  /**
   * The default shader pipeline.
   */
  var defaultPipeline: Pipeline;

  /**
   * The view projection.
   */
  var projection: Mat4;

  /**
   * The vertex buffer for the renderer.
   */
  var vertexBuffer: Buffer;

  /**
   * The index buffer for the renderer.
   */
  var indexBuffer: Buffer;

  /**
   * The vertex indices that will be rendered.
   */
  var vertexIndices: Float32Array;

  /**
   * The index indices per triangle or quad depending on the renderer.
   */
  var indexIndices: Int32Array;

  /**
   * WebGL rendering context.
   */
  final context: Context;

  /**
   * Create a new renderer.
   * @param context Rendering context.
   */
  public function new(context: Context) {
    this.context = context;
    projection = new Mat4();
  }

  /**
   * Update the projection.
   * @param projection The new projection.
   */
  public inline function setProjection(projection: Mat4) {
    this.projection.copyFrom(projection);
  }

  /**
   * Set a shader pipeline.
   * @param pipeline The new pipeline. If passed null the default pipeline is used.
   */
  public inline function setPipeline(pipeline: Pipeline) {
    if (pipeline == null) {
      this.pipeline = this.defaultPipeline;
    } else {
      this.pipeline = pipeline;
    }
  }
}
