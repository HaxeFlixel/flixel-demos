package props;

import flixel.math.FlxRect;
import flixel.addons.display.FlxSliceSprite;

@:forward
abstract BorderSprite(FlxSliceSprite) from FlxSliceSprite to FlxSliceSprite
{
	inline public function new (x = 0.0, y = 0.0, width:Float, height:Float)
	{
		this = new FlxSliceSprite("assets/Border.png", new FlxRect(15, 15, 20, 20), width, height);
		this.x = x;
		this.y = y;
		#if debug
		this.ignoreDrawDebug = true;
		#end
	}
}