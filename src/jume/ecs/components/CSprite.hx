package jume.ecs.components;

import jume.ecs.Component.ComponentParams;
import jume.graphics.Color;
import jume.graphics.Flip;
import jume.graphics.Graphics;
import jume.graphics.atlas.Atlas;
import jume.graphics.atlas.AtlasFrame;
import jume.math.Rectangle;
import jume.math.Vec2;

typedef CSpriteParams = ComponentParams & {
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

  public function new(params: CSpriteParams) {
    super(params);
    anchor = new Vec2();
    tint = new Color(1, 1, 1, 1);

    flip.x = params.flipX ?? false;
    flip.y = params.flipY ?? false;

    tempPos = new Vec2();
    frameRect = new Rectangle();

    if (params.anchor != null) {
      anchor.set(params.anchor.x, params.anchor.y);
    }

    if (params.tint != null) {
      tint.copyFrom(params.tint);
    }

    setFrame(params.frameName, params.atlas);
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
