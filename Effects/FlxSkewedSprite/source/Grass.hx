package;

import flixel.FlxG;
import flixel.addons.effects.FlxSkewedSprite;
import flixel.graphics.frames.FlxTileFrames;
import flixel.math.FlxPoint;

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
		
		loadGraphic("assets/grass.png", true, 600, 56);
		// extrude the edge pixels beyond the frame to avoid seams on html5
		frames = FlxTileFrames.fromBitmapAddSpacesAndBorders(
			graphic,
			FlxPoint.get(600, 56),
			null,
			FlxPoint.get(1, 1)
		);
		// set the frame
		animation.frameIndex = frame;
		
		// set origin to the bottom so it stays attached to the same ground
		origin.set(0, height);
		antialiasing = true;
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		time += elapsed;
		
		// simple sine wave going from 0 to 1
		final skewFactor = Math.cos(time / SKEW_FREQ * Math.PI) / 2 + 0.5;
		// set skew based on min, max and factor
		skew.x = SKEW_MIN + skewFactor * (SKEW_MAX - SKEW_MIN);
	}
}
