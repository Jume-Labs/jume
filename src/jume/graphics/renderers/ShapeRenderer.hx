package jume.graphics.renderers;

import js.html.webgl.GL;
import js.lib.Float32Array;
import js.lib.Int32Array;

import jume.graphics.gl.Context;
import jume.math.Rectangle;
import jume.math.Vec2;
import jume.math.Vec3;

/**
 * Renders shapes like triangles, rectangles and circles.
 */
class ShapeRenderer extends BaseRenderer {
  /**
   * The offset per triangle.
   * x, y, z positions.
   * r, g, b, a colors.
   * 3 vertices per triangle.
   */
  static inline final OFFSET = 7 * 3;

  /**
   * The number of vertices per triangle.
   */
  static inline final VERTICES_PER_TRI = 3;

  /**
   * The current buffer index.
   */
  var index: Int;

  // Temp vertex positions.
  var p1: Vec3;
  var p2: Vec3;
  var p3: Vec3;

  // temp points for drawing lines and triangles.
  var tempP1: Vec2;
  var tempP2: Vec2;
  var tempP3: Vec2;

  var lineP1: Vec2;
  var lineP2: Vec2;
  var lineP3: Vec2;

  /**
   * Create a new shape renderer.
   * @param context The WebGL context.
   */
  public function new(context: Context) {
    super(context);

    index = 0;
    p1 = new Vec3();
    p2 = new Vec3();
    p3 = new Vec3();
    tempP1 = new Vec2();
    tempP2 = new Vec2();
    tempP3 = new Vec2();
    lineP1 = new Vec2();
    lineP2 = new Vec2();
    lineP3 = new Vec2();

    #if !headless
    vertexBuffer = context.gl.createBuffer();
    #end
    vertexIndices = new Float32Array(BUFFER_SIZE * OFFSET);

    #if !headless
    indexBuffer = context.gl.createBuffer();
    #end
    indexIndices = new Int32Array(BUFFER_SIZE * VERTICES_PER_TRI);

    // Set all the triangle indices once, because they don't change.
    for (i in 0...indexIndices.length) {
      indexIndices[i * VERTICES_PER_TRI] = i * VERTICES_PER_TRI;
      indexIndices[i * VERTICES_PER_TRI + 1] = i * VERTICES_PER_TRI + 1;
      indexIndices[i * VERTICES_PER_TRI + 2] = i * VERTICES_PER_TRI + 2;
    }

    createDefaultPipeline();
  }

  /**
   * Send the vertices to the buffer to draw.
   */
  public function present() {
    if (index == 0) {
      return;
    }
    pipeline.use();

    #if !headless
    final gl = context.gl;
    gl.uniformMatrix4fv(pipeline.projectionLocation, false, projection);
    gl.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
    gl.bufferData(GL.ARRAY_BUFFER, vertexIndices, GL.DYNAMIC_DRAW);
    gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer);
    gl.bufferData(GL.ELEMENT_ARRAY_BUFFER, indexIndices, GL.STATIC_DRAW);
    gl.vertexAttribPointer(pipeline.vertexPositionLocation, 3, GL.FLOAT, false, 7 * FLOAT_SIZE, 0);
    gl.enableVertexAttribArray(pipeline.vertexPositionLocation);
    gl.vertexAttribPointer(pipeline.vertexColorLocation, 4, GL.FLOAT, false, 7 * FLOAT_SIZE, 3 * FLOAT_SIZE);
    gl.enableVertexAttribArray(pipeline.vertexColorLocation);
    gl.drawElements(GL.TRIANGLES, index * VERTICES_PER_TRI, GL.UNSIGNED_INT, 0);
    gl.bindBuffer(GL.ARRAY_BUFFER, null);
    gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);
    gl.disableVertexAttribArray(pipeline.vertexPositionLocation);
    gl.disableVertexAttribArray(pipeline.vertexColorLocation);
    #end
    index = 0;
  }

  /**
   * Draw a solid triangle.
   * @param point1 The first position.
   * @param point2 The second position.
   * @param point3 The third position.
   */
  public function drawSolidTriangle(point1: Vec2, point2: Vec2, point3: Vec2) {
    #if debug
    if (currentTransform == null || currentColor == null) {
      trace('current transform or color not set');
      return;
    }
    #end

    if (index >= BUFFER_SIZE) {
      present();
    }

    p1.transformMat4(point1.x, point1.y, 0, currentTransform);
    p2.transformMat4(point2.x, point2.y, 0, currentTransform);
    p3.transformMat4(point3.x, point3.y, 0, currentTransform);

    setTransformVertices(p1, p2, p3);
    setColorVertices();
    index++;
  }

  /**
   * Draw a solid rectangle.
   * @param rect The rectangle to draw.
   */
  public function drawSolidRect(rect: Rectangle) {
    #if debug
    if (currentTransform == null || currentColor == null) {
      trace('current transform or color not set');
      return;
    }
    #end

    tempP1.set(rect.x, rect.y);
    tempP2.set(rect.x + rect.width, rect.y);
    tempP3.set(rect.x, rect.y + rect.height);
    drawSolidTriangle(tempP1, tempP2, tempP3);

    tempP1.set(rect.x, rect.y + rect.height);
    tempP2.set(rect.x + rect.width, rect.y);
    tempP3.set(rect.x + rect.width, rect.y + rect.height);
    drawSolidTriangle(tempP1, tempP2, tempP3);
  }

  /**
   * Draw a rectangle outline.
   * @param rect The rectangle to draw.
   * @param lineWidth The line width in pixels.
   */
  public function drawRect(rect: Rectangle, lineWidth: Float) {
    // top
    tempP1.set(rect.x, rect.y);
    tempP2.set(rect.x + rect.width, rect.y);
    drawLine(tempP1, tempP2, INSIDE, lineWidth);
    // right
    tempP1.set(rect.x + rect.width, rect.y);
    tempP2.set(rect.x + rect.width, rect.y + rect.height);
    drawLine(tempP1, tempP2, INSIDE, lineWidth);
    // bottom
    tempP1.set(rect.x + rect.width, rect.y + rect.height);
    tempP2.set(rect.x, rect.y + rect.height);
    drawLine(tempP1, tempP2, INSIDE, lineWidth);
    // left
    tempP1.set(rect.x, rect.y + rect.height);
    tempP2.set(rect.x, rect.y);
    drawLine(tempP1, tempP2, INSIDE, lineWidth);
  }

  /**
   * Draw a line between two points.
   * @param start The start position.
   * @param end The end position.
   * @param align Should the line be on the outside, middle or inside of the points.
   * @param lineWidth The width of the line in pixels.
   */
  public function drawLine(start: Vec2, end: Vec2, align: LineAlign, lineWidth: Float) {
    final dx = end.x - start.x;
    final dy = end.y - start.y;
    final lineLength = Math.sqrt(dx * dx + dy * dy);
    final scale = lineWidth / (2 * lineLength);
    final ddx = -scale * dy;
    final ddy = scale * dx;
    switch (align) {
      case INSIDE:
        lineP1.copyFrom(start);
        lineP2.set(start.x + ddx * 2, start.y + ddy * 2);
        lineP3.copyFrom(end);
        drawSolidTriangle(lineP1, lineP2, lineP3);

        lineP1.copyFrom(end);
        lineP2.set(start.x + ddx * 2, start.y + ddy * 2);
        lineP3.set(end.x + ddx * 2, end.y + ddy * 2);
        drawSolidTriangle(lineP1, lineP2, lineP3);

      case MIDDLE:
        lineP1.set(start.x + ddx, start.y + ddy);
        lineP2.set(start.x - ddx, start.y - ddy);
        lineP3.set(end.x + ddx, end.y + ddy);
        drawSolidTriangle(lineP1, lineP2, lineP3);

        lineP1.set(end.x + ddx, end.y + ddy);
        lineP2.set(start.x - ddx, start.y - ddy);
        lineP3.set(end.x - ddx, end.y - ddy);
        drawSolidTriangle(lineP1, lineP2, lineP3);

      case OUTSIDE:
        lineP1.copyFrom(start);
        lineP2.set(start.x - ddx * 2, start.y - ddy * 2);
        lineP3.copyFrom(end);
        drawSolidTriangle(lineP1, lineP2, lineP3);

        lineP1.copyFrom(end);
        lineP2.set(start.x - ddx * 2, start.y - ddy * 2);
        lineP3.set(end.x - ddx * 2, end.y - ddy * 2);
        drawSolidTriangle(lineP1, lineP2, lineP3);
    }
  }

  /**
   * Draw a circle outline.
   * @param position The center position of the circle.
   * @param radius The radius in pixels.
   * @param segments The number of segments. More segments is a smoother circle.
   * @param lineWidth The line width of the outline in pixels.
   */
  public function drawCircle(position: Vec2, radius: Float, segments: Int, lineWidth: Float) {
    final theta = (2 * Math.PI) / segments;
    final cos = Math.cos(theta);
    final sin = Math.sin(theta);
    var sx = radius;
    var sy = 0.0;
    for (i in 0...segments) {
      final px = sx + position.x;
      final py = sy + position.y;
      final t = sx;
      sx = cos * sx - sin * sy;
      sy = cos * sy + sin * t;
      tempP1.set(sx + position.x, sy + position.y);
      tempP2.set(px, py);
      drawLine(tempP1, tempP2, INSIDE, lineWidth);
    }
  }

  /**
   * Draw a circle filled with a color.
   * @param position The center position of the circle.
   * @param radius The circle radius in pixels.
   * @param segments The number of segments. More segments is a smoother circle.
   */
  public function drawSolidCircle(position: Vec2, radius: Float, segments: Int) {
    final theta = (2 * Math.PI) / segments;
    final cos = Math.cos(theta);
    final sin = Math.sin(theta);
    var sx = radius;
    var sy = 0.0;
    for (i in 0...segments) {
      final px = sx + position.x;
      final py = sy + position.y;
      final t = sx;
      sx = cos * sx - sin * sy;
      sy = cos * sy + sin * t;
      tempP1.set(px, py);
      tempP2.set(sx + position.x, sy + position.y);
      tempP3.copyFrom(position);
      drawSolidTriangle(tempP1, tempP2, tempP3);
    }
  }

  /**
   * Draw a polygon outline.
   * @param position The center position of the polygon.
   * @param vertices The positions of all vertices.
   * @param lineWidth The line width in pixels.
   */
  public function drawPolygon(position: Vec2, vertices: Array<Vec2>, lineWidth: Float) {
    #if debug
    if (vertices.length < 3) {
      trace('Cannot draw polygon with less than 3 points');
      return;
    }
    #end

    final start = vertices[0];
    var last = start;

    for (i in 1...vertices.length) {
      final current = vertices[i];

      tempP1.set(last.x + position.x, last.y + position.y);
      tempP2.set(current.x + position.x, current.y + position.y);
      drawLine(tempP1, tempP2, INSIDE, lineWidth);
      last = current;
    }

    // Connect the last point to the start
    tempP1.set(last.x + position.x, last.y + position.y);
    tempP2.set(start.x + position.x, start.y + position.y);
    drawLine(tempP1, tempP2, INSIDE, lineWidth);
  }

  /**
   * Draw a solid polygon.
   * @param position The center position of the polygon.
   * @param vertices The positions of all vertices.
   */
  public function drawSolidPolygon(position: Vec2, vertices: Array<Vec2>) {
    #if debug
    if (vertices.length < 3) {
      trace('Cannot draw polygon with less than 3 points');
      return;
    }
    #end

    final first = vertices[0];
    var last = vertices[1];

    for (i in 2...vertices.length) {
      final current = vertices[i];

      tempP1.set(first.x + position.x, first.y + position.y);
      tempP2.set(last.x + position.x, last.y + position.y);
      tempP3.set(current.x + position.x, current.y + position.y);
      drawSolidTriangle(tempP1, tempP2, tempP3);
      last = current;
    }
  }

  /**
   * Set the positions for the shape.
   * @param p1 The first point.
   * @param p2 The second point.
   * @param p3 The third point.
   */
  function setTransformVertices(p1: Vec3, p2: Vec3, p3: Vec3) {
    final i = index * OFFSET;
    vertexIndices[i] = p1[0];
    vertexIndices[i + 1] = p1[1];
    vertexIndices[i + 2] = 0;
    vertexIndices[i + 7] = p2[0];
    vertexIndices[i + 8] = p2[1];
    vertexIndices[i + 9] = 0;
    vertexIndices[i + 14] = p3[0];
    vertexIndices[i + 15] = p3[1];
    vertexIndices[i + 16] = 0;
  }

  /**
   * Set the color vertices for the shape.
   */
  function setColorVertices() {
    final i = index * OFFSET;
    final r = currentColor.red;
    final g = currentColor.green;
    final b = currentColor.blue;
    final a = currentColor.alpha;

    vertexIndices[i + 3] = r;
    vertexIndices[i + 4] = g;
    vertexIndices[i + 5] = b;
    vertexIndices[i + 6] = a;
    vertexIndices[i + 10] = r;
    vertexIndices[i + 11] = g;
    vertexIndices[i + 12] = b;
    vertexIndices[i + 13] = a;
    vertexIndices[i + 17] = r;
    vertexIndices[i + 18] = g;
    vertexIndices[i + 19] = b;
    vertexIndices[i + 20] = a;
  }

  /**
   * Create the default shader pipeline.
   */
  function createDefaultPipeline() {
    final vertexSource = DefaultShaders.shapeVert(context.isGL1);
    final vertexShader = new Shader(vertexSource, VERTEX);

    final fragmentSource = DefaultShaders.shapeFrag(context.isGL1);
    final fragmentShader = new Shader(fragmentSource, FRAGMENT);

    defaultPipeline = new Pipeline(vertexShader, fragmentShader, false);
    pipeline = defaultPipeline;
  }
}
