package jume.tilemap;

import haxe.Exception;

import jume.graphics.Image;
import jume.math.Rectangle;

/**
 * Tilesets are used to render different tiles in a tilemap.
 */
class Tileset {
  /**
   * The width per tile in pixels.
   */
  public final tileWidth: Int;

  /**
   * The height per tile in pixels.
   */
  public final tileHeight: Int;

  /**
   * The image that has all the tiles.
   */
  public final image: Image;

  /**
   * The images rectangles for each ile.
   */
  public final tiles: Array<Rectangle>;

  /**
   * Create a new Tileset instance.
   * @param image The tileset image.
   * @param tileWidth The width per tile in pixels.
   * @param tileHeight The height per tile in pixels.
   * @param spacing The spacing between tiles in pixels.
   * @param margin The margin between the edge of the image and the tile in pixels.
   */
  public function new(image: Image, tileWidth: Int, tileHeight: Int, spacing = 0, margin = 0) {
    this.image = image;
    this.tileWidth = tileWidth;
    this.tileHeight = tileHeight;
    tiles = createTileRects(margin, spacing);
  }

  /**
   * Get the image rect for a tile index.
   * @param index The index in the tileset.
   * @return The rectangle for the index.
   */
  public function getRect(index: Int): Rectangle {
    if (index < 0 || index >= tiles.length) {
      throw new Exception('Tile with index ${index} is out of range');
    }

    return tiles[index];
  }

  /**
   * Create the rectangles for each tile.
   * @param spacing The spacing between tiles in pixels.
   * @param margin The margin between the edge of the image and the tile in pixels.
   * @return The created rectangles.
   */
  function createTileRects(margin: Int, spacing: Int): Array<Rectangle> {
    final width = image.width;
    final height = image.height;
    final horizontalTiles = Math.floor((width - margin * 2 + spacing) / (tileWidth + spacing));
    final verticalTiles = Math.floor((height - margin * 2 + spacing) / (tileHeight + spacing));

    final tileRects: Array<Rectangle> = [];
    for (y in 0...verticalTiles) {
      for (x in 0...horizontalTiles) {
        final xPos = margin + x * tileWidth + x * spacing;
        final yPos = margin + y * tileHeight + y * spacing;
        tileRects.push(new Rectangle(xPos, yPos, tileWidth, tileHeight));
      }
    }

    return tileRects;
  }
}
