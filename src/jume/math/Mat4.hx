package jume.math;

import haxe.Exception;

import js.lib.Float32Array;

/**
 * The parameters for the ortho function.
 */
typedef OrthoParams = {
  /**
   * Left view position.
   */
  var left: Float;

  /**
   * Right view position.
   */
  var right: Float;

  /**
   * Top view position.
   */
  var top: Float;

  /**
   * Bottom view position.
   */
  var bottom: Float;

  /**
   * Near clipping plane.
   */
  var near: Float;

  /**
   * Far clipping plane.
   */
  var far: Float;
}

/**
 * Basic matrix 4x4 class.
 */
@:forward(length)
abstract Mat4(Array<Float>) from Array<Float> to Array<Float> {
  /**
   * Internal object pool.
   */
  static final POOL: Array<Mat4> = [];

  /**
   * Get a matrix from the object pool. If the pool is empty a new matrix will be created.
   * @param data Use an existing matrix for the values.
   * @return The matrix from the pool.
   */
  public static function get(?data: Mat4): Mat4 {
    var mat: Mat4;
    if (POOL.length > 0) {
      mat = POOL.pop();
    } else {
      mat = new Mat4();
    }

    if (data != null) {
      if (data.length != 16) {
        throw new Exception('data is not a 4x4 matrix. Wrong length ${data.length}.');
      }

      mat[0] = data[0];
      mat[1] = data[1];
      mat[2] = data[2];
      mat[3] = data[3];
      mat[4] = data[4];
      mat[5] = data[5];
      mat[6] = data[6];
      mat[7] = data[7];
      mat[8] = data[8];
      mat[9] = data[9];
      mat[10] = data[10];
      mat[11] = data[11];
      mat[12] = data[12];
      mat[13] = data[13];
      mat[14] = data[14];
      mat[15] = data[15];
    } else {
      mat.identity();
    }

    return mat;
  }

  /**
   * Create a matrix from translation values.
   * @param x The x axis value.
   * @param y The y axis value.
   * @param z The z axis value.
   * @param out Optional matrix to store the result in.
   * @return The created matrix.
   */
  public static function fromTranslation(x: Float, y: Float, z: Float, ?out: Mat4): Mat4 {
    if (out == null) {
      out = Mat4.get();
    }

    out[0] = 1;
    out[1] = 0;
    out[2] = 0;
    out[3] = 0;
    out[4] = 0;
    out[5] = 1;
    out[6] = 0;
    out[7] = 0;
    out[8] = 0;
    out[9] = 0;
    out[10] = 1;
    out[11] = 0;
    out[12] = x;
    out[13] = y;
    out[14] = z;
    out[15] = 1;

    return out;
  }

  /**
   * Create a matrix from a z axis rotation. Used for 2d rotations.
   * @param rotation The rotation value in radians.
   * @param out Optional matrix to store the result in.
   * @return The created matrix.
   */
  public static function fromZRotation(rotation: Float, ?out: Mat4): Mat4 {
    if (out == null) {
      out = Mat4.get();
    }

    final s = Math.sin(rotation);
    final c = Math.cos(rotation);

    out[0] = c;
    out[1] = s;
    out[2] = 0;
    out[3] = 0;
    out[4] = -s;
    out[5] = c;
    out[6] = 0;
    out[7] = 0;
    out[8] = 0;
    out[9] = 0;
    out[10] = 1;
    out[11] = 0;
    out[12] = 0;
    out[13] = 0;
    out[14] = 0;
    out[15] = 1;

    return out;
  }

  /**
   * Create a matrix from scale values.
   * @param x The x axis scale.
   * @param y The y axis scale.
   * @param z The z axis scale.
   * @param out Optional matrix to store the result in.
   * @return The created matrix.
   */
  public static function fromScale(x: Float, y: Float, z: Float, ?out: Mat4): Mat4 {
    if (out == null) {
      out = Mat4.get();
    }

    out[0] = x;
    out[1] = 0;
    out[2] = 0;
    out[3] = 0;
    out[4] = 0;
    out[5] = y;
    out[6] = 0;
    out[7] = 0;
    out[8] = 0;
    out[9] = 0;
    out[10] = z;
    out[11] = 0;
    out[12] = 0;
    out[13] = 0;
    out[14] = 0;
    out[15] = 1;

    return out;
  }

  /**
   * Multiply two matrices.
   * @param a The left matrix.
   * @param b The right matrix.
   * @param out Optional matrix to store the result in.
   * @return The multiplied matrix.
   */
  public static function multiply(a: Mat4, b: Mat4, ?out: Mat4): Mat4 {
    if (out == null) {
      out = Mat4.get();
    }

    final a00 = a[0];
    final a01 = a[1];
    final a02 = a[2];
    final a03 = a[3];
    final a10 = a[4];
    final a11 = a[5];
    final a12 = a[6];
    final a13 = a[7];
    final a20 = a[8];
    final a21 = a[9];
    final a22 = a[10];
    final a23 = a[11];
    final a30 = a[12];
    final a31 = a[13];
    final a32 = a[14];
    final a33 = a[15];

    var b0 = b[0];
    var b1 = b[1];
    var b2 = b[2];
    var b3 = b[3];
    out[0] = b0 * a00 + b1 * a10 + b2 * a20 + b3 * a30;
    out[1] = b0 * a01 + b1 * a11 + b2 * a21 + b3 * a31;
    out[2] = b0 * a02 + b1 * a12 + b2 * a22 + b3 * a32;
    out[3] = b0 * a03 + b1 * a13 + b2 * a23 + b3 * a33;

    b0 = b[4];
    b1 = b[5];
    b2 = b[6];
    b3 = b[7];
    out[4] = b0 * a00 + b1 * a10 + b2 * a20 + b3 * a30;
    out[5] = b0 * a01 + b1 * a11 + b2 * a21 + b3 * a31;
    out[6] = b0 * a02 + b1 * a12 + b2 * a22 + b3 * a32;
    out[7] = b0 * a03 + b1 * a13 + b2 * a23 + b3 * a33;

    b0 = b[8];
    b1 = b[9];
    b2 = b[10];
    b3 = b[11];
    out[8] = b0 * a00 + b1 * a10 + b2 * a20 + b3 * a30;
    out[9] = b0 * a01 + b1 * a11 + b2 * a21 + b3 * a31;
    out[10] = b0 * a02 + b1 * a12 + b2 * a22 + b3 * a32;
    out[11] = b0 * a03 + b1 * a13 + b2 * a23 + b3 * a33;

    b0 = b[12];
    b1 = b[13];
    b2 = b[14];
    b3 = b[15];
    out[12] = b0 * a00 + b1 * a10 + b2 * a20 + b3 * a30;
    out[13] = b0 * a01 + b1 * a11 + b2 * a21 + b3 * a31;
    out[14] = b0 * a02 + b1 * a12 + b2 * a22 + b3 * a32;
    out[15] = b0 * a03 + b1 * a13 + b2 * a23 + b3 * a33;

    return out;
  }

  /**
   * Create a matrix from z rotation, 2d translation and scale values.
   * @param rotation The z rotation in radians.
   * @param x The x translation.
   * @param y The y translation.
   * @param sx The x scale.
   * @param sy The y scale.
   * @param out Optional matrix to store the result in.
   * @return The created matrix.
   */
  public static function from2dRotationTranslationScale(rotation: Float, position: Vec2, scale: Vec2,
      ?out: Mat4): Mat4 {
    if (out == null) {
      out = Mat4.get();
    }

    final z = Math.sin(rotation * 0.5);
    final w = Math.cos(rotation * 0.5);

    final z2 = z + z;
    final zz = z * z2;
    final wz = w * z2;

    final sz = 1;

    out[0] = (1 - zz) * scale.x;
    out[1] = wz * scale.x;
    out[2] = 0;
    out[3] = 0;
    out[4] = (0 - wz) * scale.y;
    out[5] = (1 - zz) * scale.y;
    out[6] = 0;
    out[7] = 0;
    out[8] = 0;
    out[9] = 0;
    out[10] = sz;
    out[11] = 0;
    out[12] = position.x;
    out[13] = position.y;
    out[14] = 0;
    out[15] = 1;

    return out;
  }

  /**
   * Create a new matrix.
   * @param data Optional matrix to copy.
   */
  public function new(?data: Array<Float>) {
    if (data != null) {
      if (data.length != 16) {
        throw new Exception('Data is not a 4x4 matrix. Wrong length ${data.length}.');
      }
      this = [
         data[0],  data[1],  data[2],  data[3],
         data[4],  data[5],  data[6],  data[7],
         data[8],  data[9], data[10], data[11],
        data[12], data[13], data[14], data[15]
      ];
    } else {
      this = [
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
      ];
    }
  }

  @:op(A == B)
  public function equals(other: Mat4): Bool {
    return this[0] == other[0] && this[1] == other[1] && this[2] == other[2] && this[3] == other[3]
      && this[4] == other[4] && this[5] == other[5] && this[6] == other[6] && this[7] == other[7]
      && this[8] == other[8] && this[9] == other[9] && this[10] == other[10] && this[11] == other[11]
      && this[12] == other[12] && this[13] == other[13] && this[14] == other[14] && this[15] == other[15];
  }

  @:op(A != B)
  public function nequals(other: Mat4): Bool {
    return this[0] != other[0] || this[1] != other[1] || this[2] != other[2] || this[3] != other[3]
      || this[4] != other[4] || this[5] != other[5] || this[6] != other[6] || this[7] != other[7]
      || this[8] != other[8] || this[9] != other[9] || this[10] != other[10] || this[11] != other[11]
      || this[12] != other[12] || this[13] != other[13] || this[14] != other[14] || this[15] != other[15];
  }

  /**
   * Setup matrix[index] support.
   * @param index The index to access.
   * @return The index value.
   */
  @:arrayAccess
  public inline function getIndex(index: Int): Float {
    #if debug
    if (index < 0 || index > 15) {
      throw new Exception('Index ${index} is out of range.');
    }
    #end

    return this[index];
  }

  /**
   * Setup matrix[index] = value support.
   * @param index The index to set.
   * @param value The new value.
   * @return The index value.
   */
  @:arrayAccess
  public inline function setIndex(index: Int, value: Float): Float {
    #if debug
    if (index < 0 || index > 15) {
      throw new Exception('Index ${index} is out of range.');
    }
    #end

    this[index] = value;

    return value;
  }

  /**
   * Set this matrix to the identity matrix.
   * @return This matrix.
   */
  public function identity(): Mat4 {
    this[0] = 1;
    this[1] = 0;
    this[2] = 0;
    this[3] = 0;
    this[4] = 0;
    this[5] = 1;
    this[6] = 0;
    this[7] = 0;
    this[8] = 0;
    this[9] = 0;
    this[10] = 1;
    this[11] = 0;
    this[12] = 0;
    this[13] = 0;
    this[14] = 0;
    this[15] = 1;

    return this;
  }

  /**
   * Copy the values from another matrix.
   * @param other The matrix to copy from.
   * @return This matrix.
   */
  public function copyFrom(other: Mat4): Mat4 {
    this[0] = other[0];
    this[1] = other[1];
    this[2] = other[2];
    this[3] = other[3];
    this[4] = other[4];
    this[5] = other[5];
    this[6] = other[6];
    this[7] = other[7];
    this[8] = other[8];
    this[9] = other[9];
    this[10] = other[10];
    this[11] = other[11];
    this[12] = other[12];
    this[13] = other[13];
    this[14] = other[14];
    this[15] = other[15];

    return this;
  }

  /**
    * Set an orthographic projection.
    * @param params The ortho project parameters.
     @return This matrix.
   */
  public function ortho(params: OrthoParams): Mat4 {
    final lr = 1 / (params.left - params.right);
    final bt = 1 / (params.bottom - params.top);
    final nf = 1 / (params.near - params.far);

    this[0] = -2 * lr;
    this[1] = 0;
    this[2] = 0;
    this[3] = 0;
    this[4] = 0;
    this[5] = -2 * bt;
    this[6] = 0;
    this[7] = 0;
    this[8] = 0;
    this[9] = 0;
    this[10] = 2 * nf;
    this[11] = 0;
    this[12] = (params.left + params.right) * lr;
    this[13] = (params.top + params.bottom) * bt;
    this[14] = (params.far + params.near) * nf;
    this[15] = 1;

    return this;
  }

  /**
   * Return this matrix inverted. Does not change this matrix.
   * @param out The matrix to store the result in.
   * @return The inverted matrix.
   */
  public function invert(out: Mat4): Mat4 {
    final a00 = this[0];
    final a01 = this[1];
    final a02 = this[2];
    final a03 = this[3];
    final a10 = this[4];
    final a11 = this[5];
    final a12 = this[6];
    final a13 = this[7];
    final a20 = this[8];
    final a21 = this[9];
    final a22 = this[10];
    final a23 = this[11];
    final a30 = this[12];
    final a31 = this[13];
    final a32 = this[14];
    final a33 = this[15];

    final b00 = a00 * a11 - a01 * a10;
    final b01 = a00 * a12 - a02 * a10;
    final b02 = a00 * a13 - a03 * a10;
    final b03 = a01 * a12 - a02 * a11;
    final b04 = a01 * a13 - a03 * a11;
    final b05 = a02 * a13 - a03 * a12;
    final b06 = a20 * a31 - a21 * a30;
    final b07 = a20 * a32 - a22 * a30;
    final b08 = a20 * a33 - a23 * a30;
    final b09 = a21 * a32 - a22 * a31;
    final b10 = a21 * a33 - a23 * a31;
    final b11 = a22 * a33 - a23 * a32;

    // Calculate the determinant
    var det = b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06;

    if (det == 0) {
      return null;
    }
    det = 1.0 / det;

    out[0] = (a11 * b11 - a12 * b10 + a13 * b09) * det;
    out[1] = (a02 * b10 - a01 * b11 - a03 * b09) * det;
    out[2] = (a31 * b05 - a32 * b04 + a33 * b03) * det;
    out[3] = (a22 * b04 - a21 * b05 - a23 * b03) * det;
    out[4] = (a12 * b08 - a10 * b11 - a13 * b07) * det;
    out[5] = (a00 * b11 - a02 * b08 + a03 * b07) * det;
    out[6] = (a32 * b02 - a30 * b05 - a33 * b01) * det;
    out[7] = (a20 * b05 - a22 * b02 + a23 * b01) * det;
    out[8] = (a10 * b10 - a11 * b08 + a13 * b06) * det;
    out[9] = (a01 * b08 - a00 * b10 - a03 * b06) * det;
    out[10] = (a30 * b04 - a31 * b02 + a33 * b00) * det;
    out[11] = (a21 * b02 - a20 * b04 - a23 * b00) * det;
    out[12] = (a11 * b07 - a10 * b09 - a12 * b06) * det;
    out[13] = (a00 * b09 - a01 * b07 + a02 * b06) * det;
    out[14] = (a31 * b01 - a30 * b03 - a32 * b00) * det;
    out[15] = (a20 * b03 - a21 * b01 + a22 * b00) * det;

    return out;
  }

  /**
   * Put this matrix back into the object pool.
   */
  public inline function put() {
    POOL.push(this);
  }

  /**
   * Return this matrix as a Float32 array.
   * @return The created Float32 array.
   */
  public inline function toFloat32Array(): Float32Array {
    return new Float32Array(this);
  }

  /**
   * A string representation of the matrix.
   * @return The matrix string.
   */
  public inline function toString(): String {
    return '[ ${this[0]}, ${this[1]}, ${this[2]}, ${this[3]}, ${this[4]}, ${this[5]}, ${this[6]}, ${this[7]}'
      + ', ${this[8]}, ${this[9]}, ${this[10]}, ${this[11]}, ${this[12]}, ${this[13]}, ${this[14]}, ${this[15]} ]';
  }
}
