package jume.tweens;

import jume.di.Service;

/**
 * The tween manager class.
 */
class Tweens implements Service {
  /**
   * All tweens updated by the manager.
   */
  final current: Array<Tween> = [];

  /**
   * All sequence updated by the manager.
   */
  final sequences: Array<TweenSequence> = [];

  /**
   * All completed tweens during a frame.
   */
  final completed: Array<Tween> = [];

  /**
   * Tweens constructor.
   */
  public function new() {}

  /**
   * Add a new tween to the manager. The manager will update it automatically.
   * @param tween The tween to add.
   */
  public function addTween(tween: Tween) {
    current.push(tween);
  }

  /**
   * Add a new sequence to the manager. The manager will update it automatically.
   * @param tween The sequence to add.
   */
  public function addSequence(sequence: TweenSequence) {
    sequences.push(sequence);
  }

  /**
   * Updates all tweens and sequences. Is called automatically.
   * @param dt The time passed since the last update in seconds.
   */
  public function update(dt: Float) {
    for (tween in current) {
      tween.update(dt);
      if (tween.complete) {
        if (tween.repeat > tween.timesCompleted || tween.repeat == -1) {
          tween.restart();
          tween.timesCompleted++;
        } else {
          completed.push(tween);
        }
      }
    }

    /**
     * Run the completed callback and remove the completed tween from the manager.
     */
    while (completed.length > 0) {
      final tween = completed.pop();
      current.remove(tween);
      tween.runComplete();
    }

    for (sequence in sequences) {
      if (sequence.index > sequence.list.length - 1) {
        sequence.index = 0;
      }

      final tween = sequence.currentTween;
      tween.update(dt);
      if (tween.complete) {
        if (tween.repeat > tween.timesCompleted || tween.repeat == -1) {
          tween.timesCompleted++;
          tween.resetTime();
          tween.complete = false;
          tween.paused = false;
        } else {
          tween.runComplete();
          sequence.index++;

          if (sequence.repeat > sequence.timesCompleted || sequence.repeat == -1) {
            for (seqTween in sequence.list) {
              seqTween.complete = false;
              seqTween.resetTime();
            }
            sequence.timesCompleted++;
          } else {
            sequences.remove(sequence);
          }
        }
      }
    }
  }

  /**
   * Pause all tweens and sequences.
   */
  public function pauseAll() {
    for (tween in current) {
      tween.paused = true;
    }

    for (sequence in sequences) {
      sequence.currentTween.paused = true;
    }
  }

  /**
   * Pause all tweens and sequences with a tag.
   * @param tag The tag to check for.
   */
  public function pauseWithTag(tag: String) {
    for (tween in current) {
      if (tween.tag == tag) {
        tween.paused = true;
      }
    }

    for (sequence in sequences) {
      if (sequence.tag == tag) {
        sequence.currentTween.paused = true;
      }
    }
  }

  /**
   * Resume all tweens and sequences.
   */
  public function resumeAll() {
    for (tween in current) {
      tween.paused = false;
    }

    for (sequence in sequences) {
      sequence.currentTween.paused = false;
    }
  }

  /**
   * Resume all tweens and sequences with a tag.
   * @param tag The tag to check for.
   */
  public function resumeWithTag(tag: String) {
    for (tween in current) {
      if (tween.tag == tag) {
        tween.paused = false;
      }
    }

    for (sequence in sequences) {
      if (sequence.tag == tag) {
        sequence.currentTween.paused = false;
      }
    }
  }

  /**
   * Remove a tween from the manager.
   * @param tween 
   */
  public inline function removeTween(tween: Tween) {
    current.remove(tween);
  }

  /**
   * Remove a sequence from the manager.
   * @param sequence 
   */
  public inline function removeSequence(sequence: TweenSequence) {
    sequences.remove(sequence);
  }

  /**
   * Remove all tweens from a target. Does not include sequences.
   * @param target The target to check.
   */
  public function removeAllFrom(target: Dynamic) {
    final tweensToRemove: Array<Tween> = [];
    for (tween in current) {
      if (tween.hasTarget(target)) {
        tweensToRemove.push(tween);
      }
    }

    for (tween in tweensToRemove) {
      current.remove(tween);
    }
  }

  /**
   * Clear all the tween that are active.
   */
  public function clearTweens() {
    while (current.length > 0) {
      current.pop();
    }

    while (sequences.length > 0) {
      sequences.pop();
    }

    while (completed.length > 0) {
      completed.pop();
    }
  }
}
