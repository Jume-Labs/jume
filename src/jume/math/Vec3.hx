package jume.math;

/**
 * Small Vec3 class used to convert screen space to gl space.
 */
abstract Vec3(Array<Float>) from Array<Float> to Array<Float> {
  /**
   * The x position in the vector.
   */
  public var x(get, set): Float;

  /**
   * The y position in the vector.
   */
  public var y(get, set): Float;

  /**
   * The z position in the vector.
   */
  public var z(get, set): Float;

  /**
   * Internal object pool.
   */
  static final POOL: Array<Vec3> = [];

  /**
   * Get a vector 3 from the object pool. If the pool is empty a new vector will be created.
   * @param x The x position. 
   * @param y The y position.
   * @param z The z position.
   * @return The vector 3 from the pool.
   */
  public static function get(x = 0.0, y = 0.0, z = 0.0): Vec3 {
    if (POOL.length > 0) {
      final vec = POOL.pop();
      vec.set(x, y, z);

      return vec;
    } else {
      return new Vec3(x, y, z);
    }
  }

  /**
   * Create a new Vec3.
   * @param x The x position. 
   * @param y The y position.
   * @param z The z position.
   */
  public inline function new(x = 0.0, y = 0.0, z = 0.0) {
    this = [x, y, z];
  }

  @:op(A == B)
  public function equals(other): Bool {
    return this[0] == other[0] && this[1] == other[1] && this[2] == other[2];
  }

  @:op(A != B)
  public function nequals(other): Bool {
    return this[0] != other[0] || this[1] != other[1] || this[2] != other[2];
  }

  /**
   * Update the vector values.
   * @param x The new x value.
   * @param y The new y value.
   * @param z The new z value.
   */
  public function set(x: Float, y: Float, z: Float) {
    this[0] = x;
    this[1] = y;
    this[2] = z;
  }

  /**
   * Transform a Vec3 using a Mat4.
   * @param x The x translation.
   * @param y The y translation.
   * @param z The z translation.
   * @param mat The matrix to multiply with.
   * @return Vec3 This vector.
   */
  public function transformMat4(x: Float, y: Float, z: Float, mat: Mat4): Vec3 {
    var w = mat[3] * x + mat[7] * y + mat[11] * z + mat[15];
    if (w == 0) {
      w = 1.0;
    }

    this[0] = (mat[0] * x + mat[4] * y + mat[8] * z + mat[12]) / w;
    this[1] = (mat[1] * x + mat[5] * y + mat[9] * z + mat[13]) / w;
    this[2] = (mat[2] * x + mat[6] * y + mat[10] * z + mat[14]) / w;

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
    return '{ x: ${this[0]}, y: ${this[1]}, z: ${this[2]} }';
  }

  inline function get_x(): Float {
    return this[0];
  }

  inline function set_x(value: Float): Float {
    this[0] = value;

    return value;
  }

  inline function get_y(): Float {
    return this[1];
  }

  inline function set_y(value: Float): Float {
    this[1] = value;

    return value;
  }

  inline function get_z(): Float {
    return this[2];
  }

  inline function set_z(value: Float): Float {
    this[2] = value;

    return value;
  }
}
