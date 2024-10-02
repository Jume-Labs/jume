package jume.view;

import jume.di.Injectable;
import jume.graphics.Color;
import jume.graphics.RenderTarget;
import jume.math.Mat4;
import jume.math.Rectangle;
import jume.math.Size;
import jume.math.Vec2;

using jume.math.MathUtils;

/**
 * The camera renders everything in view.
 */
class Camera implements Injectable {
  /**
   * Only active cameras render actors.
   */
  public var active: Bool;

  /**
   * The camera position in pixels.
   */
  public var position: Vec2;

  /**
   * The camera rotation in degrees.
   */
  public var rotation: Float;

  /**
   * The camera zoom. 1.0 is no zoom.
   */
  public var zoom: Float;

  /**
   * The camera transform matrix.
   */
  public var transform: Mat4;

  /**
   * The camera background color.
   */
  public var bgColor: Color;

  /**
   * Layers skip when rendering.
   */
  public var ignoredLayers: Array<Int>;

  /**
   * The camera bounds in pixels.
   */
  public var bounds(default, null) = new Rectangle();

  /**
   * Screen bounds are the bounds in view space.
   */
  public var screenBounds(default, null) = new Rectangle();

  /**
   * The camera render target.
   */
  public var target(default, null): RenderTarget;

  /**
   * The rectangle of the space this camera takes up in the game view.
   */
  var viewRect: Rectangle;

  /**
   * Matrix used for transform calculations.
   */
  var tempMatrix: Mat4;

  /**
   * Used in screen to world.
   */
  var tempPos: Vec2;

  /**
   * View service reference.
   */
  @:inject
  var view: View;

  /**
   * Create a new camera.
   * @param options Creation options.
   * @param view Injected view dependency.
   */
  public function new(?options: CameraOptions) {
    active = true;
    position = new Vec2();
    rotation = 0;
    zoom = 1;
    transform = new Mat4();
    ignoredLayers = [];
    viewRect = new Rectangle();
    tempMatrix = new Mat4();
    tempPos = new Vec2();

    if (options != null) {
      position.set(options.x ?? view.viewCenterX, options.y ?? view.viewCenterY);
      rotation = options.rotation ?? 0.0;
      zoom = options.zoom ?? 1.0;
      bgColor = options.bgColor ?? Color.BLACK;
      ignoredLayers = options.ignoredLayers ?? [];
      updateView(options.viewX ?? 0, options.viewY ?? 0, options.viewWidth ?? 1, options.viewHeight ?? 1);
    } else {
      position.set(view.viewCenterX, view.viewCenterY);
      updateView(0, 0, 1, 1);
    }
    updateBounds();
  }

  /**
   * Update the camera transform.
   */
  public function updateTransform() {
    this.updateBounds();
    Mat4.fromTranslation(screenBounds.width * 0.5, screenBounds.height * 0.5, 0, transform);
    Mat4.fromZRotation(Math.toRad(rotation), tempMatrix);
    Mat4.multiply(transform, tempMatrix, transform);

    Mat4.fromScale(zoom, zoom, 1, tempMatrix);
    Mat4.multiply(transform, tempMatrix, transform);

    Mat4.fromTranslation(-position.x, -position.y, 0, tempMatrix);
    Mat4.multiply(transform, tempMatrix, transform);
  }

  /**
   * Update the camera size and position inside the game view.
   * @param x The top left x position (0 - 1).
   * @param y The top left y position (0 - 1).
   * @param width The view width (0 - 1).
   * @param height The view height (0 - 1).
   */
  public function updateView(x: Float, y: Float, width: Float, height: Float) {
    x = Math.clamp(x, 0, 1);
    y = Math.clamp(y, 0, 1);
    width = Math.clamp(width, 0, 1);
    height = Math.clamp(height, 0, 1);
    viewRect.set(x, y, width, height);

    screenBounds.set(x * view.viewWidth, y * view.viewHeight, width * view.viewWidth, height * view.viewHeight);
    target = new RenderTarget(new Size(Std.int(width * view.viewWidth), Std.int(height * view.viewHeight)));
  }

  /**
   * Update the camera bounds.
   */
  public function updateBounds() {
    bounds.x = position.x - (screenBounds.width * 0.5) / zoom;
    bounds.y = position.y - (screenBounds.height * 0.5) / zoom;
    bounds.width = screenBounds.width / zoom;
    bounds.height = screenBounds.height / zoom;
  }

  /**
   * Resize gets called when the canvas resizes.
   */
  public function resize() {
    updateView(viewRect.x, viewRect.y, viewRect.width, viewRect.height);
    updateBounds();
  }

  /**
   * Convert a screen position to a game world position.
   * @param x The x position on the screen in pixels.
   * @param y The y position on the screen in pixels.
   * @param out Optional variable to store the result in.
   * @return The converted position.
   */
  public function screenToWorld(x: Float, y: Float, ?out: Vec2): Vec2 {
    final tempX = position.x
      - (screenBounds.width * 0.5) / zoom
      + (x / (view.canvasWidth / view.pixelRatio)) * (screenBounds.width / zoom);
    final tempY = position.y
      - (screenBounds.height * 0.5) / zoom
      + (y / (view.canvasHeight / view.pixelRatio)) * (screenBounds.height / zoom);

    tempPos.set(tempX, tempY);

    return Math.rotateAround(tempPos, position, -rotation, out);
  }

  /**
   * Convert a screen position to a game view position.
   * @param x The x position on the screen in pixels.
   * @param y The y position on the screen in pixels.
   * @param out Optional variable to store the result in.
   * @return The converted position.
   */
  public function screenToView(x: Float, y: Float, ?out: Vec2): Vec2 {
    if (out == null) {
      out = Vec2.get();
    }

    return out.set((x / (view.canvasWidth / view.pixelRatio)) * view.viewWidth,
      (y / (view.canvasHeight / view.pixelRatio)) * view.viewHeight);
  }
}

/**
 * Camera creation options.
 */
typedef CameraOptions = {
  /**
   * The x position.
   */
  var ?x: Float;

  /**
   * The y position.
   */
  var ?y: Float;

  /**
   * The z rotation in degrees.
   */
  var ?rotation: Float;

  /**
   * The camera zoom.
   */
  var ?zoom: Float;

  /**
   * The x position of the top left on the canvas (0 - 1).
   */
  var ?viewX: Float;

  /**
   * The x position of the top left on the canvas (0 - 1).
   */
  var ?viewY: Float;

  /**
   * The x position of the top left on the canvas (0 - 1).
   */
  var ?viewWidth: Float;

  /**
   * The x position of the top left on the canvas (0 - 1).
   */
  var ?viewHeight: Float;

  /**
   * The camera background color.
   */
  var ?bgColor: Color;

  /**
   * Layers to skip when rendering.
   */
  var ?ignoredLayers: Array<Int>;
}
