package jume.ecs.components;

import jume.graphics.Color;
import jume.graphics.Graphics;
import jume.math.Vec2;

typedef CCircleShapeParams = {
  var radius: Float;
  var ?segments: Int;
  var ?filled: Bool;
  var ?stroke: Bool;
  var ?strokeColor: Color;
  var ?fillColor: Color;
  var ?strokeWidth: Float;
  var ?anchor: { x: Float, y: Float };
}

class CCircleShape extends Component implements Renderable {
  public var strokeColor: Color;

  public var fillColor: Color;

  public var anchor: Vec2;

  public var radius: Float;

  public var segments: Int;

  public var filled: Bool;

  public var stroke: Bool;

  public var strokeWidth: Float;

  var tempPos: Vec2;

  public function init(params: CCircleShapeParams): CCircleShape {
    strokeColor = new Color(1, 1, 1, 1);
    fillColor = new Color(1, 1, 1, 1);
    anchor = new Vec2(0.5, 0.5);
    tempPos = new Vec2();

    radius = params.radius;
    segments = params.segments ?? 48;
    filled = params.filled ?? false;
    stroke = params.stroke ?? true;

    if (params.strokeColor != null) {
      strokeColor.copyFrom(params.strokeColor);
    }

    if (params.fillColor != null) {
      fillColor.copyFrom(params.fillColor);
    }

    strokeWidth = params.strokeWidth ?? 1;

    if (params.anchor != null) {
      anchor.set(params.anchor.x, params.anchor.y);
    }

    return this;
  }

  public function cRender(graphics: Graphics) {
    tempPos.set(-radius * anchor.x, -radius * anchor.y);
    if (filled) {
      graphics.color.copyFrom(fillColor);
      graphics.drawSolidCircle(tempPos, radius, segments);
    }

    if (stroke) {
      graphics.color.copyFrom(strokeColor);
      graphics.drawCircle(tempPos, radius, segments, strokeWidth);
    }
  }

  public function cDebugRender(graphics: Graphics) {}
}
