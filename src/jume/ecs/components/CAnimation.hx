package jume.ecs.components;

import jume.ecs.Component.ComponentParams;
import jume.graphics.animation.Animation;
import jume.graphics.atlas.Atlas;

typedef CAnimationParams = ComponentParams & {
  var ?animations: Array<Animation>;
}

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

  public function new(params: CAnimationParams) {
    super(params);
    sprite = getComponent(CSprite);
    time = 0;
    animations = new Map<String, Animation>();

    if (params.animations != null) {
      for (anim in params.animations) {
        animations[anim.name] = anim;
      }
    }
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
