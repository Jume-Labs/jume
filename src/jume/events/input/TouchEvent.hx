package jume.events.input;

/**
 * TouchEvent for sending touch input events.
 */
class TouchEvent extends Event {
  /**
   * Touch start event type.
   */
  public static inline final TOUCH_START: EventType<TouchEvent> = 'lumi_touch_start';

  /**
   * Touch end event type.
   */
  public static inline final TOUCH_END: EventType<TouchEvent> = 'lumi_touch_end';

  /**
   * Touch move event type.
   */
  public static inline final TOUCH_MOVE: EventType<TouchEvent> = 'lumi_touch_move';

  /**
   * touch id used.
   */
  var id: Int;

  /**
   * The x position of the touch in screen pixels.
   */
  var x: Int;

  /**
   * The y position of the touch in screen pixels.
   */
  var y: Int;

  /**
   * The amount of touches on screen.
   */
  var touchCount: Int;
}