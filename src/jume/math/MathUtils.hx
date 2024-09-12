package jume.math;

/**
 * MathUtils has math helper variables and functions.
 */
class MathUtils {
  /**
   * Minimum value of a floating point number.
   */
  public static inline final MIN_VALUE_FLOAT: Float = 0.0000000000000001;

  /**
   * Maximum value of a floating point number.
   */
  public static inline final MAX_VALUE_FLOAT: Float = 1.79e+308;

  /**
   * Minimum value of an integer.
   */
  public static inline final MIN_VALUE_INT: Int = -MAX_VALUE_INT;

  /**
   * Maximum value of an integer.
   */
  public static inline final MAX_VALUE_INT: Int = 0x7FFFFFFF;

  /**
   * Lerp between two values.
   * @param a Start value.
   * @param b End value.
   * @param position Lerp position.
   */
  public static inline function lerp(cl: Class<Math>, a: Float, b: Float, position: Float): Float {
    return a + position * (b - a);
  }

  /**
   * Clamp a value between a min and max.
   * @param value The value to clamp.
   * @param min Minimum.
   * @param max Maximum.
   */
  public static function clamp(cl: Class<Math>, value: Float, min: Float, max: Float): Float {
    if (min > max) {
      var temp = max;
      max = min;
      min = temp;
    }

    final lower = (value < min) ? min : value;

    return (lower > max) ? max : lower;
  }

  /**
   * Clamp an integer value between a min and max.
   * @param value The value to clamp.
   * @param min Minimum.
   * @param max Maximum.
   */
  public static function clampInt(cl: Class<Math>, value: Int, min: Int, max: Int): Int {
    if (min > max) {
      var temp = max;
      max = min;
      min = temp;
    }

    final lower = (value < min) ? min : value;

    return (lower > max) ? max : lower;
  }

  /**
   * Return the lowest value of two integers.
   * @param a First value.
   * @param b Second value.
   */
  public static inline function minInt(cl: Class<Math>, a: Int, b: Int): Int {
    return (a < b) ? a : b;
  }

  /**
   * Return the highest value of two integers.
   * @param a First value.
   * @param b Second value.
   */
  public static inline function maxInt(cl: Class<Math>, a: Int, b: Int): Int {
    return (a > b) ? a : b;
  }

  /**
   * Convert radians to degrees.
   * @param rad Value to convert.
   */
  public static inline function toDeg(cl: Class<Math>, rad: Float): Float {
    return rad * (180.0 / Math.PI);
  }

  /**
   * Convert degrees to radians.
   * @param deg Value to convert.
   */
  public static inline function toRad(cl: Class<Math>, deg: Float): Float {
    return deg * (Math.PI / 180.0);
  }

  /**
   * Calculate the distance between two points.
   * @param x1 The x position of the first point.
   * @param y1 The y position of the first point.
   * @param x2 The x position of the second point.
   * @param y2 The y position of the second point.
   * @return The distance.
   */
  public static function distance(cl: Class<Math>, p1: Vec2, p2: Vec2): Float {
    return Math.sqrt(Math.pow(p2.x - p1.x, 2) + Math.pow(p2.y - p1.y, 2));
  }

  /**
   * Check if two values are almost equal.
   * @param a The first value.
   * @param b The second value.
   * @param epsilon Optional precision value.
   * @return True if the values are almost equal.
   */
  public static function fuzzyEqual(cl: Class<Math>, a: Float, b: Float, ?epsilon: Float): Bool {
    if (epsilon == null) {
      epsilon = 0.0001;
    }

    return Math.abs(a - b) < epsilon;
  }

  /**
   * Rotate a position around a point.
   * @param pos The position to rotate.
   * @param center The position to rotate around.
   * @param angle The angle in degrees.
   * @param out Optional vector to store the result in.
   * @return The rotated result.
   */
  @SuppressWarnings('checkstyle:ParameterNumber')
  public static function rotateAround(cl: Class<Math>, pos: Vec2, center: Vec2, angle: Float, ?out: Vec2): Vec2 {
    out ??= Vec2.get();

    final rad = -angle * (Math.PI / 180.0);
    final c = Math.cos(rad);
    final s = Math.sin(rad);

    final tx = pos.x - center.x;
    final ty = pos.y - center.y;

    out.set(c * tx + s * ty + center.x, c * ty - s * tx + center.y);

    return out;
  }

  /**
   * Check if 2 lines intersect.
   * @param cl The Math class.
   * @param p1Start The position of the start of line 1.
   * @param p1End The position of the end of line 1.
   * @param p2Start The position of the start of line 2.
   * @param p2End The position of the end of line 2.
   * @param out The intersection point.
   * @return True if the lines intersect.
   */
  @SuppressWarnings('checkstyle:ParameterNumber')
  public static function linesIntersect(cl: Class<Math>, p1Start: Vec2, p1End: Vec2, p2Start: Vec2, p2End: Vec2,
      ?out: Vec2): Bool {
    final b = p1End - p1Start;
    final d = p2End - p2Start;

    var bDotDPerp = b.x * d.y - b.y * d.x;
    if (bDotDPerp == 0) {
      b.put();
      d.put();

      return false;
    }

    final c = p2Start - p1Start;
    final t = (c.x * d.y - c.y * d.x) / bDotDPerp;
    if (t < 0 || t > 1) {
      b.put();
      d.put();
      c.put();

      return false;
    }

    final u = (c.x * b.y - c.y * b.x) / bDotDPerp;
    if (u < 0 || u > 1) {
      b.put();
      d.put();
      c.put();

      return false;
    }

    if (out != null) {
      final point = p1Start.clone();
      b.x *= t;
      b.y *= t;
      point.add(b);

      // Choose the closest hit.
      if (out == Vec2.ZERO) {
        out.copyFrom(point);
      } else {
        final p1s = p1Start.clone();
        if (Vec2.distance(p1s, point) < Vec2.distance(p1s, out)) {
          out.copyFrom(point);
        }
        p1s.put();
      }
      point.put();
    }

    b.put();
    d.put();
    c.put();

    return true;
  }
}
