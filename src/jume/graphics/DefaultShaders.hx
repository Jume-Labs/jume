package jume.graphics;

/**
 * These are the default shape and image shaders.
 */
class DefaultShaders {
  public static inline function shapeVert(gl1: Bool): String {
    return gl1 ? SHAPE_VERT_GL1 : SHAPE_VERT;
  }

  public static inline function shapeFrag(gl1: Bool): String {
    return gl1 ? SHAPE_FRAG_GL1 : SHAPE_FRAG;
  }

  public static inline function imageVert(gl1: Bool): String {
    return gl1 ? IMAGE_VERT_GL1 : IMAGE_VERT;
  }

  public static inline function imageFrag(gl1: Bool): String {
    return gl1 ? IMAGE_FRAG_GL1 : IMAGE_FRAG;
  }

  static final SHAPE_VERT = [
    '#version 300 es',
    'in vec3 vertexPosition;',
    'in vec4 vertexColor;',
    'uniform mat4 projectionMatrix;',
    'out vec4 fragmentColor;',
    'void main() {',
    ' gl_Position = projectionMatrix * vec4(vertexPosition, 1.0);',
    ' fragmentColor = vertexColor;',
    '}',
  ].join('\n');

  static final SHAPE_FRAG = [
    '#version 300 es',
    'precision mediump float;',
    'in vec4 fragmentColor;',
    'out vec4 FragColor;',
    'void main() {',
    ' FragColor = fragmentColor;',
    '}',
  ].join('\n');

  static final SHAPE_VERT_GL1 = [
    '#version 100',
    'attribute vec3 vertexPosition;',
    'attribute vec4 vertexColor;',
    'uniform mat4 projectionMatrix;',
    'varying vec4 fragColor;',
    'void main() {',
    ' gl_Position = projectionMatrix * vec4(vertexPosition, 1.0);',
    ' fragColor = vertexColor;',
    '}',
  ].join('\n');

  static final SHAPE_FRAG_GL1 = [
    '#version 100',
    'precision mediump float;',
    'varying vec4 fragColor;',
    'void main() {',
    ' gl_FragColor = fragColor;',
    '}',
  ].join('\n');

  static final IMAGE_VERT = [
    '#version 300 es',
    'in vec3 vertexPosition;',
    'in vec4 vertexColor;',
    'in vec2 vertexUV;',
    'uniform mat4 projectionMatrix;',
    'out vec2 fragUV;',
    'out vec4 fragColor;',
    'void main() {',
    ' gl_Position = projectionMatrix * vec4(vertexPosition, 1.0);',
    ' fragUV = vertexUV;',
    ' fragColor = vertexColor;',
    '}',
  ].join('\n');

  static final IMAGE_FRAG = [
    '#version 300 es',
    'precision mediump float;',
    'uniform sampler2D tex;',
    'in vec2 fragUV;',
    'in vec4 fragColor;',
    'out vec4 FragColor;',
    'void main() {',
    ' vec4 texcolor = texture(tex, fragUV) * fragColor;',
    ' texcolor.rgb *= fragColor.a;',
    ' FragColor = texcolor;',
    '}',
  ].join('\n');

  static final IMAGE_VERT_GL1 = [
    '#version 100',
    'attribute vec3 vertexPosition;',
    'attribute vec4 vertexColor;',
    'attribute vec2 vertexUV;',
    'uniform mat4 projectionMatrix;',
    'varying vec4 fragColor;',
    'varying vec2 fragUV;',
    'void main() {',
    ' gl_Position = projectionMatrix * vec4(vertexPosition, 1.0);',
    ' fragColor = vertexColor;',
    ' fragUV = vertexUV;',
    '}',
  ].join('\n');

  static final IMAGE_FRAG_GL1 = [
    '#version 100',
    'uniform sampler2D tex;',
    'varying vec4 fragColor;',
    'varying vec2 fragUV;',
    'void main() {',
    ' vec4 texColor = texture2D(tex, fragUV) * fragColor;',
    ' texColor.rgb *= fragColor.a;',
    ' gl_FragColor = texColor;',
    '}',
  ].join('\n');
}
