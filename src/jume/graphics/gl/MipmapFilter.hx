package jume.graphics.gl;

/**
 * Mipmap filtering options.
 */
enum abstract MipmapFilter(String) {
  var NONE = 'none';
  var NEAREST = 'nearest';
  var LINEAR = 'linear';
}
