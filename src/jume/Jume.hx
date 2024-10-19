package jume;

import haxe.Exception;
import haxe.Timer;

import js.Browser;
import js.html.CanvasElement;

import jume.JumeOptions.setDefaultJumeOptions;
import jume.assets.Assets;
import jume.assets.AtlasLoader;
import jume.assets.BitmapFontLoader;
import jume.assets.ImageLoader;
import jume.assets.ShaderLoader;
import jume.assets.SoundLoader;
import jume.assets.TextLoader;
import jume.assets.TilesetLoader;
import jume.audio.Audio;
import jume.di.Services;
import jume.ecs.Scene;
import jume.events.Events;
import jume.events.FocusEvent;
import jume.events.ResizeEvent;
import jume.events.SceneEvent;
import jume.graphics.Color;
import jume.graphics.Graphics;
import jume.graphics.RenderTarget;
import jume.graphics.gl.Context;
import jume.input.Input;
import jume.math.Mat4;
import jume.math.Random;
import jume.math.Size;
import jume.math.Vec2;
import jume.utils.BrowserInfo.isMobile;
import jume.utils.Time;
import jume.view.View;

/**
 * The main engine class.
 */
class Jume {
  /**
   * The maximum delta time possible. To avoid unpredictable behavior delta time is clamped to this.
   */
  static final MAX_DT = 1.0 / 15.0;

  /**
   * The time passed on the previous update in seconds.
   */
  var prevTime: Float;

  /**
   * Check to see if the canvas is in focus.
   */
  var inFocus: Bool;

  /**
   * Check to see if the game should pause when not in focus.
   */
  final pauseUnfocused: Bool;

  /**
   * The event manager.
   */
  final events: Events;

  /**
   * Web gl context.
   */
  final context: Context;

  /**
   * Rendering functions.
   */
  final graphics: Graphics;

  /**
   * Input manager.
   */
  final input: Input;

  /**
   * Time manager.
   */
  final time: Time;

  /**
   * View manager.
   */
  final view: View;

  /**
   * Main render target.
   */
  var target: RenderTarget;

  /**
   * The current active scene.
   */
  var scene: Scene;

  /**
   * Temporary position used when rendering the target to the screen.
   */
  var tempPos: Vec2;

  /**
   * Create a new Jume instance.
   * @param options The game options.
   */
  public function new(options: JumeOptions) {
    setDefaultJumeOptions(options);
    prevTime = 0;
    inFocus = true;

    final isFullScreen = isMobile() && options.fullScreen;
    var width = options.canvasSize.widthi;
    var height = options.canvasSize.heighti;
    var pixelRatio = 1;

    pauseUnfocused = options.pauseUnfocused;

    #if !headless
    Browser.document.title = options.title;
    pixelRatio = options.hdpi ? Std.int(Browser.window.devicePixelRatio) : 1;
    if (isFullScreen) {
      width = Browser.window.innerWidth;
      height = Browser.window.innerHeight;
    }

    final canvas: CanvasElement = cast Browser.document.getElementById(options.canvasId);
    if (canvas == null) {
      throw new Exception(' Canvas with id ${options.canvasId} not found.');
    }
    canvas.width = width * pixelRatio;
    canvas.style.width = '${width}px';
    canvas.height = height * pixelRatio;
    canvas.style.height = '${height}px';
    #end

    events = new Events();
    Services.add(events);

    context = new Context(options.canvasId, options.forceWebGL1);
    Services.add(context);

    tempPos = new Vec2();

    view = new View({
      width: options.designSize.widthi,
      height: options.designSize.heighti,
      pixelRatio: pixelRatio,
      pixelFilter: options.pixelFilter,
      isFullScreen: isFullScreen,
      targetFps: options.targetFps,
      canvasId: options.canvasId
    });
    Services.add(view);

    input = new Input(options.canvasId);
    Services.add(input);

    time = new Time();
    Services.add(time);

    Services.add(new Audio());
    Services.add(new Random());

    graphics = new Graphics(context, view);

    final assets = new Assets();
    Services.add(assets);
    addAssetLoaders(assets);

    target = new RenderTarget(new Size(view.viewWidth, view.viewHeight), view.pixelFilter ? NEAREST : LINEAR,
      view.pixelFilter ? NEAREST : LINEAR);
  }

  /**
   * Launch the game.
   * @param sceneType The scene to start the game with.
   */
  public function launch(sceneType: Class<Scene>) {
    events.addListener({ type: SceneEvent.CHANGE, callback: onSceneChange });
    changeScene(sceneType);

    #if headless
    prevTime = Timer.stamp();
    Timer.delay(headlessLoop, Std.int(1.0 / 60.0 * 1000));
    #else
    final canvas = view.canvas;
    canvas.focus();
    canvas.addEventListener('blur', () -> lostFocus());
    canvas.addEventListener('focus', () -> hasFocus());
    Browser.window.addEventListener('resize', () -> resize(Browser.window.innerWidth, Browser.window.innerHeight));

    Browser.window.requestAnimationFrame((time) -> {
      prevTime = Timer.stamp();
      loop(0.016);
    });
    #end
  }

  /**
   * Called when the game gets focus.
   */
  public function hasFocus() {
    inFocus = true;
    FocusEvent.send(FocusEvent.HAS_FOCUS);
    scene.hasFocus();
  }

  /**
   * Called when the game loses focus.
   */
  public function lostFocus() {
    inFocus = false;
    FocusEvent.send(FocusEvent.LOST_FOCUS);
    scene.lostFocus();
  }

  /**
   * Setup the built-in asset loaders.
   * @param assets The asset manager.
   */
  function addAssetLoaders(assets: Assets) {
    assets.registerLoader(new AtlasLoader());
    assets.registerLoader(new BitmapFontLoader());
    assets.registerLoader(new ImageLoader());
    assets.registerLoader(new ShaderLoader());
    assets.registerLoader(new SoundLoader());
    assets.registerLoader(new TextLoader());
    assets.registerLoader(new TilesetLoader());
  }

  /**
   * Called when the browser window size changes.
   * @param width The window width in pixels.
   * @param height The window height in pixels.
   */
  function resize(width: Int, height: Int) {
    final ratio = view.pixelRatio;
    if (view.isFullScreen) {
      final canvas = view.canvas;
      canvas.width = width * ratio;
      canvas.height = height * ratio;
      canvas.style.width = '${width}px';
      canvas.style.height = '${height}px';
      view.scaleToFit();

      target = new RenderTarget(new Size(view.viewWidth, view.viewHeight), view.pixelFilter ? NEAREST : LINEAR,
        view.pixelFilter ? NEAREST : LINEAR);
    }

    ResizeEvent.send(ResizeEvent.RESIZE, width * ratio, height * ratio);
    scene.resize(width * ratio, height * ratio);
  }

  /**
   * Game loop when running in headless mode.
   */
  function headlessLoop() {
    final now = Timer.stamp();
    final passed = now - prevTime;
    update(passed);
    prevTime = now;

    Timer.delay(headlessLoop, Std.int(1.0 / 60.0 * 1000));
  }

  /**
   * Game loop when running in browser mode.
   * @param time not used.
   */
  function loop(time: Float) {
    Browser.window.requestAnimationFrame(loop);

    final now = Timer.stamp();
    final passed = now - prevTime;
    if (view.targetFps != -1) {
      final interval = 1.0 / view.targetFps;
      if (passed < interval) {
        return;
      }
      final excess = passed % interval;
      update((passed - excess));
      prevTime = now - excess;
    } else {
      update(passed);
      prevTime = now;
    }
  }

  /**
   * The update loop. Updates time and the active scene.
   * @param dt The time passed since the last update in seconds.
   */
  function update(dt: Float) {
    if (inFocus || !pauseUnfocused) {
      if (dt > MAX_DT) {
        dt = MAX_DT;
      }

      time.update(dt);
      scene.update(time.dt);

      #if !headless
      render();
      #end
    }
  }

  /**
   * The render loop.
   */
  function render() {
    graphics.transform.identity();
    graphics.pushTarget(target);

    scene.render(graphics);

    graphics.popTarget();

    // TOdO: Draw fps and memory here.

    graphics.transform.identity();
    graphics.color.copyFrom(Color.WHITE);

    // Scale to make the render target fit the screen.
    Mat4.fromScale(view.viewScaleX, view.viewScaleY, 1, graphics.transform);

    // Render the main render target to the screen.
    graphics.start();
    tempPos.set(0, 0);
    graphics.drawRenderTarget(tempPos, target);
    graphics.present();
  }

  /**
   * Callback for the scene change event.
   * @param event The scene event.
   */
  function onSceneChange(event: SceneEvent) {
    changeScene(event.sceneType);
    event.canceled = true;
  }

  /**
   * Change the current scene.
   * @param sceneType The new scene to start.
   */
  function changeScene(sceneType: Class<Scene>) {
    if (scene != null) {
      scene.destroy();
    }

    scene = Type.createInstance(sceneType, []);
    scene.init();
  }
}
