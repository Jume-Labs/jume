package jume.ecs.components;

import jume.math.Rectangle;
import jume.graphics.Graphics;
import jume.math.Vec2;
import jume.ecs.Component.ComponentParams;
import jume.graphics.Color;

typedef CBoxShapeParams = ComponentParams & {
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

  public function new(params: CBoxShapeParams) {
    super(params);

    strokeColor = new Color(1, 1, 1, 1);
    fillColor = new Color(1, 1, 1, 1);
    anchor = new Vec2(0.5, 0.5);
    tempRect = new Rectangle();

    width = params.width;
    height = params.height;
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
