package gameobj;

import Constants.TileType;
import flixel.addons.nape.FlxNapeTilemap;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets;
import nape.geom.Vec2;

using Lambda;
using logic.PhysUtil;

class CustomNapeTilemap extends FlxNapeTilemap
{
	public var spawnPoints(default, null) = new Array<FlxPoint>();

	public function new(tiles:String, graphics:FlxTilemapGraphicAsset, tileSize:Int)
	{
		super();
		loadMapFromCSV(tiles, graphics, tileSize, tileSize);
		setupTileIndices(TileType.BLOCK);

		var vertices = new Array<Vec2>();
		vertices.push(Vec2.get(16, 0));
		vertices.push(Vec2.get(16, 16));
		vertices.push(Vec2.get(0, 16));
		placeCustomPolygon(TileType.SLOPE_SE, vertices);
		vertices[0] = Vec2.get(0, 0);
		placeCustomPolygon(TileType.SLOPE_SW, vertices);
		vertices[1] = Vec2.get(16, 0);
		placeCustomPolygon(TileType.SLOPE_NW, vertices);
		vertices[2] = Vec2.get(16, 16);
		placeCustomPolygon(TileType.SLOPE_NE, vertices);

		for (ty in 0...heightInTiles)
		{
			var prevOneWay = false;
			var length:Int = 0;
			var startX:Int = 0;
			var startY:Int = 0;

			for (tx in 0...widthInTiles)
			{
				if (TileType.ONE_WAY.has(getTileIndex(tx, ty)))
				{
					if (!prevOneWay)
					{
						prevOneWay = true;
						length = 0;
						startX = tx;
						startY = ty;
					}
					length++;
				}
				else if (prevOneWay)
				{
					prevOneWay = false;
					var startPos = getTilePos(startX, startY, false);
					PhysUtil.setOneWayLong(this, startPos, length);
				}
			}

			if (prevOneWay)
			{
				prevOneWay = false;
				var startPos = getTilePos(startX, startY, false);
				PhysUtil.setOneWayLong(this, startPos, length);
			}
		}

		for (point in getAllTilePos(TileType.SPAWN, false))
		{
			point.x += scaledTileHeight * 0.5;
			spawnPoints.push(point);
		}
	}
}
