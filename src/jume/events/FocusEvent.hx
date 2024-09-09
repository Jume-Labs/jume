package jume.events;

/**
 * Events triggered when the canvas focus changes.
 */
class FocusEvent extends Event {
  /**
   * This event is triggered when the window gets focus.
   */
  public static final FOCUSED: EventType<FocusEvent> = 'jume_focused_event';

  /**
   * This event is triggered when the window loses focus.
   */
  public static final UNFOCUSED: EventType<FocusEvent> = 'jume_unfocused_event';
}
