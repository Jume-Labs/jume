package jume.events;

/**
 * Events triggered when the canvas focus changes.
 */
class FocusEvent extends Event {
  /**
   * This event is triggered when the window gets focus.
   */
  public static final HAS_FOCUS: EventType<FocusEvent> = 'jume_has_focus_event';

  /**
   * This event is triggered when the window loses focus.
   */
  public static final LOST_FOCUS: EventType<FocusEvent> = 'jume_lost_focus_event';
}
