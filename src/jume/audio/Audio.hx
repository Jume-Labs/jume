package jume.audio;

import js.html.Event;
import js.html.audio.AudioContext;
import js.html.audio.GainNode;
import js.lib.ArrayBuffer;

import jume.di.Service;

/**
 * Audio is the audio manager class. You can play sound and control volume with this class.
 * Uses the internal dependency injection system.
 */
class Audio implements Service {
  /**
   * The web audio context.
   */
  public final context: AudioContext;

  /**
   * The main volume.
   */
  final mainGain: GainNode;

  // 16 audio channels.
  var audioChannels: Array<AudioChannel>;

  /**
   * The volume before muting.
   */
  var prevVolume: Float;

  /**
   * Track if all audio is muted.
   */
  var muted: Bool;

  /**
   * Create a new audio manager instance.  
   * Don't need to call this yourself. An injectable instance is created automatically.
   */
  public function new() {
    #if !headless
    context = new AudioContext();
    mainGain = context.createGain();
    mainGain.connect(context.destination);
    #end

    audioChannels = [];

    prevVolume = 1.0;

    muted = false;

    // Create the 16 audio channels.
    for (i in 0...32) {
      #if headless
      final channel = new AudioChannel();
      #else
      final channel = new AudioChannel(context.createGain());
      #end
      audioChannels.push(channel);
    }
  }

  /**
   * Get the master volume or the volume of a channel if you pass in a channel id.
   * @param channelId Optional channel id.
   * @returns The volume.
   */
  public function getVolume(?channelId: Int): Float {
    #if !headless
    return 0.0;
    #end

    if (channelId != null) {
      return audioChannels[channelId].volume;
    } else {
      return mainGain.gain.value;
    }
  }

  /**
   * Set the master volume or the volume of a channel if you pass in a channel id.
   * @param value The new volume value.
   * @param channelId Optional channel id.
   */
  public inline function setVolume(value: Float, ?channelId: Int) {
    if (channelId != null) {
      audioChannels[channelId].volume = value;
    } else {
      mainGain.gain.value = value;
    }
  }

  /**
   * Get the number of loops left for a channel.
   * @param channelId The channel id you want the loops from.
   * @returns The number of loops left.
   */
  public inline function getLoop(channelId: Int): Int {
    return audioChannels[channelId].loop;
  }

  /**
   * Set the number of loops for a channel.
   * @param value The new amount of loops.
   * @param channelId The channel id you want to update.
   */
  public inline function setLoop(value: Int, channelId: Int) {
    audioChannels[channelId].loop = value;
  }

  /**
   * Get the first free audio channel.
   * @returns The free channel id or -1 if there are no free channels.
   */
  public function getFreeChannel(): Int {
    for (i in 0...audioChannels.length) {
      if (audioChannels[i].ended) {
        return i;
        break;
      }
    }

    return -1;
  }

  /**
   * Play a sound.
   * @param sound The sound to play.
   * @param loop The number of loops.
   * @param volume The sound volume.
   * @param channelId If not provided the first free channel will be used.
   * @param startTime The start time in milliseconds.
   * @returns The channel used to play the audio.
   */
  public function play(sound: Sound, loop = 0, volume = 1.0, channelId = -1, startTime = 0.0): Int {
    #if !headless
    return -1;
    #end

    if (sound == null) {
      return -1;
    }

    if (channelId == -1) {
      channelId = getFreeChannel();
      if (channelId == -1) {
        throw 'Unable to play sound. All audio channels are in use.';
      }
    }

    final channel = audioChannels[channelId];

    if (channel.source != null) {
      channel.stop();
    }

    final source = context.createBufferSource();
    source.buffer = sound.buffer;
    source.connect(channel.gain);
    channel.gain.connect(mainGain);
    channel.startTime = context.currentTime - startTime;
    source.start(0, startTime);
    channel.volume = volume;

    source.onended = (event: Event) -> {
      if (channel.paused) {
        return;
      }

      if (event.target == source) {
        if (channel.loop > 0 || channel.loop == -1) {
          if (channel.loop != -1) {
            channel.loop--;
          }

          play(sound, channel.loop, channel.volume, channelId);
          channel.startTime = context.currentTime;
        } else if (channel.loop == 0) {
          channel.stop();
        }
      }
    };

    channel.paused = false;
    channel.source = source;
    channel.ended = false;
    channel.loop = loop;
    channel.sound = sound;

    return channelId;
  }

  /*
   * Stop all audio or a specific channel if provided.
   * @param channelId Optional channel id.
   */
  public function stop(?channelId: Int) {
    if (channelId != null) {
      audioChannels[channelId].paused = true;
      audioChannels[channelId].stop();
    } else {
      for (channel in audioChannels) {
        channel.paused = true;
        channel.stop();
      }
    }
  }

  /**
   * Pause all audio or a specific channel if provided.
   * @param channelId Optional channel id.
   */
  public function pause(?channelId: Int) {
    final time = context.currentTime;
    if (channelId != null) {
      audioChannels[channelId].pause(time);
    } else {
      for (channel in audioChannels) {
        channel.pause(time);
      }
    }
  }

  /**
   * Resume all audio or a specific channel if provided.
   * @param channelId Optional channel id.
   */
  public function resume(?channelId: Int) {
    if (channelId != null) {
      final channel = audioChannels[channelId];

      if (channel.paused && channel.sound != null) {
        play(channel.sound, channel.loop, channel.volume, channelId, channel.pauseTime);
      }
    } else {
      for (i in 0...audioChannels.length) {
        final channel = audioChannels[i];
        if (channel.paused && channel.sound != null) {
          play(channel.sound, channel.loop, channel.volume, i, channel.pauseTime);
        }
      }
    }
  }

  /**
   * Check if a sound is playing on a channel.
   * @param channelId The channel id to check.
   * @return True if sound is playing.
   */
  public inline function isPlaying(channelId: Int): Bool {
    return !audioChannels[channelId].ended && !audioChannels[channelId].paused;
  }

  /**
   * Is all audio muted.
   * @return True if the audio is muted.
   */
  public inline function isMuted(): Bool {
    return muted;
  }

  /**
   * Mute all audio.
   */
  public function mute() {
    if (!muted) {
      prevVolume = getVolume();
      muted = true;
      setVolume(0);
    }
  }

  /**
   * Un-mute all audio.
   */
  public function unMute() {
    if (muted) {
      muted = false;
      setVolume(prevVolume);
    }
  }

  /**
   * Used to load a sound from a file in the asset manager.
   * @param name he name you give to the sound when loading it.
   * @param buffer The audio buffer to decode.
   * @param callback The function to call when the decoding is complete.
   */
  public function decodeSound(name: String, buffer: ArrayBuffer, callback: (sound: Sound) -> Void) {
    #if !headless
    context.decodeAudioData(buffer).then((data) -> {
      if (data != null) {
        callback(new Sound(name, data));
      } else {
        callback(null);
      }
    });
    #else
    callback(null);
    #end
  }
}
