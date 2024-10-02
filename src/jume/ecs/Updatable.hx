package jume.ecs;

/**
 * Interface that components can implement if they want a function that gets called every frame.
 */
interface Updatable {
  /**
   * Called every frame.
   * @param dt The time passed since the last update in seconds.
   */
  function cUpdate(dt: Float): Void;
}
