package jume.view;

import js.Browser;
import js.html.CanvasElement;

import jume.di.Service;
import jume.math.Size;
import jume.math.Vec2;
import jume.view.ScaleModes.ScaleMode;
import jume.view.ScaleModes.scaleModeFitView;

typedef ViewParams = {
  /**
   * The width the game is designed for in pixels.
   */
  var width: Int;

  /**
   * The height the game is designed for in pixels.
   */
  var height: Int;

  /**
   * Use point filtering for better pixel art results.
   */
  var pixelFilter: Bool;

  /**
   * The ratio between physical pixels and logical pixels.
   */
  var pixelRatio: Int;

  /**
   * Is the game is full screen.
   */
  var isFullScreen: Bool;

  /**
   * The id of the canvas object.
   */
  var canvasId: String;

  /**
   * The frames per second the game will try to run at.
   */
  var targetFps: Int;
}

/**
 * The view class has view related information like design, view, and window size.
 */
class View implements Service {
  /**
   * If true debug render systems and components.
   */
  public var debugRender: Bool;

  /**
   * The ratio between physical pixels and logical pixels.
   */
  public final pixelRatio: Int;

  /**
   * The top left anchor of the view.
   */
  public final viewAnchor = new Vec2();

  /**
   * Use point filtering for better pixel art results.
   */
  public var pixelFilter: Bool;

  /**
   * The frames per second the game will try to run at.
   */
  public var targetFps: Int;

  /**
   * Check if the game is full screen.
   * TODO: Changing full screen after game start needs to be implemented.
   */
  public var isFullScreen: Bool;

  /**
   * The game canvas element.
   */
  public var canvas(default, null): CanvasElement;

  /**
   * The width the game is designed for in pixels.
   */
  public var designWidth(get, never): Int;

  /**
   * The height the game is designed for in pixels.
   */
  public var designHeight(get, never): Int;

  /**
   * The canvas element width in pixels.
   */
  public var canvasWidth(get, never): Int;

  /**
   * The canvas element height in pixels.
   */
  public var canvasHeight(get, never): Int;

  /**
   * The canvas center x axis position in pixels.
   */
  public var canvasCenterX(get, never): Int;

  /**
   * The canvas center y axis position in pixels.
   */
  public var canvasCenterY(get, never): Int;

  /**
   * The scale game view width in pixels.
   */
  public var viewWidth(get, never): Int;

  /**
   * The scale game view height in pixels.
   */
  public var viewHeight(get, never): Int;

  /**
   * The view center x axis position in pixels.
   */
  public var viewCenterX(get, never): Int;

  /**
   * The view center x axis position in pixels.
   */
  public var viewCenterY(get, never): Int;

  /**
   * The scale factor on the x axis between canvas width and view width.
   */
  public var viewScaleX(get, never): Float;

  /**
   * The scale factor on the y axis between canvas height and view height.
   */
  public var viewScaleY(get, never): Float;

  /**
   * The current scale mode.
   */
  public var scaleMode(default, null): ScaleMode;

  /**
   * Internal design size.
   */
  final designSize = new Size();

  /**
   * Internal view size.
   */
  final viewSize = new Size();

  /**
   * Internal view scale.
   */
  final viewScale = new Vec2();

  /**
   * Internal view offset.
   */
  final viewOffset = new Vec2();

  /**
   * Initialize the View. This gets called automatically by the Game class on startup.
   */
  public function new(params: ViewParams) {
    designSize.set(params.width, params.height);
    pixelFilter = params.pixelFilter;

    #if !headless
    canvas = cast Browser.document.getElementById(params.canvasId);
    #end

    pixelRatio = params.pixelRatio;
    isFullScreen = params.isFullScreen;
    scaleMode = scaleModeFitView;
    targetFps = params.targetFps;
    scaleToFit();
  }

  /**
   * Scale the design size to fit the canvas. The result will be the view size.
   */
  public function scaleToFit() {
    final result = scaleMode({
      designWidth: designWidth,
      designHeight: designHeight,
      canvasWidth: canvasWidth,
      canvasHeight: canvasHeight,
      anchorX: viewAnchor.x,
      anchorY: viewAnchor.y
    });

    viewSize.set(result.viewWidth, result.viewHeight);
    viewScale.set(result.scaleFactorX, result.scaleFactorY);
    viewOffset.set(result.offsetX, result.offsetY);
  }

  /**
   * Set a new scale mode.
   * @param mode The new scale mode.
   */
  public function setScaleMode(mode: ScaleMode) {
    scaleMode = mode;
    scaleToFit();
  }

  inline function get_designWidth(): Int {
    return designSize.widthi;
  }

  inline function get_designHeight(): Int {
    return designSize.heighti;
  }

  function get_canvasWidth(): Int {
    #if headless
    // Hard code width for headless mode.
    return Math.round(800 * pixelRatio);
    #end
    return Math.round(canvas.clientWidth * pixelRatio);
  }

  function get_canvasHeight(): Int {
    #if headless
    // Hard code height for headless mode.
    return Math.round(600 * pixelRatio);
    #end
    return Math.round(canvas.clientHeight * pixelRatio);
  }

  inline function get_canvasCenterX(): Int {
    return Math.floor(canvasWidth * 0.5);
  }

  inline function get_canvasCenterY(): Int {
    return Math.floor(canvasHeight * 0.5);
  }

  inline function get_viewWidth(): Int {
    return viewSize.widthi;
  }

  inline function get_viewHeight(): Int {
    return viewSize.heighti;
  }

  inline function get_viewCenterX(): Int {
    return Math.floor(viewSize.width * 0.5);
  }

  inline function get_viewCenterY(): Int {
    return Math.floor(viewSize.height * 0.5);
  }

  inline function get_viewScaleX(): Float {
    return viewScale.x;
  }

  inline function get_viewScaleY(): Float {
    return viewScale.y;
  }
}
