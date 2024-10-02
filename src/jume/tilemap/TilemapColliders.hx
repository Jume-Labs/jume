package jume.tilemap;

import jume.math.Rectangle;
import jume.math.Vec2;

typedef CollisionTile = {
  var id: Int;
  var checked: Bool;
};

typedef GenFromIntGridProps = {
  var grid: Array<Array<Int>>;
  var worldX: Int;
  var worldY: Int;
  var tileWidth: Int;
  var tileHeight: Int;
  var collisionIds: Array<Int>;
};

typedef GenColliderProps = {
  var tiles: Array<Array<CollisionTile>>;
  var worldX: Int;
  var worldY: Int;
  var tileWidth: Int;
  var tileHeight: Int;
  var collisionIds: Array<Int>;
};

function generateFromIntGrid(params: GenFromIntGridProps): Array<Rectangle> {
  final tiles: Array<Array<CollisionTile>> = [];

  for (y in 0...params.grid.length) {
    final row: Array<CollisionTile> = [];
    for (x in 0...params.grid[0].length) {
      row.push({ id: params.grid[y][x], checked: false });
    }
    tiles.push(row);
  }

  return generateColliders({
    tiles: tiles,
    worldX: params.worldX,
    worldY: params.worldY,
    tileWidth: params.tileWidth,
    tileHeight: params.tileHeight,
    collisionIds: params.collisionIds
  });
}

function isCollisionTile(id: Int, collisionIds: Array<Int>): Bool {
  // If no ids specified every non-empty tile is a collision tile.
  if (collisionIds.length == 0) {
    return id > 0;
  }

  return collisionIds.contains(id);
}

function generateColliders(params: GenColliderProps): Array<Rectangle> {
  final colliders: Array<Rectangle> = [];
  final start = Vec2.get();
  final current = Vec2.get();

  var checking = false;
  var foundLastY = false;

  // Starting at the top lef, loop over all tiles and create colliders.
  for (x in 0...params.tiles[0].length) {
    for (y in 0...params.tiles.length) {
      var tile = params.tiles[y][x];

      // Check if the tile should be part of a collider.
      if (tile.checked || !isCollisionTile(tile.id, params.collisionIds)) {
        continue;
      }

      tile.checked = true;
      start.set(x, y);
      current.set(x, y);
      checking = true;
      foundLastY = false;

      // Move down until there is no collider found or the3nd of the map is reached.
      while (checking) {
        // If it found the bottom most connected collision tile move right from the start to see how big
        // the collider can be horizontally.
        if (foundLastY) {
          current.x++;
          if (current.x >= params.tiles[0].length) {
            checking = false;
            current.x--;
            break;
          }

          for (i in start.yi...(current.yi + 1)) {
            tile = params.tiles[i][current.xi];
            if (tile.checked || !isCollisionTile(tile.id, params.collisionIds)) {
              current.x--;
              checking = false;
            } else {
              tile.checked = true;
            }

            if (!checking) {
              break;
            }
          }

          if (!checking) {
            for (i in start.yi...(current.yi + 1)) {
              params.tiles[i][current.xi + 1].checked = false;
            }
          }
        } else {
          current.y++;
          if (current.y >= params.tiles.length) {
            foundLastY = true;
            current.y--;
          } else {
            tile = params.tiles[current.yi][current.xi];
            if (tile.checked || !isCollisionTile(tile.id, params.collisionIds)) {
              current.y--;
              foundLastY = true;
            } else {
              tile.checked = true;
            }
          }
        }
      }

      final distX = current.x - start.x + 1;
      final distY = current.y - start.y + 1;
      final xPos = params.worldX + start.x * params.tileWidth;
      final yPos = params.worldY + start.y * params.tileHeight;
      colliders.push(new Rectangle(xPos, yPos, params.tileWidth * distX, params.tileHeight * distY));
    }
  }

  start.put();
  current.put();

  return colliders;
}
