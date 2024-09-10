package jume.graphics;

using jume.math.MathUtils;

/**
 * Generic color parameter type used in the color functions.
 */
typedef ColorParams<T> = {
  var ?red: T;
  var ?green: T;
  var ?blue: T;
  var ?alpha: T;
}

/**
 * RGBA color class.
 */
class Color {
  // Some basic colors that can be used for prototyping.
  public static final BLACK = Color.fromHex(0xff000000);
  public static final WHITE = Color.fromHex(0xffffffff);
  public static final RED = Color.fromHex(0xffff0000);
  public static final GREEN = Color.fromHex(0xff00ff00);
  public static final BLUE = Color.fromHex(0xff0000ff);
  public static final YELLOW = Color.fromHex(0xffffff00);
  public static final ORANGE = Color.fromHex(0xffff7700);
  public static final CYAN = Color.fromHex(0xff00ffff);
  public static final TRANSPARENT = Color.fromHex(0x00000000);

  /**
   * The red color channel (0 - 1).
   */
  public var red: Float;

  /**
   * The green color channel (0 - 1).
   */
  public var green: Float;

  /**
   * The blue color channel (0 - 1).
   */
  public var blue: Float;

  /**
   * The alpha color channel (0 - 1).
   */
  public var alpha: Float;

  /**
   * Create a color from bytes values.
   * @param red The red byte value (0 - 255).
   * @param green The green byte value (0 - 255).
   * @param blue The blue byte value (0 - 255).
   * @param alpha The alpha byte value (0 - 255).
   * @param out Optional color to store the result in. If null a new color will be created.
   * @return The created color.
   */
  public static function fromBytes(colors: ColorParams<Int>, ?out: Color): Color {
    out ??= new Color();

    final r = Math.clampInt(colors.red ?? 0, 0, 255) / 255.0;
    final g = Math.clampInt(colors.green ?? 0, 0, 255) / 255.0;
    final b = Math.clampInt(colors.blue ?? 0, 0, 255) / 255.0;
    final a = Math.clampInt(colors.alpha ?? 255, 0, 255) / 255.0;
    out.set({
      red: r,
      green: g,
      blue: b,
      alpha: a
    });

    return out;
  }

  /**
   * Create a color from a hex value.
   * @param hex the ARGB hex color.
   * @param out Optional color to store the result in. If null a new color will be created.
   * @return The created color.
   */
  public static function fromHex(hex: Int, ?out: Color): Color {
    out ??= new Color();
    final r = (hex >> 16) & 255;
    final g = (hex >> 8) & 255;
    final b = hex & 255;
    final a = (hex >> 24) & 255;

    Color.fromBytes({
      red: r,
      green: g,
      blue: b,
      alpha: a
    }, out);

    return out;
  }

  /**
   * Create a color from a hex string.
   * @param hex The ARGB hex color.
   * @param out Optional color to store the result in. If null a new color will be created.
   * @return The created color.
   */
  public static function fromHexString(hex: String, ?out: Color): Color {
    out ??= new Color();

    final regex = ~/^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i;
    if (regex.match(hex)) {
      final r = Std.parseInt('0x${regex.matched(2)}');
      final g = Std.parseInt('0x${regex.matched(3)}');
      final b = Std.parseInt('0x${regex.matched(4)}');
      final a = Std.parseInt('0x${regex.matched(1)}');

      Color.fromBytes({
        red: r,
        green: g,
        blue: b,
        alpha: a
      }, out);

      return out;
    }

    return null;
  }

  /**
   * Interpolate between two colors.
   * @param color1 The start color.
   * @param color2 The end color.
   * @param position The interpolation position (0 - 1).
   * @param out Optional color to store the result in. If null a new color will be created.
   * @return Color
   */
  public static function interpolate(color1: Color, color2: Color, position: Float, ?out: Color): Color {
    out ??= new Color();

    final r = (color2.red - color1.red) * position + color1.red;
    final g = (color2.green - color1.green) * position + color1.green;
    final b = (color2.blue - color1.blue) * position + color1.blue;
    final a = (color2.alpha - color1.alpha) * position + color1.alpha;
    out.red = r;
    out.green = g;
    out.blue = b;
    out.alpha = a;

    return out;
  }

  /**
   * Create a new color instance.
   * @param red The red channel value (0 - 1).
   * @param green The green channel value (0 - 1). 
   * @param blue The blue channel value (0 - 1). 
   * @param alpha The alpha channel value (0 - 1).
   */
  public function new(?colors: ColorParams<Float>) {
    if (colors == null) {
      red = 0;
      green = 0;
      blue = 0;
      alpha = 1;
    } else {
      set(colors);
    }
  }

  /**
   * update the color values.
   * @param red The red channel value (0 - 1).
   * @param green The green channel value (0 - 1). 
   * @param blue The blue channel value (0 - 1). 
   * @param alpha The alpha channel value (0 - 1).
   */
  public function set(colors: ColorParams<Float>) {
    red = colors.red ?? 0;
    green = colors.green ?? 0;
    blue = colors.blue ?? 0;
    alpha = colors.alpha ?? 1;
  }

  /**
   * Clone this color.
   * @param out Optional color to store the result in. If null a new color will be created.
   * @return The cloned color.
   */
  public function clone(?out: Color): Color {
    out ??= new Color();
    out.set({
      red: red,
      green: green,
      blue: blue,
      alpha: alpha
    });

    return out;
  }

  /**
   * Copy the values from another color.
   * @param source The source to copy from.
   */
  public inline function copyFrom(source: Color) {
    red = source.red;
    green = source.green;
    blue = source.blue;
    alpha = source.alpha;
  }

  /**
   * Get a string representation of this color.
   * @return The color string.
   */
  public inline function toString(): String {
    return '{ r: ${red}, g: ${green}, b: ${blue}, a: ${alpha} }';
  }
}
