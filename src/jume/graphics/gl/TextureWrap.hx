package jume.graphics.gl;

/**
 * Texture wrap options.
 */
enum abstract TextureWrap(String) {
  var REPEAT = 'repeat';
  var CLAMP_TO_EDGE = 'clamp_to_edge';
  var MIRRORED_REPEAT = 'mirrored_repeat';
}
