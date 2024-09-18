package jume.graphics;

import haxe.Exception;

import js.html.webgl.GL;
import js.html.webgl.UniformLocation;
import js.lib.Float32Array;
import js.lib.Int32Array;

import jume.di.Injectable;
import jume.di.Service;
import jume.graphics.bitmapFont.BitmapFont;
import jume.graphics.gl.BlendMode;
import jume.graphics.gl.BlendOperation;
import jume.graphics.gl.Context;
import jume.graphics.gl.MipmapFilter;
import jume.graphics.gl.TextureFilter;
import jume.graphics.gl.TextureWrap;
import jume.graphics.renderers.ImageRenderer;
import jume.graphics.renderers.ShapeRenderer;
import jume.math.Mat4;
import jume.math.Rectangle;
import jume.math.Size;
import jume.math.Vec2;
import jume.view.View;

typedef TextureParams = {
  var texUnit: Int;
  var uWrap: TextureWrap;
  var vWrap: TextureWrap;
  var minFilter: TextureFilter;
  var magFilter: TextureFilter;
  var mipmapFilter: MipmapFilter;
}

typedef BlendModeParams = {
  var source: BlendMode;
  var destination: BlendMode;
  var operation: BlendOperation;
  var alphaSource: BlendMode;
  var alphaDestination: BlendMode;
  var alphaOperation: BlendOperation;
}

/**
 * The graphics class does all the rendering in the engine.
 */
class Graphics implements Service implements Injectable {
  /**
   * The color for the next item to draw.
   */
  public var color: Color;

  /**
   * The current transform.
   */
  public var transform(get, never): Mat4;

  /**
   * The transform stores all pushed transforms.
   */
  public var transformStack(default, null): Array<Mat4>;

  /**
   * The limit of targets on the stack.
   */
  static inline final MAX_TARGET_STACK = 64;

  /**
   * The limit of transforms on the stack.
   */
  static inline final MAX_TRANSFORM_STACK = 128;

  /**
   * The shape renderer instance.
   */
  var shapeRenderer: ShapeRenderer;

  /**
   * The image renderer instance.
   */
  var imageRenderer: ImageRenderer;

  /**
   * The render target stack.
   */
  final targetStack: Array<RenderTarget> = [];

  /**
   * The gl clear color.
   */
  var clearColor: Color;

  /**
   * The view projection.
   */
  var projection: Mat4;

  /**
   * The WebGL rendering context.
   */
  var context: Context;

  /**
   * The view service.
   */
  var view: View;

  /**
   * Temporary projection params.
   */
  var tempOrtho: OrthoParams;

  /**
   * Temporary blend params.
   */
  var tempBlendModeParams: BlendModeParams;

  /**
   * Create a new graphics instance.
   * @param context The WebGL context.
   * @param view The view service.
   */
  public function new(context: Context, view: View) {
    this.context = context;
    this.view = view;

    color = new Color(1, 1, 1, 1);

    clearColor = new Color(0, 0, 0, 1);

    transformStack = [new Mat4()];
    targetStack = [];

    projection = new Mat4();

    tempOrtho = {
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
      near: 0,
      far: 0
    };

    tempBlendModeParams = {
      source: BLEND_ONE,
      destination: INVERSE_SOURCE_ALPHA,
      operation: ADD,
      alphaSource: BLEND_ONE,
      alphaDestination: INVERSE_SOURCE_ALPHA,
      alphaOperation: ADD
    };

    setBlendMode(tempBlendModeParams);
    shapeRenderer = new ShapeRenderer(context);
    imageRenderer = new ImageRenderer(context);
  }

  /**
   * Set the blend modes.
   * @param params The blend parameters.
   */
  public function setBlendMode(params: BlendModeParams) {
    #if !headless
    final gl = context.gl;
    final mode = context.getGLBlendMode;
    final operation = context.getBlendOperation;
    if (params.source == BLEND_ONE && params.destination == BLEND_ZERO) {
      gl.disable(GL.BLEND);
    } else {
      gl.enable(GL.BLEND);
      gl.blendFuncSeparate(mode(params.source), mode(params.destination), mode(params.alphaSource),
        mode(params.alphaDestination));
      gl.blendEquationSeparate(operation(params.operation), operation(params.alphaOperation));
    }
    #end
  }

  /**
   * Push a render target onto the render stack.
   * @param target The target to push.
   */
  public function pushTarget(target: RenderTarget) {
    if (transformStack.length == MAX_TARGET_STACK) {
      throw new Exception('Render target stack size exceeded. (more pushes than pulls?)');
    }

    targetStack.push(target);
    context.gl.bindFramebuffer(GL.FRAMEBUFFER, target.buffer);
  }

  /**
   * Pop a render target from the render stack.
   */
  public function popTarget() {
    targetStack.pop();

    final gl = context.gl;
    if (targetStack.length > 0) {
      gl.bindFramebuffer(GL.FRAMEBUFFER, targetStack[targetStack.length - 1].buffer);
    } else {
      gl.bindFramebuffer(GL.FRAMEBUFFER, null);
    }
  }

  /**
   * Clear all render targets.
   */
  public function clearTargets() {
    while (targetStack.length > 0) {
      targetStack.pop();
    }
    context.gl.bindFramebuffer(GL.FRAMEBUFFER, null);
  }

  /**
   * Set texture parameters.
   * @param params The texture parameters.
   */
  public inline function setTextureParameters(params: TextureParams) {
    imageRenderer.setTextureParameters(params);
  }

  /**
   * Push a new transform onto the stack.
   * @param transform The new transform.
   */
  public function pushTransform(?transform: Mat4) {
    if (transformStack.length == MAX_TRANSFORM_STACK) {
      throw new Exception('Transform stack size exceeded. (more pushes than pulls)');
    }

    if (transform == null) {
      transformStack.push(Mat4.get(this.transform));
    } else {
      transformStack.push(Mat4.get(transform));
    }
  }

  /**
   * Multiple the current transform with this transform.
   * @param transform The transform to multiply with.
   */
  public inline function applyTransform(transform: Mat4) {
    Mat4.multiply(this.transform, transform, this.transform);
  }

  /**
   * Pops the top transform from the stack.
   */
  public inline function popTransform() {
    if (transformStack.length <= 1) {
      throw new Exception('Cannot pop the last transform off the stack.');
    }
    transformStack.pop().put();
  }

  /**
   * Start the renderer.
   * @param clear If true clear the screen / target. Defaults to true.
   * @param clearColor The clear color used when clear is set to true.
   */
  public function start(clear = true, ?clearColor: Color) {
    final gl = context.gl;

    var width: Int;
    var height: Int;

    if (targetStack.length > 0) {
      final target = targetStack[targetStack.length - 1];
      width = target.width;
      height = target.height;
    } else {
      width = view.canvasWidth;
      height = view.canvasHeight;
    }

    tempOrtho.left = 0;
    tempOrtho.right = width;
    tempOrtho.bottom = height;
    tempOrtho.top = 0;
    tempOrtho.near = 0;
    tempOrtho.far = 1000;
    projection.ortho(tempOrtho);

    shapeRenderer.setProjection(projection);
    imageRenderer.setProjection(projection);

    gl.viewport(0, 0, width, height);
    if (clear) {
      if (clearColor != null) {
        gl.clearColor(clearColor.red, clearColor.green, clearColor.blue, clearColor.alpha);
      } else {
        gl.clearColor(this.clearColor.red, this.clearColor.green, this.clearColor.blue, this.clearColor.alpha);
      }
      gl.clear(GL.COLOR_BUFFER_BIT);
    }
  }

  /**
   * Render the batch to the screen / target.
   */
  public function present() {
    shapeRenderer.present();
    imageRenderer.present();
  }

  /**
   * Set the shader pipeline.
   * @param pipeline The pipeline to set.
   */
  public function setPipeline(?pipeline: Pipeline) {
    if (pipeline != null) {
      tempBlendModeParams.source = pipeline.blendSource;
      tempBlendModeParams.destination = pipeline.blendDestination;
      tempBlendModeParams.operation = pipeline.blendOperation;
      tempBlendModeParams.alphaSource = pipeline.alphaBlendSource;
      tempBlendModeParams.alphaDestination = pipeline.alphaBlendDestination;
      tempBlendModeParams.alphaOperation = pipeline.alphaBlendOperation;
      setBlendMode(tempBlendModeParams);
      pipeline.use();
    }

    shapeRenderer.setPipeline(pipeline);
    imageRenderer.setPipeline(pipeline);
  }

  /**
   * Draw a solid triangle.
   * @param point1 The first position.
   * @param point2 The second position.
   * @param point3 The third position.
   */
  public function drawSolidTriangle(point1: Vec2, point2: Vec2, point3: Vec2) {
    imageRenderer.present();
    shapeRenderer.currentColor = color;
    shapeRenderer.currentTransform = transform;
    shapeRenderer.drawSolidTriangle(point1, point2, point3);
  }

  /**
   * Draw a solid rectangle.
   * @param rect The rectangle to draw.
   */
  public inline function drawSolidRect(rect: Rectangle) {
    imageRenderer.present();
    shapeRenderer.currentColor = color;
    shapeRenderer.currentTransform = transform;
    shapeRenderer.drawSolidRect(rect);
  }

  /**
   * Draw a rectangle outline.
   * @param rect The rectangle to draw.
   * @param lineWidth The line width in pixels.
   */
  public inline function drawRect(rect: Rectangle, lineWidth: Float) {
    imageRenderer.present();
    shapeRenderer.currentColor = color;
    shapeRenderer.currentTransform = transform;
    shapeRenderer.drawRect(rect, lineWidth);
  }

  /**
   * Draw a line between two points.
   * @param start The start position.
   * @param end The end position.
   * @param align Should the line be on the outside, middle or inside of the points.
   * @param lineWidth The width of the line in pixels.
   */
  public function drawLine(start: Vec2, end: Vec2, align: LineAlign, lineWidth: Float) {
    imageRenderer.present();
    shapeRenderer.currentColor = color;
    shapeRenderer.currentTransform = transform;
    shapeRenderer.drawLine(start, end, align, lineWidth);
  }

  /**
   * Draw a circle outline.
   * @param position The center position of the circle.
   * @param radius The radius in pixels.
   * @param segments The number of segments. More segments is a smoother circle.
   * @param lineWidth The line width of the outline in pixels.
   */
  public function drawCircle(position: Vec2, radius: Float, segments: Int, lineWidth: Float) {
    imageRenderer.present();
    shapeRenderer.currentColor = color;
    shapeRenderer.currentTransform = transform;
    shapeRenderer.drawCircle(position, radius, segments, lineWidth);
  }

  /**
   * Draw a circle filled with a color.
   * @param position The center position of the circle.
   * @param radius The circle radius in pixels.
   * @param segments The number of segments. More segments is a smoother circle.
   */
  public function drawSolidCircle(position: Vec2, radius: Float, segments: Int) {
    imageRenderer.present();
    shapeRenderer.currentColor = color;
    shapeRenderer.currentTransform = transform;
    shapeRenderer.drawSolidCircle(position, radius, segments);
  }

  /**
   * Draw a polygon outline.
   * @param position The center position of the polygon.
   * @param vertices The positions of all vertices.
   * @param lineWidth The line width in pixels.
   */
  public function drawPolygon(position: Vec2, vertices: Array<Vec2>, lineWidth: Float) {
    imageRenderer.present();
    shapeRenderer.currentColor = color;
    shapeRenderer.currentTransform = transform;
    shapeRenderer.drawPolygon(position, vertices, lineWidth);
  }

  /**
   * Draw a solid polygon.
   * @param position The center position of the polygon.
   * @param vertices The positions of all vertices.
   */
  public function drawSolidPolygon(position: Vec2, vertices: Array<Vec2>) {
    imageRenderer.present();
    shapeRenderer.currentColor = color;
    shapeRenderer.currentTransform = transform;
    shapeRenderer.drawSolidPolygon(position, vertices);
  }

  /**
   * Draw an image into the buffer.
   * @param position The position in pixels.
   * @param image The image to draw.
   * @param flip Flip the image on the x or y axis.
   */
  public inline function drawImage(position: Vec2, image: Image, flip: Flip) {
    shapeRenderer.present();
    imageRenderer.currentColor = color;
    imageRenderer.currentTransform = transform;
    imageRenderer.drawImage(position, image, flip);
  }

  /**
   * Draw an image with a custom size into the buffer.
   * @param position The position in pixels.
   * @param size The custom image size in pixels.
   * @param image The image to draw.
   * @param flip Flip the image on the x or y axis.
   */
  public inline function drawScaledImage(position: Vec2, size: Size, image: Image, flip: Flip) {
    shapeRenderer.present();
    imageRenderer.currentColor = color;
    imageRenderer.currentTransform = transform;
    imageRenderer.drawScaledImage(position, size, image, flip);
  }

  /**
   * Draw a section of an image.
   * @param position The position in pixels.
   * @param rect The rect inside the source image in pixels.
   * @param image The source image.
   * @param flip Flip the image on the x or y axis.
   */
  public inline function drawImageSection(position: Vec2, rect: Rectangle, image: Image, flip: Flip) {
    shapeRenderer.present();
    imageRenderer.currentColor = color;
    imageRenderer.currentTransform = transform;
    imageRenderer.drawImageSection(position, rect, image, flip);
  }

  /**
   * Draw a section of an image and set a custom image size.
   * @param position The position in pixels.
   * @param size The custom image size in pixels.
   * @param rect The rect inside the source image in pixels.
   * @param image The source image.
   * @param flip Flip the image on the x or y axis.
   */
  public function drawScaledImageSection(position: Vec2, size: Size, rect: Rectangle, image: Image, flip: Flip) {
    shapeRenderer.present();
    imageRenderer.currentColor = color;
    imageRenderer.currentTransform = transform;
    imageRenderer.drawScaledImageSection(position, size, rect, image, flip);
  }

  /**
   * Draw an image that is not uniform by specifying each point.
   * @param tl The top left position in pixels.
   * @param tr The top right position in pixels.
   * @param br The bottom right position in pixels.
   * @param bl The bottom left position in pixels.
   * @param image The image to draw.
   */
  public function drawImagePoints(tl: Vec2, tr: Vec2, br: Vec2, bl: Vec2, image: Image) {
    shapeRenderer.present();
    imageRenderer.currentColor = color;
    imageRenderer.currentTransform = transform;
    imageRenderer.drawImagePoints(tl, tr, br, bl, image);
  }

  /**
   * 
   * Draw an image part that is not uniform by specifying each point.
   * @param tl The top left position in pixels.
   * @param tr The top right position in pixels.
   * @param br The bottom right position in pixels.
   * @param bl The bottom left position in pixels.
   * @param rect The rectangle of the section inside the image in pixels.
   * @param image The image to draw.
   */
  @SuppressWarnings('checkstyle:ParameterNumber')
  public function drawImageSectionPoints(tl: Vec2, tr: Vec2, br: Vec2, bl: Vec2, rect: Rectangle, image: Image) {
    shapeRenderer.present();
    imageRenderer.currentColor = color;
    imageRenderer.currentTransform = transform;
    imageRenderer.drawImageSectionPoints(tl, tr, br, bl, rect, image);
  }

  /**
   * Draw a render target to the screen.
   * @param position The position in pixels.
   * @param target The target to render.
   */
  public function drawRenderTarget(position: Vec2, target: RenderTarget) {
    shapeRenderer.present();
    imageRenderer.currentColor = color;
    imageRenderer.currentTransform = transform;
    imageRenderer.drawRenderTarget(position, target);
  }

  /**
   * Draw a string using a bitmap font.
   * @param position The position in pixels.
   * @param text The text to draw.
   * @param font The bitmap font to use.
   */
  public function drawBitmapText(position: Vec2, font: BitmapFont, text: String) {
    shapeRenderer.present();
    imageRenderer.currentColor = color;
    imageRenderer.currentTransform = transform;
    imageRenderer.drawBitmapText(position, font, text);
  }

  /**
   * Set a boolean value for the current pipeline.
   * @param location The location in the shader.
   * @param value The new value.
   */
  public inline function setBool(location: UniformLocation, value: Bool) {
    #if !headless
    context.gl.uniform1i(location, value ? 1 : 0);
    #end
  }

  /**
   * Set an integer value for the current pipeline.
   * @param location The location in the shader.
   * @param value The new value.
   */
  public inline function setInt(location: UniformLocation, value: Int) {
    #if !headless
    context.gl.uniform1i(location, value);
    #end
  }

  /**
   * Set two integer values for the current pipeline.
   * @param location The location in the shader.
   * @param value1 The first new integer value.
   * @param value2 The second integer value.
   */
  public inline function setInt2(location: UniformLocation, value1: Int, value2: Int) {
    #if !headless
    context.gl.uniform2i(location, value1, value2);
    #end
  }

  /**
   * Set three integer values for the current pipeline.
   * @param location The location in the shader.
   * @param value1 The first new integer value.
   * @param value2 The second integer value.
   * @param value3 The third integer value.
   */
  public inline function setInt3(location: UniformLocation, value1: Int, value2: Int, value3: Int) {
    #if !headless
    context.gl.uniform3i(location, value1, value2, value3);
    #end
  }

  /**
   * Set four integer values for the current pipeline.
   * @param location The location in the shader.
   * @param value1 The first new integer value.
   * @param value2 The second integer value.
   * @param value4 The fourth integer value.
   */
  public inline function setInt4(location: UniformLocation, value1: Int, value2: Int, value3: Int, value4: Int) {
    #if !headless
    context.gl.uniform4i(location, value1, value2, value3, value4);
    #end
  }

  /**
   * Set an array of integer for the current pipeline.
   * @param location The location in the shader.
   * @param values The new values.
   */
  public inline function setInts(location: UniformLocation, value: Int32Array) {
    #if !headless
    context.gl.uniform1iv(location, value);
    #end
  }

  /**
   * Set a float value for the current pipeline.
   * @param location The location in the shader.
   * @param value The new value.
   */
  public inline function setFloat(location: UniformLocation, value: Float) {
    #if !headless
    context.gl.uniform1f(location, value);
    #end
  }

  /**
   * Set two float values for the current pipeline.
   * @param location The location in the shader.
   * @param value1 The first float value.
   * @param value2 The second float value.
   */
  public inline function setFloat2(location: UniformLocation, value1: Float, value2: Float) {
    #if !headless
    context.gl.uniform2f(location, value1, value2);
    #end
  }

  /**
   * Set three float values for the current pipeline.
   * @param location The location in the shader.
   * @param value1 The first float value.
   * @param value2 The second float value.
   * @param value3 The third float value.
   */
  public inline function setFloat3(location: UniformLocation, value1: Float, value2: Float, value3: Float) {
    #if !headless
    context.gl.uniform3f(location, value1, value2, value3);
    #end
  }

  /**
   * Set four float values for the current pipeline.
   * @param location The location in the shader.
   * @param value1 The first float value.
   * @param value2 The second float value.
   * @param value3 The third float value.
   * @param value4 The fourth float value.
   */
  public inline function setFloat4(location: UniformLocation, value1: Float, value2: Float, value3: Float,
      value4: Float) {
    #if !headless
    context.gl.uniform4f(location, value1, value2, value3, value4);
    #end
  }

  /**
   * Set an array of float values for the current pipeline.
   * @param location The location in the shader.
   * @param values The new values.
   */
  public inline function setFloats(location: UniformLocation, value: Float32Array) {
    #if !headless
    context.gl.uniform1fv(location, value);
    #end
  }

  /**
   * Set a 4x4 matrix value for the current pipeline.
   * @param location The location in the shader.
   * @param value The new value.
   */
  public inline function setMatrix(location: UniformLocation, value: Mat4) {
    #if !headless
    context.gl.uniformMatrix4fv(location, false, value);
    #end
  }

  /**
   * Set a texture for the current pipeline.
   * @param unit The location in the shader.
   * @param texture The texture image.
   */
  public inline function setTexture(unit: Int, ?value: Image) {
    #if !headless
    final gl = context.gl;
    gl.activeTexture(GL.TEXTURE0 + unit);
    if (value != null) {
      gl.bindTexture(GL.TEXTURE_2D, value.texture);
    } else {
      gl.bindTexture(GL.TEXTURE_2D, null);
    }
    #end
  }

  inline function get_transform(): Mat4 {
    return transformStack[transformStack.length - 1];
  }
}
