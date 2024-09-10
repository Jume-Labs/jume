package jume;

import haxe.Timer;

import jume.events.FocusEvent;
import jume.di.Services;

import haxe.Exception;

import js.html.CanvasElement;
import js.Browser;

import jume.utils.BrowserInfo.isMobile;
import jume.events.Events;
import jume.JumeOptions.setDefaultJumeOptions;

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

    #if !headless
    canvas.focus();
    canvas.addEventListener('blur', () -> lostFocus());
    canvas.addEventListener('focus', () -> hasFocus());
    Browser.window.addEventListener('resize', ()->resize(Browser.window.innerWidth, Browser.window.innerHeight));
    #end
  }

  public function launch() {
    #if headless
    prevTime = Timer.stamp();
    Timer.delay(headlessLoop, Std.int(1.0 / 60.0 * 1000));
    #else
    Browser.window.requestAnimationFrame((time) -> {
      prevTime = Timer.stamp();
      loop(0.016);
    });
    #end
  }

  public function hasFocus() {
    inFocus = true;
    FocusEvent.send(FocusEvent.HAS_FOCUS);
  }

  public function lostFocus() {
    inFocus = false;
    FocusEvent.send(FocusEvent.LOST_FOCUS);
  }

  function resize(width: Int, height: Int) {}

  function headlessLoop() {
    final now = Timer.stamp();
    final passed = now - prevTime;
    update(passed);
    prevTime = now;

    Timer.delay(headlessLoop, Std.int(1.0 / 60.0 * 1000));
  }

  function loop(time: Float) {
    Browser.window.requestAnimationFrame(loop);

    final now = Timer.stamp();
    final passed = now - prevTime;
  }

  function update(dt: Float) {
    if (inFocus || !pauseUnfocused) {
      if (dt > MAX_DT) {
        dt = MAX_DT;
      }

      #if !headless
      render();
      #end
    }
  }

  function render() {}
}
