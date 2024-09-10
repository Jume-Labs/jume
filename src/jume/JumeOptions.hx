package jume;

import jume.math.Size;

/**
 * The Jume configuration option.
 */
typedef JumeOptions = {
  /**
   * The game title. Will display in the title of the browser.
   */
  var ?title: String;

  /**
   * The width and height in pixels the game is designed for before scaling.
   */
  var ?designSize: Size;

  /**
   * The html canvas width and height in pixels. If not provided it will be set to the design width and height.
   */
  var ?canvasSize: Size;

  /**
   * The id of the html canvas. Default is 'jume'.
   */
  var ?canvasId: String;

  /**
   * Should the game pause when not focused. Default is true.
   */
  var ?pauseUnfocused: Bool;

  /**
   * Should WebGL 1 be used even if 2 is available. Default is false.
   */
  var ?forceWebGL1: Bool;

  /**
   * Should all filtering be 'nearest'. This is good for pixel art games.
   */
  var ?pixelFilter: Bool;

  /**
   * Should the game be the full width of the browser.
   * TODO: Make this work properly on desktop.
   */
  var ?fullScreen: Bool;

  /**
   * Should the game use the actual pixels instead of browser pixel ratio pixels. Default is false.
   * This will look better, but performance will be worse if there is a lot on the screen.
   */
  var ?hdpi: Bool;

  /**
   * The target fps to run the game in. Default is 60.
   */
  var ?targetFps: Int;
}

/**
 * Set the default options if they are not provided.
 * @param options The object to set the defaults on.
 */
function setDefaultJumeOptions(options: JumeOptions) {
  options.title ??= 'A Jume Game';
  options.designSize ??= new Size(800, 600);
  options.canvasSize ??= options.designSize.clone();
  options.canvasId ??= 'jume';
  options.pauseUnfocused ??= true;
  options.forceWebGL1 ??= false;
  options.pixelFilter ??= false;
  options.fullScreen ??= false;
  options.hdpi ??= false;
  options.targetFps ??= -1;
}
