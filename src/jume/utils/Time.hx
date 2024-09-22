package jume.utils;

import jume.di.Service;

using Lambda;

/**
 * Time service. Controls delta time and game speed.
 */
class Time implements Service {
  /**
   * This controls the game speed.
   */
  public var timeScale: Float;

  /**
   * The current delta time.
   */
  public var dt(default, null) = 0.0;

  /**
   * The total time elapsed in game since the game started in seconds.
   */
  public var totalElapsed(default, null) = 0.0;

  /**
   * The current delta time ignoring time scale.
   */
  public var unscaledDt(default, null) = 0.0;

  /**
   * The current game FPS.
   */
  public var fps(default, null) = 0.0;

  /**
   * The cached delta times to calculate the average fps.
   */
  var deltas: Array<Float>;

  /**
   * Create a new time instance.
   */
  public function new() {
    timeScale = 1.0;
    deltas = [];
  }

  /**
   * Update the delta time.
   * @param dt The time passed since the last update in seconds.
   */
  public function update(dt: Float) {
    unscaledDt = dt;
    totalElapsed += dt;
    this.dt = dt * timeScale;

    if (deltas.length > 600) {
      deltas.shift();
    }
    deltas.push(dt);

    final average = deltas.fold((delta, total) -> total += delta, 0) / deltas.length;
    fps = Math.floor(1.0 / average);
  }
}
