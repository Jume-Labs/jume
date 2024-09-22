package jume.tweens;

import haxe.Exception;

import jume.di.Injectable;
import jume.graphics.Color;
import jume.tweens.Easing.Ease;
import jume.tweens.Easing.easeLinear;
import jume.utils.TimeStep;

/**
 * Parameters when creating a new tween.
 */
typedef TweenParams = {
  /**
   * The property to tween.
   */
  var target: Dynamic;

  /**
   * The tween duration in seconds.
   */
  var duration: Float;

  /**
   * The properties start position.
   */
  var from: Dynamic;

  /**
   * The properties end position.
   */
  var to: Dynamic;

  /**
   * How many times should the tween repeat. -1 is forever.
   */
  var ?repeat: Int;

  /**
   * Optional tag to group pause / resume tweens.
   */
  var ?tag: String;

  /**
   * Should this tween ignore the time scale.
   */
  var ?ignoreTimescale: Bool;
}

/**
 * The Tween class is used to tween values over time.
 */
class Tween implements Injectable {
  /**
   * Is the tween complete.
   */
  public var complete: Bool;

  /**
   * The tween tag. You can pause / resume a group of tweens/sequences using this tag.
   */
  public var tag: String;

  /**
   * The target to tween.
   */
  public var target(default, null): Dynamic;

  /**
   * The percentage of the tween that is complete.
   */
  public var percentageComplete(get, never): Float;

  /**
   * How many times the tween will repeat. Gets subtracted by one every time the tween is completed.
   */
  public var repeat: Int;

  /**
   * How many times the tween has been completed.
   */
  public var timesCompleted: Int;

  /**
   * Should this tween ignore time scaling (speeding up or slowing down time).
   * Useful for ui animations for example.
   */
  public var ignoreTimescale: Bool;

  /**
   * True if the tween is paused.
   */
  public var paused: Bool;

  /**
   * The time since the tween started in seconds.
   */
  var time: Float;

  /**
   * How long the tween takes to complete in seconds.
   */
  var duration: Float;

  /**
   * List of properties to tween each frame.
   */
  var dataList: Array<TweenProperty>;

  /**
   * Type of easing to use.
   */
  var ease: Ease;

  /**
   * Function to call when the tween is complete.
   */
  var onComplete: () -> Void;

  /**
   * The function to call every update.
   */
  var onUpdate: (target: Dynamic) -> Void;

  /**
   * Called when a tween starts after a delay.
   */
  var onStart: () -> Void;

  /**
   * The delay before the tween starts.
   */
  var delay: Float;

  /**
   * Time passed while the tween is delayed.
   */
  var delayTime: Float;

  /**
   * Has this tween started.
   */
  var started: Bool;

  /**
   * The time step service reference.
   */
  @:inject
  final timeStep: TimeStep;

  /**
   * Used for color tweening.
   */
  final tempColor = new Color();

  /**
   * Create a new tween instance.
   * @param params The tween setup params.
   */
  public function new(params: TweenParams) {
    this.target = params.target;
    this.duration = params.duration;
    this.repeat = params.repeat ?? 0;
    this.tag = params.tag ?? '';
    this.ignoreTimescale = params.ignoreTimescale ?? false;

    repeat = 0;
    timesCompleted = 0;
    paused = false;
    time = 0;
    ease = easeLinear;
    delay = 0;
    delayTime = 0;
    started = false;

    createDataList(params.target, params.from, params.to);
  }

  /**
   * Reset this tween completely.
   */
  public function reset() {
    time = 0;
    delayTime = 0;
    timesCompleted = 0;
    paused = false;
    complete = false;
    started = false;
  }

  /**
   * Restart a tween from the beginning.
   */
  public function restart() {
    time = 0;
    complete = false;
    started = false;
  }

  /**
   * Reset just the time passed.
   */
  public function resetTime() {
    time = 0;
  }

  /**
   * Set the ease function to use.
   * @param ease The ease function.
   * @return This tween.
   */
  public inline function setEase(ease: Ease): Tween {
    this.ease = ease;

    return this;
  }

  /**
   * Add a function to be called when the tween is complete.
   * @param callback The callback function.
   * @return This tween.
   */
  public inline function setOnComplete(callback: () -> Void): Tween {
    onComplete = callback;

    return this;
  }

  /**
   * Add an on update function to call every update.
   * @param callback The callback function.
   * @return This tween.
   */
  public inline function setOnUpdate(callback: (target: Dynamic) -> Void): Tween {
    onUpdate = callback;

    return this;
  }

  /**
   * Add an on start function to call when the tween starts.
   * @param callback The callback function.
   * @return This tween
   */
  public inline function setOnStart(callback: () -> Void): Tween {
    onStart = callback;

    return this;
  }

  /**
   * Set a tween start delay.
   * @param delay Delay in seconds.
   * @return This tween.
   */
  public function setDelay(delay: Float): Tween {
    this.delay = delay;
    delayTime = 0;

    return this;
  }

  /**
   * Check if this tween has a specific target.
   * @param target The target to check.
   * @return True if the target matches.
   */
  public function hasTarget(target: Dynamic): Bool {
    return this.target == target;
  }

  /**
   * Update the tween target and tween values.
   * @param target The new target.
   * @param from The new from values.
   * @param to The new to values.
   */
  public function updateTarget(target: Dynamic, from: Dynamic, to: Dynamic) {
    this.target = target;
    createDataList(target, from, to);
  }

  /**
   * Run the complete function.
   */
  public function runComplete() {
    if (onComplete != null) {
      onComplete();
    }
    time = 0;
  }

  /**
   * Update called every frame.
   * @param dt Time passed since the last frame in seconds.
   */
  public function update(dt: Float) {
    if (complete || paused) {
      return;
    }

    if (ignoreTimescale) {
      dt = timeStep.unscaledDt;
    }

    if (delayTime < delay) {
      delayTime += dt;
    } else {
      if (!started) {
        started = true;
        if (onStart != null) {
          onStart();
        }
      }

      time += dt;
      if (time >= duration) {
        complete = true;
      }

      for (data in dataList) {
        updateProperty(data);
      }

      if (onUpdate != null) {
        onUpdate(target);
      }
    }
  }

  /**
   * Create the data properties list it iterate over every frame.
   * @param target The object to tween.
   * @param properties The properties to tween on the object.
   */
  function createDataList(target: Dynamic, from: Dynamic, to: Dynamic) {
    dataList = [];

    final fields = Type.getInstanceFields(Type.getClass(target));
    for (prop in Reflect.fields(from)) {
      // Make sure the property exists on the target.
      if (fields.indexOf(prop) != -1) {
        var startValue = Reflect.field(from, prop);
        var endValue = Reflect.field(to, prop);

        if (Std.isOfType(startValue, Color)) {
          startValue = startValue.clone();
        }

        if (Std.isOfType(endValue, Color)) {
          endValue = endValue.clone();
        }

        final data = new TweenProperty(startValue, endValue, prop);
        dataList.push(data);
      } else {
        throw new Exception('property ${prop} does not exist on the target.');
      }
    }
  }

  /**
   * Use reflection to set a target property to a new value.
   * @param data The tween info.
   */
  function updateProperty(data: TweenProperty) {
    if (Std.isOfType(data.start, Color)) {
      final factor = ease(time, 0, 1, duration);
      Color.interpolate(cast data.start, cast data.end, factor, tempColor);
      if (complete) {
        tempColor.copyFrom(cast data.end);
      }
      Reflect.setProperty(target, data.propertyName, tempColor);
    } else {
      var value = ease(time, data.start, data.change, duration);
      if (complete) {
        value = data.end;
      }
      Reflect.setProperty(target, data.propertyName, value);
    }
  }

  inline function get_percentageComplete(): Float {
    return (time / duration) * 100;
  }
}
