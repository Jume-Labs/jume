package jume.math;

using jume.math.MathUtils;

/**
 * Rectangle is a basic rectangle class using floats.
 */
class Rectangle {
  /**
   * The x position of the rectangle.
   */
  public var x: Float;

  /**
   * The y position of the rectangle.
   */
  public var y: Float;

  /**
   * The width of the rectangle.
   */
  public var width: Float;

  /**
   * The height of the rectangle.
   */
  public var height: Float;

  /**
   * The integer x position of the rectangle.
   */
  public var xi(get, never): Int;

  /**
   * The integer y position of the rectangle.
   */
  public var yi(get, never): Int;

  /**
   * The integer width of the rectangle.
   */
  public var widthi(get, never): Int;

  /**
   * The integer height of the rectangle.
   */
  public var heighti(get, never): Int;

  var tempStart: Vec2;

  var tempEnd: Vec2;

  var tempOut: Vec2;

  /**
   * @param x The top left x position.
   * @param y The top left y position.
   * @param width The width of the rectangle.
   * @param height The height of the rectangle.
   */
  public function new(x = 0.0, y = 0.0, width = 0.0, height = 0.0) {
    set(x, y, width, height);
    tempStart = new Vec2();
    tempEnd = new Vec2();
    tempOut = new Vec2();
  }

  /**
   * Check if a position is inside this rectangle.
   * @param x The x axis position.
   * @param y The y axis position.
   * @return True if the position is inside the rectangle.
   */
  public inline function hasPosition(x: Float, y: Float): Bool {
    return x >= this.x && x <= (this.x + width) && y > this.y && y <= (this.y + height);
  }

  /**
   * Check if a rectangle overlaps with this rectangle.
   * @param rect The rectangle to check with.
   * @return True if the rectangles intersect.
   */
  public inline function intersects(rect: Rectangle): Bool {
    return (x < (rect.x + rect.width) && (x + width) > rect.x && y < (rect.y + rect.height) && (y + height) > rect.y);
  }

  /**
   * Set all rect values to a new value.
   * @param x The new x value.
   * @param y The new y value.
   * @param width The new width.
   * @param height The new height.
   */
  public function set(x: Float, y: Float, width: Float, height: Float) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }

  /**
   * Check if a line intersects with this rectangle.
   * @param start The line start position.
   * @param end The line end position.
   * @param out Optional vector to store the first intersect point.
   * @return True if the line intersects with this rectangle.
   */
  public function intersectsLine(start: Vec2, end: Vec2, ?out: Vec2): Bool {
    var intersects = false;
    if (out != null) {
      out.copyFrom(Vec2.ZERO);
    }

    tempOut.copyFrom(Vec2.ZERO);
    intersects = checkLine(start, end, LEFT, tempOut);
    updateLineOut(intersects, start, out, tempOut);

    intersects = checkLine(start, end, RIGHT, tempOut);
    updateLineOut(intersects, start, out, tempOut);

    intersects = checkLine(start, end, TOP, tempOut);
    updateLineOut(intersects, start, out, tempOut);

    intersects = checkLine(start, end, BOTTOM, tempOut);
    updateLineOut(intersects, start, out, tempOut);

    return intersects;
  }

  /**
   * String representation of the rectangle.
   */
  public inline function toString(): String {
    return '{ x: $x, y: $y, w: $width, h: $height }';
  }

  /**
   * Check if a line intersects with a side of the rectangle and store the intersection point.
   * @param start The start position of the line.
   * @param end The end position of the line.
   * @param side The side of the rectangle to check.
   * @param out The variable to store the intersection point in.
   * @return True if the line intersects with the side of the rectangle.
   */
  function checkLine(start: Vec2, end: Vec2, side: Side, out: Vec2): Bool {
    switch (side) {
      case LEFT:
        tempStart.set(x, y);
        tempEnd.set(x, y + height);

      case RIGHT:
        tempStart.set(x + width, y);
        tempEnd.set(x + width, y + height);

      case TOP:
        tempStart.set(x, y);
        tempEnd.set(x + width, y);

      case BOTTOM:
        tempStart.set(x, y + height);
        tempEnd.set(x + width, y + height);
    }

    return Math.linesIntersect(start, end, tempStart, tempEnd, out);
  }

  /**
   * Update the intersection point to be the closest to the start of the line.
   * @param intersects Does the line intersect.
   * @param start The start position of the line.
   * @param out The current line intersect point.
   * @param tempOut The new line intersect point.
   */
  function updateLineOut(intersects: Bool, start: Vec2, out: Vec2, tempOut: Vec2) {
    if (intersects && out != null) {
      if (out == Vec2.ZERO) {
        out.copyFrom(tempOut);
      } else {
        if (Vec2.distance(start, tempOut) < Vec2.distance(start, out)) {
          out.copyFrom(tempOut);
        }
      }
    }
  }

  inline function get_xi(): Int {
    return Std.int(x);
  }

  inline function get_yi(): Int {
    return Std.int(y);
  }

  inline function get_widthi(): Int {
    return Std.int(width);
  }

  inline function get_heighti(): Int {
    return Std.int(height);
  }
}

/**
 * Helper enum for rectangle side intersect with line.
 */
private enum abstract Side(String) {
  var LEFT = 'Left';
  var RIGHT = 'Right';
  var TOP = 'Top';
  var BOTTOM = 'Bottom';
}
