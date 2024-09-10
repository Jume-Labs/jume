package jume.graphics.gl;

/**
 * Blend operation options.
 */
enum abstract BlendOperation(String) {
  var ADD = 'add';
  var SUBTRACT = 'subtract';
  var REVERSE_SUBTRACT = 'reverse_subtract';
}
