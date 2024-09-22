package jume.ecs.components;

import jume.graphics.animation.Animation;
import jume.graphics.atlas.Atlas;

class CAnimation extends Component implements Updatable {
  public var isPlaying(default, null): Bool;

  public var currentFrameName(default, null): String;

  public var currentAnim(get, never): String;

  public var atlas(get, never): Atlas;

  public var isFinished(get, never): Bool;

  var anim: Animation;

  var time: Float;

  var animations: Map<String, Animation>;

  var sprite: CSprite;

  public function init(anims: Array<Animation>): CAnimation {
    sprite = getComponent(CSprite);
    time = 0;
    animations = new Map<String, Animation>();

    if (anims != null) {
      for (anim in anims) {
        animations[anim.name] = anim;
      }
    }

    return this;
  }

  public function cUpdate(dt: Float) {
    if (isPlaying && anim != null && !isFinished) {
      time += dt;
    }
  }

  inline function get_currentAnim(): String {
    return anim != null ? anim.name : '';
  }

  inline function get_atlas(): Atlas {
    return anim?.atlas;
  }

  inline function get_isFinished(): Bool {
    return anim != null ? anim.finished(time) : true;
  }
}
