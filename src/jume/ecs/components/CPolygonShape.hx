package jume.ecs.components;

import jume.graphics.Color;
import jume.graphics.Graphics;
import jume.math.Vec2;

typedef CPolygonShapeOptions = {
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

  public function init(options: CPolygonShapeOptions): CPolygonShape {
    strokeColor = new Color(1, 1, 1, 1);
    fillColor = new Color(1, 1, 1, 1);

    filled = options.filled ?? false;
    stroke = options.stroke ?? true;
    vertices = options.vertices;
    tempPos = new Vec2();

    if (options.strokeColor != null) {
      strokeColor.copyFrom(options.strokeColor);
    }

    if (options.fillColor != null) {
      fillColor.copyFrom(options.fillColor);
    }

    strokeWidth = options.strokeWidth ?? 1;

    return this;
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
