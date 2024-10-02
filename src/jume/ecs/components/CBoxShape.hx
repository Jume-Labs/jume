package jume.ecs.components;

import jume.graphics.Color;
import jume.graphics.Graphics;
import jume.math.Rectangle;
import jume.math.Vec2;

typedef CBoxShapeOptions = {
  var width: Float;
  var height: Float;
  var ?filled: Bool;
  var ?stroke: Bool;
  var ?fillColor: Color;
  var ?strokeColor: Color;
  var ?strokeWidth: Float;
  var ?anchor: { x: Float, y: Float };
}

class CBoxShape extends Component implements Renderable {
  public var strokeColor: Color;

  public var fillColor: Color;

  public var anchor: Vec2;

  public var width: Float;

  public var height: Float;

  public var filled: Bool;

  public var stroke: Bool;

  public var strokeWidth: Float;

  var tempRect: Rectangle;

  public function init(options: CBoxShapeOptions): CBoxShape {
    strokeColor = new Color(1, 1, 1, 1);
    fillColor = new Color(1, 1, 1, 1);
    anchor = new Vec2(0.5, 0.5);
    tempRect = new Rectangle();

    width = options.width;
    height = options.height;
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
    tempRect.set(-width * anchor.x, -height * anchor.y, width, height);
    if (filled) {
      graphics.color.copyFrom(fillColor);
      graphics.drawSolidRect(tempRect);
    }

    if (stroke) {
      graphics.color.copyFrom(strokeColor);
      graphics.drawRect(tempRect, strokeWidth);
    }
  }

  public function cDebugRender(graphics: Graphics) {}
}
