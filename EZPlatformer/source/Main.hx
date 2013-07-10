package;

import flixel.util.FlxMisc;
import flixel.util.FlxRandom;
import flash.display.Sprite;
import flash.Lib;

/**
 * ...
 * @author Zaphod
 */

class Main extends Sprite
{
	
	public static function main() 
	{
		new Main();
	}
	
	public function new() 
	{
		super();
		Lib.current.addChild(new EZPlatformer());
	}
}