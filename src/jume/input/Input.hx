package jume.input;

import js.Browser;
import js.html.CanvasElement;
import js.html.WheelEvent;

import jume.audio.Audio;
import jume.di.Injectable;
import jume.di.Service;
import jume.events.Events;
import jume.events.input.ActionEvent;
import jume.events.input.GamepadEvent;
import jume.events.input.KeyboardEvent;
import jume.events.input.MouseEvent;
import jume.events.input.TouchEvent;

class Input implements Service implements Injectable {
  @:inject
  var audio: Audio;

  @:inject
  var events: Events;

  final gamepadStates = new Map<Int, GamepadState>();

  final bindings = new Map<String, InputActionBinding>();

  var canvas: CanvasElement;

  var isFirstAction: Bool;

  public function new(canvasId: String) {
    isFirstAction = true;

    #if !headless
    canvas = cast Browser.document.getElementById(canvasId);
    addListeners();
    #end
  }

  public function update() {
    #if headless
    return;
    #end

    final gamepads = Browser.navigator.getGamepads();
    for (gamepad in gamepads) {
      if (gamepad == null) {
        continue;
      }

      final state = gamepadStates[gamepad.index];
      if (state == null) {
        continue;
      }

      for (i in 0...gamepad.axes.length) {
        final axis = gamepad.axes[i];
        if (state.axes.exists(i)) {
          if (state.axes[i] != axis) {
            state.axes[i] = axis;

            final ev = ActionEvent.get(ActionEvent.ACTION, '', null, null, gamepad.index, i, null, null, axis, -1,
              -1, -1, -1, 0);
            emitEvent(GAMEPAD_AXIS, ev);
            GamepadEvent.send(GamepadEvent.GAMEPAD_AXIS, gamepad.index, i, -1, axis);
          }
        } else {
          state.axes[i] = axis;

          final ev = ActionEvent.get(ActionEvent.ACTION, '', null, null, gamepad.index, i, null, null, axis, -1, -1,
            -1, -1, 0);
          emitEvent(GAMEPAD_AXIS, ev);
          GamepadEvent.send(GamepadEvent.GAMEPAD_AXIS, gamepad.index, i, -1, axis);
        }
      }

      for (i in 0...gamepad.buttons.length) {
        final button = gamepad.buttons[i];
        if (state.buttons.exists(i)) {
          if (state.buttons[i] != button.value) {
            state.buttons[i] = button.value;

            final ev = ActionEvent.get(ActionEvent.ACTION, '', null, null, gamepad.index, i, null, null,
              button.value, -1, -1, -1, -1, 0);
            emitEvent(GAMEPAD_BUTTON, ev);
            GamepadEvent.send(GamepadEvent.GAMEPAD_BUTTON, gamepad.index, null, i, button.value);
          }
        }
      }
    }
  }

  public function destroy() {
    #if !headless
    removeListeners();
    #end
  }

  function emitEvent(actionType: InputActionType, event: ActionEvent) {
    if (isFirstAction && event.pressed) {
      isFirstAction = false;
      audio.context.resume().catchError((err) -> {
        trace('Unable to resume the audio.');
        trace(err);
      });
    }

    for (name in bindings.keys()) {
      final binding = bindings[name];

      switch (actionType) {
        case KEYBOARD_KEY:
          if (event.keyCode != UNKNOWN) {
            if (binding.keyboard.keys.contains(event.keyCode)) {
              event.updateName(name);
              events.sendEvent(event);
            }
          }

        case MOUSE_BUTTON:
          if (event.id != -1) {
            if (binding.mouse.mouseButtons.contains(event.id)) {
              event.updateName(name);
              events.sendEvent(event);
            }
          }

        case MOUSE_MOVE:
          if (binding.mouse.mouseMove) {
            event.updateName(name);
            events.sendEvent(event);
          }

        case MOUSE_WHEEL:
          if (binding.mouse.mouseWheel) {
            event.updateName(name);
            events.sendEvent(event);
          }

        case MOUSE_ENTER:
          if (binding.mouse.mouseEnter) {
            event.updateName(name);
            events.sendEvent(event);
          }

        case MOUSE_LEAVE:
          if (binding.mouse.mouseLeave) {
            event.updateName(name);
            events.sendEvent(event);
          }

        case TOUCH:
          if (binding.touch.touch) {
            event.updateName(name);
            events.sendEvent(event);
          }

        case TOUCH_MOVE:
          if (binding.touch.touchMove) {
            event.updateName(name);
            events.sendEvent(event);
          }

        case GAMEPAD_CONNECTED:
          if (binding.gamepad.connected) {
            event.updateName(name);
            events.sendEvent(event);
          }

        case GAMEPAD_DISCONNECTED:
          if (binding.gamepad.disconnected) {
            event.updateName(name);
            events.sendEvent(event);
          }

        case GAMEPAD_AXIS:
          if (event.id != -1) {
            if (binding.gamepad.gamepadAxes.contains(event.id)) {
              event.updateName(name);
              events.sendEvent(event);
            }
          }

        case GAMEPAD_BUTTON:
          if (event.id != -1) {
            if (binding.gamepad.gamepadButtons.contains(event.id)) {
              event.updateName(name);
              events.sendEvent(event);
            }
          }

        default:
      }
    }

    event.put();
  }

  function addListeners() {
    canvas.addEventListener('keydown', onKeyDown);
    canvas.addEventListener('keyup', onKeyUp);

    canvas.addEventListener('mousedown', onMouseDown);
    canvas.addEventListener('mouseup', onMouseUp);
    canvas.addEventListener('mousemove', onMouseMove);
    canvas.addEventListener('wheel', onMouseWheel);
    canvas.addEventListener('mouseenter', onMouseEnter);
    canvas.addEventListener('mouseleave', onMouseLeave);
    canvas.addEventListener('contextmenu', onMouseContext);

    canvas.addEventListener('touchstart', onTouchDown);
    canvas.addEventListener('touchend', onTouchUp);
    canvas.addEventListener('touchmove', onTouchMove);
    canvas.addEventListener('touchcancel', onTouchCanceled);

    Browser.window.addEventListener('gamepadconnected', onGamepadConnected);
    Browser.window.addEventListener('gamepaddisconnected', onGamepadDisconnected);
  }

  function removeListeners() {
    canvas.removeEventListener('keydown', onKeyDown);
    canvas.removeEventListener('keyup', onKeyUp);

    canvas.removeEventListener('mousedown', onMouseDown);
    canvas.removeEventListener('mouseup', onMouseUp);
    canvas.removeEventListener('mousemove', onMouseMove);
    canvas.removeEventListener('wheel', onMouseWheel);
    canvas.removeEventListener('mouseenter', onMouseEnter);
    canvas.removeEventListener('mouseleave', onMouseLeave);
    canvas.removeEventListener('contextmenu', onMouseContext);

    canvas.removeEventListener('touchstart', onTouchDown);
    canvas.removeEventListener('touchend', onTouchUp);
    canvas.removeEventListener('touchmove', onTouchMove);
    canvas.removeEventListener('touchcancel', onTouchCanceled);

    Browser.window.removeEventListener('gamepadconnected', onGamepadConnected);
    Browser.window.removeEventListener('gamepaddisconnected', onGamepadDisconnected);
  }

  function onKeyDown(event: js.html.KeyboardEvent) {
    event.preventDefault();
    event.stopPropagation();

    final keyCode = getKeyCodeFromString(event.code);
    final ev = ActionEvent.get(ActionEvent.ACTION, '', keyCode, event.code, -1, -1, true, false, -1, -1, -1, -1, -1,
      0);
    emitEvent(KEYBOARD_KEY, ev);
    KeyboardEvent.send(KeyboardEvent.KEY_DOWN, keyCode, event.code);
  }

  function onKeyUp(event: js.html.KeyboardEvent) {
    event.preventDefault();
    event.stopPropagation();

    final keyCode = getKeyCodeFromString(event.code);
    final ev = ActionEvent.get(ActionEvent.ACTION, '', keyCode, event.code, -1, -1, false, true, -1, -1, -1, -1, -1,
      0);
    emitEvent(KEYBOARD_KEY, ev);
    KeyboardEvent.send(KeyboardEvent.KEY_UP, keyCode, event.code);
  }

  function onMouseDown(event: js.html.MouseEvent) {
    final rect = canvas.getBoundingClientRect();
    final ev = ActionEvent.get(ActionEvent.ACTION, '', null, null, event.button, -1, true, false, -1,
      event.x - rect.left, event.y - rect.top, -1, -1, 0);
    emitEvent(MOUSE_BUTTON, ev);
    MouseEvent.send(MouseEvent.MOUSE_DOWN, event.button, event.x - rect.left, event.y - rect.top, -1, -1);
  }

  function onMouseUp(event: js.html.MouseEvent) {
    final rect = canvas.getBoundingClientRect();
    final ev = ActionEvent.get(ActionEvent.ACTION, '', null, null, event.button, -1, false, true, -1,
      event.x - rect.left, event.y - rect.top, -1, -1, 0);
    emitEvent(MOUSE_BUTTON, ev);
    MouseEvent.send(MouseEvent.MOUSE_UP, event.button, event.x - rect.left, event.y - rect.top, -1, -1);
  }

  function onMouseMove(event: js.html.MouseEvent) {
    final rect = canvas.getBoundingClientRect();
    final ev = ActionEvent.get(ActionEvent.ACTION, '', null, null, -1, -1, false, false, -1, event.x - rect.left,
      event.y - rect.top, event.movementX, event.movementY, 0);
    emitEvent(MOUSE_MOVE, ev);
    MouseEvent.send(MouseEvent.MOUSE_MOVE, -1, event.x - rect.left, event.y - rect.top, event.movementX,
      event.movementY);
  }

  function onMouseWheel(event: WheelEvent) {
    final ev = ActionEvent.get(ActionEvent.ACTION, '', null, null, -1, -1, false, false, -1, -1, -1, event.deltaX,
      event.deltaY, 0);
    emitEvent(MOUSE_WHEEL, ev);
    MouseEvent.send(MouseEvent.MOUSE_WHEEL, -1, -1, -1, event.deltaX, event.deltaY);
  }

  function onMouseEnter() {
    final ev = ActionEvent.get(ActionEvent.ACTION, '', null, null, -1, -1, false, false, -1, -1, -1, -1, -1, 0);
    emitEvent(MOUSE_ENTER, ev);
    MouseEvent.send(MouseEvent.MOUSE_ENTER, -1, -1, -1, -1, -1);
  }

  function onMouseLeave() {
    final ev = ActionEvent.get(ActionEvent.ACTION, '', null, null, -1, -1, false, false, -1, -1, -1, -1, -1, 0);
    emitEvent(MOUSE_LEAVE, ev);
    MouseEvent.send(MouseEvent.MOUSE_LEAVE, -1, -1, -1, -1, -1);
  }

  function onMouseContext(event: js.html.MouseEvent) {
    event.preventDefault();
    event.stopPropagation();
  }

  function onTouchDown(event: js.html.TouchEvent) {
    event.preventDefault();
    event.stopPropagation();

    var evX = -1;
    var evY = -1;
    for (i in 0...event.changedTouches.length) {
      final touch = event.changedTouches.item(i);
      if (touch != null) {
        if (evX == -1) {
          evX = touch.clientX;
          evY = touch.clientY;
        }

        final ev = ActionEvent.get(ActionEvent.ACTION, '', null, null, -1, touch.identifier, true, false, -1,
          touch.clientX, touch.clientY, -1, -1, event.touches.length);
        emitEvent(TOUCH, ev);
        TouchEvent.send(TouchEvent.TOUCH_START, touch.identifier, touch.clientX, touch.clientY, event.touches.length);
      }
    }

    final ev = ActionEvent.get(ActionEvent.ACTION, '', null, null, 0, -1, true, false, -1, evX, evY, -1, -1, 0);
    emitEvent(MOUSE_BUTTON, ev);
    MouseEvent.send(MouseEvent.MOUSE_DOWN, 0, evX, evY, -1, -1);
  }

  function onTouchUp(event: js.html.TouchEvent) {
    event.preventDefault();
    event.stopPropagation();

    var evX = -1;
    var evY = -1;
    for (i in 0...event.changedTouches.length) {
      final touch = event.changedTouches.item(i);
      if (touch != null) {
        if (evX == -1) {
          evX = touch.clientX;
          evY = touch.clientY;
        }

        final ev = ActionEvent.get(ActionEvent.ACTION, '', null, null, -1, touch.identifier, false, true, -1,
          touch.clientX, touch.clientY, -1, -1, event.touches.length);
        emitEvent(TOUCH, ev);
        TouchEvent.send(TouchEvent.TOUCH_END, touch.identifier, touch.clientX, touch.clientY, event.touches.length);
      }
    }

    final ev = ActionEvent.get(ActionEvent.ACTION, '', null, null, 0, -1, false, true, -1, evX, evY, -1, -1, 0);
    emitEvent(MOUSE_BUTTON, ev);
    MouseEvent.send(MouseEvent.MOUSE_UP, 0, evX, evY, -1, -1);
  }

  function onTouchMove(event: js.html.TouchEvent) {
    event.preventDefault();
    event.stopPropagation();

    var evX = -1;
    var evY = -1;
    for (i in 0...event.changedTouches.length) {
      final touch = event.changedTouches.item(i);
      if (touch != null) {
        if (evX == -1) {
          evX = touch.clientX;
          evY = touch.clientY;
        }

        final ev = ActionEvent.get(ActionEvent.ACTION, '', null, null, -1, touch.identifier, false, false, -1,
          touch.clientX, touch.clientY, -1, -1, event.touches.length);
        emitEvent(TOUCH_MOVE, ev);
        TouchEvent.send(TouchEvent.TOUCH_MOVE, touch.identifier, touch.clientX, touch.clientY, event.touches.length);
      }
    }

    final ev = ActionEvent.get(ActionEvent.ACTION, '', null, null, 0, -1, false, false, -1, evX, evY, -1, -1, 0);
    emitEvent(MOUSE_MOVE, ev);
    MouseEvent.send(MouseEvent.MOUSE_MOVE, null, evX, evY, -1, -1);
  }

  function onTouchCanceled(event: js.html.TouchEvent) {
    event.preventDefault();
    event.stopPropagation();

    var evX = -1;
    var evY = -1;
    for (i in 0...event.changedTouches.length) {
      final touch = event.changedTouches.item(i);
      if (touch != null) {
        if (evX == -1) {
          evX = touch.clientX;
          evY = touch.clientY;
        }

        final ev = ActionEvent.get(ActionEvent.ACTION, '', null, null, -1, touch.identifier, false, true, -1,
          touch.clientX, touch.clientY, -1, -1, event.touches.length);
        emitEvent(TOUCH, ev);
        TouchEvent.send(TouchEvent.TOUCH_END, touch.identifier, touch.clientX, touch.clientY, event.touches.length);
      }
    }

    final ev = ActionEvent.get(ActionEvent.ACTION, '', null, null, 0, -1, false, true, -1, evX, evY, -1, -1, 0);
    emitEvent(MOUSE_BUTTON, ev);
    MouseEvent.send(MouseEvent.MOUSE_UP, 0, evX, evY, -1, -1);
  }

  function onGamepadConnected(event: js.html.GamepadEvent) {
    gamepadStates[event.gamepad.index] = {
      buttons: new Map<Int, Float>(),
      axes: new Map<Int, Float>()
    };

    final ev = ActionEvent.get(ActionEvent.ACTION, '', null, null, -1, event.gamepad.index, false, false, -1, -1,
      -1, -1, -1, 0);
    emitEvent(GAMEPAD_CONNECTED, ev);
    GamepadEvent.send(GamepadEvent.GAMEPAD_CONNECTED, event.gamepad.index, -1, -1, -1);
  }

  function onGamepadDisconnected(event: js.html.GamepadEvent) {
    gamepadStates[event.gamepad.index] = null;

    final ev = ActionEvent.get(ActionEvent.ACTION, '', null, null, -1, event.gamepad.index, false, false, -1, -1,
      -1, -1, -1, 0);
    emitEvent(GAMEPAD_DISCONNECTED, ev);
    GamepadEvent.send(GamepadEvent.GAMEPAD_DISCONNECTED, event.gamepad.index, -1, -1, -1);
  }

  function getKeyCodeFromString(code: String): KeyCode {
    switch (code) {
      case 'Backspace':
        return BACKSPACE;

      case 'Tab':
        return TAB;

      case 'Enter':
        return ENTER;

      case 'NumpadEnter':
        return NUM_ENTER;

      case 'ShiftLeft':
        return SHIFT_LEFT;

      case 'ShiftRight':
        return SHIFT_RIGHT;

      case 'ControlLeft':
        return CONTROL_LEFT;

      case 'ControlRight':
        return CONTROL_RIGHT;

      case 'AltLeft':
        return ALT_LEFT;

      case 'AltRight':
        return ALT_RIGHT;

      case 'Pause':
        return PAUSE;

      case 'CapsLock':
        return CAPS_LOCK;

      case 'Escape':
        return ESCAPE;

      case 'Space':
        return SPACE;

      case 'PageUp':
        return PAGE_UP;

      case 'PageDown':
        return PAGE_DOWN;

      case 'End':
        return END;

      case 'Home':
        return HOME;

      case 'ArrowLeft':
        return ARROW_LEFT;

      case 'ArrowUp':
        return ARROW_UP;

      case 'ArrowRight':
        return ARROW_RIGHT;

      case 'ArrowDown':
        return ARROW_DOWN;

      case 'PrintScreen':
        return PRINT_SCREEN;

      case 'Insert':
        return INSERT;

      case 'Delete':
        return DELETE;

      case 'Digit0':
        return ZERO;

      case 'Digit1':
        return ONE;

      case 'Digit2':
        return TWO;

      case 'Digit3':
        return THREE;

      case 'Digit4':
        return FOUR;

      case 'Digit5':
        return FIVE;

      case 'Digit6':
        return SIX;

      case 'Digit7':
        return SEVEN;

      case 'Digit8':
        return EIGHT;

      case 'Digit9':
        return NINE;

      case 'KeyA':
        return A;

      case 'KeyB':
        return B;

      case 'KeyC':
        return C;

      case 'KeyD':
        return D;

      case 'KeyE':
        return E;

      case 'KeyF':
        return F;

      case 'KeyG':
        return G;

      case 'KeyH':
        return H;

      case 'KeyI':
        return I;

      case 'KeyJ':
        return J;

      case 'KeyK':
        return K;

      case 'KeyL':
        return L;

      case 'KeyM':
        return M;

      case 'KeyN':
        return N;

      case 'KeyO':
        return O;

      case 'KeyP':
        return P;

      case 'KeyQ':
        return Q;

      case 'KeyR':
        return R;

      case 'KeyS':
        return S;

      case 'KeyT':
        return T;

      case 'KeyU':
        return U;

      case 'KeyV':
        return V;

      case 'KeyW':
        return W;

      case 'KeyX':
        return X;

      case 'KeyY':
        return Y;

      case 'KeyZ':
        return Z;

      case 'MetaLeft':
        return OS_LEFT;

      case 'OSLeft':
        return OS_LEFT;

      case 'MetaRight':
        return OS_RIGHT;

      case 'OSRight':
        return OS_RIGHT;

      case 'Numpad0':
        return NUM_0;

      case 'Numpad1':
        return NUM_1;

      case 'Numpad2':
        return NUM_2;

      case 'Numpad3':
        return NUM_3;

      case 'Numpad4':
        return NUM_4;

      case 'Numpad5':
        return NUM_5;

      case 'Numpad6':
        return NUM_6;

      case 'Numpad7':
        return NUM_7;

      case 'Numpad8':
        return NUM_8;

      case 'Numpad9':
        return NUM_9;

      case 'NumpadMultiply':
        return NUM_MULTIPLY;

      case 'NumpadAdd':
        return NUM_ADD;

      case 'NumpadSubtract':
        return NUM_SUBTRACT;

      case 'NumpadDecimal':
        return NUM_DECIMAL;

      case 'NumpadDivide':
        return NUM_DIVIDE;

      case 'F1':
        return F1;

      case 'F2':
        return F2;

      case 'F3':
        return F3;

      case 'F4':
        return F4;

      case 'F5':
        return F5;

      case 'F6':
        return F6;

      case 'F7':
        return F7;

      case 'F8':
        return F8;

      case 'F9':
        return F9;

      case 'F10':
        return F10;

      case 'F11':
        return F11;

      case 'F12':
        return F12;

      case 'F13':
        return F13;

      case 'F14':
        return F14;

      case 'F15':
        return F15;

      case 'F16':
        return F16;

      case 'F17':
        return F17;

      case 'F18':
        return F18;

      case 'F19':
        return F19;

      case 'F20':
        return F20;

      case 'F21':
        return F21;

      case 'F22':
        return F22;

      case 'F23':
        return F23;

      case 'F24':
        return F24;

      case 'NumLock':
        return NUM_LOCK;

      case 'ScrollLock':
        return SCROLL_LOCK;

      case 'Equal':
        return EQUAL;

      case 'Comma':
        return COMMA;

      case 'Minus':
        return MINUS;

      case 'Period':
        return PERIOD;

      case 'Slash':
        return SLASH;

      case 'Semicolon':
        return SEMICOLON;

      case 'Backquote':
        return BACKQUOTE;

      case 'BracketLeft':
        return BRACKET_LEFT;

      case 'Backslash':
        return BACKSLASH;

      case 'BracketRight':
        return BRACKET_RIGHT;

      case 'Quote':
        return QUOTE;

      case 'IntlBackslash':
        return INTL_BACKSLASH;

      default:
        trace('Unknown key code: ${code}');
        return UNKNOWN;
    }
  }
}

private typedef GamepadState = {
  var axes: Map<Int, Float>;
  var buttons: Map<Int, Float>;
}
