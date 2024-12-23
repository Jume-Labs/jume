package jume.math;

using jume.math.MathUtils;

/**
 * 2d position class.
 */
class Vec2 {
  /**
   * Left direction to compare with.
   */
  public static final LEFT = new Vec2(-1, 0);

  /**
   * Right direction to compare with.
   */
  public static final RIGHT = new Vec2(1, 0);

  /**
   * Up direction to compare with.
   */
  public static final UP = new Vec2(0, -1);

  /**
   * Down direction to compare with.
   */
  public static final DOWN = new Vec2(0, 1);

  /**
   * Zero vector to compare with.
   */
  public static final ZERO = new Vec2();

  /**
   * The x axis position.
   */
  public var x: Float;

  /**
   * The y axis position.
   */
  public var y: Float;

  /**
   * The x position floored to an int.
   */
  public var xi(get, never): Int;

  /**
   * The y position floored to an int.
   */
  public var yi(get, never): Int;

  /**
   * The vector length.
   */
  public var length(get, set): Float;

  /**
   * Internal object pool.
   */
  static final POOL: Array<Vec2> = [];

  /**
   * Get a vector from the object pool. If the pool is empty a new vector will be created.
   * @param x The x axis value.
   * @param y The y axis value.
   * @return The vector from the pool.
   */
  public static function get(x = 0.0, y = 0.0): Vec2 {
    if (POOL.length > 0) {
      final vec = POOL.pop();
      vec.set(x, y);

      return vec;
    } else {
      return new Vec2(x, y);
    }
  }

  /**
   * Add two vectors.
   * @param a Left side.
   * @param b Right side.
   * @return The resulting vector.
   */
  public static inline function addVectors(a: Vec2, b: Vec2): Vec2 {
    return Vec2.get(a.x + b.x, a.y + b.y);
  }

  /**
   * Subtract two vectors.
   * @param a Left side.
   * @param b Right side.
   * @return The resulting vector.
   */
  public static inline function subVectors(a: Vec2, b: Vec2): Vec2 {
    return Vec2.get(a.x - b.x, a.y - b.y);
  }

  /**
   * Multiply two vectors.
   * @param a Left side.
   * @param b Right side.
   * @return The resulting vector.
   */
  public static inline function mulVectors(a: Vec2, b: Vec2): Vec2 {
    return Vec2.get(a.x * b.x, a.y * b.y);
  }

  /**
   * Divide two vectors.
   * @param a Left side.
   * @param b Right side.
   * @return The resulting vector.
   */
  public static inline function divVectors(a: Vec2, b: Vec2): Vec2 {
    return Vec2.get(a.x / b.x, a.y / b.y);
  }

  /**
   * Calculate the distance between two vectors.
   * @param a The first vector.
   * @param b The second vector.
   * @return The distance.
   */
  public static inline function distance(a: Vec2, b: Vec2): Float {
    return Math.sqrt(Math.pow(b.x - a.x, 2) + Math.pow(b.y - a.y, 2));
  }

  /**
   * Create a new Vector.
   * @param x The x axis value.
   * @param y The y axis value.
   */
  public inline function new(x = 0.0, y = 0.0) {
    this.x = x;
    this.y = y;
  }

  /**
   * Set new values on the vector.
   * @param x The new x axis value.
   * @param y The new y axis value.
   * @return This vector.
   */
  public inline function set(x: Float, y: Float): Vec2 {
    this.x = x;
    this.y = y;

    return this;
  }

  /**
   * Clone this vector.
   * @param out Optional variable to store the result in.
   * @return The cloned vector.
   */
  public function clone(?out: Vec2): Vec2 {
    if (out == null) {
      out = Vec2.get();
    }

    out.set(x, y);

    return out;
  }

  /**
   * Copy the values from another vector.
   * @param other The vector to copy from.
   * @return This vector.
   */
  public function copyFrom(other: Vec2): Vec2 {
    x = other.x;
    y = other.y;

    return this;
  }

  /**
   * Compare two vectors to see if they are equal.
   * @param other The vector to compare with.
   * @return True if they are equal.
   */
  public inline function equals(other: Vec2): Bool {
    return x == other.x && y == other.y;
  }

  /**
   * Add a vector.
   * @param other The vector to add.
   * @return This vector.
   */
  public inline function add(other: Vec2): Vec2 {
    x += other.x;
    y += other.y;

    return this;
  }

  /**
   * Subtract a vector.
   * @param other The vector to subtract.
   * @return This vector.
   */
  public inline function sub(other: Vec2): Vec2 {
    x -= other.x;
    y -= other.y;

    return this;
  }

  /**
   * Multiply by a vector.
   * @param other The vector to multiply by.
   * @return This vector.
   */
  public inline function mul(other: Vec2): Vec2 {
    x *= other.x;
    y *= other.y;

    return this;
  }

  /**
   * Divide by a vector.
   * @param other The vector to divide by.
   * @return This vector.
   */
  public inline function div(other: Vec2): Vec2 {
    x /= other.x;
    y /= other.y;

    return this;
  }

  /**
   * Get the dot product.
   * @param other The other vector to use.
   * @return The dot product.
   */
  public inline function dot(other: Vec2): Float {
    return x * other.x + y * other.y;
  }

  /**
   * Normalize this vector.
   * @return This vector.
   */
  public function normalize(): Vec2 {
    final l = length;
    if (l > 0) {
      x /= l;
      y /= l;
    }

    return this;
  }

  /**
   * Rotate a point around a center point.
   * @param centerX The center x position.
   * @param centerY The center y position.
   * @param angle The angle in degrees.
   * @return This vector.
   */
  public function rotateAround(centerX: Float, centerY: Float, angle: Float): Vec2 {
    final rad = Math.toRad(angle);
    final c = Math.cos(rad);
    final s = Math.sin(rad);

    final tx = x - centerX;
    final ty = y - centerY;

    x = c * tx + s * ty + x;
    y = c * ty - s * tx + y;

    return this;
  }

  /**
   * Put this vector back into the object pool.
   */
  public inline function put() {
    POOL.push(this);
  }

  /**
   * A string representation of the vector.
   * @return The vector string.
   */
  public inline function toString(): String {
    return '{ x: ${x}, y: ${y} }';
  }

  inline function get_xi(): Int {
    return Math.floor(x);
  }

  inline function get_yi(): Int {
    return Math.floor(y);
  }

  inline function get_length(): Float {
    return Math.sqrt(x * x + y * y);
  }

  function set_length(value: Float): Float {
    final l = length;

    if (l > 0) {
      x /= l;
      y /= l;
    }

    x *= value;
    y *= value;

    return value;
  }
}
