package jume.ecs.components;

import jume.graphics.Color;
import jume.graphics.Flip;
import jume.graphics.Graphics;
import jume.graphics.atlas.Atlas;
import jume.graphics.atlas.AtlasFrame;
import jume.math.Rectangle;
import jume.math.Vec2;

typedef CSpriteOptions = {
  var atlas: Atlas;
  var frameName: String;
  var ?anchor: { x: Float, y: Float };
  var ?tint: Color;
  var ?flipX: Bool;
  var ?flipY: Bool;
};

class CSprite extends Component implements Renderable {
  public var anchor: Vec2;

  public var tint: Color;

  public var flip: Flip;

  public var atlas(default, null): Atlas;

  public var frameName(get, never): String;

  public var width(get, never): Int;

  public var height(get, never): Int;

  var frame: AtlasFrame;

  var tempPos: Vec2;

  var frameRect: Rectangle;

  public function init(options: CSpriteOptions): CSprite {
    anchor = new Vec2(0.5, 0.5);
    tint = new Color(1, 1, 1, 1);

    flip = {
      x: options.flipX ?? false,
      y: options.flipY ?? false
    };

    tempPos = new Vec2();
    frameRect = new Rectangle();

    if (options.anchor != null) {
      anchor.set(options.anchor.x, options.anchor.y);
    }

    if (options.tint != null) {
      tint.copyFrom(options.tint);
    }

    setFrame(options.frameName, options.atlas);

    return this;
  }

  public function setFrame(frameName: String, ?atlas: Atlas) {
    if (atlas != null) {
      this.atlas = atlas;
    }

    this.frame = this.atlas.getFrame(frameName);
  }

  public function cRender(graphics: Graphics) {
    if (atlas == null || frame == null) {
      return;
    }

    graphics.color.copyFrom(tint);
    tempPos.set(-(frame.sourceSize.width * anchor.x) + frame.sourceRect.x,
      -(frame.sourceSize.height * anchor.y) + frame.sourceRect.y);
    graphics.drawImageSection(tempPos, frame.frame, atlas.image, flip);
  }

  public function cDebugRender(graphcis: Graphics) {}

  inline function get_frameName(): String {
    return frame?.name ?? '';
  }

  inline function get_width(): Int {
    return frame?.sourceSize.widthi ?? 0;
  }

  inline function get_height(): Int {
    return frame?.sourceSize.heighti ?? 0;
  }
}
