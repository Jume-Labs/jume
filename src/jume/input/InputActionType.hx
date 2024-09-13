package jume.input;

enum abstract InputActionType(String) from String to String {
  var KEYBOARD_KEY = 'keyboard_key';
  var MOUSE_BUTTON = 'mouse_button';
  var MOUSE_MOVE = 'mouse_move';
  var MOUSE_ENTER = 'mouse_enter';
  var MOUSE_LEAVE = 'mouse_leave';
  var MOUSE_WHEEL = 'mouse_wheel';
  var TOUCH = 'touch';
  var TOUCH_MOVE = 'touch_move';
  var GAMEPAD_CONNECTED = 'gamepad_connected';
  var GAMEPAD_DISCONNECTED = 'gamepad_disconnected';
  var GAMEPAD_AXIS = 'gamepad_axis';
  var GAMEPAD_BUTTON = 'gamepad_button';
}
