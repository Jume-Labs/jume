package jume.input;

typedef InputBindings = {
  var ?keyboard: {
    keys: Array<KeyCode>
  };

  var ?mouse: {
    ?mouseButtons: Array<Int>,
    ?mouseMove: Bool,
    ?mouseWheel: Bool,
    ?mouseEnter: Bool,
    ?mouesLeave: Bool
  };

  var ?touch: {
    ?touch: Bool,
    ?touchMove: Bool
  };

  var ?gamepad: {
    ?connected: Bool,
    ?disconnected: Bool,
    ?gamepadAxes: Array<Int>,
    ?gamepadButtons: Array<Int>
  };
}

class InputActionBinding {
  public final name: String;

  public var keyboard: {
    keys: Array<KeyCode>,
  };

  public var mouse: {
    mouseButtons: Array<Int>,
    mouseMove: Bool,
    mouseWheel: Bool,
    mouseEnter: Bool,
    mouseLeave: Bool,
  };

  public var touch: {
    touch: Bool,
    touchMove: Bool
  };

  public var gamepad: {
    connected: Bool,
    disconnected: Bool,
    gamepadAxes: Array<Int>,
    gamepadButtons: Array<Int>,
  };

  public function new(name: String, bindings: InputBindings) {
    this.name = name;
    this.keyboard = {
      keys: bindings.keyboard?.keys ?? [],
    };
    this.mouse = {
      mouseButtons: bindings.mouse?.mouseButtons ?? [],
      mouseMove: bindings.mouse?.mouseMove ?? false,
      mouseWheel: bindings.mouse?.mouseWheel ?? false,
      mouseEnter: bindings.mouse?.mouseEnter ?? false,
      mouseLeave: bindings.mouse?.mouesLeave ?? false,
    };
    this.touch = {
      touch: bindings.touch?.touch ?? false,
      touchMove: bindings.touch?.touchMove ?? false,
    };
    this.gamepad = {
      connected: bindings.gamepad?.connected ?? false,
      disconnected: bindings.gamepad?.disconnected ?? false,
      gamepadAxes: bindings.gamepad?.gamepadAxes ?? [],
      gamepadButtons: bindings.gamepad?.gamepadButtons ?? [],
    };
  }
}
