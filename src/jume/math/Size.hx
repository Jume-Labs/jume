package jume.math;

/**
 * Stores a width and a height.
 */
class Size {
  /**
   * The horizontal size.
   */
  public var width: Float;

  /**
   * The vertical size.
   */
  public var height: Float;

  /**
   * The integer horizontal size.
   */
  public var widthi(get, never): Int;

  /**
   * The integer vertical size.
   */
  public var heighti(get, never): Int;

  /**
   * Create a new size object.
   * @param width The horizontal size.
   * @param height The vertical size.
   */
  public function new(width = 0.0, height = 0.0) {
    set(width, height);
  }

  /**
   * Set new size values.
   * @param width The new width.
   * @param height The new height.
   */
  public inline function set(width: Float, height: Float) {
    this.width = width;
    this.height = height;
  }

  /**
   * Clone this size.
   * @param out Optional size to store the result in.
   * @return The cloned size.
   */
  public function clone(?out: Size): Size {
    if (out == null) {
      out = new Size();
    }
    out.set(width, height);

    return out;
  }

  /**
   * A string representation of this size.
   * @return The size string.
   */
  public function toString(): String {
    return '{ w: ${width}, h: ${height} }';
  }

  inline function get_widthi(): Int {
    return Math.floor(width);
  }

  inline function get_heighti(): Int {
    return Math.floor(height);
  }
}
