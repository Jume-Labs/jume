package jume.ecs.components;

import jume.ecs.Component.ComponentParams;
import jume.graphics.Color;
import jume.graphics.Graphics;
import jume.math.Vec2;

typedef CPolygonShapeParams = ComponentParams & {
  var vertices: Array<Vec2>;
  var ?filled: Bool;
  var ?stroke: Bool;
  var ?strokeColor: Color;
  var ?fillColor: Color;
  var ?strokeWidth: Float;
}

class CPolygonShape extends Component implements Renderable {
  public var strokeColor: Color;

  public var fillColor: Color;

  public var vertices: Array<Vec2>;

  public var filled: Bool;

  public var stroke: Bool;

  public var strokeWidth: Float;

  var tempPos: Vec2;

  public function new(params: CPolygonShapeParams) {
    super(params);

    strokeColor = new Color(1, 1, 1, 1);
    fillColor = new Color(1, 1, 1, 1);

    filled = params.filled ?? false;
    stroke = params.stroke ?? true;
    vertices = params.vertices;
    tempPos = new Vec2();

    if (params.strokeColor != null) {
      strokeColor.copyFrom(params.strokeColor);
    }

    if (params.fillColor != null) {
      fillColor.copyFrom(params.fillColor);
    }

    strokeWidth = params.strokeWidth ?? 1;
  }

  public function cRender(graphics: Graphics) {
    if (filled) {
      graphics.color.copyFrom(fillColor);
      graphics.drawSolidPolygon(tempPos, vertices);
    }

    if (stroke) {
      graphics.color.copyFrom(strokeColor);
      graphics.drawPolygon(tempPos, vertices, strokeWidth);
    }
  }

  public function cDebugRender(graphics: Graphics) {}
}
