package jume.audio;

import js.html.audio.AudioBufferSourceNode;
import js.html.audio.GainNode;

using jume.math.MathUtils;

/**
 * Audio channels store and play sounds.
 */
class AudioChannel {
  /**
   * The sound to play.
   */
  public var sound: Sound;

  /**
   * Audio node. Get set by the audio manager.
   */
  public var source: AudioBufferSourceNode;

  /**
   * The start position in milliseconds.
   */
  public var startTime: Float;

  /**
   * The position when the channel was paused in milliseconds.
   * Is used when resuming.
   */
  public var pauseTime: Float;

  /**
   * The loop the sound is on.
   */
  public var loop: Int;

  /**
   * Has this channel sound ended.
   */
  public var ended: Bool;

  /**
   * Is this channel paused.
   */
  public var paused: Bool;

  /**
   * The gain node connected to this channel.
   */
  public var gain(default, null): GainNode;

  /**
   * Set the volume for this channel.
   */
  public var volume(get, set): Float;

  /**
   * Create a new audio channel instance. Don't create these yourself. This is done through the audio manager.
   * @param gain The gain node for this channel.
   */
  public function new(?gain: GainNode) {
    this.gain = gain;
    volume = 1.0;
    startTime = 0;
    pauseTime = 0;
    loop = 0;
    ended = false;
    paused = false;
  }

  /**
   * Pause the sound.
   * @param time Current audio time in milliseconds.
   */
  public function pause(time: Float) {
    if (source != null) {
      pauseTime = time - startTime;
      paused = true;
      #if !headless
      source.disconnect();
      gain.disconnect();
      source.stop();
      #end
      source = null;
    }
  }

  /**
   * Stop the sound.
   */
  public function stop() {
    if (source != null) {
      #if !headless
      source.disconnect();
      gain.disconnect();
      source.stop();
      #end
      source = null;
      ended = true;
      paused = true;
    }
  }

  function get_volume(): Float {
    #if !headless
    return gain.gain.value;
    #end

    return 0;
  }

  function set_volume(value: Float): Float {
    #if !headless
    gain.gain.value = Math.clamp(value, 0.0, 1.0);
    #end

    return value;
  }
}
