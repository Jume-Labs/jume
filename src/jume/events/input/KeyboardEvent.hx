package jume.events.input;

import jume.input.KeyCode;

/**
 * KeyboardEvent for sending keyboard input events.
 */
class KeyboardEvent extends Event {
  /**
   * Key up event type.
   */
  public static inline final KEY_UP: EventType<KeyboardEvent> = 'jume_key_up';

  /**
   * Key down event type.
   */
  public static inline final KEY_DOWN: EventType<KeyboardEvent> = 'jume_key_down';

  /**
   * Key press event type.
   */
  public static inline final KEY_PRESS: EventType<KeyboardEvent> = 'jume_key_press';

  /**
   * The keycode that was pressed or released.
   */
  var key: KeyCode;

  /**
   * The actual code.
   */
  var code: String;
}
