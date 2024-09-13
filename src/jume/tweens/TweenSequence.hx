package jume.tweens;

/**
 * A group of tweens that run one after another.
 */
class TweenSequence {
  /**
   * The current sequence index.
   */
  public var index: Int;

  /**
   * How many times this sequence has completed.
   */
  public var timesCompleted: Int;

  /**
   * How many times that sequence will repeat. Get subtracted by one every time the sequence completes.
   */
  public var repeat: Int;

  /**
   * The sequence tag. You can pause / resume a group of tweens/sequences using this tag.
   */
  public var tag: String;

  /**
   * The sequence list of tweens.
   */
  public var list(default, null): Array<Tween>;

  /**
   * The current running tween
   */
  public var currentTween(get, never): Tween;

  /**
   * Create a new sequence.
   * @param tweens The list of tweens to run.
   * @param repeat How many times this sequence will repeat. -1 repeats forever.
   * @param tag The sequence tag.
   */
  public function new(tweens: Array<Tween>, repeat = 0, tag = '') {
    list = tweens;
    this.repeat = repeat;
    this.tag = tag;
    index = 0;
    timesCompleted = 0;
  }

  /**
   * Reset this sequence completely.
   */
  public function reset() {
    index = 0;
    timesCompleted = 0;

    for (tween in list) {
      tween.reset();
    }
  }

  /**
   * Restart this sequence from the start.
   */
  public function restart() {
    index = 0;

    for (tween in list) {
      tween.restart();
    }
  }

  inline function get_currentTween(): Tween {
    return list[list.length - 1];
  }
}
