package props;

import flixel.math.FlxRect;
import flixel.addons.display.FlxSliceSprite;

@:forward
abstract BorderSlice(FlxSliceSprite) from FlxSliceSprite to FlxSliceSprite
{
	inline public function new (x = 0.0, y = 0.0, width:Float, height:Float)
	{
		this = new FlxSliceSprite("assets/BorderSlice.png", new FlxRect(15, 15, 20, 20), width, height);
		this.x = x;
		this.y = y;
		// reduce vertice counts by stretching rather than tiling
		this.fillCenter = false;
		this.stretchBottom = true;
		this.stretchTop = true;
		this.stretchLeft = true;
		this.stretchRight = true;
		this.stretchCenter = true;
		#if debug
		this.ignoreDrawDebug = true;
		#end
	}
}