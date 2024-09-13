package jume.audio;

import js.html.audio.AudioBuffer;

/**
 * A sound you can play using the audio service.
 */
class Sound {
  /**
   * The name of the sound.
   */
  public final name: String;

  /**
   * The sound data.
   */
  public final buffer: AudioBuffer;

  /**
   * Create a new Sound.
   * @param name The name of the sound.
   * @param buffer The sound data.
   */
  public function new(name: String, buffer: AudioBuffer) {
    this.name = name;
    this.buffer = buffer;
  }
}
