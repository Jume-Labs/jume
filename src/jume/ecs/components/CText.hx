package jume.ecs.components;

import jume.graphics.Graphics;
import jume.ecs.Component.ComponentParams;
import jume.math.Vec2;
import jume.graphics.Color;
import jume.graphics.bitmapFont.BitmapFont;

typedef CTextParams = ComponentParams & {
  var font: BitmapFont;
  var text: String;
  var ?tint: Color;
  var ?anchor: { x: Float, y: Float };
}

class CText extends Component implements Renderable {
  public var font: BitmapFont;

  public var text: String;

  public var anchor: Vec2;

  public var tint: Color;

  public var width(get, never): Float;

  public var height(get, never): Float;

  var tempPos: Vec2;

  public function new(params: CTextParams) {
    super(params);

    font = params.font;
    text = params.text;

    anchor = new Vec2(0.5, 0.5);
    tint = new Color(1, 1, 1, 1);
    tempPos = new Vec2();

    if (params.anchor != null) {
      anchor.set(params.anchor.x, params.anchor.y);
    }

    if (params.tint != null) {
      tint.copyFrom(params.tint);
    }
  }

  public function cRender(graphics: Graphics) {
    if (text.length == 0) {
      return;
    }

    graphics.color.copyFrom(tint);
    tempPos.set(-width * anchor.x, -height * anchor.y);
    graphics.drawBitmapText(tempPos, font, text);
  }

  public function cDebugRender(graphics: Graphics) {}

  inline function get_width(): Int {
    return font.width(text);
  }

  inline function get_height(): Int {
    return font.height;
  }
}