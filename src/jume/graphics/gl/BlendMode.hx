package jume.graphics.gl;

/**
 * Blend mode options.
 */
enum abstract BlendMode(String) {
  var UNDEFINED = 'undefined';
  var BLEND_ONE = 'blend_one';
  var BLEND_ZERO = 'blend_zero';
  var SOURCE_ALPHA = 'source_alpha';
  var DESTINATION_ALPHA = 'destination_alpha';
  var INVERSE_SOURCE_ALPHA = 'inverse_source_alpha';
  var INVERSE_DESTINATION_ALPHA = 'inverse_destination_alpha';
  var SOURCE_COLOR = 'source_color';
  var DESTINATION_COLOR = 'destination_color';
  var INVERSE_SOURCE_COLOR = 'inverse_source_color';
  var INVERSE_DESTINATION_COLOR = 'inverse_destination_color';
}
