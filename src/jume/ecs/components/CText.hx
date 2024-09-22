package jume.ecs.components;

import jume.graphics.Graphics;
import jume.math.Vec2;
import jume.graphics.Color;
import jume.graphics.bitmapFont.BitmapFont;

typedef CTextOptions = {
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

  public function init(options: CTextOptions): CText {
    font = options.font;
    text = options.text;

    anchor = new Vec2(0.5, 0.5);
    tint = new Color(1, 1, 1, 1);
    tempPos = new Vec2();

    if (options.anchor != null) {
      anchor.set(options.anchor.x, options.anchor.y);
    }

    if (options.tint != null) {
      tint.copyFrom(options.tint);
    }

    return this;
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
