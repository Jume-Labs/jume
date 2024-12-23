package jume.graphics.animation;

/**
 * The different animation play modes.
 */
enum abstract AnimationMode(String) {
  var NORMAL = 'normal';
  var LOOP = 'loop';
  var REVERSED = 'reversed';
  var LOOP_REVERSED = 'loop_reversed';
  var PING_PONG = 'ping_pong';
}
