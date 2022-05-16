package;

import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;

class Seeker extends FlxSprite
{
	public var moving:Bool = false;

	var dest:FlxPoint;
	var vec:FlxPoint;

	public function new()
	{
		super(0, 0, "assets/images/seeker.png");
		dest = FlxPoint.get();
		vec = FlxPoint.get();
		setSize(12, 12);
		offset.set(2, 2);
		setPosition(2, 2);
	}

	public function moveTo(X:Float, Y:Float, Speed:Float):Void
	{
		moving = true;
		dest.set(X, Y);

		vec.x = dest.x - x;
		vec.y = dest.y - y;

		vec.normalize();

		velocity.x = vec.x * Speed;
		velocity.y = vec.y * Speed;
	}

	function finishMoveTo():Void
	{
		setPosition(dest.x, dest.y);
		velocity.set();
		moving = false;
	}

	override public function update(elapsed:Float):Void
	{
		var oldx:Float = vec.x;
		var oldy:Float = vec.y;
		super.update(elapsed);
		vec.x = dest.x - x;
		vec.y = dest.y - y;

		if (!FlxMath.sameSign(oldx, vec.x) || !FlxMath.sameSign(oldy, vec.y))
			finishMoveTo();
	}

	function signOf(f:Float):Int
	{
		if (f < 0)
			return -1;
		else
			return 1;
	}
}
