package jume.math;

/**
 * Small Vec3 class used to convert screen space to gl space.
 */
class Vec3 {
  /**
   * The x position in the vector.
   */
  public var x: Float;

  /**
   * The y position in the vector.
   */
  public var y: Float;

  /**
   * The z position in the vector.
   */
  public var z: Float;

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
    this.x = x;
    this.y = y;
    this.z = z;
  }

  /**
   * Check if two vectors match.
   * @param other The vector to compare with.
   * @return True if the vectors are the same.
   */
  public inline function equals(other): Bool {
    return x == other.x && y == other.y && z == other.z;
  }

  /**
   * Update the vector values.
   * @param x The new x value.
   * @param y The new y value.
   * @param z The new z value.
   */
  public function set(x: Float, y: Float, z: Float) {
    this.x = x;
    this.y = y;
    this.z = z;
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

    this.x = (mat[0] * x + mat[4] * y + mat[8] * z + mat[12]) / w;
    this.y = (mat[1] * x + mat[5] * y + mat[9] * z + mat[13]) / w;
    this.z = (mat[2] * x + mat[6] * y + mat[10] * z + mat[14]) / w;

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
    return '{ x: ${x}, y: ${y}, z: ${z} }';
  }
}
