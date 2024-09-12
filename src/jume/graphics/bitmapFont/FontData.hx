package jume.graphics.bitmapFont;

using StringTools;

/**
 * Bitmap character information.
 */
typedef BmFontChar = {
  /**
   * The character id.
   */
  var id: Int;

  /**
   * The x position in the atlas in pixels.
   */
  var x: Int;

  /**
   * The y position in the atlas in pixels.
   */
  var y: Int;

  /**
   * The character width in pixels.
   */
  var width: Int;

  /**
   * The character height in pixels.
   */
  var height: Int;

  /**
   * The horizontal position offset in pixels.
   */
  var xOffset: Int;

  /**
   * The vertical position offset in pixels.
   */
  var yOffset: Int;

  /**
   * The amount of horizontal pixels this character takes up and the next character should start after.
   */
  var xAdvance: Int;
};

/**
 * Kerning information.
 */
typedef Kerning = {
  /**
   * The first character id.
   */
  var first: Int;

  /**
   * The second character id.
   */
  var second: Int;

  /**
   * The amount of kerning in pixels.
   */
  var amount: Int;
};

/**
 * .fnt Font information.
 */
class FontData {
  /**
   * The height of a text line in pixels.
   */
  public var lineHeight(default, null): Int;

  /**
   * All character in the atlas.
   */
  var chars: Map<Int, BmFontChar>;

  /**
   * All kernings for this font.
   */
  var kernings: Array<Kerning>;

  /**
   * @param fontData The loaded text from a .fnt file.
   */
  public function new(fontData: String) {
    chars = new Map<Int, BmFontChar>();
    kernings = [];

    // Split by new lines.
    final lines = ~/\r?\n/g.split(fontData);

    for (line in lines) {
      final temp = line.trim().split(' ');
      final segments: Array<String> = [];
      for (segment in temp) {
        if (segment != '') {
          segments.push(segment);
        }
      }

      if (segments.length == 0) {
        continue;
      }

      final lineName = segments[0];
      if (lineName == 'common') {
        lineHeight = getFontInfo(segments[1]);
      } else if (lineName == 'char') {
        final character: BmFontChar = {
          id: getFontInfo(segments[1]),
          x: getFontInfo(segments[2]),
          y: getFontInfo(segments[3]),
          width: getFontInfo(segments[4]),
          height: getFontInfo(segments[5]),
          xOffset: getFontInfo(segments[6]),
          yOffset: getFontInfo(segments[7]),
          xAdvance: getFontInfo(segments[8]),
        };
        chars.set(character.id, character);
      } else if (lineName == 'kerning') {
        kernings.push({
          first: getFontInfo(segments[1]),
          second: getFontInfo(segments[2]),
          amount: getFontInfo(segments[3]),
        });
      }
    }
  }

  /**
   * Get render data from a single character.
   * @param char The character to check
   * @returns The character information.
   */
  public inline function getCharData(char: Int): BmFontChar {
    return chars[char];
  }

  /**
   * Get the kerning amount between two characters.
   * @param first The left character.
   * @param second The right character.
   * @returns The kerning amount.
   */
  public function getKerning(first: Int, second: Int): Int {
    var amount = 0;

    for (kerning in kernings) {
      if (kerning.first == first && kerning.second == second) {
        amount = kerning.amount;
        break;
      }
    }

    return amount;
  }

  /**
   * information is stored like x=1 for all segments in the data file.
   * This take the part on the right of the = and converts it into a number.
   */
  inline function getFontInfo(segment: String): Int {
    final split = segment.split('=');
    #if debug
    if (split.length != 2) {
      throw 'Incorrect segment format';
    }
    #end

    return Std.parseInt(split[1]);
  }
}
