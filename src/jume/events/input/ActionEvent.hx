package jume.events.input;

import jume.input.KeyCode;

class ActionEvent extends Event {
  public static final ACTION: EventType<ActionEvent> = 'jume_input_action';

  /**
   * The binding name.
   */
  var name: String;

  /**
   * The physics key on the keyboard.
   */
  var keyCode: KeyCode;

  /**
   * The key string.
   */
  var keyTextCode: String;

  /**
   * button or gamepad index.
   */
  var index: Int;

  /**
   * The touch id or gameepad button or axis.
   */
  var id: Int;

  /**
   * Button pressed.
   */
  var pressed: Bool;

  /**
   * Button released.
   */
  var released: Bool;

  /**
   * Gamepad button or axis value.
   */
  var value: Float;

  /**
   * X mouse or touch position.
   */
  var x: Float;

  /**
   * Y mouse or touch position.
   */
  var y: Float;

  /**
   * Mouse x position change.
   */
  var deltaX: Float;

  /**
   * Mouse y position change.
   */
  var deltaY: Float;

  /**
   * Total number of touches on screen.
   */
  var touchCount: Float;

  /**
   * Update the binding name.
   * @param name The new name.
   */
  public function updateName(name: String) {
    this.name = name;
  }
}
