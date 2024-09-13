package jume.tweens;

import jume.graphics.Color;

class TweenProperty {
  /**
   * The start value.
   */
  public var start: Dynamic;

  /**
   * The end value.
   */
  public var end: Dynamic;

  /**
   * The amount of change between start and end (end - start).
   */
  public var change: Dynamic;

  /**
   * The property field that is tweened.
   */
  public var propertyName: String;

  /**
   * TweenData constructor.
   * @param start The start value.
   * @param end The end value.
   * @param propertyName The name of the field that is tweened.
   */
  public function new(start: Dynamic, end: Dynamic, propertyName: String) {
    this.start = start;
    this.end = end;
    this.propertyName = propertyName;

    if (!Std.isOfType(start, Color)) {
      change = end - start;
    }
  }
}
