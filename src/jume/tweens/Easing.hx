package jume.tweens;

/**
 * Ease function type with five float parameters and a float return type.
 */
typedef Ease = (time: Float, begin: Float, change: Float, duration: Float)->Float;

/**
 * Two times PI. 
 */
private final PI_M2 = Math.PI * 2;

/**
 * Half PI.
 */
private final PI_D2 = Math.PI / 2;

/**
 * Constant value used in back easing functions.
 */
private inline final easeBackConst = 1.70158;

/**
 * Linear easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
inline function easeLinear(time: Float, begin: Float, change: Float, duration: Float): Float {
  return change * time / duration + begin;
}

/**
 * Sine in easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
inline function easeInSine(time: Float, begin: Float, change: Float, duration: Float): Float {
  return -change * Math.cos(time / duration * PI_D2) + change + begin;
}

/**
 * Sine out easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
inline function easeOutSine(time: Float, begin: Float, change: Float, duration: Float): Float {
  return change * Math.sin(time / duration * PI_D2) + begin;
}

/**
 * Sine in out easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
inline function easeInOutSine(time: Float, begin: Float, change: Float, duration: Float): Float {
  return -change / 2 * (Math.cos(Math.PI * time / duration) - 1) + begin;
}

/**
 * Quint in easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
inline function easeInQuint(time: Float, begin: Float, change: Float, duration: Float): Float {
  return change * (time /= duration) * time * time * time * time + begin;
}

/**
 * Quint out easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
inline function easeOutQuint(time: Float, begin: Float, change: Float, duration: Float): Float {
  return change * ((time = time / duration - 1) * time * time * time * time + 1) + begin;
}

/**
 * Quint in out easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
inline function easeInOutQuint(time: Float, begin: Float, change: Float, duration: Float): Float {
  if ((time /= duration / 2) < 1) {
    return change / 2 * time * time * time * time * time + begin;
  }

  return change / 2 * ((time -= 2) * time * time * time * time + 2) + begin;
}

/**
 * Quart in easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
inline function easeInQuart(time: Float, begin: Float, change: Float, duration: Float): Float {
  return change * (time /= duration) * time * time * time + begin;
}

/**
 * Quart out easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
inline function easeOutQuart(time: Float, begin: Float, change: Float, duration: Float): Float {
  return -change * ((time = time / duration - 1) * time * time * time - 1) + begin;
}

/**
 * Quart in out easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
inline function easeInOutQuart(time: Float, begin: Float, change: Float, duration: Float): Float {
  if ((time /= duration / 2) < 1) {
    return change / 2 * time * time * time * time + begin;
  }

  return -change / 2 * ((time -= 2) * time * time * time - 2) + begin;
}

/**
 * Quad in easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
inline function easeInQuad(time: Float, begin: Float, change: Float, duration: Float): Float {
  return change * (time /= duration) * time + begin;
}

/**
 * Quad out easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
inline function easeOutQuad(time: Float, begin: Float, change: Float, duration: Float): Float {
  return -change * (time /= duration) * (time - 2) + begin;
}

/**
 * Quad in out easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
inline function easeInOutQuad(time: Float, begin: Float, change: Float, duration: Float): Float {
  if ((time /= duration / 2) < 1) {
    return change / 2 * time * time + begin;
  }

  return -change / 2 * ((--time) * (time - 2) - 1) + begin;
}

/**
 * Expo in easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
inline function easeInExpo(time: Float, begin: Float, change: Float, duration: Float): Float {
  return (time == 0) ? begin : change * Math.pow(2, 10 * (time / duration - 1)) + begin;
}

/**
 * Expo out easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
inline function easeOutExpo(time: Float, begin: Float, change: Float, duration: Float): Float {
  return (time == duration) ? begin + change : change * (-Math.pow(2, -10 * time / duration) + 1) + begin;
}

/**
 * Expo in out easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
function easeInOutExpo(time: Float, begin: Float, change: Float, duration: Float): Float {
  if (time == 0) {
    return begin;
  }
  if (time == duration) {
    return begin + change;
  }
  if ((time /= duration / 2) < 1) {
    return change / 2 * Math.pow(2, 10 * (time - 1)) + begin;
  }

  return change / 2 * (-Math.pow(2, -10 * --time) + 2) + begin;
}

/**
 * Elastic in easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
function easeInElastic(time: Float, begin: Float, change: Float, duration: Float): Float {
  final p = duration * 0.3;
  final a = change;
  final s = p / 4.0;

  if (time == 0) {
    return begin;
  }
  if ((time /= duration) == 1) {
    return begin + change;
  }

  return -(a * Math.pow(2, 10 * (time -= 1)) * Math.sin((time * duration - s) * PI_M2 / p)) + begin;
}

/**
 * Elastic out easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
function easeOutElastic(time: Float, begin: Float, change: Float, duration: Float): Float {
  final p = duration * 0.3;
  final a = change;
  final s = p / 4.0;

  if (time == 0) {
    return begin;
  }
  if ((time /= duration) == 1) {
    return begin + change;
  }

  return (a * Math.pow(2, -10 * time) * Math.sin((time * duration - s) * PI_M2 / p) + change + begin);
}

/**
 * Elastic in out easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
function easeInOutElastic(time: Float, begin: Float, change: Float, duration: Float): Float {
  final p = duration * (0.3 * 1.5);
  final a = change;
  final s = p / 4.0;

  if (time == 0) {
    return begin;
  }
  if ((time /= duration / 2) == 2) {
    return begin + change;
  }

  if (time < 1) {
    return -0.5 * (a * Math.pow(2, 10 * (time -= 1)) * Math.sin((time * duration - s) * PI_M2 / p)) + begin;
  }

  return a * Math.pow(2, -10 * (time -= 1)) * Math.sin((time * duration - s) * PI_M2 / p) * 0.5 + change + begin;
}

/**
 * Circular in easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
inline function easeInCircular(time: Float, begin: Float, change: Float, duration: Float): Float {
  return -change * (Math.sqrt(1 - (time /= duration) * time) - 1) + begin;
}

/**
 * Circular out easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
inline function easeOutCircular(time: Float, begin: Float, change: Float, duration: Float): Float {
  return change * Math.sqrt(1 - (time = time / duration - 1) * time) + begin;
}

/**
 * Circular in out easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
inline function easeInOutCircular(time: Float, begin: Float, change: Float, duration: Float): Float {
  if ((time /= duration / 2) < 1) {
    return -change / 2 * (Math.sqrt(1 - time * time) - 1) + begin;
  }

  return change / 2 * (Math.sqrt(1 - (time -= 2) * time) + 1) + begin;
}

/**
 * Back in easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
inline function easeInBack(time: Float, begin: Float, change: Float, duration: Float): Float {
  return change * (time /= duration) * time * ((easeBackConst + 1) * time - easeBackConst) + begin;
}

/**
 * Back out easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
inline function easeOutBack(time: Float, begin: Float, change: Float, duration: Float): Float {
  return change * ((time = time / duration - 1) * time * ((easeBackConst + 1) * time + easeBackConst) + 1) + begin;
}

/**
 * Back in out easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
function easeInOutBack(time: Float, begin: Float, change: Float, duration: Float): Float {
  var s = 1.70158;

  if ((time /= duration / 2) < 1) {
    return change / 2 * (time * time * (((s *= (1.525)) + 1) * time - s)) + begin;
  }

  return change / 2 * ((time -= 2) * time * (((s *= (1.525)) + 1) * time + s) + 2) + begin;
}

/**
 * Bounce in easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
inline function easeInBounce(time: Float, begin: Float, change: Float, duration: Float): Float {
  return change - easeOutBounce(duration - time, 0, change, duration) + begin;
}

/**
 * Bounce out easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
function easeOutBounce(time: Float, begin: Float, change: Float, duration: Float): Float {
  if ((time /= duration) < (1 / 2.75)) {
    return change * (7.5625 * time * time) + begin;
  } else if (time < (2 / 2.75)) {
    return change * (7.5625 * (time -= (1.5 / 2.75)) * time + 0.75) + begin;
  } else if (time < (2.5 / 2.75)) {
    return change * (7.5625 * (time -= (2.25 / 2.75)) * time + 0.9375) + begin;
  } else {
    return change * (7.5625 * (time -= (2.625 / 2.75)) * time + 0.984375) + begin;
  }
}

/**
 * Bounce in out easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
function easeInOutBounce(time: Float, begin: Float, change: Float, duration: Float): Float {
  if (time < duration / 2) {
    return easeInBounce(time * 2, 0, change, duration) * 0.5 + begin;
  } else {
    return easeOutBounce(time * 2 - duration, 0, change, duration) * 0.5 + change * 0.5 + begin;
  }
}

/**
 * Cubic in easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
inline function easeInCubic(time: Float, begin: Float, change: Float, duration: Float): Float {
  return change * (time /= duration) * time * time + begin;
}

/**
 * Cubic out easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
inline function easeOutCubic(time: Float, begin: Float, change: Float, duration: Float): Float {
  return change * ((time = time / duration - 1) * time * time + 1) + begin;
}

/**
 * Cubic in out easing.
 * @param time The time since the tween started in seconds.
 * @param begin The start value of the property.
 * @param change The amount of change from start to end.
 * @param duration The total duration of the tween in seconds.
 * @return The updated property value.
 */
inline function easeInOutCubic(time: Float, begin: Float, change: Float, duration: Float): Float {
  if ((time /= duration / 2) < 1) {
    return change / 2 * time * time * time + begin;
  }

  return change / 2 * ((time -= 2) * time * time + 2) + begin;
}
