package jume.ecs.components;

import jume.math.Mat4;
import jume.math.Vec2;

using jume.math.MathUtils;

typedef CTransformOptions = {
  var ?x: Float;
  var ?y: Float;
  var ?rotation: Float;
  var ?scaleX: Float;
  var ?scaleXY: Float;
  var ?parent: CTransform;
};

class CTransform extends Component {
  public var parent: CTransform;

  public var position: Vec2;

  public var scale: Vec2;

  public var rotation: Float;

  public var matrix: Mat4;

  var worldPosition: Vec2;

  var worldRotation: Float;

  var worldScale: Vec2;

  var tempScale: Vec2;

  public function init(?options: CTransformOptions): CTransform {
    // @formatter:off
    options ??= {};
    // @formatter:on
    position = new Vec2(options.x ?? 0, options.y ?? 0);
    rotation = options.rotation ?? 0;
    scale = new Vec2(options.scaleX ?? 1, options.scaleXY ?? 1);
    parent = options.parent;
    matrix = new Mat4();

    worldPosition = new Vec2();
    worldRotation = 0;
    worldScale = new Vec2();
    tempScale = new Vec2();

    return this;
  }

  public function updateMatrix() {
    if (parent != null) {
      getWorldPosition(worldPosition);
      getWorldScale(worldScale);
      worldRotation = getWorldRotation();

      Mat4.from2dRotationTranslationScale(Math.toRad(worldRotation), worldPosition, worldScale, matrix);
    } else {
      Mat4.from2dRotationTranslationScale(Math.toRad(rotation), position, scale, matrix);
    }
  }

  public function parentToLocalPosition(pos: Vec2): Vec2 {
    if (rotation == 0) {
      if (scale.x == 1 && scale.y == 1) {
        pos.sub(position);
      } else {
        pos.x = (pos.x - position.x) / scale.x;
        pos.y = (pos.y - position.y) / scale.y;
      }
    } else {
      final rad = Math.toRad(rotation);
      final cos = Math.cos(rad);
      final sin = Math.sin(rad);
      final toX = pos.x - position.x;
      final toY = pos.y - position.y;
      pos.x = (toX * cos + toY * sin) / scale.x;
      pos.y = (toX * -sin + toY * cos) / scale.y;
    }
    return pos;
  }

  public function localToParentPosition(pos: Vec2): Vec2 {
    if (rotation == 0) {
      if (scale.x == 1 && scale.y == 1) {
        pos.x += position.x;
        pos.y += position.y;
      } else {
        pos.x = pos.x * scale.x + position.x;
        pos.y = pos.y * scale.y + position.y;
      }
    } else {
      final rad = Math.toRad(-rotation);
      final cos = Math.cos(rad);
      final sin = Math.sin(rad);
      final toX = pos.x * scale.x;
      final toY = pos.y * scale.y;
      pos.x = toX * cos + toY * sin + position.x;
      pos.y = toX * -sin + toY * cos + position.y;
    }
    return pos;
  }

  public function localToWorldPosition(pos: Vec2): Vec2 {
    var p = this.parent;
    while (p != null) {
      p.localToParentPosition(pos);
      p = p.parent;
    }
    return pos;
  }

  public function worldToLocalPosition(pos: Vec2): Vec2 {
    if (parent != null) {
      parentToLocalPosition(pos);
    }
    return pos;
  }

  public function getWorldPosition(?out: Vec2): Vec2 {
    if (out == null) {
      out = Vec2.get();
    }
    out.copyFrom(position);
    return localToWorldPosition(out);
  }

  public function setWorldPosition(pos: Vec2) {
    worldToLocalPosition(pos);
    position.copyFrom(pos);
  }

  public function getWorldRotation(): Float {
    if (parent != null) {
      return parent.getWorldRotation() + rotation;
    }
    return rotation;
  }

  public function setWorldRotation(rotation: Float) {
    if (parent != null) {
      rotation = rotation - parent.getWorldRotation();
    } else {
      this.rotation = rotation;
    }
  }

  public function getWorldScale(?out: Vec2): Vec2 {
    if (out == null) {
      out = Vec2.get();
    }
    out.copyFrom(scale);
    if (parent != null) {
      parent.getWorldScale(tempScale);
      out.mul(tempScale);
    }
    return out;
  }

  public function setWorldScale(scale: Vec2) {
    // Convert to local scale.
    if (parent != null) {
      parent.getWorldScale(tempScale);
      scale.div(tempScale);
    }
    scale.copyFrom(scale);
  }
}
