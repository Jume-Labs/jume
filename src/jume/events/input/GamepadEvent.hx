package jume.events.input;

/**
 * GamepadEvent for sending gamepad input events.
 */
class GamepadEvent extends Event {
  /**
   * Gamepad connected event type.
   */
  public static inline final GAMEPAD_CONNECTED: EventType<GamepadEvent> = 'jume_gamepad_connected';

  /**
   * Gamepad disconnected event type.
   */
  public static inline final GAMEPAD_DISCONNECTED: EventType<GamepadEvent> = 'jume_gamepad_disconnected';

  /**
   * Gamepad axis event type.
   */
  public static inline final GAMEPAD_AXIS: EventType<GamepadEvent> = 'jume_gamepad_axis';

  /**
   * Gamepad button event type.
   */
  public static inline final GAMEPAD_BUTTON: EventType<GamepadEvent> = 'jume_gamepad_button';

  /**
   * The controller id.
   */
  var id: Int;

  /**
   * The axis was interacted with. Only available with the gamepad axis event.
   */
  var axis: Int;

  /**
   * The button that was interacted with. Only available with the gamepad button event.
   */
  var button: Int;

  /**
   * The value of the axis or button. Only available with the gamepad axis or button event.
   */
  var value: Float;
}
