package jume.events;

/**
 * Event triggered when the browser window resizes.
 */
class ResizeEvent extends Event {
  /**
   * Resize event type.
   */
  public static final RESIZE: EventType<ResizeEvent> = 'jume_resize_event';

  /**
   * The new window width in pixels.
   */
  var width: Int;

  /**
   * The new window height in pixels.
   */
  var height: Int;
}
