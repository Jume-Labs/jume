package jume.ecs.components;

import jume.graphics.Color;
import jume.graphics.Graphics;
import jume.math.Vec2;

typedef CCircleShapeOptions = {
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

  public function init(options: CCircleShapeOptions): CCircleShape {
    strokeColor = new Color(1, 1, 1, 1);
    fillColor = new Color(1, 1, 1, 1);
    anchor = new Vec2(0.5, 0.5);
    tempPos = new Vec2();

    radius = options.radius;
    segments = options.segments ?? 48;
    filled = options.filled ?? false;
    stroke = options.stroke ?? true;

    if (options.strokeColor != null) {
      strokeColor.copyFrom(options.strokeColor);
    }

    if (options.fillColor != null) {
      fillColor.copyFrom(options.fillColor);
    }

    strokeWidth = options.strokeWidth ?? 1;

    if (options.anchor != null) {
      anchor.set(options.anchor.x, options.anchor.y);
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
