package;

import flixel.FlxG;
import flixel.addons.effects.FlxSkewedSprite;

/**
 * @author Zaphod
 */
class Grass extends FlxSkewedSprite
{
	static public inline var SKEW_MAX = 10;
	static public inline var SKEW_MIN = -30;
	static public inline var SKEW_FREQ = 1.3;
	
	var time:Float;
	
	public function new(x = 0.0, y = 0.0, frame = 0, timeOffset = 0.0)
	{
		this.time = timeOffset * SKEW_FREQ;
		super(x, y);
		
		if (frame < 0)
			loadGraphic("assets/grass.png");
		else
		{
			loadGraphic("assets/grass.png", true, 600, 56);
			animation.frameIndex = frame;
		}
		
		origin.set(0, height);
		antialiasing = true;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		time += elapsed;
		
		skew.x = SKEW_MIN + (Math.cos(time / SKEW_FREQ * Math.PI) + 1) / 2 * (SKEW_MAX - SKEW_MIN);
	}
}
