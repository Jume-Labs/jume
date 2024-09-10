package jume.graphics.gl;

/**
 * Texture filter options.
 */
enum abstract TextureFilter(String) {
  var NEAREST = 'nearest';
  var LINEAR = 'linear';
  var ANISOTROPIC = 'anisotropic';
}
