import flixel.FlxG;
import flixel.tile.FlxTilemap;

class DistanceTilemap extends FlxTilemap
{
	static inline var PATH = "assets/images/heat.png";
	static var colorTiles = 0;
	static var blockedTile = 0;

	public var collisionMap:FlxTilemap;
	public var distances:Array<Int>;
	
	public function new (collisionMap:FlxTilemap)
	{
		this.collisionMap = collisionMap;
		super();
	}

	public function createEmptyHeatmap(widthInTiles:Int, heightInTiles)
	{
		final data = [for (i in 0...widthInTiles * heightInTiles) 0];
		loadMapFromArray(data, widthInTiles, heightInTiles, PATH, 1, 1);
		blockedTile = graphic.bitmap.width - 1;
		colorTiles = blockedTile - 1;
	}
	
	inline function getIndex(tileX:Int, tileY:Int):Int
	{
		return tileX + widthInTiles * tileY;
	}

	public inline function getDistanceToTarget(tileX:Int, tileY:Int)
	{
		return getDistanceToTargetByIndex(getIndex(tileX, tileY));
	}

	public inline function getDistanceToTargetByIndex(index:Int)
	{
		return distances[index];
	}
	
	public function getIndexOfBestNeighbor(tileX:Int, tileY:Int):Int
	{
		
		if (getDistanceToTarget(tileX, tileY) <= 0)
			return getIndex(tileX, tileY);
		
		// Use totalTiles like Math.POSITIVE_INFINITY since nothing can be further
		final maxDistance = totalTiles;
		
		function getTileScoreByIndex(index:Int):Int
		{
			if (collisionMap.getTileCollisions(collisionMap.getTileByIndex(index)) == NONE)
				return getDistanceToTargetByIndex(index);
			
			return maxDistance;
		}
		
		inline function getTileScore(tileX:Int, tileY:Int):Int
		{
			return getTileScoreByIndex(getIndex(tileX, tileY));
		}
		
		final w = widthInTiles - 1;
		final h = heightInTiles - 1;
		final l = tileX > 0 ? getTileScore(tileX - 1, tileY) : maxDistance;
		final r = tileX < w ? getTileScore(tileX + 1, tileY) : maxDistance;
		final u = tileY > 0 ? getTileScore(tileX, tileY - 1) : maxDistance;
		final d = tileY < h ? getTileScore(tileX, tileY + 1) : maxDistance;
		
		final min = Math.min(Math.min(l, r), Math.min(u, d));
		final options = new Array<Int>();
		if (l == min) options.push(getIndex(tileX - 1, tileY));
		if (r == min) options.push(getIndex(tileX + 1, tileY));
		if (u == min) options.push(getIndex(tileX, tileY - 1));
		if (d == min) options.push(getIndex(tileX, tileY + 1));
		return FlxG.random.getObject(options);
	}

	public function redraw(targetX:Int, targetY:Int)
	{
		final start = (targetY * collisionMap.widthInTiles) + targetX;
		final end = start == 0 ? 1 : 0;
		// compute distances from the target to every tile, without stopping at the end
		var distances = collisionMap.computePathDistance(start, start, NONE, false);
		if (distances == null)
			distances = [for (i in 0...totalTiles) -1];
		
		this.distances = distances;

		var maxDistance:Int = 1;
		for (dist in distances)
		{
			if (dist > maxDistance)
				maxDistance = dist;
		}

		for (i => distance in distances)
		{
			if (distance < 0)
				setBlockedTile(i);
			else
				setTileByDistance(i, distance / maxDistance);
		}
	}

	function setTileByDistance(index:Int, distanceRatio:Float)
	{
		setTileByIndex(index, Std.int(colorTiles * distanceRatio), true);
	}

	function setBlockedTile(index:Int)
	{
		setTileByIndex(index, blockedTile, true);
	}
}
