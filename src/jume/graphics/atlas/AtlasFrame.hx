package jume.graphics.atlas;

import jume.math.Rectangle;
import jume.math.Size;

/**
 * Json data per frame.
 */
typedef JsonAtlasFrameInfo = {
  var filename: String;
  var trimmed: Bool;
  var frame: {
    x: Int,
    y: Int,
    w: Int,
    h: Int
  };
  var spriteSourceSize: {
    x: Int,
    y: Int,
    w: Int,
    h: Int
  };
  var sourceSize: {
    w: Int,
    h: Int
  };
};

/**
 * All information needed to draw a frame from an atlas.
 */
class AtlasFrame {
  /**
   * The frame name.
   */
  public final name: String;

  /**
   * The frame rect in pixels.
   */
  public final frame: Rectangle;

  /**
   * Has this frame had the transparency trimmed.
   */
  public final trimmed: Bool;

  /**
   * The rect of the original image.
   */
  public final sourceRect: Rectangle;

  /**
   * The size of the original image.
   */
  public final sourceSize: Size;

  /**
   * @param name The frame name.
   * @param frame The frame rect.
   * @param trimmed Has the frame been trimmed.
   * @param sourceRect The original rect.
   * @param sourceSize The original size.
   */
  public function new(name: String, frame: Rectangle, trimmed: Bool, sourceRect: Rectangle, sourceSize: Size) {
    this.name = name;
    this.frame = frame;
    this.trimmed = trimmed;
    this.sourceRect = sourceRect;
    this.sourceSize = sourceSize;
  }

  /**
   * Create an AtlasFrame from json data.
   * @param frameInfo The json frame info.
   * @returns The created AtlasFrame.
   */
  public static function fromJsonFrame(frameInfo: JsonAtlasFrameInfo): AtlasFrame {
    final frameRect = new Rectangle(frameInfo.frame.x, frameInfo.frame.y, frameInfo.frame.w, frameInfo.frame.h);
    final sourceRect = new Rectangle(frameInfo.spriteSourceSize.x, frameInfo.spriteSourceSize.y,
      frameInfo.spriteSourceSize.w, frameInfo.spriteSourceSize.h);
    final sourceSize = new Size(frameInfo.sourceSize.w, frameInfo.sourceSize.h);

    return new AtlasFrame(frameInfo.filename, frameRect, frameInfo.trimmed, sourceRect, sourceSize);
  }
}
