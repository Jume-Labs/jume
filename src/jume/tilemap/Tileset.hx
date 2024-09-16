package jume.tilemap;

import haxe.Exception;

import jume.math.Rectangle;
import jume.graphics.Image;

class Tileset {
  public final tileWidth: Int;

  public final tileHeight: Int;

  public final image: Image;

  public final tiles: Array<Rectangle>;

  public function new(image: Image, tileWidth: Int, tileHeight: Int, spacing = 0, margin = 0) {
    this.image = image;
    this.tileWidth = tileWidth;
    this.tileHeight = tileHeight;

    final width = image.width;
    final height = image.height;
    final horizontalTiles = Math.floor((width - margin * 2 + spacing) / (tileWidth + spacing));
    final verticalTiles = Math.floor((height - margin * 2 + spacing) / (tileHeight + spacing));

    this.tiles = [];
    for (y in 0...verticalTiles) {
      for (x in 0...horizontalTiles) {
        final xPos = margin + x * tileWidth + x * spacing;
        final yPos = margin + y * tileHeight + y * spacing;
        this.tiles.push(new Rectangle(xPos, yPos, tileWidth, tileHeight));
      }
    }
  }

  public function getRect(index: Int): Rectangle {
    if (index < 0 || index >= tiles.length) {
      throw new Exception('Tile with index ${index} is out of range');
    }

    return tiles[index];
  }
}
