package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxCollision;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxDirectionFlags;

/**
 * This is a secret FlxState I use to test various pathfinding features.
 * I'll find a way to showcase it, someday.
 */
class TestState extends FlxState
{
	var map:Tilemap;
	
	var start = FlxVector.get(0, -10);
	var end = FlxVector.get(0, -10);
	
	var lineRed:FlxSprite;
	var lineWhite:FlxSprite;
	
	override function create():Void
	{
		map = new Tilemap();
		map.x = 128 + 16;
		map.y = 128 - 16;
		
		var bg = new FlxSprite(map.x, map.y);
		bg.makeGraphic(Std.int(map.width), Std.int(map.height), 0xFF639bff);
		add(bg);
		add(map);
		
		lineRed = new FlxSprite(0, -10);
		lineRed.makeGraphic(FlxG.width, 1, 0xFFff0000);
		lineRed.origin.set();
		add(lineRed);
		
		lineWhite = new FlxSprite(0, -10);
		lineWhite.makeGraphic(FlxG.width, 1);
		lineWhite.origin.set();
		add(lineWhite);
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
		
		var displayStart:FlxVector = null;
		var displayEnd:FlxVector = null;
		
		final trim = true;
		if (trim)
		{
			displayStart = map.calcRayEntry(start, end);
			displayEnd = map.calcRayExit(start, end);
			
			if (displayStart == null || displayEnd == null)
			{
				displayStart = start.clone();
				displayEnd = end.clone();
			}
		}
		else
		{
			displayStart = start.clone();
			displayEnd = end.clone();
		}
		
		checkRay(displayStart, displayEnd);
		// checkRayStep(displayStart, displayEnd);
		// drawRayTiles();
		
		var dif = end.subtractNew(start);
		lineRed.x = start.x;
		lineRed.y = start.y;
		var length = dif.isZero() ? lineRed.frameHeight : Std.int(dif.length);
		lineRed.setGraphicSize(length, lineRed.frameHeight);
		lineRed.angle = dif.degrees;
		dif.put();
		
		dif = displayEnd.subtractNew(displayStart);
		lineWhite.x = displayStart.x;
		lineWhite.y = displayStart.y;
		length = dif.isZero() ? lineWhite.frameHeight : Std.int(dif.length);
		lineWhite.setGraphicSize(length, lineWhite.frameHeight);
		lineWhite.angle = dif.degrees;
		dif.put();
		
		displayStart.put();
		displayEnd.put();
	}
	
	function checkRay(displayStart:FlxVector, displayEnd:FlxVector)
	{
		var result = FlxVector.get();
		if (map.ray(start, end, result) == false)
			displayEnd.copyFrom(result);
		
		result.put();
	}
	
	function checkRayStep(displayStart:FlxVector, displayEnd:FlxVector)
	{
		var result = FlxVector.get();
		if (map.rayStep(start, end, result) == false)
			displayEnd.copyFrom(result);
		
		result.put();
	}
	
	function drawRayTiles()
	{
		map.highlightRay(start, end);
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
			[for (i in 0...width * height) FlxG.random.bool(10) ? 1 : 0],
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
		
		var tempStart = calcRayEntry(start, end);
		var tempEnd = calcRayExit(start, end);
		
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
		
		if (startX == endX)
		{
			highlightColumn(startX, startY, endY);
		}
		else
		{
			// Use y = mx + b formula
			final m = (start.y - end.y) / (start.x - end.x);
			// y - mx = b
			final b = start.y - m * start.x;
			
			final movesRight = start.x < end.x;
			var inc = movesRight ? 1 : -1;
			var offset = movesRight ? 1 : 0;
			var tileX = startX;
			var lastTileY = startY;
			
			while (tileX != endX)
			{
				var xPos = x + (tileX + offset) * scaledTileWidth;
				var yPos = m * xPos + b;
				var tileY = Math.floor((yPos - y) / scaledTileHeight);
				highlightColumn(tileX, lastTileY, tileY);
				lastTileY = tileY;
				tileX += inc;
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
}