package;

import flixel.util.FlxMisc;
import flixel.util.FlxRandom;
import flixel.FlxG;
import flixel.util.FlxColorUtil;

class Colors
{		
	public static function random():Int
	{
		var flipped:Bool = FlxRandom.float() < 0.5;
		return FlxColorUtil.makeFromRGBA(genPair(flipped), genPair(flipped), genPair(flipped));
	}
	
	public static function genPair(Flipped:Bool):Int
	{
		if (FlxRandom.float() < 0.5)
		{
			if (Flipped)
			{
				return 0;
			}
			else
			{
				return 0;
			}
		}
		else
		{
			if (Flipped)
			{
				return 0xff;
			}
			else
			{
				return 0xbb;
			}
		}
		return 0;
		
		switch (Std.int(FlxRandom.float()*4))
		{
			case 0:
				return 0;
			case 1:
				return 0xff;
			case 2:
				return 0xff;//0x55;
			case 3:
				return 0;//0xAA;
		}
		return 0;
	}
}