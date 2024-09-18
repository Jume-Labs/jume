package jume.ecs.components;

import jume.graphics.Flip;
import jume.math.Vec2;
import jume.graphics.Graphics;
import jume.ecs.Component.ComponentParams;
import jume.graphics.Color;
import jume.tilemap.Tileset;

typedef CTilemapParams = ComponentParams & {
  var grid: Array<Array<Int>>;
  var tileset: Tileset;
  var ?tint: Color;
}

class CTilemap extends Component implements Renderable {
  public var grid: Array<Array<Int>>;

  public var tileset: Tileset;

  public var tint: Color;

  var tempPos: Vec2;

  var flip: Flip;

  public function new(params: CTilemapParams) {
    super(params);
    grid = params.grid;
    tileset = params.tileset;
    tint = new Color(1, 1, 1, 1);
    tempPos = new Vec2();
    flip = {
      x: false,
      y: false,
    };

    if (params.tint != null) {
      tint.copyFrom(params.tint);
    }
  }

  public function getTile(x: Int, y: Int): Int {
    #if debug
    if (x < 0 || x >= grid[0].length || y < 0 || y >= grid.length) {
      trace('tile position x: ${x}, y: ${y} is out of bounds');
      return -1;
    }
    #end

    return grid[y][x];
  }

  public function setTile(x: Int, y: Int, value: Int) {
    #if debug
    if (x < 0 || x >= grid[0].length || y < 0 || y >= grid.length) {
      trace('tile position x: ${x}, y: ${y} is out of bounds');
      return;
    }
    #end

    this.grid[y][x] = value;
  }

  public function cRender(graphics: Graphics) {
    graphics.color.copyFrom(tint);
    for (y in 0...grid.length) {
      for (x in 0...grid[0].length) {
        final id = grid[y][x];
        if (id != -1) {
          final rect = tileset.getRect(id);
          tempPos.set(x * tileset.tileWidth, y * tileset.tileHeight);
          graphics.drawImageSection(tempPos, rect, tileset.image, flip);
        }
      }
    }
  }

  public function cDebugRender(graphics: Graphics) {}
}