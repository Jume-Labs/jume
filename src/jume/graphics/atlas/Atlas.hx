package jume.graphics.atlas;

import haxe.Json;

import jume.graphics.atlas.AtlasFrame.JsonAtlasFrameInfo;

/**
 * Type to get the correct data when parsing the json data.
 */
typedef AtlasData = {
  var frames: Array<JsonAtlasFrameInfo>;
};

/**
 * Sprite atlas class.
 */
class Atlas {
  /**
   * The image used in the atlas.
   */
  public final image: Image;

  /**
   * All the frame data mapped by frame name.
   */
  final frames = new Map<String, AtlasFrame>();

  /**
   * Create a new atlas.
   * @param image The image to use.
   * @param data The json data.
   */
  public function new(image: Image, data: String) {
    this.image = image;

    final frameData: AtlasData = Json.parse(data);
    for (frameInfo in frameData.frames) {
      final frame = AtlasFrame.fromJsonFrame(frameInfo);
      frames[frame.name] = frame;
    }
  }

  /**
   * Get a frame by frame name.
   * @param name The name of the frame.
   * @returns The frame or undefined if it doesn't exist.
   */
  public inline function getFrame(name: String): AtlasFrame {
    return frames[name];
  }
}
