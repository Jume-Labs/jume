package jume.graphics.bitmapFont;

import jume.graphics.bitmapFont.FontData.BmFontChar;

/**
 * Bitmap font class.
 */
class BitmapFont {
  /**
   * The image with the font characters.
   */
  public var image(default, null): Image;

  /**
   * The font height in pixels.
   */
  public var height(get, never): Int;

  /**
   * The .fnt data.
   */
  var fontData: FontData;

  /**
   * @param image Font image.
   * @param data content of .fnt data file.
   */
  public function new(image: Image, data: String) {
    this.image = image;
    fontData = new FontData(data);
  }

  /**
   * Get render data for a character.
   * @param char The char to check.
   * @returns The character render data.
   */
  public inline function getCharData(char: Int): BmFontChar {
    return fontData.getCharData(char);
  }

  /**
   * Get the offset between two characters.
   * @param first The current character.
   * @param second The next character to the right.
   * @returns The offset.
   */
  public inline function getKerning(first: Int, second: Int): Int {
    return fontData.getKerning(first, second);
  }

  /**
   * Get the width in pixels of the string using this font.
   * @param text The string to check.
   * @returns The width in pixels.
   */
  public function width(text: String): Int {
    if (text == null) {
      return 0;
    }

    var length = 0;
    for (i in 0...text.length) {
      final char = text.charCodeAt(i);
      final charData = fontData.getCharData(char);
      if (charData == null) {
        break;
      }
      length += charData.xAdvance;
      if (i > 0) {
        final prevElem = text.charCodeAt(i - 1);
        length += fontData.getKerning(prevElem, char);
      }
    }
    return length;
  }

  inline function get_height(): Int {
    return fontData.lineHeight;
  }
}
