package;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.tile.FlxTilemap;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;

class TestState extends FlxState
{
	var map:Tilemap;
	
	var start = FlxVector.get(0, -10);
	var end = FlxVector.get(0, -10);
	
	var line:FlxSprite;
	
	override function create():Void
	{
		map = new Tilemap();
		map.x = 128 + 16;
		map.y = 128 - 16;
		
		var bg = new FlxSprite(map.x, map.y);
		bg.makeGraphic(Std.int(map.width), Std.int(map.height), 0xFF639bff);
		add(bg);
		add(map);
		
		line = new FlxSprite(0, -10);
		line.makeGraphic(FlxG.width, 3);
		line.origin.x = 1;
		add(line);
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (FlxG.mouse.justPressed)
		{
			FlxG.mouse.getWorldPosition(null, start);
			end.copyFrom(start);
		}
		else if (FlxG.mouse.pressed)
		{
			FlxG.mouse.getWorldPosition(null, end);
		}
		
		var tempStart:FlxVector = null;
		var tempEnd:FlxVector = null;
		
		final trim = true;
		if (trim)
		{
			tempStart = map.getRayEntry(start, end);
			tempEnd = map.getRayExit(start, end);
			
			if (tempStart == null || tempEnd == null)
			{
				tempStart = start.clone();
				tempEnd = end.clone();
			}
		}
		else
		{
			tempStart = start.clone();
			tempEnd = end.clone();
		}
		
		var dif = tempEnd.subtractNew(tempStart);
		line.x = tempStart.x;
		line.y = tempStart.y;
		var length = dif.isZero() ? line.frameHeight : Std.int(dif.length);
		line.setGraphicSize(length, line.frameHeight);
		line.angle = dif.degrees;
		map.highlightRay(start, tempEnd);
		
		tempStart.put();
		tempEnd.put();
	}
}

private class Tilemap extends FlxTilemap
{
	public function new ()
	{
		super();
		
		var width = Math.floor(FlxG.width / 16 / 2);
		var height = Math.floor(FlxG.height / 16 / 2);
		loadMapFromArray(
			[for (i in 0...width * height) 0],
			width,
			height, 
			FlxGraphic.fromClass(GraphicAutoFull),
			16,
			16,
			FULL
		);
	}
	
	public function highlightRay(start:FlxPoint, end:FlxPoint)
	{
		for (i in 0...totalTiles)
			setTileByIndex(i, 0);
		
		var tempStart = getRayEntry(start, end);
		var tempEnd = getRayExit(start, end);
		
		if (tempStart == null || tempEnd == null)
			return;
		
		start = tempStart;
		end = tempEnd;
		
		var startIndex = getTileIndexByCoords(start);
		var endIndex = getTileIndexByCoords(end);
		
		var startX = startIndex % widthInTiles;
		var startY = Std.int(startIndex / widthInTiles);
		var endX = endIndex % widthInTiles;
		var endY = Std.int(endIndex / widthInTiles);
		
		if (start.x == end.x)
		{
			highlightColumn(startX, startY, endY);
		}
		else
		{
			// Use y = mx + b formula
			var m = (start.y - end.y) / (start.x - end.x);
			// y - mx = b
			var b = start.y - m * start.x;
			
			var lastTileY = startY;
			
			if (start.x < end.x)
			{
				for (tileX in startX...endX)
				{
					var xPos = x + (tileX + 1) * _scaledTileWidth;
					var yPos = m * xPos + b;
					var tileY = Math.floor((yPos - y) / _scaledTileHeight);
					highlightColumn(tileX, lastTileY, tileY);
					lastTileY = tileY;
				}
			}
			else
			{
				for (i in 0...startX - endX)
				{
					var tileX = startX - i;
					var xPos = x + tileX * _scaledTileWidth;
					var yPos = m * xPos + b;
					var tileY = Math.floor((yPos - y) / _scaledTileHeight);
					highlightColumn(tileX, lastTileY, tileY);
					lastTileY = tileY;
				}
			}
			
			highlightColumn(endX, lastTileY, endY);
		}
	}
	
	function highlightColumn(x:Int, startY:Int, endY:Int)
	{
		if (startY > endY)
		{
			highlightColumn(x, endY, startY);
			return;
		}
		
		if (startY < 0)
			startY = 0;
		
		if (endY > heightInTiles - 1)
			endY = heightInTiles - 1;
		
		for (y in startY...endY + 1)
			setTileByIndex(y * widthInTiles + x, 1);
	}
	
	public function getRayEntry(start:FlxPoint, end:FlxPoint):Null<FlxPoint>
	{
		final get = FlxPoint.get;
		
		var bounds = getBounds();
		if (bounds.containsPoint(start))
			return start.copyTo();
		
		if ((end.y < bounds.top && start.y < bounds.top) || (end.y >= bounds.bottom && start.y >= bounds.bottom))
			return null;
		
		if (start.x == end.x)
		{
			if (start.y < y)
				return get(start.x, bounds.top);
			
			return get(start.x, bounds.bottom);
		}
		
		// Use y = mx + b formula
		var m = (start.y - end.y) / (start.x - end.x);
		// y - mx = b
		var b = start.y - m * start.x;
		
		// y = mx + b
		var leftY = m * bounds.left + b;
		var rightY = m * bounds.right + b;
		// never intercepts
		if ((leftY < bounds.top && rightY < bounds.top) || (leftY >= bounds.bottom && rightY >= bounds.bottom))
			return null;
		
		if (start.x < end.x)
		{
			if (start.x > bounds.right || end.x < bounds.left)
				return null;
			
			if (leftY < bounds.top)
			{
				// x = (y - b)/m
				return get((bounds.top - b) / m, bounds.top);
			}
			else if (leftY >= bounds.bottom)
			{
				// x = (y - b)/m
				return get((bounds.bottom - b - 1) / m, bounds.bottom - 1);
			}
			return get(bounds.left, leftY);
		}
		
		if (start.x < bounds.left || end.x > bounds.right)
			return null;
		
		if (rightY < bounds.top)
		{
			// x = (y - b)/m
			return get((bounds.top - b) / m, bounds.top);
		}
		else if (rightY >= bounds.bottom)
		{
			// x = (y - b)/m
			return get((bounds.bottom - b - 1) / m, bounds.bottom - 1);
		}
		return get(bounds.right - 1, rightY);
	}
	
	public function getRayExit(start:FlxPoint, end:FlxPoint):Null<FlxPoint>
	{
		return getRayEntry(end, start);
	}
}