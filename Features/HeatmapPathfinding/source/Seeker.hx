package;

import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;

class Seeker extends TileSprite
{
	public static inline var TILE_SIZE = PlayState.TILE_SIZE;
	public static inline var SPEED = TILE_SIZE * 4;

	var dest:FlxPoint;

	public function new()
	{
		super(0, 0, "assets/images/seeker.png");
		dest = FlxPoint.get();
		setSize(12, 12);
		offset.set(2, 2);
		moves = false;
	}

	public function moveToTile(toTileX:Int, toTileY:Int):Void
	{
		if (toTileX == tileX && toTileY == tileY)
			return;
		
		final diffX = toTileX - tileX;
		final diffY = toTileY - tileY;
		
		dest.set(x + (diffX * TILE_SIZE), y + (diffY * TILE_SIZE));

		velocity.x = diffX * SPEED;
		velocity.y = diffY * SPEED;
		moves = true;
	}

	function finishMoveTo():Void
	{
		setPosition(dest.x, dest.y);
		velocity.set(0, 0);
		moves = false;
	}

	override public function update(elapsed:Float):Void
	{
		if (!moves)
		{
			super.update(elapsed);
		}
		else
		{
			final oldX = dest.x - x;
			final oldY = dest.y - y;
			super.update(elapsed);
			final newX = dest.x - x;
			final newY = dest.y - y;
			
			if (!FlxMath.sameSign(oldX, newX) || !FlxMath.sameSign(oldY, newY))
				finishMoveTo();
		}
	}
}
