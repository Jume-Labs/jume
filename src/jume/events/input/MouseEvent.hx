package jume.events.input;

/**
 * MouseEvent for sending mouse input events.
 */
class MouseEvent extends Event {
  /**
   * Mouse down event type.
   */
  public static inline final MOUSE_DOWN: EventType<MouseEvent> = 'jume_mouse_down';

  /**
   * Mouse up event type.
   */
  public static inline final MOUSE_UP: EventType<MouseEvent> = 'jume_mouse_up';

  /**
   * Mouse move event type.
   */
  public static inline final MOUSE_MOVE: EventType<MouseEvent> = 'jume_mouse_move';

  /**
   * Mouse scroll wheel event type.
   */
  public static inline final MOUSE_WHEEL: EventType<MouseEvent> = 'jume_mouse_wheel';

  /**
   * Mouse enter event type.
   */
  public static inline final MOUSE_ENTER: EventType<MouseEvent> = 'jume_mouse_enter';

  /**
   * Mouse leave event type.
   */
  public static inline final MOUSE_LEAVE: EventType<MouseEvent> = 'jume_mouse_leave';

  /**
   * The button pressed.
   */
  var button: Int;

  /**
   * The x position of the mouse in window pixels.
   */
  var x: Float;

  /**
   * The y position of the mouse in window pixels.
   */
  var y: Float;

  /**
   * The amount moved on the x axis since the last event in window pixels.
   */
  var deltaX: Float;

  /**
   * The amount moved on the y axis since the last even in window pixels.
   */
  var deltaY: Float;
}
